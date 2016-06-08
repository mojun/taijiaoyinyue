//
//  PZProgressBar.m
//  PlayZer
//
//  Created by mo jun on 1/6/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "PZProgressBar.h"

@implementation PZProgressBar{
    UIView  *_progressBgView;
    UIView  *_progressPassedView;
    
    UIView  *_handlerView;
    
    BOOL    _holdHandler;
    
    UIView  *_handlerLineView;
    
    CGFloat _startCenterX;
}

- (instancetype)init{
    if (self = [super init]) {
        
        _holdHandler = NO;
        
        _progressBgView = [UIView new];
        _progressBgView.backgroundColor = kThemeGrayColor;
        _progressBgView.alpha = 0.8f;
        [self addSubview:_progressBgView];
        
        _progressPassedView = [UIView new];
        _progressPassedView.backgroundColor = kThemeColor;
        _progressPassedView.alpha = 0.8f;
        [self addSubview:_progressPassedView];
        
        _handlerView = [UIView new];
        _handlerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_handlerView];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [_handlerView addGestureRecognizer:pan];
        
        _handlerLineView = [UIView new];
        _handlerLineView.backgroundColor = kThemeColor;
        [_handlerView addSubview:_handlerLineView];
        _handlerLineView.alpha = 0.8;
    }
    return self;
}

- (void)setProgress:(CGFloat)progress{
    if(_holdHandler) return;
    
    if (_progress != progress) {
        BOOL animated = _progress < progress;
        _progress = progress;
        CGFloat progressLength = CGRectGetWidth(self.bounds) * _progress;
        CGRect rect = _progressPassedView.frame;
        rect.size.width = progressLength;
        
        CGPoint handlerCenter = _handlerView.center;
        handlerCenter.x = progressLength;
        if (animated) {
            [UIView animateWithDuration:0.5 animations:^{
                _progressPassedView.frame = rect;
                _handlerView.center = handlerCenter;
            }];
        } else {
            _progressPassedView.frame = rect;
            _handlerView.center = handlerCenter;
        }
    }
}

- (void)setProgressNoneAnimated:(CGFloat)progress{
    if (_progress != progress) {
        _progress = progress;
        CGFloat progressLength = CGRectGetWidth(self.bounds) * _progress;
        CGRect rect = _progressPassedView.frame;
        rect.size.width = progressLength;
        
        CGPoint handlerCenter = _handlerView.center;
        handlerCenter.x = progressLength;
        _progressPassedView.frame = rect;
        _handlerView.center = handlerCenter;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture{
    UIGestureRecognizerState state = gesture.state;
    switch (state) {
        case UIGestureRecognizerStateBegan:{
            _startCenterX = _handlerView.center.x;
            _holdHandler = YES;
            void(^b)(void) = self.panBegin;
            if (b) {
                b();
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            CGFloat x = [gesture translationInView:self].x;
            NSLog(@"x: %@", @(x));
            
            CGPoint center = _handlerView.center;
            CGFloat xPos = x + _startCenterX;
            CGFloat maxX = CGRectGetWidth(self.bounds);
            xPos = MAX(xPos, 0);
            xPos = MIN(maxX, xPos);
            CGFloat progress = xPos / maxX;
            [self setProgressNoneAnimated:progress];
            
            _handlerView.center = center;
            void(^b)(CGFloat) = self.panChanged;
            if (b) {
                b(progress);
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            void(^b)(void) = self.panEnded;
            if (b) {
                b();
            }
            _holdHandler = NO;
            break;
        }
        case UIGestureRecognizerStateCancelled:{
            void(^b)(void) = self.panCancelled;
            if (b) {
                b();
            }
            _holdHandler = NO;
            break;
        }
        default:
            break;
    }
}

- (void)layoutSubviews{
    CGRect bounds = self.bounds;
    CGFloat width = CGRectGetWidth(bounds);
    
     _progressBgView.frame = CGRectMake(0, 0, width, 3);
    
    _progressPassedView.frame = CGRectMake(0, 0, width * _progress, 3);
    
    _handlerView.frame = CGRectMake(-40 * 0.5 + width * _progress, 0, 40, 38);
    
    _handlerLineView.frame = CGRectMake(0, 0, 2, 38 * 0.4);
    _handlerLineView.center = CGPointMake(CGRectGetMidX(_handlerView.bounds), CGRectGetMidY(_handlerView.bounds) * 0.4f);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
