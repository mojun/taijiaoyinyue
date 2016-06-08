//
//  AppDelegate.m
//  AntenatalTraining
//
//  Created by mo jun on 4/24/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "AppDelegate.h"
#import "AppRoute.h"
#import "FICImageHelper.h"

@interface AppDelegate ()<GADInterstitialDelegate>

@end

@implementation AppDelegate

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:[FCFileManager pathForDocumentsDirectory]]];
    
//    [[FIRAnalyticsConfiguration sharedInstance] setAnalyticsCollectionEnabled:NO];
//    [FIRApp configure];
    [[FICImageHelper sharedHelper] setup];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [FMEncryptDatabase setEncryptKey:kEncryptKey];
    [FMEncryptHelper setEncryptKey:kEncryptKey];
//    [self enctfile:@"taijiao-download.db"];
//    [self enctfile:@"playlist.db"];
    
    NSError *categoryError = nil;
    if ([[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:&categoryError]) {
        NSLog(@"Audio Session error %@, %@", categoryError, [categoryError userInfo]);
    } else {
        
    }
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
    [[AVAudioSession sharedInstance]setActive:YES error:nil];
    return YES;
}

- (void)enctfile: (NSString *)file {
    NSString *resPath = [FCFileManager pathForMainBundleDirectoryWithPath:file];
    NSString *docPath = [FCFileManager pathForDocumentsDirectoryWithPath:file];
    [FCFileManager copyItemAtPath:resPath toPath:docPath];
    BOOL suc = [FMEncryptHelper encryptDatabase:docPath];
    NSLog(@"suc: %@", @(suc));
    NSLog(@"docPath: %@", docPath   );
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [AdMobTool api].interstitialDelegate = self;
    [[AppRoute route] setupWithWindow:self.window];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    [FIRAnalytics logEventWithName:kFIREventAppOpen parameters:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    [ad presentFromRootViewController:self.window.rootViewController];
    
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    
}

@end
//
//{
//    "src": "/Users/mojun/Desktop/file",
//    "dest": "qiniu:access_key=XMqUTONN1EehfGGFz3MgmHxai5_Se7EMLoUa6LYe&secret_key=6sBQ2n8FfPPXXGR6o_8A99NZ-luL9rBZt0D0me_l&bucket=taijiao2016",
//    "debug_level": 1
//}
