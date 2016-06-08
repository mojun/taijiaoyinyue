//
//  MusicTableListCell.m
//  AntenatalTraining
//
//  Created by mo jun on 5/5/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "MusicTableListCell.h"

@implementation MusicTableListCell {
    NSMutableArray *_items;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont systemFontOfSize:14];
        _indexLabel.textColor = [UIColor grayColor];
        [self addSubview:_indexLabel];
        [_indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(20);
        }];
        
        UIView *btnContainer = [[UIView alloc] init];
        [self addSubview:btnContainer];
        [btnContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(2);
            make.bottom.equalTo(self).offset(-2);
            make.right.equalTo(self);
            make.width.mas_equalTo(40);
        }];
        
//        UIButton *collectBtn = [self createButtonImage:[self ci]];
//        [btnContainer addSubview:collectBtn];
//        
//        UIButton *playlistBtn = [self createButtonImage:[self pi]];
//        [btnContainer addSubview:playlistBtn];
//        
//        UIButton *downloadBtn = [self createButtonImage:[self di]];
//        [btnContainer addSubview:downloadBtn];
//        [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(btnContainer);
//            make.bottom.equalTo(btnContainer);
//            make.left.equalTo(btnContainer);
//            make.right.equalTo(playlistBtn.mas_left);
//        }];
//        
//        [playlistBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(btnContainer);
//            make.bottom.equalTo(btnContainer);
//            make.left.equalTo(collectBtn.mas_right);
//            make.width.equalTo(collectBtn.mas_width);
//        }];
//        
//        [downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(btnContainer);
//            make.bottom.equalTo(btnContainer);
//            make.left.equalTo(playlistBtn.mas_right);
//            make.right.equalTo(btnContainer.mas_right);
//            make.width.equalTo(playlistBtn.mas_width);
//        }];
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreBtn addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *moreImage = [UIImage imageNamed:@"btn_shared_more"];
        moreImage = [moreImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        moreBtn.tintColor = kThemeColor;
        [moreBtn setImage:moreImage forState:UIControlStateNormal];
        [btnContainer addSubview:moreBtn];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(btnContainer);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_indexLabel.mas_right).offset(5);
            make.right.equalTo(btnContainer.mas_left).offset(-5);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
    }
    return self;
}

+ (void)registerForTableView:(UITableView *)tableView{
    [tableView registerClass:[self class] forCellReuseIdentifier:[self registeredIdentifier]];
}

+ (NSString *)registeredIdentifier{
    return @"MusicTableListCell";
}

- (UIButton *)createButtonImage:(UIImage *)image {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}


- (UIImage *)ci {
    static dispatch_once_t onceToken;
    static UIImage *ci = nil;
    dispatch_once(&onceToken, ^{
        ci = [UIImage imageNamed:@"action_btn_collection"];
    });
    return ci;
}


- (UIImage *)pi {
    static dispatch_once_t onceToken;
    static UIImage *pi = nil;
    dispatch_once(&onceToken, ^{
        pi = [UIImage imageNamed:@"action_btn_playlist"];
    });
    return pi;
}


- (UIImage *)di {
    static dispatch_once_t onceToken;
    static UIImage *di = nil;
    dispatch_once(&onceToken, ^{
        di = [UIImage imageNamed:@"action_btn_download"];
    });
    return di;
}

- (void)moreButtonAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(musicTableListCell:didTouchedButtonAtIndexPath:)]) {
        [_delegate musicTableListCell:self didTouchedButtonAtIndexPath:self.indexPath];
    }
}

@end
