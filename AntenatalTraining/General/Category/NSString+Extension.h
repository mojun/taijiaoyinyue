//
//  NSString+Extension.h
//  PlayZer
//
//  Created by mo jun on 1/2/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

- (NSString *)trimSpace;

/// 0:00
- (NSString *)toDateStringTime;

+ (NSString *)stringFromBytes:(NSNumber *)bytes;

@end
