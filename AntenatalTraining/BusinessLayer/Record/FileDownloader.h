//
//  FileDownloader.h
//  AntenatalTraining
//
//  Created by test on 16/5/24.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TCBlobDownload/TCBlobDownload.h>

@class MusicModel;
@interface FileDownloader : NSObject

@property (nonatomic, strong, readonly) TCBlobDownloader *downloader;
@property (nonatomic, strong, readonly) MusicModel *music;

+ (instancetype)downloaderWithMusic:(MusicModel *)music delegate:(id<TCBlobDownloaderDelegate>)delegate;
- (instancetype)initWithMusic:(MusicModel *)music delegate:(id<TCBlobDownloaderDelegate>)delegate; 

- (void)start;

@end
