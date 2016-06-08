//
//  QueueBarView.h
//  AntenatalTraining
//
//  Created by mo jun on 5/7/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueueBarView : UIView

@property (nonatomic, copy) void(^playPauseBlock)(void);
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *bgCoverImageView;
///
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL isPlaying;

@end
