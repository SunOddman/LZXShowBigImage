//
//  LZXBigImageView.h
//  ShowBigImage
//
//  Created by 海底捞lzx on 2017/9/12.
//  Copyright © 2017年 海底捞. All rights reserved.
//


#import <UIKit/UIKit.h>
@class LZXBigImageCache;

@interface LZXBigImageView : UIView

+ (instancetype)bigImageViewWithImageNamed:(NSString *)imgName;
+ (instancetype)bigImageViewWithImage:(UIImage *)img;

- (instancetype)initWithImageNamed:(NSString *)imgName;
- (instancetype)initWithUIImage:(UIImage *)img;
- (instancetype)initWithUIImage:(UIImage *)img cacheSize:(CGSize)cacheImageSize;

/**
 缓存单元的大小
  单位：点
 */
@property (nonatomic, assign) CGSize cacheImageSize;
@property (nonatomic, strong, readonly) LZXBigImageCache *imgCache;

/**
 收到内存警告时调用
 */
- (void)receiveMemoryWarning;

@end


#pragma mark - Zipper
@interface LZXBigImageView (Zipper)


+ (instancetype)zipImageView:(LZXBigImageView *)originalImageView forLevel:(CGFloat)zipLevel;


@end
