//
//  DataTool+Collection.h
//  AntenatalTraining
//
//  Created by mo jun on 5/2/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "DataTool.h"

@interface DataTool (Collection)

+ (void)getSongs:(void(^)(NSArray *songs))callback;

+ (void)addSong:(MusicModel *)song callback:(void (^)(BOOL suc))callback;

+ (void)removeSong:(MusicModel *)song callback:(void (^)(BOOL suc))callback;

+ (void)isCollectedSongId:(NSNumber *)songID callback:(void (^)(BOOL suc))callback;

+ (BOOL)isCollectedSongId:(NSNumber *)songID;

@end
