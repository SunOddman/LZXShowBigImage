//
//  LZXBigImageCache.m
//  ShowBigImage
//
//  Created by 海底捞lzx on 2017/9/12.
//  Copyright © 2017年 海底捞. All rights reserved.
//

#import "LZXBigImageCache.h"

CGSize const kLZXCacheSizeSmall = {64, 64};
CGSize const kLZXCacheSizeMiddle = {128, 128};
CGSize const kLZXCacheSizeBig = {256, 256};

NSString * const LZXDiskCacheFolderPath = @"LZXBigImageCache/";

@interface LZXBigImageCache ()

@property (nonatomic, assign) CGImageRef originalCgImg;

@property (nonatomic, strong) NSCondition *lock;

@property (nonatomic, strong) NSMutableDictionary *memoryImgCache;

@end

@interface LZXBigImageCache (LZXCacheTool)

/**
 计算是当前是第几行第几列
 
 @param rect 目标 rect
 @return row * column
 */
- (struct LZXRowAndColumn)row_and_columnForRect:(CGRect)rect;

/**
 获取目标位置缓存名称
 
 @param rect 目标位置
 @return 缓存名称
 */
- (NSString *)cacheNameForRect:(CGRect)rect;

/**
 获取目标位置磁盘缓存路径
 
 @param rect 目标位置
 @return 缓存路径
 */
- (NSString *)diskPathForRect:(CGRect)rect;

/**
 如果达到标定上限，删除内存缓存
 */
- (void)flushMemoryCacheIfNeeded;

/**
 删除内存缓存
 不推荐手动调用，使用 - flushMemoryCacheIfNeeded 替代
 */
- (void)flushMemoryCache;

/**
 删除磁盘缓存
 */
- (void)flushDiskCache;

@end

@implementation LZXBigImageCache

- (instancetype)init {
    if (self = [super init]) {
        // 初始化默认缓存策略
        self.cacheType = LZXBigImageCacheType_Memory;
        self.memoryCacheSize = 500;
    }
    return self;
}

/**
 载入图片全部缓存
 */
- (void)loadAllImageCache {
    // TODO： 可以在这里异步加载所有缓存
}

/**
 读取指定位置缓存图片
   优先级：内存 > 硬盘 > 重新计算
 @param rect 位置
 */
- (UIImage *)imageInRect:(CGRect)rect {
    if (CGRectGetMaxX(rect) != self.originalImage.size.width && CGRectGetMaxY(rect) != self.originalImage.size.height) {
        // 非边界时检验大小
        NSAssert(CGSizeEqualToSize(rect.size, self.cacheSize), @"LZXBigImageView 的 Layer 的 tileSize 与 Cache 的 cacheSize 没有同步！使用 - setCacheImageSize: 进行同步！");
    }
    
    // 内存
    UIImage *imageReturn;
    if (self.cacheType & LZXBigImageCacheType_Memory) {
        imageReturn = [self memoryImageForRect:rect];
    }
    
    // 硬盘
    if (self.cacheType & LZXBigImageCacheType_Disk &&!imageReturn) {
        imageReturn = [self diskImageForRect:rect];
    }
    
    // 计算
    if (!imageReturn) {
        imageReturn = [self calculateImageForRect:rect];
    }
    
    return imageReturn;
}

- (UIImage *)memoryImageForRect:(CGRect)rect {
    NSString *cacheName = [self cacheNameForRect:rect];
    UIImage *imgReturn = [self.memoryImgCache objectForKey:cacheName];
    return imgReturn;
}

- (UIImage *)diskImageForRect:(CGRect)rect {
    NSString *cachePath = [self diskPathForRect:rect];
    UIImage *imageReturn = [UIImage imageWithContentsOfFile:cachePath];
    return imageReturn;
}

- (UIImage *)calculateImageForRect:(CGRect)rect {
    UIImage *imageReturn;
    
    // 计算
    CGImageRef cgImg = CGImageCreateWithImageInRect(self.originalCgImg, rect);
    imageReturn = [UIImage imageWithCGImage:cgImg];
    CGImageRelease(cgImg);
    
    // 内存缓存
    if (self.cacheType & LZXBigImageCacheType_Memory) {
        [self flushMemoryCacheIfNeeded];
        NSString *cacheName = [self cacheNameForRect:rect];
        [self.lock lock];
        self.memoryImgCache[cacheName] = imageReturn;
        [self.lock unlock];
    }
    
    // 磁盘缓存
    if (self.cacheType & LZXBigImageCacheType_Disk) {
        NSString *cachePath = [self diskPathForRect:rect];
        NSData *imgData = UIImagePNGRepresentation(imageReturn);
        [imgData writeToFile:cachePath atomically:NO];
    }
    
    return imageReturn;
}

/**
 清空缓存
 */
- (void)flushCache {
    [self flushMemoryCache];
    [self flushDiskCache];
}

#pragma mark - setter
- (void)setOriginalImage:(UIImage *)originalImage {
    _originalImage = originalImage;
    
    // 图片载入缓存
    [self loadAllImageCache];
}

- (void)setCacheSize:(CGSize)cacheSize {
    _cacheSize = cacheSize;
    
    [self flushCache];
}

#pragma mark - getter
- (NSCondition *)lock {
    if (!_lock) {
        _lock = [[NSCondition alloc] init];
    }
    return _lock;
}

- (NSMutableDictionary *)memoryImgCache {
    if (!_memoryImgCache) {
        NSInteger capacityX = (NSInteger)ceil(self.originalImage.size.width / self.cacheSize.width);
        NSInteger capacityY = (NSInteger)ceil(self.originalImage.size.height / self.cacheSize.height);
        _memoryImgCache = [[NSMutableDictionary alloc] initWithCapacity:capacityX * capacityY];
    }
    return _memoryImgCache;
}

- (CGImageRef)originalCgImg {
    return self.originalImage.CGImage;
}


@end

#pragma mark - Tool Function
@implementation LZXBigImageCache (LZXCacheTool)

- (struct LZXRowAndColumn)row_and_columnForRect:(CGRect)rect {
    NSInteger row = (NSInteger)floor(rect.origin.x / self.cacheSize.width);
    NSInteger column = (NSInteger)floor(rect.origin.y / self.cacheSize.height);
    struct LZXRowAndColumn rowAndColumn = {row, column};
    return rowAndColumn;
}

- (NSString *)cacheNameForRect:(CGRect)rect {
    struct LZXRowAndColumn row_column = [self row_and_columnForRect:rect];
    NSString *cacheName = [NSString stringWithFormat:@"%zd_%zd", row_column.row, row_column.column];
    return cacheName;
}

- (NSString *)diskPathForRect:(CGRect)rect {
    NSString *cacheName = [self cacheNameForRect:rect];
    return [NSString stringWithFormat:@"%@%@.png", LZXDiskCacheFolderPath, cacheName];
}

- (void)flushMemoryCacheIfNeeded {
    [self.lock lock];
    if (self.memoryImgCache.count == self.memoryCacheSize) {
        NSLog(@"\n--------【自动删除内存缓存】----------");
        [self flushMemoryCache];
    }
    [self.lock unlock];
}

- (void)flushMemoryCache {
    [self.memoryImgCache removeAllObjects];
}

- (void)flushDiskCache {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:LZXDiskCacheFolderPath error:nil];
}



@end
