//
//  MMTransitionAnimator.m
//  MusicPlaybackTransition
//
//  Created by mojun on 16/2/26.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "MMTransitionAnimator.h"

@interface MMTransitionAnimator ()<UIGestureRecognizerDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UIPanGestureRecognizer *gesture;
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, assign) CGFloat panLocationStart;
@property (nonatomic, weak) UIViewController *fromVC;
@property (nonatomic, weak) UIViewController *toVC;
@property (nonatomic, assign) MMTransitionAnimatorOperation operationType;

@end

@implementation MMTransitionAnimator

#pragma mark - life cycle 
- (instancetype)initWithOperationType:(MMTransitionAnimatorOperation)operationType
                               fromVC:(UIViewController *)fromVC
                                 toVC:(UIViewController *)toVC {
    if (self = [super init]) {
        _operationType = operationType;
        _fromVC = fromVC;
        _toVC = toVC;
        
        _usingSpringWithDamping = 1.0;
        _transitionDuration = 0.5f;
        _initialSpringVelocity = 0.1;
        _useKeyframeAnimation = NO;
        _panCompletionThreshold = 100;
        
        _panCompletionTranslation = 200;
        
        if (_operationType == MMTransitionAnimatorOperationPush ||
            _operationType == MMTransitionAnimatorOperationPresent) {
            _isPresenting = YES;
        } else if (_operationType == MMTransitionAnimatorOperationPop ||
                   _operationType == MMTransitionAnimatorOperationDismiss) {
            _isPresenting = NO;
        }
    }
    return self;
}

#pragma mark - event response
- (void)handlePan:(UIPanGestureRecognizer *)recognizer {

    UIWindow *window = nil;
    if (_interactiveType == MMTransitionAnimatorOperationPush ||
        _interactiveType == MMTransitionAnimatorOperationPresent) {
        window = self.fromVC.view.window;
    } else if (_interactiveType == MMTransitionAnimatorOperationPop ||
               _interactiveType == MMTransitionAnimatorOperationDismiss) {
        window = self.toVC.view.window;
    } else {
        return;
    }
    CGPoint location = [recognizer locationInView:window];
    location = CGPointApplyAffineTransform(location, CGAffineTransformInvert(recognizer.view.transform));
    CGPoint velocity = [recognizer velocityInView:window];
    velocity = CGPointApplyAffineTransform(velocity, CGAffineTransformInvert(recognizer.view.transform));
    UIGestureRecognizerState state = recognizer.state;
    if (state == UIGestureRecognizerStateBegan) {
        [self __setPanStartPoint:location];
        
        if (_contentScrollView) {
            if (_contentScrollView.contentOffset.y <= 0) {
                [self __startGestureTransition];
            }
        } else {
            [self __startGestureTransition];
        }
    } else if (state == UIGestureRecognizerStateChanged) {
        CGRect bounds = CGRectZero;
        switch (_interactiveType) {
            case MMTransitionAnimatorOperationPush:
            case MMTransitionAnimatorOperationPresent:
                bounds = self.fromVC.view.bounds;
                break;
            case MMTransitionAnimatorOperationPop:
            case MMTransitionAnimatorOperationDismiss:
                bounds = self.toVC.view.bounds;
                break;
            default:
                break;
        }
        
        CGFloat animationRatio = 0.0;
        switch (_direction) {
            case MMTransitionAnimatorDirectionTop:
                animationRatio = (_panLocationStart - location.y) / CGRectGetHeight(bounds);
                break;
            case MMTransitionAnimatorDirectionBottom:
                animationRatio = (location.y - _panLocationStart) / CGRectGetHeight(bounds);
                break;
            case MMTransitionAnimatorDirectionLeft:
                animationRatio = (_panLocationStart - location.x) / CGRectGetWidth(bounds);
                break;
            case MMTransitionAnimatorDirectionRight:
                animationRatio = (location.x - _panLocationStart) / CGRectGetWidth(bounds);
                break;
            default:
                break;
        }
        
        if (_contentScrollView) {
            if (_isTransitioning == NO && _contentScrollView.contentOffset.y <= 0) {
                [self __setPanStartPoint:location];
                [self __startGestureTransition];
            } else {
                [self updateInteractiveTransition:animationRatio];
            }
        } else {
            [self updateInteractiveTransition:animationRatio];
        }
    } else if (state == UIGestureRecognizerStateEnded) {
        CGFloat velocityForSelectedDirection = 0;
        CGFloat locationForSelectedDirection = 0;
        switch (_direction) {
            case MMTransitionAnimatorDirectionTop:
            case MMTransitionAnimatorDirectionBottom:
                velocityForSelectedDirection = velocity.y;
                locationForSelectedDirection = location.y;
                break;
            case MMTransitionAnimatorDirectionLeft:
            case MMTransitionAnimatorDirectionRight:
                velocityForSelectedDirection = velocity.x;
                locationForSelectedDirection = location.y;
                break;
            default:
                break;
        }
        
        /// velocity and translation to check the interactionTransition is complete.
        if (velocityForSelectedDirection > self.panCompletionThreshold && (_direction == MMTransitionAnimatorDirectionRight || _direction == MMTransitionAnimatorDirectionBottom)) {
            [self finishInteractiveTransitionAnimated:YES];
        } else if (velocityForSelectedDirection < -self.panCompletionThreshold && (_direction == MMTransitionAnimatorDirectionLeft || _direction == MMTransitionAnimatorDirectionTop)) {
            [self finishInteractiveTransitionAnimated:YES];
        } else if (_panLocationStart - locationForSelectedDirection < -self.panCompletionTranslation && (_direction == MMTransitionAnimatorDirectionRight || _direction == MMTransitionAnimatorDirectionBottom)) {
            [self finishInteractiveTransitionAnimated:YES];
        } else if (_panLocationStart - locationForSelectedDirection > self.panCompletionTranslation && (_direction == MMTransitionAnimatorDirectionLeft || _direction == MMTransitionAnimatorDirectionTop)) {
            [self finishInteractiveTransitionAnimated:YES];
        } else {
            BOOL animated = _contentScrollView.contentOffset.y <= 0;
            [self cancelInteractiveTransitionAnimated:animated];
        }
        [self __resetGestureTransitionSetting];
    } else {
        [self __resetGestureTransitionSetting];
        if (_isTransitioning) {
            [self cancelInteractiveTransitionAnimated:YES];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return _contentScrollView != nil ? YES : NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
 
    if (self.gestureRecognizerShouldBegin) {
        return self.gestureRecognizerShouldBegin(gestureRecognizer);
    } else {
        return YES;
    }
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return self.transitionDuration;
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    if (_interactiveType == MMTransitionAnimatorOperationPush ||
        _interactiveType == MMTransitionAnimatorOperationPresent) {
        _isPresenting = YES;
    } else if (_interactiveType == MMTransitionAnimatorOperationPop ||
               _interactiveType == MMTransitionAnimatorOperationDismiss) {
        _isPresenting = NO;
    }
    _transitionContext = transitionContext;
    [self __fireBeforeHandler:containerView transitionContext:transitionContext];
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    _transitionContext = transitionContext;
    [self __fireBeforeHandler:[transitionContext containerView] transitionContext:transitionContext];
    [self __animationWithDuration:[self transitionDuration:transitionContext] containerView:[transitionContext containerView] completeTransition:YES completion:^{
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)animationEnded:(BOOL)transitionCompleted{
    _transitionContext = nil;
}

#pragma mark - UIPercentDrivenInteractiveTransition
- (void)updateInteractiveTransition:(CGFloat)percentComplete {
    [super updateInteractiveTransition:percentComplete];
    if (_transitionContext) {
        [self __fireAnimationHandler:[_transitionContext containerView] percentComplete:percentComplete];
    }
}

- (void)finishInteractiveTransitionAnimated:(BOOL)animated {
    [super finishInteractiveTransition];
    if (_transitionContext) {
        [self __animationWithDuration:animated ? [self transitionDuration:_transitionContext] : 0 containerView:[_transitionContext containerView] completeTransition:YES completion:^{
            [_transitionContext completeTransition:YES];
        }];
    }
}

- (void)cancelInteractiveTransitionAnimated:(BOOL)animated {
    [super cancelInteractiveTransition];
    if (_transitionContext) {
        [self __animationWithDuration:animated ? [self transitionDuration:_transitionContext] : 0 containerView:[_transitionContext containerView] completeTransition:NO completion:^{
            [_transitionContext completeTransition:NO];
        }];
    }
}

#pragma mark - UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _isPresenting = YES;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    _isPresenting = NO;
    return self;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
    if (_gesture && (_interactiveType == MMTransitionAnimatorOperationPush || _interactiveType == MMTransitionAnimatorOperationPresent)) {
        _isPresenting = YES;
        return self;
    }
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    if (_gesture != nil && (_interactiveType == MMTransitionAnimatorOperationPop || _interactiveType == MMTransitionAnimatorOperationDismiss)) {
        _isPresenting = false;
        return self;
    }
    return nil;
}

#pragma mark - public methods

#pragma mark - private methods
- (void)__setPanStartPoint:(CGPoint)location {
    if (_direction == MMTransitionAnimatorDirectionTop ||
        _direction == MMTransitionAnimatorDirectionBottom) {
        _panLocationStart = location.y;
    } else if (_direction == MMTransitionAnimatorDirectionLeft ||
               _direction == MMTransitionAnimatorDirectionRight) {
        _panLocationStart = location.x;
    }
}

- (void)__startGestureTransition {
    if (_isTransitioning == NO) {
        _isTransitioning = YES;
        switch (_interactiveType) {
            case MMTransitionAnimatorOperationPush:
                [self.fromVC.navigationController pushViewController:self.toVC animated:YES];
                break;
            case MMTransitionAnimatorOperationPresent:
                [self.fromVC presentViewController:self.toVC animated:YES completion:nil];
                break;
            case MMTransitionAnimatorOperationPop:
                [self.toVC.navigationController popViewControllerAnimated:YES];
                break;
            case MMTransitionAnimatorOperationDismiss:
                [self.toVC dismissViewControllerAnimated:YES completion:nil];
                break;
            default:
                break;
        }
    }
}

- (void)__resetGestureTransitionSetting {
    _isTransitioning = NO;
}

- (void)__unregisterPanGesture {
    if (_gesture && _gesture.view) {
        [_gesture.view removeGestureRecognizer:_gesture];
    }
    _gesture.delegate = nil;
    _gesture = nil;
}

- (void)__registerPanGesture {
    [self __unregisterPanGesture];
    
    _gesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    _gesture.delegate = self;
    _gesture.maximumNumberOfTouches = 1;
    
    if (_gestureTargetView) {
        [_gestureTargetView addGestureRecognizer:_gesture];
    } else {
        switch (_interactiveType) {
            case MMTransitionAnimatorOperationPush:
            case MMTransitionAnimatorOperationPresent:
            {
                [self.fromVC.view addGestureRecognizer:_gesture];
                break;
            }
            case MMTransitionAnimatorOperationPop:
            case MMTransitionAnimatorOperationDismiss:
            {
                [self.toVC.view addGestureRecognizer:_gesture];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - fire Handler
- (void)__fireBeforeHandler:(UIView *)containerView
        transitionContext:(id<UIViewControllerContextTransitioning>)transitionContext {
    void (^b)(UIView *, id<UIViewControllerContextTransitioning>) = _isPresenting ? self.presentationBeforeHandler : self.dismissalBeforeHandler;
    if (b) { b(containerView, transitionContext); }
}

- (void)__fireAnimationHandler:(UIView *)containerView
             percentComplete:(CGFloat)percentComplete {
    void (^b)(UIView *, CGFloat) = _isPresenting ? self.presentationAnimationHandler : self.dismissalAnimationHandler;
    if (b) { b(containerView, percentComplete); }
}

- (void)__fireCancelAnimationHandler:(UIView *)containerView {
    void (^b)(UIView *) = _isPresenting ? self.presentationCancelAnimationHandler : self.dismissalCancelAnimationHandler;
    if (b) { b(containerView); }
}

- (void)__fireCompletionHandler:(UIView *)containerView
             completeTransition:(BOOL)completeTransition {
    void (^b)(UIView *, BOOL) = _isPresenting ? self.presentationCompletionHandler : self.dismissalCompletionHandler;
    if (b) { b(containerView, completeTransition); }
}

- (void)__animationWithDuration:(NSTimeInterval)duration
                  containerView:(UIView *)containerView
             completeTransition:(BOOL)completeTransition
                     completion:(void (^)(void))completion {
    __weak __typeof(self)weakSelf = self;
    void (^animations)(void) = ^{
        if (completeTransition) {
            [weakSelf __fireAnimationHandler:containerView percentComplete:1];
        } else {
            [weakSelf __fireCancelAnimationHandler:containerView];
        }
    };
    
    void (^animationCompletion)(BOOL) = ^(BOOL finished){
        [weakSelf __fireCompletionHandler:containerView completeTransition:completeTransition];
        if (completion) { completion(); }
    };
    
    if (_useKeyframeAnimation) {
        [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:animations completion:animationCompletion];
    } else {
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:_usingSpringWithDamping initialSpringVelocity:_initialSpringVelocity options:UIViewAnimationOptionCurveEaseOut animations:animations completion:animationCompletion];
    }
}

#pragma mark - getters and setters
- (void)setGestureTargetView:(UIView *)gestureTargetView {
    if (_gestureTargetView != gestureTargetView) {
        [self __unregisterPanGesture];
        _gestureTargetView = gestureTargetView;
        [self __registerPanGesture];
    }
}

- (void)setInteractiveType:(MMTransitionAnimatorOperation)interactiveType{
    _interactiveType = interactiveType;
    if (_interactiveType == MMTransitionAnimatorOperationNone) {
        [self __unregisterPanGesture];
    } else {
        [self __registerPanGesture];
    }
}

@end
