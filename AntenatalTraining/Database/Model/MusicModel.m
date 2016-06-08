//
//  MusicModel.m
//  AntenatalTraining
//
//  Created by mo jun on 4/30/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

- (NSURL *)audioFileURL {
    
    if ([FCFileManager isFileItemAtPath:[self downloadedFilePath]]) {
        return [NSURL fileURLWithPath:[self downloadedFilePath]];
    }
    
    NSString *url = [[kAuidoHost stringByAppendingString:self.mp3] stringByAppendingString:@".mp3"];
    return [NSURL URLWithString:url];
}

- (NSString *)audioHttpURL {
    NSString *url = [[kAuidoHost stringByAppendingString:self.mp3] stringByAppendingString:@".mp3"];
    return url;
}

- (NSString *)downloadedFilePath {
    return [NSString stringWithFormat:@"%@/%@.mp3",kATDownloadFilePath(@"at_music_download_file"), self.mp3];
}

- (BOOL)deleteSong {
    return YES;
}

- (ATImageEntity *)imageEntity {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@.jpg",@(self.c_id.integerValue - 1)] ofType:nil];
    ATImageEntity *entity = [ATImageEntity entityWithURL:[NSURL fileURLWithPath:imagePath]];
    return entity;
}

- (NSString *)imagePath {
    return [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"a_%@.jpg",@(self.c_id.integerValue - 1)] ofType:nil];
}

@end
