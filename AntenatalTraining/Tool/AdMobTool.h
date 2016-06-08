//
//  AdMobTool.h
//  Template
//
//  Created by mo jun on 1/26/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAdMobTestDevice @"110"
#define kAdmobBannerUnitId @"110"
#define kAdmobInterstitialAdUnitId @"110"

@interface AdMobTool : NSObject

@property (nonatomic, weak) id<GADInterstitialDelegate> interstitialDelegate;

+ (instancetype)api;

+ (UIView *)bannerViewWithDelegate:(id<GADBannerViewDelegate>)delegate
                        controller:(UIViewController *)controller;

- (void)presentInterstitial;

@end
