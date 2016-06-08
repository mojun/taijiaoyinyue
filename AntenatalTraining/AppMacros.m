//
//  AppMacros.m
//  AntenatalTraining
//
//  Created by test on 16/4/27.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "AppMacros.h"

CGSize screenSize(){
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    return screenSize;
}

CGFloat screenHScale(){
    return screenSize().height / 480;
}

UIColor *UIColor_HexString(NSString *stringToConvert){
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

UIColor *UIColor_RGBA(CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a/255.0f];
}

UIColor *UIColor_RGB(CGFloat r, CGFloat g, CGFloat b){
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1];
}

NSArray *arrayFromResource(NSString *fileName) {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    return [NSArray arrayWithContentsOfFile:path];
}