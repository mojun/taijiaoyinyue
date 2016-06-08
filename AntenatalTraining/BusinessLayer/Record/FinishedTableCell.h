//
//  FinishedTableCell.h
//  AntenatalTraining
//
//  Created by test on 16/5/25.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QITableBaseCell.h"

@interface FinishedTableCell : QITableBaseCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fileSizeLabel;

@end
