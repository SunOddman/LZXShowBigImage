//
//  LZXImageZipper.h
//  LZXShowBigImageDemo
//
//  Created by 海底捞lzx on 2017/10/25.
//  Copyright © 2017年 海底捞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZXImageZipper : NSObject

/**
 按照指定比例压缩图片

 @param originalImage 原图片
 @param zipLevel 压缩比例
 @return 压缩后图片
 */
+ (UIImage *)zipImage:(UIImage *)originalImage withZipLevel:(CGFloat)zipLevel;

@end
