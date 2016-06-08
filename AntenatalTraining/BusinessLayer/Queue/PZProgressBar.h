//
//  PZProgressBar.h
//  PlayZer
//
//  Created by mo jun on 1/6/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PZProgressBar : UIView

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, copy) void (^panBegin)(void);
@property (nonatomic, copy) void (^panChanged)(CGFloat progress);
@property (nonatomic, copy) void (^panEnded)(void);
@property (nonatomic, copy) void (^panCancelled)(void);

@end
