//
//  QILocalMovieTableCell.h
//  PlayZer
//
//  Created by mo jun on 2/21/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "QITableBaseCell.h"

@class PZImageEntity;
@interface QILocalMovieTableCell : QITableBaseCell

@property (nonatomic, strong) UIImageView  *coverView;

@property (nonatomic, strong) UILabel      *titleLabel;

@property (nonatomic, strong) UILabel      *durationLabel;

@property (nonatomic, copy) PZImageEntity *coverEntity;

@end
