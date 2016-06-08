//
//  UIImage+ColorProperty.m
//  PlayZer
//
//  Created by mo jun on 3/24/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "UIImage+ColorProperty.h"
#import <objc/runtime.h>

@implementation UIImage (ColorProperty)

static char UIImage_averageColor;
- (void)setAverageColor:(UIColor *)averageColor{
    objc_setAssociatedObject(self, &UIImage_averageColor, averageColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)averageColor{
    return objc_getAssociatedObject(self, &UIImage_averageColor);
}

static char UIImage_isDarkColor;
- (void)setIsDarkColor:(BOOL)isDarkColor{
    objc_setAssociatedObject(self, &UIImage_isDarkColor, @(isDarkColor), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isDarkColor{
    NSNumber *darkNum = objc_getAssociatedObject(self, &UIImage_isDarkColor);
    return darkNum.boolValue;
}

@end
