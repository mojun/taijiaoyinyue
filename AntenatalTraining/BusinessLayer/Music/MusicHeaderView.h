//
//  MusicHeaderView.h
//  AntenatalTraining
//
//  Created by test on 16/5/31.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface MusicHeaderView : UICollectionReusableView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *songs;
@property (nonatomic, strong) NSArray *subSongs;

@end
