//
//  UIImageView+LBBlurredImage.m
//  LBBlurredImage
//
//  Created by Luca Bernardi on 11/11/12.
//  Copyright (c) 2012 Luca Bernardi. All rights reserved.
//

#import "UIImageView+LBBlurredImage.h"
//#import <CoreImage/CoreImage.h>
#import "UIImage+ImageEffects.h"

#define WIDTH 200
#define HEIGHT 300
//NSString *const kLBBlurredImageErrorDomain          = @"com.lucabernardi.blurred_image_additions";
//CGFloat const   kLBBlurredImageDefaultBlurRadius    = 20.0;
CGFloat const kLBBlurredImageDefaultBlurRadius            = 20.0;
CGFloat const kLBBlurredImageDefaultSaturationDeltaFactor = 1.8;

@implementation UIImageView (LBBlurredImage)

#pragma mark - LBBlurredImage Additions

- (void)setImageToBlur:(UIImage *)image
            blurRadius:(CGFloat)blurRadius
       completionBlock:(LBBlurredImageCompletionBlock) completion
{
    NSParameterAssert(image);
    NSParameterAssert(blurRadius >= 0);
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        UIImage *blurredImage = [image applyBlurWithRadius:blurRadius
                                                 tintColor:nil
                                     saturationDeltaFactor:kLBBlurredImageDefaultSaturationDeltaFactor
                                                 maskImage:nil];
        
//        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = blurredImage;
            if (completion) {
                completion(nil);
            }
//        });
//    });
}

- (void)setImageViewToBlurWithImage:(UIImage *)image andBlurRadius: (CGFloat)blurRadius{
    NSParameterAssert(image);
    NSParameterAssert(blurRadius >= 0);
    __block __typeof(self) weakSelf = self;
    
    dispatch_queue_t queue = dispatch_queue_create("cn.lugede.bular", NULL);
    dispatch_async(queue, ^{
        UIImage *blurredImage = [image applyBlurWithRadiusNew:blurRadius
                                                    tintColor:nil
                                        saturationDeltaFactor:kLBBlurredImageDefaultSaturationDeltaFactor maskImage:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
             weakSelf.layer.contents = (id)blurredImage.CGImage;
        });
    });
}

- (void)setImageViewToBlurWithImage:(UIImage *)image andBlurRadius:(CGFloat)blurRadius completionBlock:(LBBlurredImageCompletionBlock)completion{
    NSParameterAssert(image);
    NSParameterAssert(blurRadius >= 0);
    __block __typeof(self) weakSelf = self;
    
    dispatch_queue_t queue = dispatch_queue_create("cn.lugede.bular", NULL);
    dispatch_async(queue, ^{
        UIImage *blurredImage = [image applyBlurWithRadiusNew:blurRadius
                                                    tintColor:nil
                                        saturationDeltaFactor:kLBBlurredImageDefaultSaturationDeltaFactor maskImage:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.layer.contents = (id)blurredImage.CGImage;
            self.image = blurredImage;
            if (completion) {
                completion(nil);
            }
        });
    });
}

+ (UIImage *)getImageLayoutWithImage:(UIImage *)image andSize:(CGSize)size{
    
//    CGFloat _imageHeight = size.width*2/3.0;
    if (image.size.width > image.size.height* 1.5) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width*size.height/image.size.height, image.size.height), YES, 0);
        UIImage *viewImage = image;
        CGImageRef imageRef = viewImage.CGImage;
        CGRect rect = CGRectMake(image.size.width/2-(image.size.height*1.5)/2, 0, image.size.height*1.5, image.size.height);
        CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
        UIGraphicsEndImageContext();
        UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
        CGImageRelease(imageRefRect);
        
        return sendImage;
        
    }else{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(image.size.width, image.size.height), YES, 0);
        UIImage *viewImage = image;
        CGImageRef imageRef = viewImage.CGImage;
        CGRect rect = CGRectMake(0, 0, image.size.width, image.size.width*2/3);
        CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
        UIGraphicsEndImageContext();
        UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
        CGImageRelease(imageRefRect);
        return sendImage;
        
    }
}

//- (void)setImageToBlur: (UIImage *)image
//            blurRadius: (CGFloat)blurRadius
//       completionBlock: (LBBlurredImageCompletionBlock) completion
//
//{
//    CIContext *context   = [CIContext contextWithOptions:nil];
//    CIImage *sourceImage = [CIImage imageWithCGImage:image.CGImage];
//    
//    // Apply clamp filter:
//    // this is needed because the CIGaussianBlur when applied makes
//    // a trasparent border around the image
//    
//    NSString *clampFilterName = @"CIAffineClamp";
//    CIFilter *clamp = [CIFilter filterWithName:clampFilterName];
//    
//    if (!clamp) {
//        
//        NSError *error = [self errorForNotExistingFilterWithName:clampFilterName];
//        if (completion) {
//            completion(error);
//        }
//        return;
//    }
//    
//    [clamp setValue:sourceImage
//             forKey:kCIInputImageKey];
//    
//    CIImage *clampResult = [clamp valueForKey:kCIOutputImageKey];
//    
//    // Apply Gaussian Blur filter
//    
//    NSString *gaussianBlurFilterName = @"CIGaussianBlur";
//    CIFilter *gaussianBlur = [CIFilter filterWithName:gaussianBlurFilterName];
//    
//    if (!gaussianBlur) {
//        
//        NSError *error = [self errorForNotExistingFilterWithName:gaussianBlurFilterName];
//        if (completion) {
//            completion(error);
//        }
//        return;
//    }
//    
//    [gaussianBlur setValue:clampResult
//                    forKey:kCIInputImageKey];
//    [gaussianBlur setValue:[NSNumber numberWithFloat:blurRadius]
//                    forKey:@"inputRadius"];
//    
//    CIImage *gaussianBlurResult = [gaussianBlur valueForKey:kCIOutputImageKey];
//    
//    __weak UIImageView *selfWeak = self;
//    
////    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        CGImageRef cgImage = [context createCGImage:gaussianBlurResult
//                                           fromRect:[sourceImage extent]];
//        
//        UIImage *blurredImage = [UIImage imageWithCGImage:cgImage];
//
//        CGImageRelease(cgImage);
//        
////        dispatch_async(dispatch_get_main_queue(), ^{
//            selfWeak.image = blurredImage;
//            if (completion){
//                completion(nil);
//            }
////        });
////    });
//}
//
///**
// Internal method for generate an NSError if the provided CIFilter name doesn't exists
// */
//- (NSError *)errorForNotExistingFilterWithName:(NSString *)filterName
//{
//    NSString *errorDescription = [NSString stringWithFormat:@"The CIFilter named %@ doesn't exist",filterName];
//    NSError *error             = [NSError errorWithDomain:kLBBlurredImageErrorDomain
//                                                     code:LBBlurredImageErrorFilterNotAvailable
//                                                 userInfo:@{NSLocalizedDescriptionKey : errorDescription}];
//    return error;
//}

@end
