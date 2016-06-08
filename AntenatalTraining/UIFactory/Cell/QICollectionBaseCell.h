//
//  QICollectionBaseCell.h
//  PlayZer
//
//  Created by mo jun on 10/27/15.
//  Copyright © 2015 kimoworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QICollectionBaseCell : UICollectionViewCell

+ (void)registerForCollectionView:(UICollectionView *)collectionView;
+ (NSString *)registeredIdentifier;

- (void)highlightedShow;

@end
