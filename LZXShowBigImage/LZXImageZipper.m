//
//  LZXImageZipper.m
//  LZXShowBigImageDemo
//
//  Created by 海底捞lzx on 2017/10/25.
//  Copyright © 2017年 海底捞. All rights reserved.
//

#import "LZXImageZipper.h"

@implementation LZXImageZipper

+ (UIImage *)zipImage:(UIImage *)originalImage withZipLevel:(CGFloat)zipLevel {
    NSAssert((zipLevel > 0 && zipLevel <= 1), @"非法的压缩等级！");
    
    // 压缩图片质量 压缩系数不宜太低，通常是0.3~0.7，过小则可能会出现黑边等
    UIImage *compressedImage = [UIImage imageWithData:UIImageJPEGRepresentation(originalImage, zipLevel)];
    
    // 压缩图片大小
    UIImage *imageReturn;
    CGSize originalSize = originalImage.size;
    CGSize returnSize = CGSizeMake(originalSize.width * zipLevel, originalSize.height * zipLevel);
    UIGraphicsBeginImageContext(returnSize);
    [compressedImage drawInRect:CGRectMake(0, 0, returnSize.width, returnSize.height)];
    imageReturn = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageReturn;
}


@end
