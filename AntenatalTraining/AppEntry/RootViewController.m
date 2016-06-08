//
//  RootViewController.m
//  PlayZer
//
//  Created by mo jun on 6/30/15.
//  Copyright (c) 2015 kimoworks. All rights reserved.
//

#import "RootViewController.h"
#import "LeftViewController.h"
#import "MainViewController.h"

@interface RootViewController ()<UIGestureRecognizerDelegate>{
    IBOutlet UIView *_leftContainerView;
    IBOutlet UIView *_mainContainerView;
    IBOutlet NSLayoutConstraint *_mainLeftConstraint;
    
    BOOL _showLeftFlag;
    BOOL _animating;
    CGFloat _xStartLocation;
    
    UIView *_mainMaskView;
}

@end

@implementation RootViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _showLeftFlag = YES;
    }
    return self;
}

- (BOOL)shouldAutorotate{
    return !self.isShowingLeft && _mainViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return _mainViewController.supportedInterfaceOrientations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_mainContainerView addSubview:_mainViewController.view];
    [_mainViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_mainContainerView);
    }];
    [self addChildViewController:_mainViewController];
    
    _mainContainerView.layer.shadowColor = [UIColor blackColor].CGColor;
    _mainContainerView.layer.shadowOffset = CGSizeMake(4, 0);
    _mainContainerView.layer.shadowOpacity = 0.8;
    _mainContainerView.layer.shadowRadius = 4;
    
    [_leftContainerView addSubview:_leftViewController.view];
    [_leftViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_leftViewController.view.superview);
    }];
    [self addChildViewController:_leftViewController];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(gestureHandler:)];
    pan.delegate = self;
    [_mainContainerView addGestureRecognizer:pan];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gestureHandler:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeft.delegate = self;
    [_mainContainerView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gestureHandler:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.delegate = self;
    [_mainContainerView addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeLeftDown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gestureHandler:)];
    swipeLeftDown.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionDown;
    swipeLeftDown.delegate = self;
    [_mainContainerView addGestureRecognizer:swipeLeftDown];
    
    UISwipeGestureRecognizer *swipeRightUp = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gestureHandler:)];
    swipeRightUp.direction = UISwipeGestureRecognizerDirectionRight | UISwipeGestureRecognizerDirectionUp;
    swipeRightUp.delegate = self;
    [_mainContainerView addGestureRecognizer:swipeRightUp];
    
//    [pan requireGestureRecognizerToFail:swipeLeft];
//    [pan requireGestureRecognizerToFail:swipeRight];
//    [pan requireGestureRecognizerToFail:swipeLeftDown];
//    [pan requireGestureRecognizerToFail:swipeRightUp];
    [swipeLeft requireGestureRecognizerToFail:pan];
    [swipeRight requireGestureRecognizerToFail:pan];
    [swipeLeftDown requireGestureRecognizerToFail:pan];
    [swipeRightUp requireGestureRecognizerToFail:pan];
    
    _mainMaskView = [UIView new];
    _mainMaskView.backgroundColor = [UIColor clearColor];
    [_mainContainerView addSubview:_mainMaskView];
    [_mainMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_mainMaskView.superview);
    }];
    _mainMaskView.hidden = YES;
    UITapGestureRecognizer *tapMainMask = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gestureHandler:)];
    [_mainMaskView addGestureRecognizer:tapMainMask];
}

- (void)gestureHandler:(UIGestureRecognizer *)gesture{
#warning XXX
//    if (_mainViewController.isShowFullQueue) {
//        NSLog(@"显示全屏queue 手势禁用");
//        return;
//    }
    
    if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gesture;
        switch (panGesture.state) {
            case UIGestureRecognizerStateBegan:{
                _xStartLocation = _mainContainerView.frameX;
                break;
            }
            case UIGestureRecognizerStateChanged:{
                CGPoint deltaPoint = [panGesture translationInView:self.view];
                CGFloat xPos = deltaPoint.x;
                CGFloat xTmpPos = xPos + _xStartLocation;
                xTmpPos = MIN(xTmpPos, 104);
                xTmpPos = MAX(xTmpPos, 0);
                _mainContainerView.frameX = xTmpPos;
                break;
            }
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:{
                CGFloat xVelocity = [panGesture velocityInView:self.view].x;
                CGFloat minimumVelocity = 250;
                if (xVelocity > minimumVelocity) {
                    [self showLeftViewControler];
                    return;
                } else if (xVelocity < - minimumVelocity){
                    [self showCenterViewController];
                    return;
                }
                
                CGFloat xPos = _mainContainerView.frameX;
                if (xPos > 52) {
                    [self showLeftViewControler];
                } else {
                    [self showCenterViewController];
                }
                
                break;
            }
            default:
                break;
        }
        
    } else if ([gesture isKindOfClass:[UISwipeGestureRecognizer class]]) {
        UISwipeGestureRecognizer *swipeGesture = (UISwipeGestureRecognizer *)gesture;
        if (swipeGesture.direction & UISwipeGestureRecognizerDirectionLeft || swipeGesture.direction & UISwipeGestureRecognizerDirectionDown) {
            [self showCenterViewController];
        } else if (swipeGesture.direction & UISwipeGestureRecognizerDirectionRight || swipeGesture.direction & UISwipeGestureRecognizerDirectionUp) {
            [self showLeftViewControler];
        }
    } else if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
        [self showCenterViewController];
    }
}

- (void)toggleShowController{
    NSLog(@"toggle");
    _showLeftFlag = !_showLeftFlag;
    if (_showLeftFlag) {
        [self showLeftViewControler];
    } else {
        [self showCenterViewController];
    }
}

- (void)showLeftViewControler{
    if (_animating) return;
//    if (_showLeftFlag) return;
    
    _showLeftFlag = YES;
    _animating = YES;
    [self showAnimation];
}

- (void)showCenterViewController{
    if (_animating) return;
//    if(!_showLeftFlag) return;
    
    _showLeftFlag = NO;
    _animating = YES;
    [self showAnimation];
}

- (void)showAnimation{
    CGRect mainFrame = _mainContainerView.frame;
    mainFrame.origin.x = _showLeftFlag ? 104 : 0;
    _mainMaskView.hidden = !_showLeftFlag;
    
    CGFloat damping = _showLeftFlag ? 0.6 : 1.0f;
    [UIView animateWithDuration:0.30 delay:0 usingSpringWithDamping:damping initialSpringVelocity:4 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        _mainLeftConstraint.constant = _showLeftFlag ? 104 : 0;
//        [_mainContainerView layoutIfNeeded];
        _mainContainerView.frame = mainFrame;
    } completion:^(BOOL finished) {
        _animating = NO;
    }];
}

- (BOOL)isShowingLeft{
    return _showLeftFlag;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - gesture delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UIView *touchView = [touch view];
    if (touchView.tag == 100) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint deltaPoint = [gestureRecognizer locationInView:self.view];
        if (deltaPoint.x > 100 ) {
            return NO;
        }
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
