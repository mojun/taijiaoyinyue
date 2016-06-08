//
//  MusicModel.h
//  AntenatalTraining
//
//  Created by mo jun on 4/30/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATImageEntity.h"

@interface MusicModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *c_id;
@property (nonatomic, strong) NSString *file_size;
@property (nonatomic, strong) NSNumber *m_id;
@property (nonatomic, strong) NSString *mp3;

@property (nonatomic, assign) BOOL isCollection;
@property (nonatomic, strong) ATImageEntity *imageEntity;

- (NSString *)imagePath;

// play
- (NSURL *)audioFileURL;

- (NSString *)audioHttpURL;

// 下载文件路径
- (NSString *)downloadedFilePath;

// 删除文件
- (BOOL)deleteSong;

@end
