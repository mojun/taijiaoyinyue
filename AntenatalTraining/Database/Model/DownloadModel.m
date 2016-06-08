//
//  DownloadModel.m
//  AntenatalTraining
//
//  Created by test on 16/5/25.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "DownloadModel.h"
#import "DataTool+Download.h"

@implementation DownloadModel

- (BOOL)deleteSong {
    
    if ([FCFileManager isFileItemAtPath:[self downloadedFilePath]]) {
        if ([FCFileManager removeItemAtPath:[self downloadedFilePath]] == NO) {
            return NO;
        }
    }
    return [DataTool deleteDownload:self];
}

@end
