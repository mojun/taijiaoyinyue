//
//  QILocalCollectionCell.h
//  PlayZer
//
//  Created by mo jun on 10/28/15.
//  Copyright © 2015 kimoworks. All rights reserved.
//

#import "QICollectionBaseCell.h"

@class ATImageEntity;
@interface QILocalCollectionCell : QICollectionBaseCell

@property (nonatomic, strong) UIImageView  *coverView;

@property (nonatomic, strong) UIImageView  *typeView;

@property (nonatomic, strong) UILabel      *titleLabel;

@property (nonatomic, strong) UILabel      *durationLabel;

@property (nonatomic, strong) UILabel      *trackNumberLabel;

@property (nonatomic, copy) ATImageEntity *coverEntity;

@end
