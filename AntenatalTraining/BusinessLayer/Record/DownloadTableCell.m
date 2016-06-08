//
//  DownloadTableCell.m
//  AntenatalTraining
//
//  Created by test on 16/5/24.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "DownloadTableCell.h"

@implementation DownloadTableCell

- (void)awakeFromNib {
    // Initialization code
    self.stateLabel.text = @"等待下载";
    self.progressLabel.text = @"0M/0M";
    
//    self.progressBar = [[TYMProgressBarView alloc]initWithFrame:CGRectNull];
    self.progressBar.barBackgroundColor = kThemeGrayColor;
    self.progressBar.barFillColor = kThemeColor;
    self.progressBar.barBorderWidth = 0;
    self.progressBar.usesRoundedCorners = 0;
    self.progressBar.barInnerPadding = 0;
//    [self addSubview:self.progressBar];
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
    return @"DownloadTableCell";
}

@end
