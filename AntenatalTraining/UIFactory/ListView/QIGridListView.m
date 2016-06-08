//
//  QIGridListView.m
//  PlayZer
//
//  Created by mo jun on 11/8/15.
//  Copyright © 2015 kimoworks. All rights reserved.
//

#import "QIGridListView.h"

@implementation QIGridListView{
    BDKCollectionIndexView *_quickIndexView;
}

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setQuickIndexTitles:(NSArray *)quickIndexTitles
{
    NSMutableArray *titles = [quickIndexTitles mutableCopy];
    self.quickIndexView.indexTitles = titles;
}

- (NSArray*)quickIndexTitles
{
    if (_quickIndexView != nil) {
        return _quickIndexView.indexTitles;
    }
    return nil;
}

- (void)setShowQuickIndex:(BOOL)showQuickIndex{
    if (_showQuickIndex == showQuickIndex) {
        return;
    }
    
    _showQuickIndex = showQuickIndex;
    if (_showQuickIndex) {
        [self addSubview:self.quickIndexView];
        [self.quickIndexView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.top.equalTo(self).offset(64);
//            make.bottom.equalTo(self).offset(-kQueueBarHeight);
            make.width.equalTo(@17);
        }];
        self.quickIndexView.indexTitles = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"];
    } else {
        [self.quickIndexView removeFromSuperview];
    }
    
}

#pragma mark - BDKCollectionIndexView
- (BDKCollectionIndexView *)quickIndexView{
    if (_quickIndexView) return _quickIndexView;
    
    _quickIndexView = [BDKCollectionIndexView indexViewWithFrame:CGRectNull indexTitles:@[]];
    _quickIndexView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin);
    [_quickIndexView addTarget:self action:@selector(indexViewValueChanged:) forControlEvents:UIControlEventValueChanged];
    _quickIndexView.titleColor = [UIColor whiteColor];
    
    return _quickIndexView;
}

/// override this methods
- (void)indexViewValueChanged:(BDKCollectionIndexView *)sender{
    
}

#pragma mark - QIListViewProtocol

- (void)addToSuperView:(UIView *)superView{
    [superView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(superView);
    }];
}

- (void)reloadData{
    
}

- (void)registerCellClass:(Class)cellClass{
    
}

- (void)removeFromSuperview{
    [super removeFromSuperview];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
