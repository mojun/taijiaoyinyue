//
//  UIImage+CGImage.h
//  EIPhotoSDK
//
//  Created by ChenQi on 14-2-11.
//  Copyright (c) 2014年 Everimaging. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef struct EIImageInfo
{
    size_t width;
    size_t height;
    size_t channel;
    size_t bitsPerComponent;
    size_t bytesPerRow;
} EIImageInfo;


@interface UIImage (CGImage)


+ (CGBitmapInfo)defaultBitMapOrder;
+ (CGBitmapInfo)systemDefaultBitMapOrder;

+ (BOOL)isDefaultBitMapOrder:(CGBitmapInfo)info;
+ (BOOL)isSystemDefaultBitMapOrder:(CGBitmapInfo)info;

+ (CGImageRef)initCGImageWithContentOfFile:(NSString *)path CF_RETURNS_RETAINED;
+ (CGImageRef)createARGBImageRefFromImageBuffer:(CVImageBufferRef)imageBuffer CF_RETURNS_RETAINED;

+ (NSData *)dataFromCGImage:(CGImageRef)cgImage info:(EIImageInfo *)info redraw:(BOOL)forceRedraw;

/**
 @brief	生成纯色矩形图
 
 @param color [IN] <#color description#>
 @param size [IN] 单位：点
 
 @return <#return value description#>
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;


//
// CGImage help method
//

/**
 @brief	bitmap context
 
 @param size [IN] 单位：像素
 
 @return
 */
+ (CGContextRef)createImageContext:(CGSize)size CF_RETURNS_RETAINED;

/**
 @brief	bitmap context, redraw img to up orientation
 
 @param img [IN] <#img description#>
 
 @return <#return value description#>
 */
+ (CGContextRef)createImageContextWithImage:(UIImage *)img CF_RETURNS_RETAINED;

+ (UIImage *)maskImage:(UIImage *)src alphaMask:(CGLayerRef)mask blend:(CGBlendMode)blend;

+ (void)drawRadialGradientRound:(CGFloat)radius colors:(const CGFloat[])colors count:(size_t)count atPoint:(CGPoint)pt inContext:(CGContextRef)context;

+ (void)drawLinearGradientStart:(CGPoint)start end:(CGPoint)end colors:(const CGFloat[])colors count:(size_t)count inContext:(CGContextRef)context;


- (CGSize)pixelSize;
- (CGFloat)pixelMeasure;

/**
 @brief	blend image to color
 
 @param color [IN] target color
 
 @return colored image with fixed to UIImageOrientationUp, and raw image scale
 */
- (UIImage *)blendWithColor:(UIColor *)color;


@end
