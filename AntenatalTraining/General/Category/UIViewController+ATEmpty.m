//
//  UIViewController+ATEmpty.m
//  AntenatalTraining
//
//  Created by test on 16/5/31.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "UIViewController+ATEmpty.h"
#import <objc/runtime.h>

@implementation UIViewController (ATEmpty)

@dynamic emptyView;
static char emptyViewKey;
- (void)setEmptyView:(ATEmptyView *)emptyView {
    objc_setAssociatedObject(self, &emptyViewKey, emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ATEmptyView *)emptyView {
    return objc_getAssociatedObject(self, &emptyViewKey);
}

- (void)hideBlank {
    if (self.emptyView) {
        [self.emptyView removeFromSuperview];
    }
    self.emptyView = nil;
}

- (void)showBlank {
    
    [self hideBlank];
    self.emptyView = [[ATEmptyView alloc] init];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)showDownloadedEmpty {
    
    [self showBlank];
    self.emptyView.messageLabel.text = @"无下载完成的音乐";
}

- (void)showDownloadingEmpty {
    
    [self showBlank];
    self.emptyView.messageLabel.text = @"无正在下载的音乐";
}

- (void)showPlaylistEmpty {
    
    [self showBlank];
    self.emptyView.messageLabel.text = @"播放列表为空";
    
}

@end
