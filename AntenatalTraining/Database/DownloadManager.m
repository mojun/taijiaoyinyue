//
//  DownloadManager.m
//  AntenatalTraining
//
//  Created by test on 16/5/25.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "DownloadManager.h"

#define DOWNLOAD_DB_NAME @"taijiao-download.db"

@interface DownloadManager ()

@property (nonatomic, strong) FMEncryptDatabaseQueue *queue;

@end

@implementation DownloadManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static DownloadManager *i = nil;
    dispatch_once(&onceToken, ^{
        i = [[DownloadManager alloc] init];
        [FMEncryptDatabase setEncryptKey:kEncryptKey];
    });
    return i;
}

#pragma mark - public
- (NSArray *)getDownloadedList {
    return [self getDownloadList:1];
}
- (NSArray *)getDownloadingList {
    return [self getDownloadList:0];
}

- (NSArray *)getDownloadList:(NSInteger)state {
    
    __block NSMutableArray *datas = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSString *order = state == 0 ? @"asc" : @"desc";
        NSString *sql = [NSString stringWithFormat:@"select m_id, c_id, mp3, file_size, title, state, recieved_size, total_size from music where state = ? order by create_time %@", order];
        FMResultSet *rs = [db executeQuery:sql, @(state)];
        while ([rs next]) {
            DownloadModel *bean = [[DownloadModel alloc] init];
            [bean setValuesForKeysWithDictionary:rs.resultDictionary];
            [datas addObject:bean];
        }
        [rs close];
    }];
    return datas;
}

- (DownloadModel *)addSongToDownload:(MusicModel *)song {
    
    __block DownloadModel *bean = nil;
    if ([self fileIsInDataBase:song]) {
        
        [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            FMResultSet *rs = [db executeQuery:@"select m_id, c_id, mp3, file_size, title, state, recieved_size, total_size from music where m_id = ? and c_id = ?", song.m_id, song.c_id];
            if ([rs next]) {
                bean = [[DownloadModel alloc] init];
                [bean setValuesForKeysWithDictionary:rs.resultDictionary];
            }
            [rs close];
        }];
        return bean;
    }
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (![db executeUpdate:@"insert into music (m_id, c_id, mp3, file_size, title, create_time, state) values (?,?,?,?,?,?,?)", song.m_id, song.c_id, song.mp3, song.file_size, song.title, @(time(NULL)), @0]) {
            *rollback = YES;
            return ;
        }
        
        FMResultSet *rs = [db executeQuery:@"select m_id, c_id, mp3, file_size, title, state, recieved_size, total_size from music where m_id = ? and c_id = ?", song.m_id, song.c_id];
        if ([rs next]) {
            bean = [[DownloadModel alloc] init];
            [bean setValuesForKeysWithDictionary:rs.resultDictionary];
        }
        [rs close];
    }];
    return bean;
}

- (BOOL)updateDown:(DownloadModel *)download {
    
    __block BOOL result = YES;
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (![db executeUpdate:@"update music set state = ?, recieved_size = ?, total_size = ? where m_id = ? and c_id = ?", download.state, download.recieved_size, download.total_size, download.m_id, download.c_id]) {
            *rollback = YES;
            result = NO;
        }
    }];
    
    return result;
}

- (BOOL)deleteDownload:(DownloadModel *)download {
    __block BOOL result = YES;
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (![db executeUpdate:@"delete from music where m_id = ? and c_id = ?", download.m_id, download.c_id]) {
            *rollback = YES;
            result = NO;
        }
    }];
    
    return result;
}

#pragma mark - private
- (FMEncryptDatabaseQueue *)queue {
    if (_queue == nil) {
        
        NSString *docPath = [FCFileManager pathForDocumentsDirectoryWithPath:DOWNLOAD_DB_NAME];
        if (![FCFileManager existsItemAtPath:docPath]) {
            NSString *resPath = [FCFileManager pathForMainBundleDirectoryWithPath:DOWNLOAD_DB_NAME];
            [FCFileManager copyItemAtPath:resPath toPath:docPath];
        }
        _queue = [FMEncryptDatabaseQueue databaseQueueWithPath:docPath];
    }
    return _queue;
}

- (BOOL)fileIsInDataBase:(MusicModel *)music {
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select count(*) as tc from music where m_id = ?", music.m_id];
        result = [rs intForColumn:@"tc"] > 0;
        [rs close];
    }];
    return result;
}

@end
