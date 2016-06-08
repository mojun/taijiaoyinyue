//
//  QIGridListView.h
//  PlayZer
//
//  Created by mo jun on 11/8/15.
//  Copyright © 2015 kimoworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDKCollectionIndexView.h"

@class QIGridListView;
@protocol BDKCollectionIndexViewDelegate <NSObject>

@optional
- (NSIndexPath*)QIGridListView:(QIGridListView *)gridListView scrollToIndexPathWithQuickIndex:(NSInteger)index;

@end

@interface QIGridListView : UIView<BDKCollectionIndexViewDelegate>

@property (nonatomic, assign) BOOL showQuickIndex;

@property (nonatomic, copy) NSArray *quickIndexTitles;

@property (nonatomic, strong, readonly) BDKCollectionIndexView *quickIndexView;

@property (nonatomic, weak) id<BDKCollectionIndexViewDelegate> quickDelegate;

- (void)addToSuperView:(UIView *)superView;
- (void)reloadData;
- (void)registerCellClass:(Class)cellClass;
- (void)removeFromSuperview;
- (void)indexViewValueChanged:(BDKCollectionIndexView *)sender;

@end


