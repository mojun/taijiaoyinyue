//
//  AdMobTool.m
//  Template
//
//  Created by mo jun on 1/26/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "AdMobTool.h"

@implementation AdMobTool

+ (instancetype)api{
    static dispatch_once_t onceToken;
    static AdMobTool *t = nil;
    dispatch_once(&onceToken, ^{
        t = [AdMobTool new];
    });
    return t;
}

+ (UIView *)bannerViewWithDelegate:(id<GADBannerViewDelegate>)delegate
                        controller:(UIViewController *)controller{
    GADBannerView *bannerView = [[GADBannerView alloc]initWithAdSize:kGADAdSizeBanner];
    bannerView.adUnitID = kAdmobBannerUnitId;
    bannerView.rootViewController = controller;
    bannerView.delegate = delegate;
    bannerView.frame = CGRectMake(0, 0, kGADAdSizeBanner.size.width, kGADAdSizeBanner.size.height);
    GADRequest *r = [self admob_request];
    [bannerView loadRequest:r];
    return bannerView;
}

- (void)presentInterstitial{
    NSAssert(self.interstitialDelegate != nil, @"不能为nil");
    GADInterstitial *interstitial = [[GADInterstitial alloc]initWithAdUnitID:kAdmobInterstitialAdUnitId];
    interstitial.delegate = self.interstitialDelegate;
    
    GADRequest *r = [[self class] admob_request];
    [interstitial loadRequest:r];
}


#pragma mark - private methods
+ (GADRequest *)admob_request{
    GADRequest *r = [GADRequest request];
    r.testDevices = @[kGADSimulatorID, kAdMobTestDevice];
    return r;
}

@end
