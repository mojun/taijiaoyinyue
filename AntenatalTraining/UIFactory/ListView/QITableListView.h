//
//  QITableListView.h
//  PlayZer
//
//  Created by mojun on 15/10/27.
//  Copyright © 2015年 kimoworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QIGridListView.h"

@class QITableBaseCell;
@interface QITableListView : QIGridListView

@property (nonatomic, strong, readonly) UITableView *tableView;

- (instancetype)initWithStyle:(UITableViewStyle)style delegate:(id <UITableViewDataSource, UITableViewDelegate>)delegate;

- (QITableBaseCell *)dequeueResuableCellWithReuseIdentifier:(NSString *)identifier
                                               forIndexPath:(NSIndexPath *)indexPath;

@end
