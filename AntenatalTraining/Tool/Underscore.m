//
//  Underscore.m
//  AntenatalTraining
//
//  Created by mo jun on 4/30/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "Underscore.h"

@implementation Underscore

+ (NSInteger)randomNumberFrom:(NSInteger)from to:(NSInteger)to {
    if (from > to) {
        NSInteger _to = from;
        from = to;
        to = _to;
    } else if (from == to) {
        return from;
    }
    
    return from + (arc4random() % (to - from));
}

+ (NSArray *)randomNumbersFrom:(NSInteger)from to:(NSInteger)to times:(NSInteger)times distinguish:(BOOL)distinguish{
    if (distinguish) {
        NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:(to - from + 1) ];
        for (NSInteger i=from; i<=to; i++) {
            [mArray addObject:@(i)];
        }
        
        NSMutableArray *rArray = [NSMutableArray arrayWithCapacity:times];
        for (NSInteger i=0; i<times; i++) {
            NSInteger seed = [self randomNumberFrom:0 to:mArray.count -1];
            NSNumber *number = mArray[seed];
            [rArray addObject:number];
            [mArray replaceObjectAtIndex:seed withObject:[mArray objectAtIndex:(mArray.count - i -1)]];
        }
        
        return rArray;
    } else {
        NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:times];
        for (NSInteger i=0; i<times; i++) {
            NSInteger random = [self randomNumberFrom:from to:to];
            [mArray addObject:@(random)];
        }
        return mArray;
    }
}

@end
