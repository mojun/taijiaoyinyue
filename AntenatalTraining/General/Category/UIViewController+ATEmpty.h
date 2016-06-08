//
//  UIViewController+ATEmpty.h
//  AntenatalTraining
//
//  Created by test on 16/5/31.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATEmptyView.h"

@interface UIViewController (ATEmpty)

@property (nonatomic, strong) ATEmptyView *emptyView;

- (void)hideBlank;

- (void)showDownloadedEmpty;

- (void)showDownloadingEmpty;

- (void)showPlaylistEmpty;

@end
