//
//  DownloadFinishedBar.h
//  AntenatalTraining
//
//  Created by test on 16/5/28.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchButton.h"

@class DownloadFinishedBar;
@protocol DownloadFinishedBarDelegate <NSObject>
@optional
/**
 *  @brief 按钮点击回调
 *  @param index 参数说明  0：随机播放 | 1：编辑 | 2：完成 | 3：取消
 *
 */
- (void)downloadFinishedBar:(DownloadFinishedBar *)bar
          didTouchedAtIndex:(NSInteger)index;

@end

@interface DownloadFinishedBar : UIView

@property (nonatomic, weak) id<DownloadFinishedBarDelegate> delegate;
@property (nonatomic, strong) TouchButton *playBtn;
@property (nonatomic, strong) TouchButton *editBtn; // state 1 2
@property (nonatomic, strong) TouchButton *cancelBtn;

@end
