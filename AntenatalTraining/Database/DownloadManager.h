//
//  DownloadManager.h
//  AntenatalTraining
//
//  Created by test on 16/5/25.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"
#import "DownloadModel.h"

@interface DownloadManager : NSObject

+ (instancetype)manager;

- (NSArray *)getDownloadedList;
- (NSArray *)getDownloadingList;

- (DownloadModel *)addSongToDownload:(MusicModel *)music;

- (BOOL)updateDown:(DownloadModel *)download;

- (BOOL)deleteDownload:(DownloadModel *)download;

@end
