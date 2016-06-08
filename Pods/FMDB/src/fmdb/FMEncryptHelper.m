//
//  FMEncryptHelper.m
//  FmdbDemo
//
//  Created by ZhengXiankai on 15/8/26.
//  Copyright (c) 2015年 ZhengXiankai. All rights reserved.
//

#import "FMEncryptHelper.h"
#import "sqlite3.h"

@implementation FMEncryptHelper

static NSString *encryptKey_;

+ (void)initialize
{
    encryptKey_ = @"FDLSAFJEIOQJR34JRI4JIGR93209T489FR";
}

#pragma mark - 配置方法
+ (void)setEncryptKey:(NSString *)encryptKey
{
    encryptKey_ = encryptKey;
}

//对数据库加密（文件不变）
+ (BOOL)encryptDatabase:(NSString *)path
{
    NSString *sourcePath = path;
    NSString *targetPath = [NSString stringWithFormat:@"%@.tmp.db", path];
    
    if([self encryptDatabase:sourcePath targetPath:targetPath]) {
        NSFileManager *fm = [[NSFileManager alloc] init];
        [fm removeItemAtPath:sourcePath error:nil];
        [fm moveItemAtPath:targetPath toPath:sourcePath error:nil];
        return YES;
    } else {
        return NO;
    }
}

//对数据库解密（文件不变）
+ (BOOL)unEncryptDatabase:(NSString *)path
{
    NSString *sourcePath = path;
    NSString *targetPath = [NSString stringWithFormat:@"%@.tmp.db", path];
    
    if([self unEncryptDatabase:sourcePath targetPath:targetPath]) {
        NSFileManager *fm = [[NSFileManager alloc] init];
        [fm removeItemAtPath:sourcePath error:nil];
        [fm moveItemAtPath:targetPath toPath:sourcePath error:nil];
        return YES;
    } else {
        return NO;
    }
}

/** 对数据库加密 */
+ (BOOL)encryptDatabase:(NSString *)sourcePath targetPath:(NSString *)targetPath
{
    const char* sqlQ = [[NSString stringWithFormat:@"ATTACH DATABASE '%@' AS encrypted KEY '%@';", targetPath, encryptKey_] UTF8String];
    
    sqlite3 *unencrypted_DB;
    if (sqlite3_open([sourcePath UTF8String], &unencrypted_DB) == SQLITE_OK) {
        
        // Attach empty encrypted database to unencrypted database
        sqlite3_exec(unencrypted_DB, sqlQ, NULL, NULL, NULL);
        
        // export database
        sqlite3_exec(unencrypted_DB, "SELECT sqlcipher_export('encrypted');", NULL, NULL, NULL);
        
        // Detach encrypted database
        sqlite3_exec(unencrypted_DB, "DETACH DATABASE encrypted;", NULL, NULL, NULL);
        
        sqlite3_close(unencrypted_DB);
        
        return YES;
    }
    else {
        sqlite3_close(unencrypted_DB);
        NSAssert1(NO, @"Failed to open database with message '%s'.", sqlite3_errmsg(unencrypted_DB));
        
        return NO;
    }
}

/** 对数据库解密 */
+ (BOOL)unEncryptDatabase:(NSString *)sourcePath targetPath:(NSString *)targetPath
{
    const char* sqlQ = [[NSString stringWithFormat:@"ATTACH DATABASE '%@' AS plaintext KEY '';", targetPath] UTF8String];
    
    sqlite3 *encrypted_DB;
    if (sqlite3_open([sourcePath UTF8String], &encrypted_DB) == SQLITE_OK) {
        
        
        sqlite3_exec(encrypted_DB, [[NSString stringWithFormat:@"PRAGMA key = '%@';", encryptKey_] UTF8String], NULL, NULL, NULL);
        
        // Attach empty unencrypted database to encrypted database
        sqlite3_exec(encrypted_DB, sqlQ, NULL, NULL, NULL);
        
        // export database
        sqlite3_exec(encrypted_DB, "SELECT sqlcipher_export('plaintext');", NULL, NULL, NULL);
        
        // Detach unencrypted database
        sqlite3_exec(encrypted_DB, "DETACH DATABASE plaintext;", NULL, NULL, NULL);
        
        sqlite3_close(encrypted_DB);
        
        return YES;
    }
    else {
        sqlite3_close(encrypted_DB);
        NSAssert1(NO, @"Failed to open database with message '%s'.", sqlite3_errmsg(encrypted_DB));
        
        return NO;
    }
}

/** 修改数据库秘钥 */
+ (BOOL)changeKey:(NSString *)dbPath originKey:(NSString *)originKey newKey:(NSString *)newKey
{
    sqlite3 *encrypted_DB;
    if (sqlite3_open([dbPath UTF8String], &encrypted_DB) == SQLITE_OK) {
        
        sqlite3_exec(encrypted_DB, [[NSString stringWithFormat:@"PRAGMA key = '%@';", originKey] UTF8String], NULL, NULL, NULL);
        
        sqlite3_exec(encrypted_DB, [[NSString stringWithFormat:@"PRAGMA rekey = '%@';", newKey] UTF8String], NULL, NULL, NULL);
        
        sqlite3_close(encrypted_DB);
        return YES;
    }
    else {
        sqlite3_close(encrypted_DB);
        NSAssert1(NO, @"Failed to open database with message '%s'.", sqlite3_errmsg(encrypted_DB));
        
        return NO;
    }
}

@end
