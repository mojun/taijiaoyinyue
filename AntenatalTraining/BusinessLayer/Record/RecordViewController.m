//
//  RecordViewController.m
//  AntenatalTraining
//
//  Created by mo jun on 4/28/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "RecordViewController.h"
#import "FinishedTableCell.h"
#import "DownloadTableCell.h"
#import "DataTool+Download.h"
#import "TCBlobDownloader+TCMusic.h"
#import <TCBlobDownload/TCBlobDownload.h>
#import "NSString+Extension.h"
#import "DownloadFinishedBar.h"
#import "DownloadingBar.h"

@interface RecordViewController ()<GADBannerViewDelegate, UITableViewDataSource, UITableViewDelegate, TCBlobDownloaderDelegate, DownloadFinishedBarDelegate, DownloadingBarDelegate>

@property (nonatomic, strong) QITableListView *finishedTable;
@property (nonatomic, strong) QITableListView *downloadTable;
@property (nonatomic, strong) NSMutableArray *finishedDatas;
@property (nonatomic, strong) NSMutableArray *downloadDatas;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSObject *locker;
@property (nonatomic, strong) DownloadFinishedBar *downloadFinishedBar;
@property (nonatomic, strong) DownloadingBar *downloadingBar;

@end

@implementation RecordViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadNotification:) name:kDownloadMediaNotification object:nil];
        [self fetchData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = [self segmentedControl];
    [self.view addSubview:[self finishedTable]];
    [self.view addSubview:[self downloadTable]];
    [self.view addSubview:[self downloadFinishedBar]];
    [self.view addSubview:[self downloadingBar]];
    [self.downloadFinishedBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(kDownloadBarHeight);
    }];
    
    [self.downloadingBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.mas_equalTo(kDownloadBarHeight);
    }];
    
    [self.finishedTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.downloadingBar.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    [self.downloadTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.downloadingBar.mas_bottom);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [self segmentValueChanged];
    
    [self.finishedTable reloadData];
    [self.downloadTable reloadData];
    
    [self.downloadingBar pause:NO];
    
    
}

static NSInteger faq = 0;
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (faq % 5 == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[AdMobTool api] presentInterstitial];
        });
    }
    faq++;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notifier
- (void)downloadNotification:(NSNotification *)notification {
    NSArray *songs = [notification.object objectForKey:@"songs"];
    [self addSongsToDownload:songs];
    [self.downloadTable reloadData];
    [UIView ccMakeToast:@"已添加到下载列表"];
    [self checkEmpty];
}

#pragma mark - private
- (void)checkEmpty {
    
    BOOL showFinished = _segmentedControl.selectedSegmentIndex == 0;
    if (self.finishedDatas.count == 0 && showFinished) {
        [self showDownloadedEmpty];
    } else if (self.downloadDatas.count == 0 && !showFinished) {
        [self showDownloadingEmpty];
    } else {
        [self hideBlank];
    }
}

- (void)segmentValueChanged {
    
    BOOL showFinished = _segmentedControl.selectedSegmentIndex == 0;
    self.finishedTable.hidden = !showFinished;
    self.downloadTable.hidden = showFinished;
    self.downloadFinishedBar.hidden = !showFinished;
    self.downloadingBar.hidden = showFinished;
    
    [self checkEmpty];
}

- (void)fetchData {
    
    SSELF
    [DataTool getDownloadedList:^(NSArray *list) {
        [weakSelf.finishedDatas addObjectsFromArray:list];
        if (weakSelf.isViewLoaded) {
            [weakSelf.finishedTable reloadData];
        }
    }];
    
    [DataTool getDownloadingList:^(NSArray *list) {
        [weakSelf addSongsToDownload:list];
        if (weakSelf.isViewLoaded) {
            [weakSelf.downloadTable reloadData];
        }
    }];
}

- (void)addSongsToDownload:(NSArray *)songs {

    @synchronized(self.locker) {
        NSMutableArray *downloadDatas = self.downloadDatas;
        
        for (MusicModel *song in songs) {
            
            DownloadModel *m = [DataTool addSongToDownload:song];
            if (m) {
                TCBlobDownloader *downloader = [[TCBlobDownloader alloc] initWithURL:[NSURL URLWithString:[song audioHttpURL]] downloadPath:kATDownloadFilePath(@"at_music_download_file") delegate:self];
                downloader.mark = m;
                [downloadDatas addObject:downloader];
                [[TCBlobDownloadManager sharedInstance] setMaxConcurrentDownloads:1];
                [[TCBlobDownloadManager sharedInstance] startDownload:downloader];
            }
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 0) {
        return [self.finishedDatas count];
    }
    return [self.downloadDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        FinishedTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[FinishedTableCell registeredIdentifier] forIndexPath:indexPath];
        DownloadModel *model = [self.finishedDatas objectAtIndex:indexPath.row];
        cell.titleLabel.text = model.title;
        cell.fileSizeLabel.text = model.file_size;
        return cell;
    } else {
        DownloadTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[DownloadTableCell registeredIdentifier] forIndexPath:indexPath];
        TCBlobDownloader *downloader = [self.downloadDatas objectAtIndex:indexPath.row];
        DownloadModel *model = downloader.mark;
        cell.titleLabel.text = model.title;
        
        NSString *state = nil;
        switch (downloader.state) {
            case TCBlobDownloadStateReady:
                state = @"准备下载";
                break;
            case TCBlobDownloadStateDownloading:
                state = @"下载中";
                break;
            case TCBlobDownloadStateDone:
                state = @"下载完成";
                break;
            case TCBlobDownloadStateCancelled:
                state = @"下载取消";
                break;
            case TCBlobDownloadStateFailed:
                state = @"下载出错";
                break;
            default:
                break;
        }
        
        if (self.downloadingBar.pauseBtn.tag == 0) {
            state = @"暂停";
        }
        
        cell.progressBar.progress = downloader.progress;
        cell.stateLabel.text = state;
        if (model.total_size.integerValue == 0) {
            cell.progressLabel.text = [NSString stringWithFormat:@"0M/%@", model.file_size];
        } else {
            cell.progressLabel.text = [NSString stringWithFormat:@"%@/%@",[NSString stringFromBytes:model.recieved_size], [NSString stringFromBytes:model.total_size]];
        }
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSInteger row = indexPath.row;
        DownloadModel *m = nil;
        NSInteger newCount = 0;
        if (tableView.tag == 0) {
            m = [self.finishedDatas objectAtIndex:row];
            [m deleteSong];
            [self.finishedDatas removeObject:m];
            newCount = self.finishedDatas.count;
        } else {
            TCBlobDownloader *downloader = [self.downloadDatas objectAtIndex:row];
            [downloader cancelDownloadAndRemoveFile:YES];
            m = downloader.mark;
            [m deleteSong];
            [self.downloadDatas removeObject:downloader];
            newCount = self.downloadDatas.count;
        }
        [tableView beginUpdates];
        if (newCount <= 0) {
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
        [self checkEmpty];
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 0) {
        PLAY_MUSIC(self.finishedDatas, indexPath.row);
    }
}

#pragma mark - TCBlobDownloaderDelegate
- (void)download:(TCBlobDownloader *)blobDownload didReceiveFirstResponse:(NSURLResponse *)response {
    if (self.isViewLoaded) {
        NSInteger index = [self.downloadDatas indexOfObject:blobDownload];
        DownloadTableCell *cell = [self.downloadTable.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.stateLabel.text = @"准备下载";
    }
}

- (void)download:(TCBlobDownloader *)blobDownload
  didReceiveData:(uint64_t)receivedLength
         onTotal:(uint64_t)totalLength
        progress:(float)progress {
    NSInteger index = [self.downloadDatas indexOfObject:blobDownload];
    DownloadModel *model = blobDownload.mark;
    model.recieved_size = @(receivedLength);
    model.total_size = @(totalLength);
    
    if (self.isViewLoaded) {
        DownloadTableCell *cell = [self.downloadTable.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.stateLabel.text = @"下载中";
        cell.progressBar.progress = progress;
        cell.progressLabel.text = [NSString stringWithFormat:@"%@/%@",[NSString stringFromBytes:model.recieved_size], [NSString stringFromBytes:model.total_size]];
    }
}

- (void)download:(TCBlobDownloader *)blobDownload
didStopWithError:(NSError *)error {
    if (self.isViewLoaded) {
        NSInteger index = [self.downloadDatas indexOfObject:blobDownload];
        DownloadTableCell *cell = [self.downloadTable.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.stateLabel.text = @"下载出错";
    }
}

- (void)download:(TCBlobDownloader *)blobDownload
didFinishWithSuccess:(BOOL)downloadFinished
          atPath:(NSString *)pathToFile {
    
    if (downloadFinished) {
        NSInteger index = [self.downloadDatas indexOfObject:blobDownload];
        DownloadModel *model = blobDownload.mark;
        DownloadTableCell *cell = [self.downloadTable.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        cell.stateLabel.text = @"下载完成";
        model.state = @1;
        [DataTool updateDown:model];
        @synchronized(self.locker) {
            [self.downloadDatas removeObjectAtIndex:index];
            
            NSInteger newCount = self.downloadDatas.count;
            if (self.isViewLoaded) {
                [self.downloadTable.tableView beginUpdates];
                if (newCount <= 0) {
                    [self.downloadTable.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
                }
                
                [self.downloadTable.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [self.downloadTable.tableView endUpdates];
            }
            
            [self.finishedDatas insertObject:model atIndex:0];
            [self.finishedTable reloadData];
            [self checkEmpty];
        }
    } else {

    }
}

#pragma mark - DownloadingBarDelegate
- (void)downloadingBar:(DownloadingBar *)bar didTouchedAtIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            @synchronized(self.locker) {
                [[TCBlobDownloadManager sharedInstance] setMaxConcurrentDownloads:1];
            }
            break;
        }
        case 1:{
            @synchronized(self.locker) {
                [[TCBlobDownloadManager sharedInstance] setMaxConcurrentDownloads:0];
            }
            break;
        }
        case 2:{
            [self.downloadTable.tableView setEditing:YES animated:YES];
            break;
        }
        case 3:{
            [self.downloadTable.tableView setEditing:NO animated:YES];
            break;
        }
        case 4:{
            [self.downloadTable.tableView setEditing:NO animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - DownloadFinishedBarDelegate
- (void)downloadFinishedBar:(DownloadFinishedBar *)bar didTouchedAtIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            if (self.finishedDatas.count == 0) {
                [UIView ccMakeToast:@"下载列表为空"];
                return;
            }
            NSArray *songs = [self.finishedDatas shuffledArray];
            PLAY_MUSIC(songs, 0);
            break;
        }
        case 1:{
            [self.finishedTable.tableView setEditing:YES animated:YES];
            break;
        }
        case 2:{
            [self.finishedTable.tableView setEditing:NO animated:YES];
            break;
        }
        case 3:{
            [self.finishedTable.tableView setEditing:NO animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - getters and setters
- (NSObject *)locker {
    if (_locker == nil) {
        _locker = [[NSObject alloc] init];
    }
    return _locker;
}

- (UISegmentedControl *)segmentedControl {
    if (_segmentedControl == nil) {
        
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"已下载",@"正在下载"]];
        [_segmentedControl setTintColor:[UIColor whiteColor]];
        _segmentedControl.selectedSegmentIndex = 0;
        [_segmentedControl addTarget:self action:@selector(segmentValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (QITableListView *)finishedTable {
    if (_finishedTable == nil) {
        _finishedTable = [[QITableListView alloc] initWithStyle:UITableViewStylePlain delegate:self];
        _finishedTable.tableView.tag = 0;
        [_finishedTable registerCellClass:[FinishedTableCell class]];
        _finishedTable.tableView.separatorColor = kTableCellSeparatorColor;
    }
    return _finishedTable;
}

- (QITableListView *)downloadTable {
    if (_downloadTable == nil) {
        _downloadTable = [[QITableListView alloc] initWithStyle:UITableViewStylePlain delegate:self];
        _downloadTable.tableView.tag = 1;
        [_downloadTable registerCellClass:[DownloadTableCell class]];
        _downloadTable.tableView.separatorColor = kTableCellSeparatorColor;
    }
    return _downloadTable;
}

- (DownloadFinishedBar *)downloadFinishedBar {
    if (_downloadFinishedBar == nil) {
        _downloadFinishedBar = [[DownloadFinishedBar alloc]initWithFrame:CGRectNull];
        _downloadFinishedBar.delegate = self;
    }
    return _downloadFinishedBar;
}

- (DownloadingBar *)downloadingBar {
    if (_downloadingBar == nil) {
        _downloadingBar = [[DownloadingBar alloc] initWithFrame:CGRectNull];
        _downloadingBar.delegate = self;
    }
    return _downloadingBar;
}

- (NSMutableArray *)finishedDatas {
    if (_finishedDatas == nil) {
        _finishedDatas = [NSMutableArray array];
    }
    return _finishedDatas;
}

- (NSMutableArray *)downloadDatas {
    if (_downloadDatas == nil) {
        _downloadDatas = [NSMutableArray array];
    }
    return _downloadDatas;
}

@end
