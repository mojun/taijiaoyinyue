//
//  PZGridPhoto.h
//  PlayZer
//
//  Created by mojun on 15/11/7.
//  Copyright © 2015年 kimoworks. All rights reserved.
//

#import <Foundation/Foundation.h>

/// PZImage Family
#define PZPhotoImageFormatFamily @"PZPhotoImageFormatFamily"

///这是category grid图片
#define FICCategoryGridImageFormatName @"com.kimoworks.AntenatalTraining.FICCategoryGridImageFormatName"
#define FICCategoryGridImageSize (CGSize){kGridCellWidth * [UIScreen mainScreen].scale, kGridCellImageHeight * [UIScreen mainScreen].scale}

@interface ATImageEntity : NSObject<FICEntity>

@property (nonatomic, copy) NSURL *sourceImageURL;
- (instancetype)initWithSourceImageURL:(NSURL *)sourceImageURL;
+ (instancetype)entityWithURL:(NSURL *)sourceImageURL;

@end
