//
//  DataTool+Collection.m
//  AntenatalTraining
//
//  Created by mo jun on 5/2/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "DataTool+Collection.h"
#import "CollectionManager.h"

@implementation DataTool (Collection)

+ (void)getSongs:(void(^)(NSArray *songs))callback {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *songs = [[CollectionManager manager] getSongs];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(songs);
            }
        });
    });
}

+ (void)addSong:(MusicModel *)song callback:(void (^)(BOOL suc))callback {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL suc = [[CollectionManager manager] addSong:song];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(suc);
            }
        });
    });
}

+ (void)removeSong:(MusicModel *)song callback:(void (^)(BOOL suc))callback {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL suc = [[CollectionManager manager] removeSong:song];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(suc);
            }
        });
    });
}

+ (void)isCollectedSongId:(NSNumber *)songID callback:(void (^)(BOOL suc))callback {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL suc = [[CollectionManager manager] isCollectedSongId:songID];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(suc);
            }
        });
    });
}

+ (BOOL)isCollectedSongId:(NSNumber *)songID {
    return [[CollectionManager manager] isCollectedSongId:songID];
}

@end
