//
//  DataTool+Download.h
//  AntenatalTraining
//
//  Created by test on 16/5/25.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "DataTool.h"
#import "DownloadModel.h"

@interface DataTool (Download)

+ (void)getDownloadedList:(void (^)(NSArray *list))callback;
+ (void)getDownloadingList:(void (^)(NSArray *list))callback;

+ (DownloadModel *)addSongToDownload:(MusicModel *)music;

+ (BOOL)updateDown:(DownloadModel *)download;

+ (BOOL)deleteDownload:(DownloadModel *)download;

@end
