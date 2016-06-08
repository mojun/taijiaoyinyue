//
//  SearchViewController.m
//  AntenatalTraining
//
//  Created by test on 16/4/28.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "SearchViewController.h"
#import "DataTool.h"
#import "SqliteDataFetcher.h"
#import "MusicTableListCell.h"
#import "UIImage+CGImage.h"

@interface SearchViewController ()<GADBannerViewDelegate, UITableViewDataSource, UITableViewDelegate, MusicTableListCellDelegate, UISearchBarDelegate> {
    
    // search
    UISearchBar *_searchBar;
    UIButton    *_closeButton;
    UIButton    *_cancelSearchButton;
}

@property (nonatomic, strong) QITableListView *listView;
@property (nonatomic, strong) id<DataFetcherProtocol> dataFetcher;
@property (nonatomic, strong) UIView *bannerView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.listView addToSuperView:self.view];
    [self.view addSubview:self.listView];
    [self setupNavTitleViewHome];
    
    self.bannerView = [AdMobTool bannerViewWithDelegate:self controller:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.listView.frame = self.view.bounds;
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

- (QITableListView *)listView {
    if (_listView == nil) {
        _listView = [[QITableListView alloc] initWithStyle:UITableViewStylePlain delegate:self];
        [_listView registerCellClass:[MusicTableListCell class]];
        _listView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8f];
        _listView.tableView.separatorColor = kTableCellSeparatorColor;
    }
    return _listView;
}


#pragma mark - search bar
- (void)setupNavTitleViewHome
{
    UIView *titleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-30, 44)];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 11, 66, 22);
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    [titleBgView addSubview:closeButton];
    _closeButton = closeButton;
    
    CGFloat loginButtonWidth = 0;

    
    UIImage *clearImage = [UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(kScreenWidth, 44)];
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(81, 0, kScreenWidth-111-loginButtonWidth, 44)];
    [searchBar setContentMode:UIViewContentModeLeft];
    searchBar.delegate = self;
    [searchBar setBackgroundImage:clearImage];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.barStyle = UISearchBarStyleProminent;
    [searchBar setSearchFieldBackgroundImage:[[UIImage imageNamed:@"img_home_search_h"]
                                              resizableImageWithCapInsets:UIEdgeInsetsMake(16, 16, 16.0f, 16)]
                                    forState:UIControlStateNormal];
    searchBar.placeholder = @"搜索歌曲";
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.layer.cornerRadius = 22;
    searchBar.clipsToBounds = YES;
    [searchBar setImage:[UIImage imageNamed:@"search_white_search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [searchBar setImage:[UIImage imageNamed:@"search_white_close"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [titleBgView addSubview:searchBar];
    _searchBar = searchBar;
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentRight;
    cancelButton.frame = CGRectMake(CGRectGetMaxX(searchBar.frame)-50, 0, 40, 44);
    [cancelButton addTarget:self action:@selector(actionCancelSearch:) forControlEvents:UIControlEventTouchUpInside];
    [titleBgView addSubview:cancelButton];
    [titleBgView sendSubviewToBack:cancelButton];
    _cancelSearchButton = cancelButton;
    
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    [searchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.navigationItem.titleView = titleBgView;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat loginButtonWidth = 0;
        searchBar.frame = CGRectMake(0, 0, kScreenWidth-75-loginButtonWidth, 44);
        _closeButton.frame = CGRectMake(-90, 11, 66, 22);
        _cancelSearchButton.frame = CGRectMake(CGRectGetMaxX(searchBar.frame) + 10, 0, 40, 44);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    NSString *text = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.dataFetcher = [DataTool listSearchByKeyword:text];
    
    [self.listView reloadData];
}

- (void)actionCancelSearch:(id)sender
{
    [_searchBar resignFirstResponder];
    
    CGFloat loginButtonWidth = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _searchBar.frame = CGRectMake(81, 0, kScreenWidth-111-loginButtonWidth, 44);
        _closeButton.frame = CGRectMake(0, 11, 66, 22);
        _cancelSearchButton.frame = CGRectMake(CGRectGetMaxX(_searchBar.frame)-50, 0, 40, 44);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissVC {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
