//
//  NSString+Extension.m
//  PlayZer
//
//  Created by mo jun on 1/2/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSString *)trimSpace{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)toDateStringTime{
    NSInteger seconds = [self integerValue];
    NSInteger h = seconds / 3600;
    NSInteger m = (seconds - h * 3600) / 60;
    NSInteger s = (seconds - h * 3600) - m * 60;
    
    NSString *hour = @"";
    NSString *minute = @"";
    NSString *second = @"";
    
    if (h > 9) {
        hour = [NSString stringWithFormat:@"%@", @(h)];
    }
    else if(h > 0) {
        hour = [NSString stringWithFormat:@"%@", @(h)];
    }
    
    if (m > 9) {
        minute = [NSString stringWithFormat:@"%@", @(m)];
    }
    else if(minute >= 0 && h < 1) {
        minute = [NSString stringWithFormat:@"%@", @(m)];
    }
    
    if (s > 9) {
        second = [NSString stringWithFormat:@"%@", @(s)];
    }
    else if(s >= 0) {
        second = [NSString stringWithFormat:@"0%@", @(s)];
    }
    
    if (hour.length > 0) {
        return [NSString stringWithFormat:@"%@:%@:%@", hour, minute, second];
    }
    else if (minute.length > 0) {
        return [NSString stringWithFormat:@"%@:%@", minute, second];
    }
    else {
        return [NSString stringWithFormat:@"%@", second];
    }
}

+ (NSString *)stringFromBytes:(NSNumber *)bytes {
    CGFloat size = bytes.doubleValue;
    CGFloat factor = 1024;
    NSString *stringSize = @"0KB";
    if (size < factor * factor) {
        CGFloat a = size;
        CGFloat c = a / factor;
        stringSize = [NSString stringWithFormat:@"%0.3fKB",c];
    } else if (size < factor * factor *factor) {
        CGFloat a = size;
        CGFloat c = a / (factor * factor);
        stringSize = [NSString stringWithFormat:@"%0.2fMB",c];
    } else {
        CGFloat a = size;
        CGFloat c = a / (factor * factor * factor);
        stringSize = [NSString stringWithFormat:@"%0.2fGB",c];
    }
    return stringSize;
}

@end
