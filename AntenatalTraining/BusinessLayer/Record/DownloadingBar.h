//
//  DownloadingBar.h
//  AntenatalTraining
//
//  Created by test on 16/5/28.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchButton.h"

@class DownloadingBar;
@protocol DownloadingBarDelegate <NSObject>
@optional
/**
 *  @brief 按钮点击回调
 *  @param index 参数说明  0：开始下载 | 1：暂停下载 | 2：编辑 | 3：完成 | 4：取消
 *
 */
- (void)downloadingBar:(DownloadingBar *)bar
     didTouchedAtIndex:(NSInteger)index;

@end

@interface DownloadingBar : UIView

@property (nonatomic, weak) id<DownloadingBarDelegate> delegate;
@property (nonatomic, strong) TouchButton *pauseBtn;
@property (nonatomic, strong) TouchButton *editBtn; // state 1 2
@property (nonatomic, strong) TouchButton *cancelBtn;

- (void)pause:(BOOL)pause;

@end
