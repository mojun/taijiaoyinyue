//
//  MusicDetailHeaderView.m
//  AntenatalTraining
//
//  Created by mo jun on 5/5/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "MusicDetailHeaderView.h"
#import "ATImageEntity.h"

@implementation MusicDetailHeaderView

- (instancetype)init {
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor clearColor];
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(15).priorityHigh();
            make.width.mas_equalTo(kGridCellWidth);
            make.height.mas_equalTo(kGridCellImageHeight);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 1;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageView.mas_right).offset(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(16);
        }];
        
//        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
//        [_titleLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        
        _playAll = [UIButton buttonWithType:UIButtonTypeCustom];
        _playAll.titleLabel.font = [UIFont systemFontOfSize:15];
        [_playAll setTitle:@" 播放全部" forState:UIControlStateNormal];
        
        UIImage *playImage = [UIImage imageNamed:@"btn_play"];
        playImage = [playImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _playAll.tintColor = kThemeLightBlack;
        [_playAll setImage:playImage forState:UIControlStateNormal];
        [_playAll setTitleColor:kThemeLightBlack forState:UIControlStateNormal];
        [self addSubview:_playAll];
        [_playAll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(84, 38));
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(self).offset(-15);
        }];
        
        _downloadAll = [UIButton buttonWithType:UIButtonTypeCustom];
        _downloadAll.titleLabel.font = [UIFont systemFontOfSize:15];
        [_downloadAll setTitle:@" 下载全部" forState:UIControlStateNormal];
        
        UIImage *downloadImage = [UIImage imageNamed:@"btn_download"];
        downloadImage = [downloadImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _downloadAll.tintColor = kThemeLightBlack;
        [_downloadAll setImage:downloadImage forState:UIControlStateNormal];
        [_downloadAll setTitleColor:kThemeLightBlack forState:UIControlStateNormal];
        [self addSubview:_downloadAll];
        [_downloadAll mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(84, 38));
            make.bottom.equalTo(self.mas_bottom);
            make.right.equalTo(_playAll.mas_left).offset(-10);
        }];
    }
    return self;
}

- (void)setCoverEntity:(ATImageEntity *)coverEntity{
    if (coverEntity != _coverEntity) {
        _coverEntity = coverEntity;
        __weak __typeof(&*self)weakSelf = self;
        __weak UIImageView *imageView = self.imageView;
        [[FICImageCache sharedImageCache] retrieveImageForEntity:coverEntity withFormatName:FICCategoryGridImageFormatName completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
            // This completion block may be called much later. We should check to make sure this cell hasn't been reused for different photos before displaying the image that has loaded.
            if (entity == weakSelf.coverEntity) {
                [imageView setImage:image];
                [imageView setNeedsLayout];
            }
        }];
    }
}

@end
