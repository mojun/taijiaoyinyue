//
//  QICollectionListView.h
//  PlayZer
//
//  Created by mo jun on 10/27/15.
//  Copyright © 2015 kimoworks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QIGridListView.h"

@protocol QIGridViewDataSource;
@protocol QIGridViewDelegate;

@class QICollectionBaseCell;
@interface QICollectionListView : QIGridListView<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, weak) id<QIGridViewDelegate> delegate;
@property (nonatomic, weak) id<QIGridViewDataSource> dataSource;

- (instancetype)initWithDelegate:(id<QIGridViewDelegate, QIGridViewDataSource>)delegate;

- (QICollectionBaseCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier
                                                    forIndexPath:(NSIndexPath *)indexPath;


@end

@protocol QIGridViewDataSource <NSObject>

- (NSInteger)QIGridView:(QICollectionListView *)gridView numberOfItemsInSection:(NSInteger)section;
- (QICollectionBaseCell *)QIGridView:(QICollectionListView *)gridView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (NSInteger)numberOfSectionsInQIGridView:(QICollectionListView *)gridView;
- (UICollectionReusableView *)QIGridView:(QICollectionListView *)gridView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

@end

@protocol QIGridViewDelegate <NSObject>

@optional

- (void)QIGridView:(QICollectionListView *)gridView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)QIGridView:(QICollectionListView *)gridView didLongPressed:(UILongPressGestureRecognizer *)recognizer itemIndexPath:(NSIndexPath *)indexPath;
- (void)QIGridView:(QICollectionListView *)gridView didScrollToIndexPath:(NSIndexPath *)indexPath;

@end
