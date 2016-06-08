//
//  DataTool+Download.m
//  AntenatalTraining
//
//  Created by test on 16/5/25.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "DataTool+Download.h"
#import "DownloadManager.h"

@implementation DataTool (Download)

+ (void)getDownloadedList:(void (^)(NSArray *list))callback {
    
    NSArray *list = [[DownloadManager manager] getDownloadedList];
    if (callback) {
        callback(list);
    }
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSArray *list = [[DownloadManager manager] getDownloadedList];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (callback) {
//                callback(list);
//            }
//        });
//    });
}

+ (void)getDownloadingList:(void (^)(NSArray *list))callback {
    NSArray *list = [[DownloadManager manager] getDownloadingList];
    if (callback) {
        callback(list);
    }
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSArray *list = [[DownloadManager manager] getDownloadingList];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (callback) {
//                callback(list);
//            }
//        });
//    });
}


+ (DownloadModel *)addSongToDownload:(MusicModel *)music {
    return [[DownloadManager manager] addSongToDownload:music];
}


+ (BOOL)updateDown:(DownloadModel *)download {
    return [[DownloadManager manager] updateDown:download];
}

+ (BOOL)deleteDownload:(DownloadModel *)download {
    return [[DownloadManager manager] deleteDownload:download];
}

@end
