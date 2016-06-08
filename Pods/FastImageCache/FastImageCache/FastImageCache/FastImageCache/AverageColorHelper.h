//
//  AverageColorHelper.h
//  PlayZer
//
//  Created by mo jun on 3/24/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COLOR_STRING_KEY @"COLOR_STRING_KEY"
#define IS_DARK_COLOR_KEY @"IS_DARK_COLOR_KEY"

@interface AverageColorHelper : NSObject

+ (void)saveImageAverageColor:(UIImage *)image path:(NSString *)path;

+ (NSDictionary *)averageColorInfoFromPath:(NSString *)path;

@end
