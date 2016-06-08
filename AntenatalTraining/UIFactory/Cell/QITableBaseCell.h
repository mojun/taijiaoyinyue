//
//  QITableBaseCell.h
//  PlayZer
//
//  Created by mojun on 15/10/27.
//  Copyright © 2015年 kimoworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QITableBaseCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

+ (void)registerForTableView:(UITableView *)tableView;

+ (NSString *)registeredIdentifier;

- (void)highlightedShow;

@end
