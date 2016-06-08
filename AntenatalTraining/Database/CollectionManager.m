//
//  CollectionManager.m
//  AntenatalTraining
//
//  Created by mo jun on 4/30/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "CollectionManager.h"

#define COLLECTION_DB_NAME @"collection.db"

@interface CollectionManager ()

@property (nonatomic, strong) FMEncryptDatabaseQueue *queue;

@end

@implementation CollectionManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static CollectionManager *i = nil;
    dispatch_once(&onceToken, ^{
        i = [[[self class] alloc] init];
        [FMEncryptDatabase setEncryptKey:kEncryptKey];
    });
    return i;
}

#pragma mark - private
- (FMEncryptDatabaseQueue *)queue {
    if (!_queue) {
        NSString *docPath = [FCFileManager pathForDocumentsDirectoryWithPath:COLLECTION_DB_NAME];
        if (![FCFileManager existsItemAtPath:docPath]) {
            NSString *resPath = [FCFileManager pathForMainBundleDirectoryWithPath:COLLECTION_DB_NAME];
            [FCFileManager copyItemAtPath:resPath toPath:docPath];
        }
        
        _queue = [FMEncryptDatabaseQueue databaseQueueWithPath:docPath];
    }
    return _queue;
}

- (NSArray *)getSongs {
    __block NSMutableArray *playlistArray = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from music"];
        while ([rs next]) {
            MusicModel *bean = [[MusicModel alloc]init];
            [bean setValuesForKeysWithDictionary:rs.resultDictionary];
            bean.isCollection = YES;
            [playlistArray addObject:bean];
        }
        [rs close];
    }];
    return playlistArray;
}

- (BOOL)addSong:(MusicModel *)song {
    
    __block BOOL result = YES;
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (![db executeUpdate:@"insert into music (m_id, c_id, mp3, file_size, title) values (?,?,?,?,?)", song.m_id, song.c_id, song.mp3, song.file_size, song.title]) {
            *rollback = YES;
            result = NO;
            return ;
        }
    }];
    return result;
}

- (BOOL)removeSong:(MusicModel *)song {
    if (song.isCollection == NO) {
        return YES;
    }
    
    __block BOOL result = YES;
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (![db executeUpdate:@"delete from music where m_id = ? and c_id = ?", song.m_id, song.c_id]) {
            *rollback = YES;
            result = NO;
            return ;
        }
    }];
    
    return result;
}

- (BOOL)isCollectedSongId:(NSNumber *)songID {
    __block BOOL result = NO;
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select count(*) as tc from music where m_id = ?", songID];
        result = [rs intForColumn:@"tc"] > 0;
        [rs close];
    }];
    return result;
}

@end
