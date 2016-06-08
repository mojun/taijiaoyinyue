//
//  PlaylistPopViewController.m
//  AntenatalTraining
//
//  Created by test on 16/5/21.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "PlaylistPopViewController.h"
#import "DataTool+Playlist.h"
#import "IPlaylistTableViewCell.h"
#import "MKInputBoxView.h"
#import "NSString+Extension.h"

NSString * const PlaylistDidAddSongsNotification = @"PlaylistDidAddSongsNotification";

@interface PlaylistPopViewController ()<GADBannerViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) QITableListView *listView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *bannerView;

@end

@implementation PlaylistPopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加到列表";
    self.dataArray = [NSMutableArray array];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:[self listView]];
//    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
    
    TouchButton *leftButton = [TouchButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 40, 40);
    [leftButton setTitle:@"新建" forState:UIControlStateNormal];
    [leftButton setTitleColor:kThemeColor forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    TouchButton *rightButton = [TouchButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setTitle:@"取消" forState:UIControlStateNormal];
    [rightButton setTitleColor:kThemeColor forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self requestData];
    
    self.bannerView = [AdMobTool bannerViewWithDelegate:self controller:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.listView.frame = self.view.bounds;
}

- (void)requestData {
    SSELF
    [DataTool getPlaylists:^(NSArray *playlists) {
        weakSelf.dataArray = [NSMutableArray arrayWithArray:playlists];
        [weakSelf.listView reloadData];
    }];
}

#pragma mark - event response
- (void)cancelAction {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)addAction {
    
    SSELF
    MKInputBoxView *inputBoxView = [MKInputBoxView boxOfType:PlainTextInput];
    [inputBoxView setBlurEffectStyle:UIBlurEffectStyleLight];
    [inputBoxView setTitle:@"新建播放列表"];
    [inputBoxView setOnSubmit:^BOOL(NSString *s1, NSString *s2) {
        s1 = [s1 trimSpace];
        if (s1.length == 0) {
            return NO;
        }
        [weakSelf createPlaylistWithTitle:s1];
        return YES;
    }];
    [inputBoxView show];
}

- (void)createPlaylistWithTitle:(NSString *)title {
    
    SSELF
    [DataTool addPlaylistWithTitle:title callback:^(PlaylistBean *playlist) {
//        [weakSelf.dataArray addObject:playlist];
//        [weakSelf.listView reloadData];
        [weakSelf addToPlaylist:playlist];
    }];
}

- (void)addToPlaylist:(PlaylistBean *)playlistBean {
    SSELF
    [DataTool addSongsToPlaylistWithID:playlistBean.playlist_id songs:self.songs callback:^(BOOL suc) {
        [[NSNotificationCenter defaultCenter] postNotificationName:PlaylistDidAddSongsNotification object:nil];
        [weakSelf.presentingViewController dismissViewControllerAnimated:YES completion:^{
            if (weakSelf.callback) {
                weakSelf.callback();
            }
        }];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IPlaylistTableViewCell *cell = (IPlaylistTableViewCell *)[_listView dequeueResuableCellWithReuseIdentifier:[IPlaylistTableViewCell registeredIdentifier] forIndexPath:indexPath];
    PlaylistBean *file = [self.dataArray objectAtIndex:indexPath.row];
    cell.firstLab.text = file.title;
    cell.secondLab.text = [NSString stringWithFormat:@"%@首",file.song_num];
    cell.indexPath = indexPath;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kListCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlaylistBean *file = [self.dataArray objectAtIndex:indexPath.row];
    [self addToPlaylist:file];
}

#pragma mark - getters and setter
- (QITableListView *)listView {
    if (_listView == nil) {
        _listView = [[QITableListView alloc] initWithStyle:UITableViewStylePlain delegate:self];
        [_listView registerCellClass:[IPlaylistTableViewCell class]];
        _listView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8f];
        _listView.tableView.separatorColor = kTableCellSeparatorColor;
        
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
