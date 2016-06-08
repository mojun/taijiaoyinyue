//
//  QICategoryCollectionCell.h
//  AntenatalTraining
//
//  Created by mo jun on 4/30/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "QICollectionBaseCell.h"

@class ATImageEntity;
@interface QICategoryCollectionCell : QICollectionBaseCell

@property (nonatomic, strong) UIImageView  *coverView;

@property (nonatomic, strong) UILabel      *titleLabel;

@property (nonatomic, copy) ATImageEntity *coverEntity;

@end
