//
//  LZXBigImageView.m
//  ShowBigImage
//
//  Created by 海底捞lzx on 2017/9/12.
//  Copyright © 2017年 海底捞. All rights reserved.
//

#import "LZXBigImageView.h"
#import "LZXBigImageCache.h"

@interface LZXBigImageView ()


@end

@implementation LZXBigImageView

+ (Class)layerClass {
    return [CATiledLayer class];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIImage *subImage = [self.imgCache imageInRect:rect];
    [subImage drawInRect:rect];
}

#pragma mark -

+ (instancetype)bigImageViewWithImageNamed:(NSString *)imgName {
    return [[self alloc] initWithImageNamed:imgName];
}

+ (instancetype)bigImageViewWithImage:(UIImage *)img {
    return [[self alloc] initWithUIImage:img];
}

+ (instancetype)bigImageViewWithUIImage:(UIImage *)img cacheSize:(CGSize)cacheImageSize {
    return [[self alloc] initWithUIImage:img cacheSize:cacheImageSize];
}

- (instancetype)initWithImageNamed:(NSString *)imgName {
    UIImage *img = [UIImage imageNamed:imgName];
    return [self initWithUIImage:img];
}

- (instancetype)initWithUIImage:(UIImage *)img {
    return [self initWithUIImage:img cacheSize:kLZXCacheSizeSmall];
}

- (instancetype)initWithUIImage:(UIImage *)img cacheSize:(CGSize)cacheImageSize {
    if (self = [super initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)]) {
        // 初始化 Cache
        LZXBigImageCache *cache = [[LZXBigImageCache alloc] init];
        cache.originalImage = img;
        _imgCache = cache;
        self.cacheImageSize = cacheImageSize;
    }
    return self;
}

#pragma mark -

- (void)setCacheImageSize:(CGSize)cacheImageSize {
    _cacheImageSize = cacheImageSize;
    
    // 设置 Layer
    CATiledLayer *layer = (CATiledLayer *)self.layer;
    layer.tileSize = CGSizeMake(cacheImageSize.width * [UIScreen mainScreen].scale, cacheImageSize.height * [UIScreen mainScreen].scale); // 这里的 size 是 @1x 屏幕下的像素，在 @2x 屏幕下会缩小一半, 在 @3x 屏幕下会缩小 三分之一
    _imgCache.cacheSize = cacheImageSize; // 同步 Cache 图像大小
}

#pragma mark -

- (void)receiveMemoryWarning {
    NSLog(@"【Warning】收到内存警告！");
    [self.imgCache flushCache];
}

@end


#pragma mark - Zipper
#import "LZXImageZipper.h"

@implementation LZXBigImageView (Zipper)

+ (instancetype)zipImageView:(LZXBigImageView *)originalImageView forLevel:(CGFloat)zipLevel {
    UIImage *originalImage = originalImageView.imgCache.originalImage;
    UIImage *zipImage = [LZXImageZipper zipImage:originalImage withZipLevel:zipLevel];
    
    id imgViewReturn = [self bigImageViewWithUIImage:zipImage cacheSize:kLZXCacheSizeSmall];
    return imgViewReturn;
}

@end
