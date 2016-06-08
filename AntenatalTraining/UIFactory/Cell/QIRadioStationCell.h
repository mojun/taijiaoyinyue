//
//  QIRadioStationCell.h
//  PlayZer
//
//  Created by mo jun on 1/3/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "QITableBaseCell.h"

@class ATImageEntity;
@interface QIRadioStationCell : QITableBaseCell

@property (nonatomic, strong) IBOutlet UIImageView  *coverView;

@property (nonatomic, strong) IBOutlet UILabel      *titleLabel;

@property (nonatomic, copy) ATImageEntity *coverEntity;

@end
