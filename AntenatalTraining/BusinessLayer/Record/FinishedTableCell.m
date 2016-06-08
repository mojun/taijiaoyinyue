//
//  FinishedTableCell.m
//  AntenatalTraining
//
//  Created by test on 16/5/25.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "FinishedTableCell.h"

@implementation FinishedTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (void)registerForTableView:(UITableView *)tableView{
    UINib *nib = [UINib nibWithNibName:[self registeredIdentifier] bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[self registeredIdentifier]];
}

+ (NSString *)registeredIdentifier{
    return @"FinishedTableCell";
}

@end
