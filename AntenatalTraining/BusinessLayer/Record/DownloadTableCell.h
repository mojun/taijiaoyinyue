//
//  DownloadTableCell.h
//  AntenatalTraining
//
//  Created by test on 16/5/24.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TYMProgressBarView/TYMProgressBarView.h>
#import "QITableBaseCell.h"

@interface DownloadTableCell : QITableBaseCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet TYMProgressBarView *progressBar;
@end
