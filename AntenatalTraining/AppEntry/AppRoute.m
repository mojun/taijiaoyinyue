//
//  AppRoute.m
//  AntenatalTraining
//
//  Created by test on 16/4/26.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "AppRoute.h"
#import "RootViewController.h"

#import "LeftViewController.h"
#import "MainViewController.h"

#import "MusicViewController.h"
#import "SearchViewController.h"
#import "PlaylistViewController.h"
#import "RecordViewController.h"
#import "MyViewController.h"

#import "QueueViewController.h"
#import "UIImage+CGImage.h"

#import <Aspects/Aspects.h>

static NSString * const AppRoute_SelectIndex_Key = @"AppRoute_SelectIndex";

@interface AppRoute ()<LeftViewControllerDelegate>

@end

@implementation AppRoute {
    
    QueueViewController *_queueController;
    
    RootViewController *_rootController;
    LeftViewController *_leftController;
    MainViewController *_mainController;
    
    NSMutableDictionary *_viewControllers;
    
    UINavigationController *_searchController;
}

#pragma mark - life cycle
+ (instancetype)route {
    static dispatch_once_t onceToken;
    static AppRoute *r = nil;
    dispatch_once(&onceToken, ^{
        r = [AppRoute new];
    });
    return r;
}

- (instancetype)init{
    if (self = [super init]) {
        
        _viewControllers = [NSMutableDictionary dictionaryWithCapacity:4];
        [self setupTheme];
        [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
            UIViewController *controller = [aspectInfo instance];
            controller.extendedLayoutIncludesOpaqueBars = NO;
            controller.automaticallyAdjustsScrollViewInsets = NO;
            controller.edgesForExtendedLayout = UIRectEdgeNone;
            if ([controller isKindOfClass:[UINavigationController class]]) {
                return ;
            }
            UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
            backButton.title = @"";
            controller.navigationItem.backBarButtonItem = backButton;
        } error:nil];
        
        [UIViewController aspect_hookSelector:@selector(preferredStatusBarStyle) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo){
            NSInvocation *invocation = aspectInfo.originalInvocation;
            UIStatusBarStyle s = UIStatusBarStyleLightContent;
            [invocation setReturnValue:&s];
            return UIStatusBarStyleLightContent;
            
        }error:nil];
    }
    return self;
}

- (void)setupTheme {
    
    CGFloat w = CGRectGetWidth([UIScreen mainScreen].bounds);
    // 背景色
    //    [[UINavigationBar appearance] tc_setBackgroundColor:SKIN_NAVI_BG_COLOR];
    [[UINavigationBar appearance] setBarTintColor:kThemeColor];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    // 分割线颜色
    [[UINavigationBar appearance] setShadowImage:[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(w, 0.5)]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:18]}]; // 标题颜色
    
    //自定义返回按钮
    UIImage *backButtonImage = [[UIImage imageNamed:@"nav_item_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, -60)]; // 图片拉伸
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
#if __IPHONE_9_0 <= __IPHONE_OS_VERSION_MAX_ALLOWED
    UIBarButtonItem * barItemInNavigationBarAppearanceProxy = [UIBarButtonItem appearance];//[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UINavigationBar class]]];
    [barItemInNavigationBarAppearanceProxy setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [barItemInNavigationBarAppearanceProxy setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateHighlighted];
#else
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIBarButtonItem * barItemInNavigationBarAppearanceProxy = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    [barItemInNavigationBarAppearanceProxy setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
#endif
}

- (void)setupWithWindow:(UIWindow *)window {
    
    [self switchControllerAtIndex:2];
    [self mainController].queueVC = [self queueController];
    
    RootViewController *rootController = [self rootController];
    rootController.leftViewController = [self leftController];
    rootController.mainViewController = [self mainController];
    window.rootViewController = rootController;
    [window makeKeyAndVisible];
    
    NSInteger selectIndex = PREF_KEY_INT(AppRoute_SelectIndex_Key);
    _leftController.selectedIndex = selectIndex;
}

#pragma mark - LeftViewControllerDelegate
- (void)leftViewController:(LeftViewController *)leftController didSelectAtIndex:(NSInteger)index {
    UIViewController *controller = [self switchControllerAtIndex:index];
    PREF_KEY_SET_INT(AppRoute_SelectIndex_Key, index);
    [self.mainController showController:controller];
    [[self rootController] toggleShowController];
}

#pragma mark - event response 
- (void)showLeftViewController:(UIButton *)sender {
    [[self rootController] toggleShowController];
}

- (void)search:(UIButton *)sender {
    [[self rootController] presentViewController:[self searchController] animated:YES completion:nil];
}

#pragma mark - getters and setters
- (RootViewController *)rootController {
    
    if (!_rootController) {
        _rootController = [[RootViewController alloc] initFromXib];
    }
    return _rootController;
}

- (LeftViewController *)leftController {
    
    if (!_leftController) {
        _leftController = [[LeftViewController alloc] initFromXib];
        _leftController.delegate = self;
    }
    return _leftController;
}

- (MainViewController *)mainController {
    
    if (!_mainController) {
        _mainController = [[MainViewController alloc] initFromXib];
    }
    return _mainController;
}

- (QueueViewController *)queueController {
    if (!_queueController) {
        _queueController = [[QueueViewController alloc] initFromXib];
        _queueController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return _queueController;
}

- (UIViewController *)switchControllerAtIndex:(NSInteger)index {
    NSNumber *controllerKey = @(index);
    UIViewController *ctrl = [_viewControllers objectForKey:controllerKey];
    if (ctrl) {
        return ctrl;
    }
    
    switch (index) {
        case 0:{
            ctrl = [[MusicViewController alloc] initFromXib];
            break;
        }
        case 1:{
            ctrl = [[PlaylistViewController alloc] initFromXib];
            break;
        }
        case 2:{
            ctrl = [[RecordViewController alloc] initFromXib];
            break;
        }
        case 3:{
            ctrl = [[MyViewController alloc] initFromXib];
            break;
        }
        default:
            break;
    }
    
    if (ctrl) {
        NSArray *items = arrayFromResource(@"SideItems.plist");
        ctrl.title = items[index][@"title"];
        
        CGFloat btnWidth = 24;
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, btnWidth, btnWidth);
        [leftButton setImage:[UIImage imageNamed:@"nav_icon_column"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(showLeftViewController:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        
        UIBarButtonItem *negativeSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpace.width = 0;
        
//        nav_item_search
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, btnWidth, btnWidth);
        [rightButton setImage:[UIImage imageNamed:@"nav_item_search"] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        
        UIBarButtonItem *negativeSpace2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpace2.width = 0;
        
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:ctrl];
        nc.topViewController.navigationItem.leftBarButtonItems = @[negativeSpace, leftItem];
        nc.topViewController.navigationItem.rightBarButtonItems = @[rightItem, negativeSpace2];
        [_viewControllers setObject:nc forKey:controllerKey];
        return nc;
    }
    
    NSAssert(ctrl != nil, @"侧边栏 无效的按钮选项");
    
    return nil;
}

- (UINavigationController *)searchController{
    if (_searchController == nil) {
        SearchViewController *c = [[SearchViewController alloc] initFromXib];
        _searchController = [[UINavigationController alloc] initWithRootViewController:c];
    }
    return _searchController;
}

@end
