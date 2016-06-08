//
//  RootViewController.h
//  PlayZer
//
//  Created by mo jun on 6/30/15.
//  Copyright (c) 2015 kimoworks. All rights reserved.
//

@class LeftViewController;
@class MainViewController;
@interface RootViewController : UIViewController

@property (nonatomic, assign, readonly) BOOL isShowingLeft;

@property (nonatomic, strong) LeftViewController *leftViewController;

@property (nonatomic, strong) MainViewController *mainViewController;

- (void)toggleShowController;

- (void)showLeftViewControler;

- (void)showCenterViewController;

@end
