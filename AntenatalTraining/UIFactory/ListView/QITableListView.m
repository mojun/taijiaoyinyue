//
//  QITableListView.m
//  PlayZer
//
//  Created by mojun on 15/10/27.
//  Copyright © 2015年 kimoworks. All rights reserved.
//

#import "QITableListView.h"
#import "QITableBaseCell.h"

@implementation QITableListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithStyle:(UITableViewStyle)style delegate:(id <UITableViewDataSource, UITableViewDelegate>)delegate{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
        _tableView = [[UITableView alloc]initWithFrame:self.bounds style:style];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.clipsToBounds = NO;
//        _tableView.separatorColor = kUIDesignTableSeparatorColor;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectNull];
        _tableView.dataSource = delegate;
        _tableView.delegate = delegate;
        [self addSubview:_tableView];
        
        UIEdgeInsets insets = UIEdgeInsetsZero;
//        insets.top = kNavbarHeight;
//        insets.bottom = kQueueBarHeight;
        _tableView.contentInset = insets;
        _tableView.contentOffset = CGPointMake(0, -insets.top);
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)indexViewValueChanged:(BDKCollectionIndexView *)sender{
    NSIndexPath *path = nil;
    if ([self.quickDelegate respondsToSelector:@selector(QIGridListView:scrollToIndexPathWithQuickIndex:)]) {
        path = [self.quickDelegate QIGridListView:self scrollToIndexPathWithQuickIndex:sender.currentIndex];
    }
}

- (void)addToSuperView:(UIView *)superView{
    [superView addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(superView);
    }];
}

- (void)reloadData{
    [_tableView reloadData];
}

- (void)registerCellClass:(Class)cellClass{
    [cellClass registerForTableView:_tableView];
}

- (QITableBaseCell *)dequeueResuableCellWithReuseIdentifier:(NSString *)identifier
                                               forIndexPath:(NSIndexPath *)indexPath{
    QITableBaseCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

@end
