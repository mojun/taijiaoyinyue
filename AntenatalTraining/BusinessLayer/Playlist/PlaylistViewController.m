//
//  PlaylistViewController.m
//  AntenatalTraining
//
//  Created by mo jun on 4/28/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "PlaylistViewController.h"
#import "DataTool+Playlist.h"
#import "IPlaylistTableViewCell.h"
#import "MKInputBoxView.h"
#import "NSString+Extension.h"
#import "PlaylistPopViewController.h"
#import "MusicDetailViewController.h"

@interface PlaylistViewController ()<GADBannerViewDelegate, UITableViewDataSource, UITableViewDelegate, IPlaylistTableViewCellDelegate>

@property (nonatomic, strong) QITableListView *listView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView *playlistBar;
@property (nonatomic, strong) TouchButton *leftButton;
@property (nonatomic, strong) TouchButton *rightButton;
@property (nonatomic, weak) NSIndexPath *currentHandleIndexPath;
@property (nonatomic, strong) UIView *bannerView;

@end

@implementation PlaylistViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [NSMutableArray array];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self playlistBar];
    [self.view addSubview:self.listView];
//    [_listView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_playlistBar.mas_bottom);
//        make.left.equalTo(self.view);
//        make.right.equalTo(self.view);
//        make.bottom.equalTo(self.view);
//    }];
    [self.view sendSubviewToBack:self.listView];
    
    [self requestData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestData) name:PlaylistDidAddSongsNotification object:nil];
    
    self.bannerView = [AdMobTool bannerViewWithDelegate:self controller:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.playlistBar.frame = CGRectMake(0, 0, kScreenWidth, kPlaylistBarHeight);
    CGRect frame = self.view.bounds;
    CGFloat barHeight = CGRectGetHeight(self.playlistBar.frame);
    frame.origin.y = barHeight;
    frame.size.height -= barHeight;
    self.listView.frame = frame;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)requestData {
    SSELF
    [DataTool getPlaylists:^(NSArray *playlists) {
        weakSelf.dataArray = [NSMutableArray arrayWithArray:playlists];
        [weakSelf.listView reloadData];
    }];
}

#pragma mark - event response
- (void)addAction {
    
    SSELF
    MKInputBoxView *inputBoxView = [MKInputBoxView boxOfType:PlainTextInput];
    [inputBoxView setBlurEffectStyle:UIBlurEffectStyleLight];
    inputBoxView.layer.shadowColor = kThemeColor.CGColor;
    inputBoxView.layer.shadowOffset = CGSizeMake(0, 0);
    inputBoxView.layer.shadowOpacity = 0.8f;
    inputBoxView.layer.shadowRadius = 4;
    [inputBoxView setTitle:@"新建播放列表"];
    [inputBoxView setCancelButtonText:@"取消"];
    [inputBoxView setSubmitButtonText:@"添加"];
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

- (void)modAction {
    
    SSELF
    
    PlaylistBean *bean = [self.dataArray objectAtIndex:self.currentHandleIndexPath.row];
    
    MKInputBoxView *inputBoxView = [MKInputBoxView boxOfType:PlainTextInput];
    [inputBoxView setBlurEffectStyle:UIBlurEffectStyleLight];
    [inputBoxView setTitle:@"修改播放列表"];
    inputBoxView.layer.shadowColor = kThemeColor.CGColor;
    inputBoxView.layer.shadowOffset = CGSizeMake(0, 0);
    inputBoxView.layer.shadowOpacity = 0.8f;
    inputBoxView.layer.shadowRadius = 4;
    [inputBoxView setCancelButtonText:@"取消"];
    [inputBoxView setSubmitButtonText:@"修改"];
    [inputBoxView setCustomise:^UITextField *(UITextField *tf) {
        tf.text = bean.title;
        return tf;
    }];
    [inputBoxView setOnSubmit:^BOOL(NSString *s1, NSString *s2) {
        s1 = [s1 trimSpace];
        if (s1.length == 0) {
            return NO;
        }
        [weakSelf modiPlaylistWithTitle:s1];
        return YES;
    }];
    [inputBoxView show];
}

- (void)editAction {
    
    if (self.listView.tableView.editing) {
        self.leftButton.enabled = YES;
        [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        [self.listView.tableView setEditing:NO animated:YES];
    } else {
        self.leftButton.enabled = NO;
        [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
        [self.listView.tableView setEditing:YES animated:YES];
        
        
    }
}

- (void)handleActionSheet:(NSInteger)index withIndexPath:(NSIndexPath *)indexPath{
    switch (index) {
        case 3:{
            [self modAction];
            break;
        }
        default:
            break;
    }
}

- (void)createPlaylistWithTitle:(NSString *)title {
    
    SSELF
    [DataTool addPlaylistWithTitle:title callback:^(PlaylistBean *playlist) {
        [weakSelf.dataArray addObject:playlist];
        [weakSelf.listView reloadData];
    }];
}

- (void)modiPlaylistWithTitle:(NSString *)title {
    
    PlaylistBean *bean = [self.dataArray objectAtIndex:self.currentHandleIndexPath.row];
    SSELF
    [DataTool modifyPlaylist:bean title:title callback:^(PlaylistBean *playlist) {
        [weakSelf.dataArray replaceObjectAtIndex:weakSelf.currentHandleIndexPath.row withObject:playlist];
        [weakSelf.listView reloadData];
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
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kListCellHeight;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.section == destinationIndexPath.section && sourceIndexPath.row == destinationIndexPath.row) {
        return;
    }
    
    PlaylistBean *playlistBean = [self.dataArray objectAtIndex:sourceIndexPath.row];
    SSELF
    [DataTool modifyPlaylist:playlistBean toIndex:destinationIndexPath.row callback:^(BOOL suc) {
        [weakSelf requestData];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PlaylistBean *playlistBean = [self.dataArray objectAtIndex:indexPath.row];
    MusicDetailViewController *c = [[MusicDetailViewController alloc] initFromXib];
    c.sourceBean = playlistBean;
    c.title = @"列表详情";
    [self.navigationController pushViewController:c animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger row = indexPath.row;
        
        PlaylistBean *playlistBean = [self.dataArray objectAtIndex:row];
        [self.dataArray removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [DataTool deletePlaylistWithBean:playlistBean callback:^(BOOL suc) {
            NSLog(@"delete playlist: %@  suc: %@", playlistBean.title, @(suc));
        }];
    }
}

#pragma mark - IPlaylistTableViewCellDelegate
- (void)cell:(IPlaylistTableViewCell *)cell didSelectAtIndexPath:(NSIndexPath *)indexPath {
    
    self.currentHandleIndexPath = indexPath;
    SSELF
    DoActionSheet *sheet = [[DoActionSheet alloc] init];
    sheet.doBackColor = DO_RGBA(255, 255, 255, 0.8);
    sheet.doButtonColor = DO_RGB(113, 208, 243);
    sheet.doCancelColor = DO_RGB(73, 168, 203);
    sheet.doDestructiveColor = DO_RGB(235, 15, 93);
    sheet.doTitleTextColor = DO_RGB(40, 47, 47);
    
    PlaylistBean *playlistBean = [self.dataArray objectAtIndex:indexPath.row];
    [sheet showC:playlistBean.title cancel:@"取消" buttons:@[@"添加到播放列表",@"添加到播放队列",@"立即播放",@"重命名"] result:^(int nResult) {
        NSLog(@"nResult: %@", @(nResult));
        [weakSelf handleActionSheet:nResult withIndexPath:indexPath];
    }];
}

#pragma mark - getters and setter
- (QITableListView *)listView {
    if (_listView == nil) {
        _listView = [[QITableListView alloc] initWithStyle:UITableViewStylePlain delegate:self];
        [_listView registerCellClass:[IPlaylistTableViewCell class]];
        _listView.tableView.separatorColor = kTableCellSeparatorColor;
        
    }
    return _listView;
}

- (UIView *)playlistBar {
    if (_playlistBar == nil) {
        _playlistBar = [[UIView alloc] init];
        _playlistBar.backgroundColor = [UIColor colorWithWhite:1 alpha:kBarAlpha];
        [self.view addSubview:_playlistBar];
//        [_playlistBar mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view);
//            make.left.equalTo(self.view);
//            make.right.equalTo(self.view);
//            make.height.mas_equalTo(kPlaylistBarHeight);
//        }];
        
        UIVisualEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        [_playlistBar addSubview:effectView];
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_playlistBar);
        }];
        
        TouchButton *leftButton = [TouchButton buttonWithType:UIButtonTypeCustom];
        [leftButton setTitle:@"添加" forState:UIControlStateNormal];
        [leftButton setTitleColor:kThemeColor forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        [_playlistBar addSubview:leftButton];
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_playlistBar);
            make.bottom.equalTo(_playlistBar);
            make.left.equalTo(_playlistBar);
            make.width.mas_equalTo(50);
        }];
        
        TouchButton *rightButton = [TouchButton buttonWithType:UIButtonTypeCustom];
        [rightButton setTitleColor:kThemeColor forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_playlistBar addSubview:rightButton];
        
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_playlistBar);
            make.bottom.equalTo(_playlistBar);
            make.right.equalTo(_playlistBar);
            make.width.mas_equalTo(50);
        }];
        
        leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        
        self.leftButton = leftButton;
        self.rightButton = rightButton;
        
    }
    return _playlistBar;
}

#pragma mark - GADBannerViewDelegate
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    CGRect frame = self.view.bounds;
    CGRect bannerFrame = CGRectMake(0, self.playlistBar.frame.size.height, kScreenWidth, kScreenWidth * 5 / 32);
    [self.view addSubview:bannerView];
    bannerView.frame = bannerFrame;
    frame.origin.y += CGRectGetHeight(bannerFrame);
    frame.size.height -= CGRectGetHeight(bannerFrame);
    self.listView.frame = frame;
}

@end
