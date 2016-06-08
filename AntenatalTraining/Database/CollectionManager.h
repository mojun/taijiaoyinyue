//
//  CollectionManager.h
//  AntenatalTraining
//
//  Created by mo jun on 4/30/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"

@interface CollectionManager : NSObject

+ (instancetype)manager;

- (NSArray *)getSongs;

- (BOOL)addSong:(MusicModel *)song;

- (BOOL)removeSong:(MusicModel *)song;

- (BOOL)isCollectedSongId:(NSNumber *)songID;

@end
