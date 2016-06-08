//
//  QICategoryCollectionCell.m
//  AntenatalTraining
//
//  Created by mo jun on 4/30/16.
//  Copyright © 2016 kimoworks. All rights reserved.
//

#import "QICategoryCollectionCell.h"
#import <FastImageCache/UIImage+ColorProperty.h>
#import "ATImageEntity.h"

@implementation QICategoryCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.coverView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kGridCellWidth, kGridCellImageHeight)];
        [self addSubview:self.coverView];
        self.coverView.contentMode = UIViewContentModeScaleToFill;
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.coverView.frameBottom, kGridCellWidth - 10 *2, kGridCellTextHeight)];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = kThemeLightBlack;
        [self addSubview:self.titleLabel];
        self.backgroundColor = kThemeLightColor;
        self.selectedBackgroundView = nil;
    }
    return self;
}

- (void)setCoverEntity:(ATImageEntity *)coverEntity{
    if (coverEntity != _coverEntity) {
        _coverEntity = coverEntity;
        __weak __typeof(&*self)weakSelf = self;
        __weak UIImageView *imageView = self.coverView;
        [[FICImageCache sharedImageCache] retrieveImageForEntity:coverEntity withFormatName:FICCategoryGridImageFormatName completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
            // This completion block may be called much later. We should check to make sure this cell hasn't been reused for different photos before displaying the image that has loaded.
            if (entity == weakSelf.coverEntity) {
                [imageView setImage:image];
                [imageView setNeedsLayout];
            }
        }];
    }
}

+ (void)registerForCollectionView:(UICollectionView *)collectionView{
    [collectionView registerClass:[self class] forCellWithReuseIdentifier:[self registeredIdentifier]];
    //    [collectionView registerNib:[UINib nibWithNibName:[self registeredIdentifier] bundle:nil] forCellWithReuseIdentifier:[self registeredIdentifier]];
}

+ (NSString *)registeredIdentifier{
    return NSStringFromClass([self class]);
}

- (void)highlightedShow{
    self.alpha = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.alpha = 1.0f;
    });
}

@end
