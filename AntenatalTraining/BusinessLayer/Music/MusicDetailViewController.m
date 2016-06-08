//
//  MusicDetailViewController.m
//  AntenatalTraining
//
//  Created by test on 16/5/3.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "MusicDetailViewController.h"
#import "CategoryModel.h"
#import "MusicDetailHeaderView.h"
#import "MusicTableListCell.h"
#import "DataTool.h"
#import "DataTool+Collection.h"
#import "PlaylistBean.h"
#import "DataTool+Playlist.h"
#import "SqliteDataFetcher.h"

@interface MusicDetailViewController ()<GADBannerViewDelegate, UITableViewDataSource, UITableViewDelegate, MusicTableListCellDelegate>
{
    UIImageView *_backgroundBlurView;
}

@property (nonatomic, strong) QITableListView *listView;
@property (nonatomic, strong) MusicDetailHeaderView *headerView;
@property (nonatomic, strong) id<DataFetcherProtocol> dataFetcher;
@property (nonatomic, strong) UIView *bannerView;

@end

@implementation MusicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:[self backgroundBlurView]];
    [_backgroundBlurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.listView];
//    [self.listView addToSuperView:self.view];
    SSELF
    if (_sourceBean == nil) {
        [DataTool getSongs:^(NSArray *songs) {
            weakSelf.dataFetcher = [[SqliteDataFetcher alloc] initWithDatas:songs];
            [weakSelf.listView reloadData];
            if (songs.count == 0) {
                [weakSelf showPlaylistEmpty];
            }
        }];

    } else if ([_sourceBean isKindOfClass:[CategoryModel class]]) {
        CategoryModel *category = self.sourceBean;
        _listView.tableView.tableHeaderView = [self headerView];
        [_headerView.imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [_headerView setCoverEntity:category.imageEntity];
        _headerView.titleLabel.text = category.title;
        
        _dataFetcher = [DataTool listMusicByCategoryId:category.c_id callback:^(BOOL suc, id<DataFetcherProtocol> selfFetcher) {
            [weakSelf.listView reloadData];
        }];
    } else if ([_sourceBean isKindOfClass:[PlaylistBean class]]) {
        PlaylistBean *playlistBean = _sourceBean;
        [DataTool getPlaylistSongsWithID:playlistBean.playlist_id callback:^(NSArray *playlistSongs) {
            weakSelf.dataFetcher = [[SqliteDataFetcher alloc] initWithDatas:playlistSongs];
            [weakSelf.listView reloadData];
            if (playlistSongs.count == 0) {
                [weakSelf showPlaylistEmpty];
            }
        }];
    }
    
    
    
    
    self.bannerView = [AdMobTool bannerViewWithDelegate:self controller:self];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.listView.frame = self.view.bounds;
}

#pragma mark - event response
- (void)playAll {
    PLAY_MUSIC([_dataFetcher dataArray], 0);
}

- (void)downloadAll {
    DOWNLOAD_MUSIC([_dataFetcher dataArray]);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataFetcher count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicTableListCell *cell = (MusicTableListCell *)[_listView dequeueResuableCellWithReuseIdentifier:[MusicTableListCell registeredIdentifier] forIndexPath:indexPath];
    MusicModel *file = [_dataFetcher objectAtIndexPath:indexPath];
    cell.indexLabel.text = [NSString stringWithFormat:@"%@", @(indexPath.row + 1)];
    cell.titleLabel.text = file.title;
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PLAY_MUSIC([_dataFetcher dataArray], indexPath.row);
}

#pragma mark - MusicTableListCellDelegate
- (void)musicTableListCell:(MusicTableListCell *)cell didTouchedButtonAtIndexPath:(NSIndexPath *)indexPath {
    MusicModel *model = [_dataFetcher objectAtIndexPath:indexPath];
    [[PopSheetTool tool] showWithOperationBean:model operationTypeBlock:nil];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"image"]) {
        UIImage *newImage = [change objectForKey:NSKeyValueChangeNewKey];
        [_backgroundBlurView setImageViewToBlurWithImage:newImage andBlurRadius:50];
    }
}

#pragma mark - getters and setters
- (UIImageView *)backgroundBlurView {
    if (_backgroundBlurView == nil) {
        _backgroundBlurView = [[UIImageView alloc] init];
    }
    return _backgroundBlurView;
}

- (QITableListView *)listView {
    if (_listView == nil) {
        _listView = [[QITableListView alloc] initWithStyle:UITableViewStylePlain delegate:self];
        [_listView registerCellClass:[MusicTableListCell class]];
        _listView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8f];
        _listView.tableView.separatorColor = kTableCellSeparatorColor;
    }
    return _listView;
}

- (MusicDetailHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[MusicDetailHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, 0, 96);
        [_headerView.playAll addTarget:self action:@selector(playAll) forControlEvents:UIControlEventTouchUpInside];
        [_headerView.downloadAll addTarget:self action:@selector(downloadAll) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _headerView;
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
