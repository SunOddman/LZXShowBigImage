//
//  LZXBigImageCache.h
//  ShowBigImage
//
//  Created by 海底捞lzx on 2017/9/12.
//  Copyright © 2017年 海底捞. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGSize const kLZXCacheSizeSmall;
extern CGSize const kLZXCacheSizeMiddle;
extern CGSize const kLZXCacheSizeBig;

extern NSString * const LZXDiskCacheFolderPath;

struct LZXRowAndColumn {
    NSInteger row;
    NSInteger column;
};

typedef NS_ENUM(NSInteger, LZXBigImageCacheType) {
    LZXBigImageCacheType_None   = 0,
    
    LZXBigImageCacheType_Memory = 1 << 0,
    LZXBigImageCacheType_Disk   = 1 << 1,
};

@interface LZXBigImageCache : NSObject

@property (nonatomic, strong) UIImage *originalImage;

@property (nonatomic, assign) CGSize cacheSize;

@property (nonatomic, assign) NSUInteger memoryCacheSize; // default is 500

/**
 缓存策略（默认只使用内存缓存）
 */
@property (nonatomic, assign) LZXBigImageCacheType cacheType;

/**
 读取指定位置缓存图片
 优先级：内存 > 硬盘 > 重新计算
 @param rect 位置
 */
- (UIImage *)imageInRect:(CGRect)rect;
- (void)flushCache;

@end
