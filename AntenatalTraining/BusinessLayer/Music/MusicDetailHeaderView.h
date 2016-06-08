//
//  MusicDetailHeaderView.h
//  AntenatalTraining
//
//  Created by mo jun on 5/5/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ATImageEntity;
@interface MusicDetailHeaderView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *playAll;
@property (nonatomic, strong) UIButton *downloadAll;
@property (nonatomic, copy) ATImageEntity *coverEntity;

@end
