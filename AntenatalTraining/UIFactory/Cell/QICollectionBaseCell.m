//
//  QICollectionBaseCell.m
//  PlayZer
//
//  Created by mo jun on 10/27/15.
//  Copyright © 2015 kimoworks. All rights reserved.
//

#import "QICollectionBaseCell.h"

@implementation QICollectionBaseCell

+ (void)registerForCollectionView:(UICollectionView *)collectionView{
    NSLog(@"subclass must override this method");
}

+ (NSString *)registeredIdentifier{
    NSLog(@"subclass must override this method");
    return nil;
}

- (void)highlightedShow{
    
}

@end
