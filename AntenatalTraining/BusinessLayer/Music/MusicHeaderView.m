//
//  MusicHeaderView.m
//  AntenatalTraining
//
//  Created by test on 16/5/31.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "MusicHeaderView.h"
#import "DataTool.h"

@interface MusicHeaderViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MusicHeaderViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *iconView = [[UIImageView alloc] init];
        iconView.contentMode = UIViewContentModeScaleAspectFill;
        iconView.layer.cornerRadius = 20;
        iconView.layer.masksToBounds = YES;
        [self addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = kThemeLightBlack;
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
            make.centerY.equalTo(self);
            make.left.mas_equalTo(15);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconView.mas_right).offset(10);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.right.equalTo(self).offset(-15);
        }];
    }
    return self;
}

@end

@implementation MusicHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.cycleView];
        [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.mas_equalTo(kScreenWidth * 0.4f);
        }];
        
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cycleView.mas_bottom);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MIN(self.subSongs.count, 3);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicHeaderViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID" forIndexPath:indexPath];
    MusicModel *model = [self.subSongs objectAtIndex:indexPath.row];
    cell.titleLabel.text = model.title;
    cell.iconView.image = [UIImage imageWithContentsOfFile:model.imagePath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MusicModel *model = [self.subSongs objectAtIndex:indexPath.row];
    PLAY_MUSIC(@[model], 0);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"热门音乐";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"热门分类";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

#pragma mark - getters

- (SDCycleScrollView *)cycleView {
    if (_cycleView == nil) {
        
        _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 0.4f) imageNamesGroup:nil];
        _cycleView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        _cycleView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _cycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleView.currentPageDotColor = [UIColor whiteColor];
    }
    return _cycleView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 66;
        _tableView.backgroundColor = UIColor_RGB(246, 246, 246);
        [_tableView registerClass:[MusicHeaderViewCell class] forCellReuseIdentifier:@"CELL_ID"];
    }
    return _tableView;
}

- (void)setSongs:(NSArray *)songs {
    
    _songs = songs;
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:songs.count];
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:songs.count];
    for (MusicModel *m in songs) {
        [titles addObject:m.title];
        [images addObject:m.imagePath];
    }
    _cycleView.localizationImageNamesGroup = images;
    _cycleView.titlesGroup = titles;
    _cycleView.titleLabelBackgroundColor = UIColor_RGBA(0, 0, 0, 150);
    _cycleView.titleLabelTextColor = [UIColor whiteColor];
    _cycleView.titleLabelTextFont = [UIFont systemFontOfSize:15];
    _cycleView.titleLabelHeight = 30;
    self.subSongs = [DataTool randomMusicCount:3];
    [self.tableView reloadData];
}

@end
