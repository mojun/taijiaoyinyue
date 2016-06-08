//
//  MainViewController.m
//  AntenatalTraining
//
//  Created by test on 16/4/27.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "MainViewController.h"
#import "QueueViewController.h"
#import "QueueBarView.h"
#import <MMTransitionAnimator/MMTransitionAnimator.h>

@interface MainViewController () {
    
}

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) QueueBarView *handleBarView;
@property (nonatomic, strong) MMTransitionAnimator *animator;
@property (nonatomic, strong) UIViewController *currentController;

@end

@implementation MainViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[self containerView] addSubview:_currentController.view];
    self.queueVC.queueBar = [self handleBarView];
    [_currentController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_containerView);
    }];
    
    [self setupAnimator];
    
    _queueVC.view.backgroundColor = [UIColor grayColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    _currentController.view.frame = _containerView.frame;
}

#pragma mark - helper
- (void)setupAnimator {
    _animator = [[MMTransitionAnimator alloc]initWithOperationType:MMTransitionAnimatorOperationPresent fromVC:self toVC:_queueVC];
    _animator.usingSpringWithDamping = 0.8f;
    _animator.gestureTargetView = self.handleBarView;
    _animator.interactiveType = MMTransitionAnimatorOperationPresent;
    
    /// 在block中的成员变量也会引起retain cycle
    __weak __typeof(*&self) weakSelf = self;
    
    [_animator setGestureRecognizerShouldBegin:^BOOL(UIGestureRecognizer *gesture) {
        if (weakSelf.animator.interactiveType == MMTransitionAnimatorOperationDismiss) {
            CGPoint pt = [gesture locationInView:weakSelf.queueVC.view];
            if (CGRectContainsPoint(CGRectMake(0, 0, screenSize().width, screenSize().width), pt)) {
                return YES;
            } else {
                return NO;
            }
        }
        
        return YES;
    }];
    
    [_animator setPresentationBeforeHandler:^(UIView *containerView, id<UIViewControllerContextTransitioning> transitionContext) {
        [weakSelf beginAppearanceTransition:NO animated:NO];
        weakSelf.animator.direction = MMTransitionAnimatorDirectionTop;
        weakSelf.queueVC.view.frameY = weakSelf.handleBarView.frameBottom;
        
        [containerView addSubview:weakSelf.queueVC.view];
        [weakSelf.view layoutIfNeeded];
        [weakSelf.queueVC.view layoutIfNeeded];
        
        // handle pan
        CGFloat startOriginY = weakSelf.handleBarView.frameY;
        CGFloat endOriginY = -weakSelf.handleBarView.frameHeight;
        CGFloat diff = startOriginY - endOriginY;
        
        [weakSelf.animator setPresentationAnimationHandler:^(UIView *containerView, CGFloat percentComplete) {
            percentComplete = percentComplete >= 0 ? percentComplete : 0;
            CGFloat expectY = startOriginY - diff * percentComplete;
            if (expectY < endOriginY) {
                expectY = endOriginY;
            }
            weakSelf.handleBarView.frameY = expectY;
            
            weakSelf.queueVC.view.frameY = weakSelf.handleBarView.frameBottom;
            
            CGFloat alpha = 1.0 - (1.0 * percentComplete);
            weakSelf.containerView.alpha = 1.0f;//alpha + 0.5f;
            for (UIView *s in weakSelf.handleBarView.subviews) {
                s.alpha = alpha;
            }
            
        }];
        
        [weakSelf.animator setPresentationCancelAnimationHandler:^(UIView *containerView) {
            weakSelf.handleBarView.frameY = startOriginY;
            weakSelf.queueVC.view.frameY = weakSelf.handleBarView.frameHeight + startOriginY;
            weakSelf.containerView.alpha = 1.0;
            for (UIView *s in weakSelf.handleBarView.subviews) {
                s.alpha = 1.0;
            }
        }];
        
        [weakSelf.animator setPresentationCompletionHandler:^(UIView *containerView, BOOL completeTransition) {
            if (completeTransition) {
                weakSelf.animator.interactiveType = MMTransitionAnimatorOperationDismiss;
                weakSelf.animator.gestureTargetView = weakSelf.queueVC.view;
                weakSelf.animator.direction = MMTransitionAnimatorDirectionBottom;
            } else {
                [weakSelf beginAppearanceTransition:YES animated:NO];
                [weakSelf endAppearanceTransition];
            }
        }];
        
    }];
    
    [_animator setDismissalBeforeHandler:^(UIView *containerView, id<UIViewControllerContextTransitioning> transitionContext) {
        [weakSelf beginAppearanceTransition:YES animated:NO];
        [weakSelf.view addSubview:weakSelf.queueVC.view];
        [weakSelf.view layoutIfNeeded];
        [weakSelf.queueVC.view layoutIfNeeded];
        
        CGFloat startOriginY = 0 - weakSelf.handleBarView.frameHeight;
        CGFloat endOriginY = weakSelf.view.frameHeight - weakSelf.handleBarView.frameHeight;
        CGFloat diff = endOriginY - startOriginY;
        
//        weakSelf.containerView.alpha = 0.5f;
        [weakSelf.animator setDismissalAnimationHandler:^(UIView *containerView, CGFloat percentComplete) {
            percentComplete = percentComplete >= -0.05 ? percentComplete : -0.05;
            weakSelf.handleBarView.frameY = startOriginY + (diff * percentComplete);
            weakSelf.queueVC.view.frameY = weakSelf.handleBarView.frameY + weakSelf.handleBarView.frameHeight;
            
            CGFloat alpha = 1.0 * percentComplete;
            weakSelf.containerView.alpha = 1;//alpha + 0.5f;
            weakSelf.handleBarView.alpha = 1;
            for (UIView *s in weakSelf.handleBarView.subviews) {
                s.alpha = alpha;
            }
        }];
        
        [weakSelf.animator setDismissalCancelAnimationHandler:^(UIView *containerView) {
            weakSelf.handleBarView.frameY = startOriginY;
            weakSelf.queueVC.view.frameY = startOriginY + weakSelf.handleBarView.frameHeight;
            weakSelf.handleBarView.alpha = 0;
            weakSelf.containerView.alpha = 0.5f;
            for (UIView *s in weakSelf.handleBarView.subviews) {
                s.alpha = 0;
            }
        }];
        
        [weakSelf.animator setDismissalCompletionHandler:^(UIView *containerView, BOOL completeTransition) {
            if (completeTransition) {
                [weakSelf.queueVC.view removeFromSuperview];
                weakSelf.animator.gestureTargetView = weakSelf.handleBarView;
                weakSelf.animator.interactiveType = MMTransitionAnimatorOperationPresent;
            } else {
                [weakSelf.queueVC.view removeFromSuperview];
                [containerView addSubview:weakSelf.queueVC.view];
                [weakSelf beginAppearanceTransition:NO animated:NO];
                [weakSelf endAppearanceTransition];
            }
        }];
        
    }];
    
    self.queueVC.transitioningDelegate = self.animator;
}

#pragma mark - public
- (BOOL)showController:(UIViewController *)controller {
    if (!self.isViewLoaded) {
        _currentController = controller;
    } else {
        if ([_currentController isEqual:controller]) {
            return self.isViewLoaded;
        }
        
        __block UIViewController *oldController = self.currentController;
        self.currentController = controller;
        
        controller.view.frame = _containerView.frame;
        [_containerView addSubview:controller.view];
        
        UIViewController *ctrl = controller;
        if ([controller isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)controller;
            UIViewController *c = nav.topViewController;
            ctrl = c;
        }
        
        ctrl.view.alpha = 0;
        
        [UIView animateWithDuration:0.25 animations:^{
            ctrl.view.alpha = 1;
        } completion:^(BOOL finished) {
            [oldController.view removeFromSuperview];
        }];
        
    }
    return self.isViewLoaded;
}

#pragma mark - getters and setters
- (UIView *)containerView {
    
    if (_containerView == nil) {
        
        _containerView = [[UIView alloc] init];
        [self.view addSubview:_containerView];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-kQueueBarHeight);
        }];
    }
    return _containerView;
}

- (UIView *)handleBarView {
    if (_handleBarView == nil) {
        
        _handleBarView = [[QueueBarView alloc] initWithFrame:CGRectNull];
        [self.view addSubview:_handleBarView];
        [_handleBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_containerView.mas_bottom);
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [_handleBarView addGestureRecognizer:tap];
    }
    return _handleBarView;
}

#pragma mark - event response 
- (void)handleTap:(UIGestureRecognizer *)gesture {
    self.animator.interactiveType = MMTransitionAnimatorOperationNone;
    [self presentViewController:self.queueVC animated:YES completion:nil];
}


@end
