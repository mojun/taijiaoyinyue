//
//  UIColor+AverageColorConverter.h
//  PlayZer
//
//  Created by mo jun on 3/24/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (AverageColorConverter)

+ (UIColor *)colorFromString:(NSString *)colorString;

+ (NSString *)averageColorStringFromImage:(UIImage *)image;

+ (UIColor *)averageColorFromImage:(UIImage *)image;

@end
