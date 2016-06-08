//
//  FMEncryptDatabase.m
//  FmdbDemo
//
//  Created by ZhengXiankai on 15/7/31.
//  Copyright (c) 2015年 ZhengXiankai. All rights reserved.

#import "FMEncryptDatabase.h"
#import <SQLCipher/sqlite3.h>

@implementation FMEncryptDatabase

static NSString *encryptKey_;

+ (void)initialize
{
    [super initialize];
    //初始化数据库加密key，在使用之前可以通过 setEncryptKey 修改
    encryptKey_ = @"FDLSAFJEIOQJR34JRI4JIGR93209T489FR";
}

#pragma mark - 重载原来方法
- (BOOL)open {
    if (_db) {
        return YES;
    }
    
    int err = sqlite3_open([self sqlitePath], (sqlite3**)&_db );
    if(err != SQLITE_OK) {
        NSLog(@"error opening!: %d", err);
        return NO;
    } else {
        //数据库open后设置加密key
        [self setKey:encryptKey_];
    }
    
    if (_maxBusyRetryTimeInterval > 0.0) {
        // set the handler
        [self setMaxBusyRetryTimeInterval:_maxBusyRetryTimeInterval];
    }
    
    return YES;
}

#if SQLITE_VERSION_NUMBER >= 3005000
- (BOOL)openWithFlags:(int)flags {
    if (_db) {
        return YES;
    }
    
    int err = sqlite3_open_v2([self sqlitePath], (sqlite3**)&_db, flags, NULL /* Name of VFS module to use */);
    if(err != SQLITE_OK) {
        NSLog(@"error opening!: %d", err);
        return NO;
    } else {
        //数据库open后设置加密key
        [self setKey:encryptKey_];
    }
    if (_maxBusyRetryTimeInterval > 0.0) {
        // set the handler
        [self setMaxBusyRetryTimeInterval:_maxBusyRetryTimeInterval];
    }
    
    return YES;
}

- (BOOL)openWithFlags:(int)flags vfs:(NSString *)vfsName {
    if (_db) {
        return YES;
    }
    
    int err = sqlite3_open_v2([self sqlitePath], (sqlite3**)&_db, flags, [vfsName UTF8String] /* Name of VFS module to use */);
    if(err != SQLITE_OK) {
        NSLog(@"error opening!: %d", err);
        return NO;
    } else {
        //数据库open后设置加密key
        [self setKey:encryptKey_];
    }
    if (_maxBusyRetryTimeInterval > 0.0) {
        // set the handler
        [self setMaxBusyRetryTimeInterval:_maxBusyRetryTimeInterval];
    }
    
    return YES;
}

#endif

- (const char*)sqlitePath {
    
    if (!_databasePath) {
        return ":memory:";
    }
    
    if ([_databasePath length] == 0) {
        return ""; // this creates a temporary database (it's an sqlite thing).
    }
    
    return [_databasePath fileSystemRepresentation];
    
}

#pragma mark - 配置方法
+ (void)setEncryptKey:(NSString *)encryptKey
{
    encryptKey_ = encryptKey;
}

@end
