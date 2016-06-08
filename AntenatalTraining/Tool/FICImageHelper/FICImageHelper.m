//
//  FICImageHelper.m
//  PlayZer
//
//  Created by mojun on 15/11/7.
//  Copyright © 2015年 kimoworks. All rights reserved.
//

#import "FICImageHelper.h"
#import "ATImageEntity.h"

@interface FICImageHelper ()<FICImageCacheDelegate>

@end

@implementation FICImageHelper

+ (instancetype)sharedHelper{
    static dispatch_once_t onceToken;
    static FICImageHelper *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[FICImageHelper alloc]init];
    });
    
    return instance;
}

- (void)setup{
     NSMutableArray *mutableImageFormats = [NSMutableArray array];
    
    NSInteger squareImageFormatMaximumCount = 400;
    FICImageFormatDevices squareImageFormatDevices = FICImageFormatDevicePhone | FICImageFormatDevicePad;
    
    FICImageFormat *gridPhotoImageFormat = [FICImageFormat formatWithName:FICCategoryGridImageFormatName family:PZPhotoImageFormatFamily imageSize:FICCategoryGridImageSize style:FICImageFormatStyle32BitBGRA maximumCount:squareImageFormatMaximumCount devices:squareImageFormatDevices protectionMode:FICImageFormatProtectionModeNone];
    [mutableImageFormats addObject:gridPhotoImageFormat];
    NSLog(@"size: %@", NSStringFromCGSize(FICCategoryGridImageSize));
    FICImageCache *sharedImageCache = [FICImageCache sharedImageCache];
    [sharedImageCache setDelegate:self];
    [sharedImageCache setFormats:mutableImageFormats];
}

#pragma mark - FICImageCacheDelegate

- (void)imageCache:(FICImageCache *)imageCache wantsSourceImageForEntity:(id<FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageRequestCompletionBlock)completionBlock {
    // Images typically come from the Internet rather than from the app bundle directly, so this would be the place to fire off a network request to download the image.
    // For the purposes of this demo app, we'll just access images stored locally on disk.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSURL *imageURL = [entity sourceImageURLWithFormatName:formatName];
        UIImage *sourceImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        
        if (sourceImage == nil) {
            sourceImage = [UIImage imageNamed:@"icon_defaultcover"];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(sourceImage);
        });
    });
}

- (BOOL)imageCache:(FICImageCache *)imageCache shouldProcessAllFormatsInFamily:(NSString *)formatFamily forEntity:(id<FICEntity>)entity {
    return NO;
}

- (void)imageCache:(FICImageCache *)imageCache errorDidOccurWithMessage:(NSString *)errorMessage {
    NSLog(@"%@", errorMessage);
}

@end
