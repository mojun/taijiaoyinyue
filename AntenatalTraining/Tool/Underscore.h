//
//  Underscore.h
//  AntenatalTraining
//
//  Created by mo jun on 4/30/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Underscore : NSObject

+ (NSInteger)randomNumberFrom:(NSInteger)from to:(NSInteger)to;

+ (NSArray *)randomNumbersFrom:(NSInteger)from to:(NSInteger)to times:(NSInteger)times distinguish:(BOOL)distinguish;

@end
