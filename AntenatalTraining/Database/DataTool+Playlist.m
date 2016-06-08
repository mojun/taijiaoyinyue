//
//  DataTool+Playlist.m
//  AntenatalTraining
//
//  Created by mo jun on 5/2/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "DataTool+Playlist.h"
#import "PlaylistManager.h"

@implementation DataTool (Playlist)

+ (void)getPlaylists:(void (^)(NSArray *playlists))block {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *playlists = [[PlaylistManager manager] getPlaylists];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(playlists);
            }
        });
    });
}

+ (void)getPlaylistSongsWithID:(NSNumber *)playlistID
                      callback:(void (^)(NSArray *playlistSongs))callback {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *playlistSongs = [[PlaylistManager manager] getPlaylistSongsWithID:playlistID];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(playlistSongs);
            }
        });
    });
}

+ (void)addPlaylistWithTitle:(NSString *)title
                    callback:(void (^)(PlaylistBean *playlist))callback {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PlaylistBean *bean = [[PlaylistManager manager] addPlaylistWithTitle:title];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(bean);
            }
        });
    });
}

+ (void)addSongsToPlaylistWithID:(NSNumber *)playlistID
                           songs:(NSArray *)songs
                        callback:(void (^)(BOOL suc))callback {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL suc = [[PlaylistManager manager] addSongsToPlaylistWithID:playlistID songs:songs];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(suc);
            }
        });
    });
}

+ (void)modifyPlaylist:(PlaylistBean *)playlist
                 title:(NSString *)title
              callback:(void (^)(PlaylistBean *playlist))callback {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PlaylistBean *playlistBean = [[PlaylistManager manager] modifyPlaylist:playlist title:title];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(playlistBean);
            }
        });
    });
}

+ (void)modifyPlaylist:(PlaylistBean *)playlist
               toIndex:(NSInteger)toIndex
              callback:(void (^)(BOOL suc))callback {
 
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL suc = [[PlaylistManager manager] modifyPlaylist:playlist toIndex:toIndex];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(suc);
            }
        });
    });
}

+ (void)modifySong:(PlaylistSongBean *)song
           toIndex:(NSInteger)toIndex
          callback:(void (^)(BOOL suc))callback {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL suc = [[PlaylistManager manager] modifySong:song toIndex:toIndex];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(suc);
            }
        });
    });
}

+ (void)deletePlaylistWithBean:(PlaylistBean *)playlist
                      callback:(void (^)(BOOL suc))callback {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL suc = [[PlaylistManager manager] deletePlaylistWithBean:playlist];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(suc);
            }
        });
    });
}

+ (void)deleteSongWithBean:(PlaylistSongBean *)song
                  callback:(void (^)(BOOL suc))callback {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        BOOL suc = [[PlaylistManager manager] deleteSongWithBean:song];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(suc);
            }
        });
    });
}

@end
