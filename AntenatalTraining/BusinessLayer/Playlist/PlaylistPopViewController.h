//
//  PlaylistPopViewController.h
//  AntenatalTraining
//
//  Created by test on 16/5/21.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const PlaylistDidAddSongsNotification;

@interface PlaylistPopViewController : UIViewController

@property (nonatomic, copy) void (^callback)(void);
@property (nonatomic, strong) NSArray *songs;

@end
