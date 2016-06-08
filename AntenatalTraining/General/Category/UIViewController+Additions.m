//
//  UIViewController+Additions.m
//  AntenatalTraining
//
//  Created by mo jun on 4/26/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "UIViewController+Additions.h"

@implementation UIViewController (Additions)

- (instancetype)initFromXib {
    
    NSString *className = NSStringFromClass([self class]);
    NSString *xibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:xibPath]) {
        className = nil;
    }
    
    self = [self initWithNibName:className bundle:nil];
    return self;
}

- (void)presentModalController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^ __nullable)(void))completion{
    UIViewController *parentController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (parentController.presentedViewController != nil) {
        parentController = parentController.presentedViewController;
    }
    [parentController presentViewController:controller animated:animated completion:completion];
}

@end
