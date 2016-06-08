//
//  ATEmptyView.m
//  AntenatalTraining
//
//  Created by test on 16/5/31.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "ATEmptyView.h"

@implementation ATEmptyView

- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"empty_alert"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
        iconView.tintColor = kThemeColor;
        [self addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];
        
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont systemFontOfSize:14];
        messageLabel.textColor = kThemeLightBlack;
        messageLabel.text = @"暂无任何记录";
        [self addSubview:messageLabel];
        [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(iconView.mas_bottom).offset(30);
            make.height.mas_greaterThanOrEqualTo(10);
        }];
        
        _messageLabel = messageLabel;
        
    }
    return self;
}

@end
