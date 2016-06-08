//
//  FileDownloader.m
//  AntenatalTraining
//
//  Created by test on 16/5/24.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "FileDownloader.h"
#import "MusicModel.h"

@implementation FileDownloader

- (instancetype)initWithMusic:(MusicModel *)music delegate:(id<TCBlobDownloaderDelegate>)delegate{
    if (self = [super init]) {
        _music = music;
        
        TCBlobDownloader *downloader = [[TCBlobDownloader alloc] initWithURL:[NSURL URLWithString:[_music audioHttpURL]] downloadPath:kATDownloadFilePath(@"at_music_download_file") delegate:delegate];
        _downloader = downloader;
    }
    return self;
}

+ (instancetype)downloaderWithMusic:(MusicModel *)music delegate:(id<TCBlobDownloaderDelegate>)delegate{
    return [[[self class]alloc]initWithMusic:music delegate:delegate];
}

- (void)start {
    [[TCBlobDownloadManager sharedInstance] startDownload:self.downloader];
}

@end
