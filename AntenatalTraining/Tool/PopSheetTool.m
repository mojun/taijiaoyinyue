//
//  PopSheetTool.m
//  AntenatalTraining
//
//  Created by mo jun on 5/17/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "PopSheetTool.h"
#import "CategoryModel.h"
#import "MusicModel.h"
#import "PlaylistBean.h"
#import "PlaylistSongBean.h"
#import "PlaylistPopViewController.h"

#import "DataTool+Playlist.h"
#import "DataTool+Collection.h"

@interface PopSheetTool ()

@property (nonatomic, strong) id<DataFetcherProtocol> dataFetcher;

@end

@implementation PopSheetTool {
    
    BOOL _showing;
}

+ (instancetype)tool {
    static dispatch_once_t onceToken;
    static PopSheetTool *t = nil;
    dispatch_once(&onceToken, ^{
        t = [[PopSheetTool alloc] init];
    });
    return t;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)showWithOperationBean:(id)sourceBean
           operationTypeBlock:(void (^)(void))block {
    
    if (_showing) {
        NSLog(@"pop sheet 正在显示");
        return;
    }
    
    if (!block) {
        block = ^{};
    }
    
    _showing = YES;
    
    __weak UIViewController *presentingVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    DoActionSheet *sheet = [[DoActionSheet alloc] init];
    sheet.doBackColor = DO_RGBA(255, 255, 255, 0.8);
    sheet.doButtonColor = DO_RGB(113, 208, 243);
    sheet.doCancelColor = DO_RGB(73, 168, 203);
    sheet.doDestructiveColor = DO_RGB(235, 15, 93);
    sheet.doTitleTextColor = DO_RGB(40, 47, 47);
    if ([sourceBean isKindOfClass:[PlaylistSongBean class]]) {
        PlaylistSongBean *bean = (PlaylistSongBean *)sourceBean;
        [sheet showC:bean.title cancel:@"取消" buttons:@[@"添加到播放列表",@"添加到播放队列",@"立即播放",@"从播放列表删除"] result:^(int nResult) {
            _showing = NO;
            PopOperationType operationType = PopOperationTypeCancel;
            switch (nResult) {
                case 0:{
                    operationType = PopOperationTypeAddToPlaylist;
                    PlaylistPopViewController *c = [[PlaylistPopViewController alloc] initFromXib];
                    c.songs = @[bean];
                    [c setCallback:^{
                        block();
                        [UIView ccMakeToast:@"添加成功"];
                    }];
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:c];
                    [presentingVC presentViewController:nav animated:YES completion:nil];
                    break;
                }
                case 1:{
                    operationType = PopOperationTypeAddToQueueBack;
                    PLAY_LATER(@[bean], 0);
                    block();
                    break;
                }
                case 2:{
                    operationType = PopOperationTypeAddToQueueNext;
                    PLAY_MUSIC(@[bean], 0);
                    block();
                    break;
                }
                case 3:{
                    operationType = PopOperationTypeRemoveFromPlaylist;
                    [DataTool deleteSongWithBean:bean callback:^(BOOL suc) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:PlaylistDidAddSongsNotification object:nil];
                        block();
                        [UIView ccMakeToast:@"删除成功"];
                    }];
                    break;
                }
                default:
                    break;
            }
        }];
    } else if ([sourceBean isKindOfClass:[MusicModel class]]) {
        MusicModel *bean = sourceBean;
        if (bean.isCollection) {
            [sheet showC:bean.title cancel:@"取消" buttons:@[@"添加到播放列表",@"添加到播放队列",@"立即播放",@"取消收藏"] result:^(int nResult) {
                _showing = NO;
                PopOperationType operationType = PopOperationTypeCancel;
                switch (nResult) {
                    case 0:{
                        operationType = PopOperationTypeAddToPlaylist;
                        PlaylistPopViewController *c = [[PlaylistPopViewController alloc] initFromXib];
                        c.songs = @[bean];
                        [c setCallback:^{
                            block();
                            [UIView ccMakeToast:@"添加成功"];
                        }];
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:c];
                        [presentingVC presentViewController:nav animated:YES completion:nil];
                        break;
                    }
                    case 1:{
                        operationType = PopOperationTypeAddToQueueBack;
                        PLAY_LATER(@[bean], 0);
                        block();
                        break;
                    }
                    case 2:{
                        operationType = PopOperationTypeAddToQueueNext;
                        PLAY_MUSIC(@[bean], 0);
                        block();
                        break;
                    }
                    case 3:{
                        operationType = PopOperationTypeRemoveFromCollection;
                        [DataTool removeSong:bean callback:^(BOOL suc) {
                            block();
                            [UIView ccMakeToast:@"取消成功"];
                        }];
                        break;
                    }
                    default:
                        break;
                }
 
            }];
        } else {
            [sheet showC:bean.title cancel:@"取消" buttons:@[@"添加到播放列表",@"添加到播放队列",@"立即播放",@"收藏",@"下载"] result:^(int nResult) {
                _showing = NO;
                PopOperationType operationType = PopOperationTypeCancel;
                switch (nResult) {
                    case 0:{
                        operationType = PopOperationTypeAddToPlaylist;
                        PlaylistPopViewController *c = [[PlaylistPopViewController alloc] initFromXib];
                        c.songs = @[bean];
                        [c setCallback:^{
                            block();
                            [UIView ccMakeToast:@"添加成功"];
                        }];
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:c];
                        [presentingVC presentViewController:nav animated:YES completion:nil];
                        break;
                    }
                    case 1:{
                        operationType = PopOperationTypeAddToQueueBack;
                        PLAY_LATER(@[bean], 0);
                        block();
                        break;
                    }
                    case 2:{
                        operationType = PopOperationTypeAddToQueueNext;
                        PLAY_MUSIC(@[bean], 0);
                        block();
                        break;
                    }
                    case 3:{
                        operationType = PopOperationTypeAddToCollection;
                        [DataTool addSong:bean callback:^(BOOL suc) {
                            block();
                            [UIView ccMakeToast:@"收藏成功"];
                        }];
                        break;
                    }
                    case 4:{
                        operationType = PopOperationTypeDownload;
                        DOWNLOAD_MUSIC(@[bean]);
                        block();
                        break;
                    }
                    default:
                        break;
                }

            }];
        }
        
    } else if ([sourceBean isKindOfClass:[PlaylistBean class]]) {
        PlaylistBean *bean = sourceBean;
        [sheet showC:bean.title cancel:@"取消" buttons:@[@"添加到播放列表",@"添加到播放队列",@"立即播放",@"删除"] result:^(int nResult) {
            _showing = NO;
            [DataTool getPlaylistSongsWithID:bean.playlist_id callback:^(NSArray *playlistSongs) {
                PopOperationType operationType = PopOperationTypeCancel;
                switch (nResult) {
                    case 0:{
                        operationType = PopOperationTypeAddToPlaylist;
                        PlaylistPopViewController *c = [[PlaylistPopViewController alloc] initFromXib];
                        c.songs = playlistSongs;
                        [c setCallback:^{
                            block();
                            [UIView ccMakeToast:@"添加成功"];
                        }];
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:c];
                        [presentingVC presentViewController:nav animated:YES completion:nil];
                        break;
                    }
                    case 1:{
                        operationType = PopOperationTypeAddToQueueBack;
                        PLAY_LATER(playlistSongs, 0);
                        block();
                        break;
                    }
                    case 2:{
                        operationType = PopOperationTypeAddToQueueNext;
                        PLAY_MUSIC(playlistSongs, 0);
                        block();
                        break;
                    }
                    case 3:{
                        operationType = PopOperationTypeDeletePlaylist;
                        [DataTool deletePlaylistWithBean:bean callback:^(BOOL suc) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:PlaylistDidAddSongsNotification object:nil];
                            block();
                            [UIView ccMakeToast:@"删除成功"];
                        }];
                        break;
                    }
                    default:
                        break;
                }
                
            }];
            
        }];
    } else if ([sourceBean isKindOfClass:[CategoryModel class]]) {
        CategoryModel *bean = sourceBean;
        [sheet showC:bean.title cancel:@"取消" buttons:@[@"添加到播放列表",@"添加到播放队列",@"立即播放"] result:^(int nResult) {
            _showing = NO;
            self.dataFetcher = [DataTool listMusicByCategoryId:bean.c_id callback:^(BOOL suc, id<DataFetcherProtocol> selfFetcher) {
                
                PopOperationType operationType = PopOperationTypeCancel;
                NSArray *playlistSongs = [selfFetcher dataArray];
                switch (nResult) {
                    case 0:{
                        operationType = PopOperationTypeAddToPlaylist;
                        
                        PlaylistPopViewController *c = [[PlaylistPopViewController alloc] initFromXib];
                        c.songs = playlistSongs;
                        [c setCallback:^{
                            block();
                            [UIView ccMakeToast:@"添加成功"];
                        }];
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:c];
                        [presentingVC presentViewController:nav animated:YES completion:nil];
                        break;
                    }
                    case 1:{
                        operationType = PopOperationTypeAddToQueueBack;
                        PLAY_LATER(playlistSongs, 0);
                        block();
                        break;
                    }
                    case 2:{
                        operationType = PopOperationTypeAddToQueueNext;
                        PLAY_MUSIC(playlistSongs, 0);
                        block();
                        break;
                    }
                    default:
                        break;
                }
            }];
        }];
    }

}

- (void)result:(NSInteger)result {
    
}

@end
