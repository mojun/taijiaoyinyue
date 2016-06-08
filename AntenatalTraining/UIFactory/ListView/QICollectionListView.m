//
//  QICollectionListView.m
//  PlayZer
//
//  Created by mo jun on 10/27/15.
//  Copyright © 2015 kimoworks. All rights reserved.
//

#import "QICollectionListView.h"
#import "QICollectionBaseCell.h"

@implementation QICollectionListView

- (instancetype)initWithDelegate:(id<QIGridViewDelegate, QIGridViewDataSource>)delegate{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
        
        self.dataSource = delegate;
        self.delegate = delegate;
        UICollectionViewFlowLayout *layout = [QICollectionListView createLayout];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.clipsToBounds = NO;
        _collectionView.allowsSelection = YES;
        _collectionView.alwaysBounceVertical = YES;
        [self addSubview:_collectionView];
        UIEdgeInsets insets = UIEdgeInsetsZero;
//        insets.top = kNavbarHeight;
//        insets.bottom = kQueueBarHeight;
        _collectionView.contentInset = insets;
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(dispatchGesture:)];
        longPress.minimumPressDuration = 0.2;
        [_collectionView addGestureRecognizer:longPress];
    }
    return self;
}

- (void)dispatchGesture:(UIGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:_collectionView];
    NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:point];
    QICollectionBaseCell *cell = (QICollectionBaseCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    if (cell != nil) {
        if ([gesture isKindOfClass:[UILongPressGestureRecognizer class]] &&
            gesture.state == UIGestureRecognizerStateBegan) {
            [cell highlightedShow];
            if ([self.delegate respondsToSelector:@selector(QIGridView:didLongPressed:itemIndexPath:)]) {
                [self.delegate QIGridView:self didLongPressed:(UILongPressGestureRecognizer *)gesture itemIndexPath:indexPath];
            }
        }
    }
}

- (void)reloadData{
    [_collectionView.collectionViewLayout invalidateLayout];
    [_collectionView reloadData];
}

- (void)registerCellClass:(Class)cellClass{
    [cellClass registerForCollectionView:_collectionView];
}

- (QICollectionBaseCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier
                                                    forIndexPath:(NSIndexPath *)indexPath{
    QICollectionBaseCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (UICollectionViewFlowLayout *)createLayout{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = kGridCellSpacing;
    layout.minimumLineSpacing = kGridCellSpacing;
    layout.itemSize = CGSizeMake(kGridCellWidth, kGridCellHeight);
    return layout;
}

#pragma mark - BDKCollectionIndexView

-(void)showTheQuickIndex{
    if (self.showQuickIndex) {
        [self.quickIndexView setHidden:NO];
    }
}

-(void)hideTheQuickIndex{
    if (self.quickIndexView.isHilighted) {
        [self performSelector:@selector(hideTheQuickIndex) withObject:nil afterDelay:1];
        return;
    }
    if (self.showQuickIndex) {
        [self.quickIndexView setHidden:YES];
    }
}

- (void)indexViewValueChanged:(BDKCollectionIndexView *)sender{
    NSIndexPath *path = nil;
    if ([self.quickDelegate respondsToSelector:@selector(QIGridListView:scrollToIndexPathWithQuickIndex:)]) {
        path = [self.quickDelegate QIGridListView:self scrollToIndexPathWithQuickIndex:sender.currentIndex];
    }
    
    if (path == nil) {
        path = [NSIndexPath indexPathForItem:0 inSection:sender.currentIndex];
    }
    
    if (path.section >= [self.dataSource numberOfSectionsInQIGridView:self] ||
        path.row >= [self.dataSource QIGridView:self numberOfItemsInSection:path.section]) {
        return;
    }
    
    [_collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
    CGFloat yOffset = _collectionView.contentOffset.y;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)_collectionView.collectionViewLayout;
    _collectionView.contentOffset = CGPointMake(_collectionView.contentOffset.x, yOffset - layout.headerReferenceSize.height);
}

#pragma mark - UICollection dataSource
- (NSInteger)numberOfSectionsInCollectionView:(nonnull UICollectionView *)collectionView{
    NSInteger number = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInQIGridView:)]) {
        number = [self.dataSource numberOfSectionsInQIGridView:self];
    }
    
    collectionView.hidden = number <= 0;
    return number;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger number = 0;
    if ([self.dataSource respondsToSelector:@selector(QIGridView:numberOfItemsInSection:)]) {
        number = [self.dataSource QIGridView:self numberOfItemsInSection:section];
    }
    
    collectionView.hidden = number <= 0;
    return number;
}

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    QICollectionBaseCell *cell = [self.dataSource QIGridView:self cellForItemAtIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(QIGridView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
        return [self.dataSource QIGridView:self viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    return nil;
}

#pragma mark - UICollection delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(QIGridView:didSelectItemAtIndexPath:)]) {
        [self.delegate QIGridView:self didSelectItemAtIndexPath:indexPath];
    }
    
    QICollectionBaseCell *cell = (QICollectionBaseCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    [cell highlightedShow];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(QIGridView:didScrollToIndexPath:)]) {
        NSArray *sortedIndexPath = [[_collectionView indexPathsForVisibleItems] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSIndexPath *indexPath1 = (NSIndexPath*)obj1;
            NSIndexPath *indexPath2 = (NSIndexPath*)obj2;
            
            if (indexPath2.section > indexPath1.section) {
                return NSOrderedAscending;
            }
            else if (indexPath2.section < indexPath1.section) {
                return NSOrderedDescending;
            }
            else if (indexPath2.row > indexPath1.row){
                return NSOrderedAscending;
            }
            else if (indexPath2.row < indexPath1.row) {
                return NSOrderedDescending;
            }
            else {
                return NSOrderedSame;
            }
        }];
        
        [self.delegate QIGridView:self didScrollToIndexPath:[sortedIndexPath firstObject]];
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (self.showQuickIndex) {
        [self performSelector:@selector(hideTheQuickIndex) withObject:nil afterDelay:1];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.showQuickIndex) {
        [self showTheQuickIndex];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (self.showQuickIndex) {
        [self showTheQuickIndex];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.showQuickIndex) {
        [self hideTheQuickIndex];
    }
}

@end
