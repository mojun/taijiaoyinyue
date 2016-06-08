//
//  DBManager.m
//  AntenatalTraining
//
//  Created by test on 16/4/29.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "DBManager.h"
#define DB_NAME @"taijiao.db"
#define USER_DB_NAME @"taijiao-user.db"

@implementation DBManager {
    FMEncryptDatabase *_database;
    FMEncryptDatabaseQueue *_userDatabaseQueue;
    FMEncryptDatabaseQueue *_downloadDatabaseQueue;
}

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static DBManager *d = nil;
    dispatch_once(&onceToken, ^{
        d = [[DBManager alloc] init];
    });
    return d;
}

- (instancetype)init {
    if (self = [super init]) {
        [FMEncryptDatabase setEncryptKey:kEncryptKey];
    }
    return self;
}

- (FMEncryptDatabase *)getResourceDB {
    if (_database == nil) {
        
        NSString *dbPath = [FCFileManager pathForMainBundleDirectoryWithPath:DB_NAME];
        FMEncryptDatabase *db = [FMEncryptDatabase databaseWithPath:dbPath];
        if (![db open]) {
            NSLog(@"数据库打不开 你机器坏了吧");
            return nil;
        }
        _database = db;
    }
    return _database;
}

- (FMEncryptDatabaseQueue *)getUserDBContext {
    if (_userDatabaseQueue == nil) {
        
        NSString *dbPath = [FCFileManager pathForMainBundleDirectoryWithPath:USER_DB_NAME];
        NSString *dbDocPath = [FCFileManager pathForDocumentsDirectoryWithPath:USER_DB_NAME];
        if ([FCFileManager existsItemAtPath:dbDocPath] == NO) {
            [FCFileManager copyItemAtPath:dbPath toPath:dbDocPath];
        }
        _userDatabaseQueue = [FMEncryptDatabaseQueue databaseQueueWithPath:dbDocPath];
    }
    
    return _userDatabaseQueue;
}

@end
