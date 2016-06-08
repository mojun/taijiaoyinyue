//
//  DownloadModel.h
//  AntenatalTraining
//
//  Created by test on 16/5/25.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "MusicModel.h"

@interface DownloadModel : MusicModel

// 0 add  start automatic   1 complete
@property (nonatomic, strong) NSNumber *state;
@property (nonatomic, strong) NSNumber *recieved_size;
@property (nonatomic, strong) NSNumber *total_size;

@end
