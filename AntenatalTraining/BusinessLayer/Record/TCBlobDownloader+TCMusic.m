//
//  TCBlobDownloader+TCMusic.m
//  AntenatalTraining
//
//  Created by test on 16/5/26.
//  Copyright © 2016年 kimoworks. All rights reserved.
//

#import "TCBlobDownloader+TCMusic.h"
#import <objc/runtime.h>

@implementation TCBlobDownloader (TCMusic)

@dynamic mark;

static char markKey;

- (void)setMark:(id)mark {
    objc_setAssociatedObject(self, &markKey, mark, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)mark {
    return objc_getAssociatedObject(self, &markKey);
}

@end
