//
//  PlaylistManager.m
//  AntenatalTraining
//
//  Created by mo jun on 4/30/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "PlaylistManager.h"

#define PLAYLIST_DB_NAME @"playlist.db"

@interface PlaylistManager ()

@property (nonatomic, strong) FMEncryptDatabaseQueue *queue;

@end

@implementation PlaylistManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    static PlaylistManager *i = nil;
    dispatch_once(&onceToken, ^{
        i = [[[self class] alloc] init];
        [FMEncryptDatabase setEncryptKey:kEncryptKey];
    });
    return i;
}

#pragma mark - private
- (FMEncryptDatabaseQueue *)queue {
    if (!_queue) {
        NSString *docPath = [FCFileManager pathForDocumentsDirectoryWithPath:PLAYLIST_DB_NAME];
        if (![FCFileManager existsItemAtPath:docPath]) {
            NSString *resPath = [FCFileManager pathForMainBundleDirectoryWithPath:PLAYLIST_DB_NAME];
            [FCFileManager copyItemAtPath:resPath toPath:docPath];
        }
        
        _queue = [FMEncryptDatabaseQueue databaseQueueWithPath:docPath];
    }
    return _queue;
}

- (NSArray *)getPlaylists {
    __block NSMutableArray *playlistArray = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from sum_playlist order by order_index asc"];
        while ([rs next]) {
            PlaylistBean *bean = [[PlaylistBean alloc]init];
            [bean setValuesForKeysWithDictionary:rs.resultDictionary];
            [playlistArray addObject:bean];
        }
        [rs close];
    }];
    return playlistArray;
}

- (NSArray *)getPlaylistSongsWithID:(NSNumber *)playlistID {
    __block NSMutableArray *songs = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from playlist_song where playlist_id = ? order by order_index asc", playlistID];
        while ([rs next]) {
            PlaylistSongBean *bean = [[PlaylistSongBean alloc] init];
            [bean setValuesForKeysWithDictionary:rs.resultDictionary];
            [songs addObject:bean];
        }
        [rs close];
    }];
    return songs;
}

- (PlaylistBean *)addPlaylistWithTitle:(NSString *)title {
    __block PlaylistBean *bean = nil;
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:@"select count(order_index) as playlist_count from playlist"];
        NSInteger orderIndex = 0;
        if ([rs next]) {
            orderIndex = [rs intForColumn:@"playlist_count"];
        }
        [rs close];
        if ([db executeUpdate:@"insert into playlist (order_index,title) values (?,?)", @(orderIndex), title]) {
            rs = [db executeQuery:@"select * from sum_playlist where order_index = ?", @(orderIndex)];
            if ([rs next]) {
                bean = [[PlaylistBean alloc] init];
                [bean setValuesForKeysWithDictionary:rs.resultDictionary];
            }
            [rs close];
        }
        
    }];
    return bean;
}

- (BOOL)addSongsToPlaylistWithID:(NSNumber *)playlistID songs:(NSArray *)songs {
    __block BOOL result = YES;
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *rs = [db executeQuery:@"select count(order_index) as song_count from playlist_song where playlist_id = ?",playlistID];
        NSInteger orderIndex = 0;
        if ([rs next]) {
            orderIndex = [rs intForColumn:@"song_count"];
        }
        [rs close];
        for (MusicModel *song in songs) {
            if ([db executeUpdate:@"insert into playlist_song (playlist_id, order_index, m_id, c_id, mp3, file_size, title) values (?,?,?,?,?,?,?)",playlistID, @(orderIndex), song.m_id, song.c_id, song.mp3, song.file_size, song.title]) {
                orderIndex++;
            } else {
                *rollback = YES;
                result = NO;
                return ;
            }
        }
    }];
    return result;
}

- (PlaylistBean *)modifyPlaylist:(PlaylistBean *)playlist title:(NSString *)title {
    __block PlaylistBean *bean = nil;
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if ([db executeUpdate:@"update playlist set title = ? where playlist_id = ?", title, playlist.playlist_id]) {
            FMResultSet *rs = [db executeQuery:@"select * from sum_playlist where playlist_id = ?", playlist.playlist_id];
            if ([rs next]) {
                bean = [[PlaylistBean alloc] init];
                [bean setValuesForKeysWithDictionary:rs.resultDictionary];
            }
            [rs close];
        }
        
    }];
    return bean;
}

- (BOOL)modifyPlaylist:(PlaylistBean *)playlist toIndex:(NSInteger)toIndex {
    __block BOOL result = YES;
    if (playlist.order_index.integerValue == toIndex) {
        return result;
    }
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        if (![db executeUpdate:@"delete from playlist where playlist_id = ?", playlist.playlist_id]) {
            *rollback = YES;
            result = NO;
            return;
        }
        
        // 如果向上移动，则中间所有歌曲的orderindex都需要+1
        if (playlist.order_index.integerValue > toIndex) {
            for (NSInteger i = playlist.order_index.integerValue - 1; i >= toIndex; i--) {
                if (![db executeUpdate:@"update playlist set order_index = ? where order_index = ?", @(i + 1), @(i)]) {
                    *rollback = YES;
                    result = NO;
                    return;
                }
            }
            
        } else {
            // 如果向下移动，则中间所有歌曲的orderindex都需要-1
            for (NSInteger i = playlist.order_index.integerValue + 1; i <= toIndex; i++) {
                if (![db executeUpdate:@"update playlist set order_index = ? where order_index = ?", @(i - 1), @(i)]) {
                    *rollback = YES;
                    result = NO;
                    return;
                }
            }
        }
        
        if (![db executeUpdate:@"insert into playlist (order_index,title) values (?,?)", @(toIndex), playlist.title]) {
            *rollback = YES;
            result = NO;
            return;
        }
        
        FMResultSet *rs =[db executeQuery:@"select playlist_id from playlist where order_index = ?", @(toIndex)];
        if ([rs next]) {
            int newPlaylistID = [rs intForColumn:@"playlist_id"];
            if (![db executeUpdate:@"update playlist_song set playlist_id = ? where playlist_id = ?", @(newPlaylistID), playlist.playlist_id]) {
                *rollback = YES;
                result = NO;
                return;
            }
        }
        [rs close];
    }];
    return result;
}

-(BOOL)modifySong:(PlaylistSongBean*)song toIndex:(NSInteger)toIndex {
    __block BOOL result = YES;
    if (song.order_index.integerValue == toIndex) {
        return result;
    }
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        if (![db executeUpdate:@"delete from playlist_song where playlist_id = ? and order_index = ?", song.playlist_id, song.order_index]) {
            *rollback = YES;
            result = NO;
            return;
        }
        
        // 如果向上移动，则中间所有歌曲的orderindex都需要+1
        if (song.order_index.integerValue > toIndex) {
            for (NSInteger i = song.order_index.integerValue - 1; i >= toIndex; i--) {
                if (![db executeUpdate:@"update playlist_song set order_index = ? where order_index = ? and playlist_id = ?", [NSNumber numberWithInteger:i + 1], [NSNumber numberWithInteger:i], song.playlist_id]) {
                    *rollback = YES;
                    result = NO;
                    return;
                }
            }
            
        } else {
            // 如果向下移动，则中间所有歌曲的orderindex都需要-1
            for (NSInteger i = song.order_index.integerValue + 1; i <= toIndex; i++) {
                if (![db executeUpdate:@"update playlist_song set order_index = ? where order_index = ? and playlist_id = ?", [NSNumber numberWithInteger:i - 1], [NSNumber numberWithInteger:i], song.playlist_id]) {
                    *rollback = YES;
                    result = NO;
                    return;
                }
            }
        }
        
        if (![db executeUpdate:@"insert into playlist_song (playlist_id, order_index, m_id, c_id, mp3, file_size, title) values (?,?,?,?,?,?,?)", song.playlist_id, [NSNumber numberWithInteger:toIndex], song.m_id, song.c_id, song.mp3, song.file_size, song.title]) {
            *rollback = YES;
            result = NO;
            return;
        }
        
    }];
    
    return result;
}

- (BOOL)deletePlaylistWithBean:(PlaylistBean *)playlist {
    __block BOOL result = YES;
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (![db executeUpdate:@"delete from playlist where playlist_id = ? ", playlist.playlist_id]) {
            *rollback = YES;
            result = NO;
            return;
        }
        
        if (![db executeUpdate:@"delete from playlist_song where playlist_id = ? ", playlist.playlist_id]) {
            *rollback = YES;
            result = NO;
            return;
        }
        // 调整playlist表中的序号顺序
        FMResultSet *rs = [db executeQuery:@"select max(order_index) as max_order_index from playlist"];
        if ([rs next]) {
            int maxOrderIndex = [rs intForColumn:@"max_order_index"];
            for (NSInteger i = playlist.order_index.integerValue + 1; i <= maxOrderIndex; i ++) {
                if (![db executeUpdate:@"update playlist set order_index = ? where order_index = ?", [NSNumber numberWithInteger:i - 1], [NSNumber numberWithInteger:i]]) {
                    *rollback = YES;
                    result = NO;
                    return;
                }
            }
        }
        [rs close];
    }];
    return result;
}

- (BOOL)deleteSongWithBean:(PlaylistSongBean *)song {
    __block BOOL result = YES;
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (![db executeUpdate:@"delete from playlist_song where playlist_id = ? and order_index = ?", song.playlist_id, song.order_index]) {
            *rollback = YES;
            result = NO;
            return;
        }
        // 调整playlist中歌曲的序号顺序
        FMResultSet *rs = [db executeQuery:@"select max(order_index) as max_order_index from playlist_song where playlist_id = ?", song.playlist_id];
        if ([rs next]) {
            int maxOrderIndex = [rs intForColumn:@"max_order_index"];
            for (NSInteger i = song.order_index.integerValue + 1; i <= maxOrderIndex; i ++) {
                if (![db executeUpdate:@"update playlist_song set order_index = ? where order_index = ? and playlist_id = ?", [NSNumber numberWithInteger:i - 1], [NSNumber numberWithInteger:i], song.playlist_id]) {
                    *rollback = YES;
                    result = NO;
                    return;
                }
            }
        }
        [rs close];
        
    }];
    
    return result;
}

@end
