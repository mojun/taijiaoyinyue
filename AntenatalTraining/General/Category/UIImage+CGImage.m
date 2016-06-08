//
//  UIImage+CGImage.m
//  EIPhotoSDK
//
//  Created by ChenQi on 14-2-11.
//  Copyright (c) 2014年 Everimaging. All rights reserved.
//

#import "UIImage+CGImage.h"
#import <CoreImage/CoreImage.h>

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0)
@import ImageIO;
#else
#import <ImageIO/ImageIO.h>
#endif

#if ! __has_feature(objc_arc)
#error this file is ARC only. Either turn on ARC for the project or use -fobjc-arc flag
#endif


static CGBitmapInfo const kEIDefaultBitMapOrder = kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst;
// kCGBitmapByteOrderDefault means kCGBitmapByteOrder32Big
static CGBitmapInfo const kEISystemDefaultOrder = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast; //

@implementation UIImage (CGImage)

+ (CGBitmapInfo)defaultBitMapOrder
{
    return kEIDefaultBitMapOrder;
}

+ (CGBitmapInfo)systemDefaultBitMapOrder
{
    return kEISystemDefaultOrder;
}

+ (BOOL)isDefaultBitMapOrder:(CGBitmapInfo)info
{
    return ((info & kCGBitmapAlphaInfoMask) | (info & kCGBitmapByteOrderMask)) == kEIDefaultBitMapOrder;
}

+ (BOOL)isSystemDefaultBitMapOrder:(CGBitmapInfo)info
{
    return ((info & kCGBitmapAlphaInfoMask) | (info & kCGBitmapByteOrderMask)) == kEISystemDefaultOrder;
}

+ (CGImageRef)initCGImageWithContentOfFile:(NSString *)path
{
    NSURL *url = [NSURL fileURLWithPath:path];
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
    if (NULL == imageSourceRef) {
        return NULL;
    }
    
    CGImageRef cgImage = CGImageSourceCreateImageAtIndex(imageSourceRef, 0, NULL);
    CFRelease(imageSourceRef);
    return cgImage;
}

+ (NSData *)dataFromCGImage:(CGImageRef)cgImage info:(EIImageInfo *)info redraw:(BOOL)forceRedraw
{
    size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(cgImage);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(cgImage);
    size_t channel = bitsPerPixel / bitsPerComponent;
    size_t realWidth = bytesPerRow / channel;
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    
    if (NULL != info) {
        info->width = realWidth;
        info->height = height;
        info->bitsPerComponent = bitsPerComponent;
        info->channel = channel;
        info->bytesPerRow = bytesPerRow;
    }
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(cgImage);
    BOOL shouldRedrawGraphic = (bitmapInfo & kEIDefaultBitMapOrder) != kEIDefaultBitMapOrder
    || realWidth != width
    || channel != 4
    || bitsPerComponent != 8;
    
    if (forceRedraw || shouldRedrawGraphic) {
#ifdef EI_LOG_TIME
        clock_t t = clock();
#endif
        channel = 4;
        bitsPerComponent = 8;
        bytesPerRow = width * channel;
        if (NULL != info) {
            info->width = width;
            info->bytesPerRow = bytesPerRow;
        }
        size_t len = bytesPerRow * height;
        
        NSMutableData *data = [NSMutableData dataWithLength:len];
        void *buffer = data.mutableBytes;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef ctx = CGBitmapContextCreate(buffer,
                                                 width, height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kEIDefaultBitMapOrder);
        CGColorSpaceRelease(colorSpace);
        CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
        CGContextDrawImage(ctx, CGRectMake(0.0, 0.0, width, height), cgImage);
        CGContextRelease(ctx);
#ifdef EI_LOG_TIME
        RLog(@"shouldRedrawGraphic用时 %g \n", (clock() -t) / 1000.0f);
#endif
        
        return data;
    }
    else {
        return (__bridge_transfer NSData *)CGDataProviderCopyData(CGImageGetDataProvider(cgImage));
    }
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize pixelSize = CGSizeMake(size.width * scale, size.height * scale);
    CGContextRef context = [self createImageContext:pixelSize];
    
    CGPatternRef pattern = CGColorGetPattern(color.CGColor);
    if (pattern) {
        CGContextSetFillColorSpace(context, CGColorGetColorSpace(color.CGColor));
        static CGFloat const alpha = 1.0f;
        CGContextSetFillPattern(context, pattern, &alpha);
        CGContextSetPatternPhase(context, CGSizeMake(0, pixelSize.height));
    }
    else {

        CGContextSetFillColorWithColor(context, color.CGColor);
    }
   
    CGContextFillRect(context, CGRectMake(0, 0, pixelSize.width, pixelSize.height));
    
    CGImageRef imgRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    UIImage *resImg = [UIImage imageWithCGImage:imgRef scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(imgRef);
    
    return resImg;
}



+ (CGContextRef)createImageContext:(CGSize)size
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, (size_t)size.width, (size_t)size.height, 8, ((size_t)size.width) * 4, colorSpace, kEIDefaultBitMapOrder);
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

+ (CGContextRef)createImageContextWithImage:(UIImage *)img CF_RETURNS_RETAINED
{
    CGSize pixelSize = img.pixelSize;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    UIImageOrientation orientation = img.imageOrientation;
    
    switch (orientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, pixelSize.width, pixelSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, pixelSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, pixelSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (orientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, pixelSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, pixelSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = [self createImageContext:pixelSize];
    CGContextConcatCTM(ctx, transform);
    
    CGFloat width = CGImageGetWidth(img.CGImage);
    CGFloat height = CGImageGetHeight(img.CGImage);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
    CGContextDrawImage(ctx, CGRectMake(0, 0, width, height), img.CGImage);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationDefault);
    return ctx;
}

- (UIImage *)blendWithColor:(UIColor *)color
{
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(self.CGImage);
    if (alphaInfo == kCGImageAlphaNone
        || alphaInfo == kCGImageAlphaNoneSkipLast
        || alphaInfo == kCGImageAlphaNoneSkipFirst) {
        return self;
    }
    
    size_t width = CGImageGetWidth(self.CGImage);
    size_t height = CGImageGetHeight(self.CGImage);
    CGRect imageRect = CGRectMake(0, 0, width, height);
    
    CGContextRef context = [[self class] createImageContextWithImage:self];
    CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, imageRect);
    CGImageRef coloredImageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    UIImage *coloredImage = [UIImage imageWithCGImage:coloredImageRef scale:self.scale orientation:UIImageOrientationUp];
    CGImageRelease(coloredImageRef);
    return coloredImage;
}

+ (UIImage *)maskImage:(UIImage *)src alphaMask:(CGLayerRef)mask blend:(CGBlendMode)blend
{
    CGSize size = src.size;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextRef ctx = [self createImageContext:size];
    CGContextDrawLayerInRect(ctx, rect, mask);
    CGContextSetBlendMode(ctx, blend);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
    CGContextDrawImage(ctx, rect, src.CGImage);
    CGImageRef resImgRef = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    UIImage *resImg = [UIImage imageWithCGImage:resImgRef];
    CGImageRelease(resImgRef);
    
    return resImg;
}


+ (void)drawRadialGradientRound:(CGFloat)radius colors:(const CGFloat[])colors count:(size_t)count atPoint:(CGPoint)pt inContext:(CGContextRef)context
{
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, count);
    CGColorSpaceRelease(rgb);
    
    CGPoint start = pt;
    CGPoint end = pt;
    CGFloat startRadius = 0.0f;
    CGFloat endRadius = radius;
    
    CGContextDrawRadialGradient(context, gradient, start, startRadius, end, endRadius, kCGGradientDrawsBeforeStartLocation/* | kCGGradientDrawsAfterEndLocation*/);
    CGGradientRelease(gradient);
}


+ (void)drawLinearGradientStart:(CGPoint)start end:(CGPoint)end colors:(const CGFloat[])colors count:(size_t)count inContext:(CGContextRef)context
{
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, count);
    CGColorSpaceRelease(rgb);
    
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    CGGradientRelease(gradient);
}

- (CGSize)pixelSize
{
    CGSize size = self.size;
    size.width *= self.scale;
    size.height *= self.scale;
    return size;
}

- (CGFloat)pixelMeasure
{
    CGSize pixel = self.pixelSize;
    return pixel.width * pixel.height;
}

+ (CGImageRef)createARGBImageRefFromImageBuffer:(CVImageBufferRef)imageBuffer CF_RETURNS_RETAINED
{
    if (NULL == imageBuffer) {
        return NULL;
    }
    
    CVPixelBufferLockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);
    uint8_t *lumaBuffer = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(lumaBuffer,
                                                 CVPixelBufferGetWidth(imageBuffer),
                                                 CVPixelBufferGetHeight(imageBuffer),
                                                 8,
                                                 CVPixelBufferGetBytesPerRow(imageBuffer),
                                                 rgbColorSpace,
                                                 kEIDefaultBitMapOrder);
    CVPixelBufferUnlockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);
    CGColorSpaceRelease(rgbColorSpace);
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);

    return imageRef;
}


@end
