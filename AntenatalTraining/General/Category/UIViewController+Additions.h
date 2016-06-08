//
//  UIViewController+Additions.h
//  AntenatalTraining
//
//  Created by mo jun on 4/26/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Additions)

- (instancetype)initFromXib;

- (void)presentModalController:(UIViewController *)controller animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

@end
