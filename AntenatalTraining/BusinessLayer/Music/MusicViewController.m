//
//  MusicViewController.m
//  AntenatalTraining
//
//  Created by test on 16/4/28.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "MusicViewController.h"
#import "QICollectionListView.h"
#import "DataTool.h"
#import "QICategoryCollectionCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "MusicDetailViewController.h"
#import "MusicHeaderView.h"

@interface MusicViewController ()<GADBannerViewDelegate, QIGridViewDataSource, QIGridViewDelegate, SDCycleScrollViewDelegate>

@property (nonatomic, strong) QICollectionListView *listView;
@property (nonatomic, strong) MusicHeaderView *headerView;
@property (nonatomic, strong) id<DataFetcherProtocol> dataFetcher;
@property (nonatomic, strong) UIView *bannerView;

@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self listView];
    [self fetchData];
    
    self.bannerView = [AdMobTool bannerViewWithDelegate:self controller:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.listView.frame = self.view.bounds;
}

#pragma mark - private
- (void)fetchData {
    SSELF
    self.dataFetcher = [DataTool listCategoryCallback:^(BOOL suc, id<DataFetcherProtocol> selfFetcher) {
        [weakSelf.listView reloadData];
        
        NSArray *songs = [DataTool randomMusic];
        self.headerView.songs = songs;
        
    }];
}

#pragma mark - QIGridViewDataSource
- (NSInteger)numberOfSectionsInQIGridView:(QICollectionListView *)gridView {
    return 1;
}

- (NSInteger)QIGridView:(QICollectionListView *)gridView numberOfItemsInSection:(NSInteger)section {
    return [self.dataFetcher count];
}

- (QICollectionBaseCell *)QIGridView:(QICollectionListView *)gridView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QICategoryCollectionCell *cell = (QICategoryCollectionCell *)[gridView dequeueReusableCellWithReuseIdentifier:[QICategoryCollectionCell registeredIdentifier] forIndexPath:indexPath];
    CategoryModel *model = [self.dataFetcher objectAtIndexPath:indexPath];
    cell.titleLabel.text = model.title;
    [cell setCoverEntity:model.imageEntity];
//    cell.coverView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", @(indexPath.row)]];
    return cell;
}

- (UICollectionReusableView *)QIGridView:(QICollectionListView *)gridView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (self.headerView == nil) {
        MusicHeaderView *header = [gridView.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HEADER" forIndexPath:indexPath];
        header.cycleView.delegate = self;
        self.headerView = header;
    }
    
    return self.headerView;
}

#pragma mark - QIGridViewDelegate
- (void)QIGridView:(QICollectionListView *)gridView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryModel *model = [self.dataFetcher objectAtIndexPath:indexPath];
    MusicDetailViewController *c = [[MusicDetailViewController alloc] initFromXib];
    c.sourceBean = model;
    c.title = @"音乐详情";
    [self.navigationController pushViewController:c animated:YES];
}

- (void)QIGridView:(QICollectionListView *)gridView didLongPressed:(UILongPressGestureRecognizer *)recognizer itemIndexPath:(NSIndexPath *)indexPath {
    CategoryModel *model = [self.dataFetcher objectAtIndexPath:indexPath];
    [[PopSheetTool tool] showWithOperationBean:model operationTypeBlock:nil];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    MusicModel *song = [self.headerView.songs objectAtIndex:index];
    CategoryModel *model = [DataTool categoryFromMusic:song];
    MusicDetailViewController *c = [[MusicDetailViewController alloc] initFromXib];
    c.sourceBean = model;
    c.title = @"音乐详情";
    [self.navigationController pushViewController:c animated:YES];
}

#pragma mark - getters and setters
- (QICollectionListView *)listView {
    if (_listView == nil) {
        _listView = [[QICollectionListView alloc] initWithDelegate:self];
        [_listView registerCellClass:[QICategoryCollectionCell class]];
        
        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)_listView.collectionView.collectionViewLayout;
        layout.headerReferenceSize = CGSizeMake(kScreenWidth,kScreenWidth * 0.4 + 258);
        layout.sectionInset = UIEdgeInsetsMake(kGridCellSpacing, kGridCellSpacing, kGridCellSpacing, kGridCellSpacing);
        [self.view addSubview:_listView];
//        [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
//        }];
        [_listView.collectionView registerClass:[MusicHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HEADER"];
    }
    return _listView;
}

#pragma mark - GADBannerViewDelegate
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    CGRect frame = self.view.bounds;
    CGRect bannerFrame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * 5 / 32);
    [self.view addSubview:bannerView];
    bannerView.frame = bannerFrame;
    frame.origin.y += CGRectGetHeight(bannerFrame);
    frame.size.height -= CGRectGetHeight(bannerFrame);
    self.listView.frame = frame;
}

@end
