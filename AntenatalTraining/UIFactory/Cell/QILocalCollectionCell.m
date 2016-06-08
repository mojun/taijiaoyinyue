//
//  QILocalCollectionCell.m
//  PlayZer
//
//  Created by mo jun on 10/28/15.
//  Copyright © 2015 kimoworks. All rights reserved.
//

#import "QILocalCollectionCell.h"
#import "ATImageEntity.h"
#import "UIImage+ColorProperty.h"

@implementation QILocalCollectionCell

//- (instancetype)init{
//    if (self = [super init]) {
//        
//    }
//    return self;
//}
//
//- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    if (self = [super initWithCoder:aDecoder]) {
//        
//    }
//    return self;
//}

- (void)setCoverEntity:(ATImageEntity *)coverEntity{
    if (coverEntity != _coverEntity) {
        _coverEntity = coverEntity;
        __weak __typeof(&*self)weakSelf = self;
        UIImageView *imageView = self.coverView;
        [[FICImageCache sharedImageCache] retrieveImageForEntity:coverEntity withFormatName:FICCategoryGridImageFormatName completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image) {
            // This completion block may be called much later. We should check to make sure this cell hasn't been reused for different photos before displaying the image that has loaded.
            if (entity == weakSelf.coverEntity) {
                [imageView setImage:image];
                [imageView setNeedsLayout];
            }
        }];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.coverView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kGridCellWidth, kGridCellWidth)];
        [self addSubview:self.coverView];
        [self.coverView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.coverView.frameBottom + 5, kGridCellWidth - 10 *2, 15)];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.titleLabel];
        
        self.durationLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.titleLabel.frameBottom + 5, kGridCellWidth - 10 *2, 13)];
        self.durationLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.durationLabel];
        
        self.trackNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.durationLabel.frameBottom + 5, kGridCellWidth - 10 *2, 13)];
        self.trackNumberLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.trackNumberLabel];
        self.selectedBackgroundView = nil;
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.selectedBackgroundView = nil;
    
}

//- (instancetype)initWithFrame:(CGRect)frame

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    UIImage *image = [change objectForKey:NSKeyValueChangeNewKey];
    if ([image isKindOfClass:[NSNull class]]) {
        return;
    }
    UIColor *bgcolor = image.averageColor;
    if (image.isDarkColor) {
        self.backgroundColor = bgcolor;
        self.titleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.7f];
        self.durationLabel.textColor = [UIColor colorWithWhite:1 alpha:0.7f];
        self.trackNumberLabel.textColor = [UIColor colorWithWhite:1 alpha:0.7f];
    } else {
        self.backgroundColor = bgcolor;
        self.titleLabel.textColor = [UIColor colorWithWhite:0 alpha:0.7f];
        self.durationLabel.textColor = [UIColor colorWithWhite:0 alpha:0.7f];
        self.trackNumberLabel.textColor = [UIColor colorWithWhite:0 alpha:0.7f];

    }
//    __weak QILocalCollectionCell *wself = self;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        UIColor *bgcolor = [image mostColor];
//        if ([wself isDarkColor:bgcolor]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                wself.backgroundColor = bgcolor;
//                wself.titleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.7f];
//                wself.durationLabel.textColor = [UIColor colorWithWhite:1 alpha:0.7f];
//                wself.trackNumberLabel.textColor = [UIColor colorWithWhite:1 alpha:0.7f];
//            });
//        }else{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                wself.backgroundColor = bgcolor;
//                wself.titleLabel.textColor = [UIColor colorWithWhite:0 alpha:0.7f];
//                wself.durationLabel.textColor = [UIColor colorWithWhite:0 alpha:0.7f];
//                wself.trackNumberLabel.textColor = [UIColor colorWithWhite:0 alpha:0.7f];
//            });
//        }
//    });
}

-(BOOL)isDarkColor:(UIColor *)newColor{
    
    if (newColor) {
        const CGFloat *componentColors = CGColorGetComponents(newColor.CGColor);
        CGFloat colorBrightness = ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114)) / 1000;
        if (colorBrightness < 0.5){
            return YES;
        }
        else{
            return NO;
        }
    }else{
        return NO;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
