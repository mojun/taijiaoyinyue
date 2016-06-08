//
//  UIImage+ColorProperty.h
//  PlayZer
//
//  Created by mo jun on 3/24/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ColorProperty)

/// 图片平均色值
@property (nonatomic, strong) UIColor *averageColor;

/// 图片是否是暗色调的
@property (nonatomic, assign) BOOL isDarkColor;

@end
