//
//  UIColor+AverageColorConverter.m
//  PlayZer
//
//  Created by mo jun on 3/24/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "UIColor+AverageColorConverter.h"


@implementation UIColor (AverageColorConverter)

+ (UIColor *)colorFromString:(NSString *)colorString {
    NSScanner *scanner = [NSScanner scannerWithString:colorString];
    if (![scanner scanString:@"{" intoString:NULL]) return nil;
    const NSUInteger kMaxComponents = 4;
    float c[kMaxComponents];
    NSUInteger i = 0;
    if (![scanner scanFloat:&c[i++]]) return nil;
    while (1) {
        if ([scanner scanString:@"}" intoString:NULL]) break;
        if (i >= kMaxComponents) return nil;
        if ([scanner scanString:@"," intoString:NULL]) {
            if (![scanner scanFloat:&c[i++]]) return nil;
        } else {
            return nil;
        }
    }
    if (![scanner isAtEnd]) return nil;
    UIColor *color;
    switch (i) {
        case 2: // monochrome
            color = [UIColor colorWithWhite:c[0] alpha:c[1]];
            break;
        case 4: // RGB
            color = [UIColor colorWithRed:c[0] green:c[1] blue:c[2] alpha:c[3]];
            break;
        default:
            color = nil;
    }
    return color;
}

+ (NSString *)averageColorStringFromImage:(UIImage *)image {
    CGSize thumbSize = CGSizeMake(100, 100);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    // 取每个点的像素
    unsigned char* data = (unsigned char*)CGBitmapContextGetData (context);
    
    if (data == NULL) return nil;
    
    NSInteger widthPoint = thumbSize.width;
    NSInteger heightPoint = thumbSize.height;
    CGFloat totalCount = (CGFloat)(widthPoint * heightPoint);
    CGFloat redTotal = 0;
    CGFloat greenTotal = 0;
    CGFloat blueTotal = 0;
    for (NSInteger x=0; x<widthPoint; x++) {
        for (NSInteger y=0; y<heightPoint; y++) {
            NSInteger offset = 4*(x*y);
            
            NSInteger red = data[offset];
            NSInteger green = data[offset+1];
            NSInteger blue = data[offset+2];
            
            redTotal += red;
            greenTotal += green;
            blueTotal += blue;
        }
    }
    CGContextRelease(context);
    
    CGFloat red = redTotal / (totalCount * 255.0f);
    CGFloat green = greenTotal / (totalCount * 255.0f);
    CGFloat blue = blueTotal / (totalCount * 255.0f);
    return [NSString stringWithFormat:@"{%0.3f, %0.3f, %0.3f, %0.3f}", red, green, blue, 1.000f];
}

+ (UIColor *)averageColorFromImage:(UIImage *)image {
    CGSize thumbSize=CGSizeMake(100, 100);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    // 取每个点的像素值
    unsigned char* data = (unsigned char*)CGBitmapContextGetData (context);
    
    if (data == NULL) return nil;
    
    NSInteger widthPoint = thumbSize.width;
    NSInteger heightPoint = thumbSize.height;
    CGFloat totalCount = (CGFloat)(widthPoint * heightPoint);
    CGFloat redTotal = 0;
    CGFloat greenTotal = 0;
    CGFloat blueTotal = 0;
    for (NSInteger x=0; x<widthPoint; x++) {
        for (NSInteger y=0; y<heightPoint; y++) {
            
            NSInteger offset = 4*(x*y);
            
            NSInteger red = data[offset];
            NSInteger green = data[offset+1];
            NSInteger blue = data[offset+2];
            
            redTotal += red;
            greenTotal += green;
            blueTotal += blue;
        }
    }
    CGContextRelease(context);
    
    CGFloat red = redTotal / (totalCount * 255.0f);
    CGFloat green = greenTotal / (totalCount * 255.0f);
    CGFloat blue = blueTotal / (totalCount * 255.0f);
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

@end
