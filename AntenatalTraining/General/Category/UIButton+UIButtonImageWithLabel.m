//
//  UIButton+UIButtonImageWithLabel.m
//  AntenatalTraining
//
//  Created by mo jun on 4/28/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "UIButton+UIButtonImageWithLabel.h"

@implementation UIButton (UIButtonImageWithLabel)

- (void)setImage:(UIImage *)image
       withTitle:(NSString *)title
      titleColor:(UIColor *)titleColor
        forState:(UIControlState)stateType {
    CGSize titleSize = [title sizeWithAttributes:@{
                                                   NSFontAttributeName: [UIFont systemFontOfSize:12]
                                                   }];
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-8, 0, 0, -titleSize.width)];
    
    [self setTintColor:kThemeColor];
    if (stateType != UIControlStateNormal) {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    } else {
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    [self setImage:image forState:stateType];
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(38, -image.size.width, 0, 0)];
    [self setTitle:title forState:stateType];
    [self setTitleColor:titleColor forState:stateType];
}

@end
