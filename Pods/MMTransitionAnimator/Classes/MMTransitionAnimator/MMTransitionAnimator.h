//
//  MMTransitionAnimator.h
//  MusicPlaybackTransition
//
//  Created by mojun on 16/2/26.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MMTransitionAnimatorDirection) {
    MMTransitionAnimatorDirectionTop,
    MMTransitionAnimatorDirectionBottom,
    MMTransitionAnimatorDirectionLeft,
    MMTransitionAnimatorDirectionRight
};

typedef NS_ENUM(NSInteger, MMTransitionAnimatorOperation) {
    MMTransitionAnimatorOperationNone,
    MMTransitionAnimatorOperationPush,
    MMTransitionAnimatorOperationPop,
    MMTransitionAnimatorOperationPresent,
    MMTransitionAnimatorOperationDismiss
};

@interface MMTransitionAnimator : UIPercentDrivenInteractiveTransition<UIViewControllerTransitioningDelegate>

/// Animation Settings
@property (nonatomic, assign) CGFloat usingSpringWithDamping;
@property (nonatomic, assign) NSTimeInterval transitionDuration;
@property (nonatomic, assign) CGFloat initialSpringVelocity;
@property (nonatomic, assign) BOOL useKeyframeAnimation;

/// Interactive Transition Gesture
@property (nonatomic, weak) UIView *gestureTargetView;

/// velocity to trigger completion, default 100.0f
@property (nonatomic, assign) CGFloat panCompletionThreshold;
/// translation to trigger completion, default 200.0f
@property (nonatomic, assign) CGFloat panCompletionTranslation;
@property (nonatomic, assign) MMTransitionAnimatorDirection direction;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, assign) MMTransitionAnimatorOperation interactiveType;

@property (nonatomic, assign) BOOL isPresenting;
@property (nonatomic, assign) BOOL isTransitioning;

/// interactive handler block
@property (nonatomic, copy) void (^presentationBeforeHandler)(UIView *containerView, id<UIViewControllerContextTransitioning> transitionContext);
@property (nonatomic, copy) void (^presentationAnimationHandler)(UIView *containerView, CGFloat percentComplete);
@property (nonatomic, copy) void (^presentationCancelAnimationHandler)(UIView *containerView);
@property (nonatomic, copy) void (^presentationCompletionHandler)(UIView *containerView, BOOL completeTransition);

@property (nonatomic, copy) void (^dismissalBeforeHandler)(UIView *containerView, id<UIViewControllerContextTransitioning> transitionContext);
@property (nonatomic, copy) void (^dismissalAnimationHandler)(UIView *containerView, CGFloat percentComplete);
@property (nonatomic, copy) void (^dismissalCancelAnimationHandler)(UIView *containerView);
@property (nonatomic, copy) void (^dismissalCompletionHandler)(UIView *containerView, BOOL completeTransition);

@property (nonatomic, copy) BOOL (^gestureRecognizerShouldBegin)(UIGestureRecognizer *gesture);

- (instancetype)initWithOperationType:(MMTransitionAnimatorOperation)operationType
                               fromVC:(UIViewController *)fromVC
                                 toVC:(UIViewController *)toVC;

@end
