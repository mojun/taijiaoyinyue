//
//  PopSheetTool.h
//  AntenatalTraining
//
//  Created by mo jun on 5/17/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PopOperationType) {
    PopOperationTypeAddToPlaylist,  // category, music, playlist
    PopOperationTypeRemoveFromPlaylist, // playlistsong
    PopOperationTypeDeletePlaylist, // playlist
    PopOperationTypeAddToQueueBack, // category, music, playlist
    PopOperationTypeAddToQueueNext, // category, music, playlist
    PopOperationTypeAddToCollection,// music
    PopOperationTypeRemoveFromCollection,// music
    PopOperationTypeEditPlaylist,
    PopOperationTypeDownload,
    
    PopOperationTypeCancel,
    PopOperationTypeNotHandle
};

@protocol PopSheetToolDelegate <NSObject>



@end

@interface PopSheetTool : NSObject

+ (instancetype)tool;

- (void)showWithOperationBean:(id)sourceBean
           operationTypeBlock:(void (^)(void))block;

@end
