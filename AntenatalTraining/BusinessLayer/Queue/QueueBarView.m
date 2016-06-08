//
//  QueueBarView.m
//  AntenatalTraining
//
//  Created by mo jun on 5/7/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "QueueBarView.h"

@implementation QueueBarView {
    UIView              *_blurContainer;
    UIImageView         *_maskImageView;
    UIView              *_progressBgView;
    UIView              *_progressPassedView;
    UIButton            *_playPauseButton;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        
        self.clipsToBounds = YES;
        _blurContainer = [UIView new];
        _blurContainer.clipsToBounds = YES;
        [self addSubview:_blurContainer];
        
        _bgCoverImageView = [UIImageView new];
        _bgCoverImageView.contentMode = UIViewContentModeScaleToFill;
        [_blurContainer addSubview:_bgCoverImageView];
        
        _maskImageView = [UIImageView new];
        _maskImageView.image = [UIImage imageNamed:@"queuebar_mask"];
        [_blurContainer addSubview:_maskImageView];
        
        
        _coverImageView = [UIImageView new];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.layer.masksToBounds = YES;
        [self addSubview:_coverImageView];
        
        _progressBgView = [UIView new];
        _progressBgView.backgroundColor = kThemeGrayColor;
        _progressBgView.alpha = 0.8f;
        [self addSubview:_progressBgView];
        
        _progressPassedView = [UIView new];
        _progressPassedView.backgroundColor = kThemeColor;
        _progressPassedView.alpha = 0.8f;
        [self addSubview:_progressPassedView];
        
        _playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_playPauseButton];
        
        [_playPauseButton setImage:[UIImage imageNamed:@"btn_controlbar_play"] forState:UIControlStateNormal];
        [_playPauseButton setImage:[UIImage imageNamed:@"btn_controlbar_pause"] forState:UIControlStateSelected];
        [_playPauseButton addTarget:self action:@selector(playPauseButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectNull];
        [self addSubview:_titleLabel];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _titleLabel.textColor = UIColor_RGB(24, 24, 24);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _subTitleLabel = [[UILabel alloc]initWithFrame:CGRectNull];
        [self addSubview:_subTitleLabel];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.textColor = UIColor_RGB(120, 120, 120);
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return self;
}

- (void)playPauseButton:(id)sender{
    void (^b)(void) = self.playPauseBlock;
    if (b) {
        b();
    }
}

- (void)setProgress:(CGFloat)progress{
    if (_progress != progress) {
        BOOL animated = _progress < progress;
        _progress = progress;
        CGRect rect = _progressPassedView.frame;
        rect.size.width = CGRectGetWidth(self.bounds) * _progress;
        if (animated) {
            [UIView animateWithDuration:0.5 animations:^{
                _progressPassedView.frame = rect;
            }];
        } else {
            _progressPassedView.frame = rect;
        }
    }
}

- (void)setIsPlaying:(BOOL)isPlaying{
    if (isPlaying != _isPlaying) {
        _isPlaying = isPlaying;
        _playPauseButton.selected = _isPlaying;
    }
}

- (void)layoutSubviews{
    CGRect bounds = self.bounds;
    CGFloat width = CGRectGetWidth(bounds);
    _blurContainer.frame = bounds;
    _maskImageView.frame = bounds;
    
    CGFloat height = CGRectGetHeight(bounds);
    
    CGRect coverRect = CGRectMake(0, (height - width) * 0.5f, width, width);
    _bgCoverImageView.frame = coverRect;
    
    _coverImageView.frame = CGRectMake(0, 0, height, height);
    
    _progressBgView.frame = CGRectMake(0, 0, width, kQueueBarProgressHeight);
    
    _progressPassedView.frame = CGRectMake(0, 0, width * _progress, kQueueBarProgressHeight);
    
    _playPauseButton.frame = CGRectMake(width - height, 0, height, height);
    
    CGFloat paddingX = height;
    _titleLabel.frame = CGRectMake(paddingX, (height - 24) * 0.5f, width - paddingX * 2, 24);
    _subTitleLabel.frame = CGRectMake(paddingX, height * 0.5, width - paddingX * 2, 20);
}

@end
