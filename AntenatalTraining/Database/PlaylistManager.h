//
//  PlaylistManager.h
//  AntenatalTraining
//
//  Created by mo jun on 4/30/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaylistBean.h"
#import "PlaylistSongBean.h"

@interface PlaylistManager : NSObject

+ (instancetype)manager;

- (NSArray *)getPlaylists;

- (NSArray *)getPlaylistSongsWithID:(NSNumber *)playlistID;

- (PlaylistBean *)addPlaylistWithTitle:(NSString *)title;

- (BOOL)addSongsToPlaylistWithID:(NSNumber *)playlistID songs:(NSArray *)songs;

- (PlaylistBean *)modifyPlaylist:(PlaylistBean *)playlist title:(NSString *)title;

- (BOOL)modifyPlaylist:(PlaylistBean *)playlist toIndex:(NSInteger)toIndex;

- (BOOL)modifySong:(PlaylistSongBean *)song toIndex:(NSInteger)toIndex;

- (BOOL)deletePlaylistWithBean:(PlaylistBean *)playlist;

- (BOOL)deleteSongWithBean:(PlaylistSongBean *)song;

@end
