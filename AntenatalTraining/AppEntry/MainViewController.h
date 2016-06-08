//
//  MainViewController.h
//  AntenatalTraining
//
//  Created by test on 16/4/27.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QueueViewController;
@interface MainViewController : UIViewController

/// 返回bool值表示是否加载
- (BOOL)showController:(UIViewController *)controller;

@property (nonatomic, strong) QueueViewController *queueVC;

@end
