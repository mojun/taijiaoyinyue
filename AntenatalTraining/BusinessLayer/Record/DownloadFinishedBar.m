//
//  DownloadFinishedBar.m
//  AntenatalTraining
//
//  Created by test on 16/5/28.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "DownloadFinishedBar.h"

@implementation DownloadFinishedBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIVisualEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        [self addSubview:effectView];
        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:kBarAlpha];
        
        TouchButton *playBtn = [TouchButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:playBtn];
        [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(84);
            make.left.equalTo(self).offset(15);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
        playBtn.tintColor = kThemeColor;
        [playBtn setTitleColor:kThemeLightBlack forState:UIControlStateNormal];
        [playBtn setImage:[[UIImage imageNamed:@"shuffle_play"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [playBtn setTitle:@"随机播放" forState:UIControlStateNormal];
        playBtn.tag = 0;
        self.playBtn = playBtn;
        
        TouchButton *editBtn = [TouchButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:editBtn];
        [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.right.equalTo(self).offset(-15);
            make.width.mas_equalTo(50);
        }];
        [editBtn setTitleColor:kThemeLightBlack forState:UIControlStateNormal];
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        editBtn.tag = 1;
        self.editBtn = editBtn;
        
        TouchButton *cancelBtn = [TouchButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.left.equalTo(self).offset(15);
            make.width.mas_equalTo(50);
        }];
        [cancelBtn setTitleColor:kThemeLightBlack forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.tag = 3;
        self.cancelBtn = cancelBtn;
        
        self.playBtn.hidden = NO;
        self.editBtn.hidden = NO;
        self.cancelBtn.hidden = YES;
        self.playBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.editBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.playBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.editBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)buttonAction:(TouchButton *)sender {
    
    NSInteger tag = sender.tag;
    switch (tag) {
        case 0:{
            
            break;
        }
        case 1:{
            sender.tag = 2;
            [sender setTitle:@"完成" forState:UIControlStateNormal];
            
            self.playBtn.hidden = YES;
            self.editBtn.hidden = NO;
            self.cancelBtn.hidden = NO;
            break;
        }
        case 2:{
            sender.tag = 1;
            [sender setTitle:@"编辑" forState:UIControlStateNormal];
            
            self.playBtn.hidden = NO;
            self.editBtn.hidden = NO;
            self.cancelBtn.hidden = YES;
            break;
        }
        case 3:{
            self.editBtn.tag = 1;
            [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
            self.playBtn.hidden = NO;
            self.editBtn.hidden = NO;
            self.cancelBtn.hidden = YES;
            break;
        }
        default:
            break;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(downloadFinishedBar:didTouchedAtIndex:)]) {
        [_delegate downloadFinishedBar:self didTouchedAtIndex:tag];
    }
}



@end
