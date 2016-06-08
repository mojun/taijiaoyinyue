//
//  DataTool+Playlist.h
//  AntenatalTraining
//
//  Created by mo jun on 5/2/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "DataTool.h"
#import "PlaylistBean.h"
#import "PlaylistSongBean.h"

@interface DataTool (Playlist)

+ (void)getPlaylists:(void (^)(NSArray *playlists))callback;

+ (void)getPlaylistSongsWithID:(NSNumber *)playlistID
                      callback:(void (^)(NSArray *playlistSongs))callback;

+ (void)addPlaylistWithTitle:(NSString *)title
                    callback:(void (^)(PlaylistBean *playlist))callback;

+ (void)addSongsToPlaylistWithID:(NSNumber *)playlistID
                           songs:(NSArray *)songs
                        callback:(void (^)(BOOL suc))callback;

+ (void)modifyPlaylist:(PlaylistBean *)playlist
                 title:(NSString *)title
              callback:(void (^)(PlaylistBean *playlist))callback;

+ (void)modifyPlaylist:(PlaylistBean *)playlist
               toIndex:(NSInteger)toIndex
              callback:(void (^)(BOOL suc))callback;

+ (void)modifySong:(PlaylistSongBean *)song
           toIndex:(NSInteger)toIndex
          callback:(void (^)(BOOL suc))callback;

+ (void)deletePlaylistWithBean:(PlaylistBean *)playlist
                      callback:(void (^)(BOOL suc))callback;

+ (void)deleteSongWithBean:(PlaylistSongBean *)song
                  callback:(void (^)(BOOL suc))callback;

@end
