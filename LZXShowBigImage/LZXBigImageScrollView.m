//
//  LZXBigImageScrollView.m
//  LZXShowBigImageDemo
//
//  Created by 海底捞lzx on 2017/10/20.
//  Copyright © 2017年 海底捞. All rights reserved.
//

#import "LZXBigImageScrollView.h"
#import <objc/runtime.h>

const CGFloat LZXBigImageScrollViewDefaultZipSize = 0.6;

@interface LZXBigImageScrollView () <UIScrollViewDelegate>
{
    __weak id<UIScrollViewDelegate> _real_delegate;
}

@property (atomic, strong) NSMutableArray<LZXBigImageView *> *arrBigImageViews;
@property (nonatomic, weak) LZXBigImageView *currentShowBigView;

@end

@implementation LZXBigImageScrollView

#pragma mark - Load Image

+ (instancetype)scrollViewWithImageNamed:(NSString *)imageName {
    return [[self alloc] initWithImageNamed:imageName zipSize:LZXBigImageScrollViewDefaultZipSize];
}

- (instancetype)initWithImageNamed:(NSString *)imageName zipSize:(CGFloat)zipSize {
    NSAssert((zipSize > 0 && zipSize <= 1), @"非法的压缩等级！");
    
    if (self = [super init]) {
        _zipSize = zipSize;
        LZXBigImageView *originalBigImage = [LZXBigImageView bigImageViewWithImageNamed:imageName];
        _arrBigImageViews = [[NSMutableArray<LZXBigImageView *> alloc] initWithObjects:originalBigImage, nil];
        [self addSubview:originalBigImage];
        self.contentSize = originalBigImage.frame.size;
        [super setDelegate:self];
    }
    return self;
}

#pragma mark - 混淆 Delegate

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate {
    _real_delegate = delegate;
}

- (id<UIScrollViewDelegate>)delegate {
    return _real_delegate;
}

/*
 * 不能 Method swizzle，会替换掉 Super 的 Implement
 
+ (void)load {
 [self swizzleDelegate];
}
 
+ (void)swizzleDelegate {
    Class selfClass = [self class];
    Method originalSetMethod = class_getInstanceMethod(selfClass, @selector(setDelegate:));
    Method originalGetMethod = class_getInstanceMethod(selfClass, @selector(delegate));
    Method newSetMethod = class_getInstanceMethod(selfClass, @selector(setReal_delegate:));
    Method newGetMethod = class_getInstanceMethod(selfClass, @selector(real_delegate));
    
    method_exchangeImplementations(originalGetMethod, newGetMethod);
    method_exchangeImplementations(originalSetMethod, newSetMethod);
}
 */

#pragma mark - Scroll Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([_real_delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_real_delegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if ([_real_delegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [_real_delegate scrollViewDidZoom:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([_real_delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [_real_delegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([_real_delegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [_real_delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([_real_delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [_real_delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([_real_delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [_real_delegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([_real_delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [_real_delegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([_real_delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [_real_delegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (LZXBigImageView *)currentShowBigView {
    if (!_currentShowBigView) {
        _currentShowBigView = self.arrBigImageViews[0];
    }
    return _currentShowBigView;
}

- (LZXBigImageView *)viewForZoomingSmaller:(BOOL)isSmaller {
    
    // 计算 scale
    CGFloat scale = self.currentShowBigView.frame.size.width / self.contentSize.width;
    NSInteger level = [self.arrBigImageViews indexOfObject:self.currentShowBigView];
    
#if defined(__LP64__) && __LP64__
    //# define CGFLOAT_TYPE double
    CGFloat currentzipLevel = floor(log(scale) / log(self.zipSize));
    CGFloat currentZip = pow(self.zipSize, currentzipLevel);
#else
    //# define CGFLOAT_TYPE float
    CGFloat currentzipLevel = floor(logf(scale) / log(scrollView.zipSize));
    CGFloat currentZip = powf(self.zipSize, currentzipLevel);
#endif
    
    if (self.arrBigImageViews.count <= currentzipLevel) {
        for (NSInteger i = self.arrBigImageViews.count; i <= currentzipLevel; i ++) {
            LZXBigImageView *bigImgViewI = [LZXBigImageView zipImageView:self.arrBigImageViews[0] forLevel:currentZip];
            [self.arrBigImageViews addObject:bigImgViewI];
            [self addSubview:bigImgViewI];
        }
    }
    return self.arrBigImageViews[(int)currentzipLevel];
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    UIView *viewReturn;
    if ([_real_delegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        viewReturn = [_real_delegate viewForZoomingInScrollView:scrollView];
    }
//    return self.arrBigImageViews[0];
    
    return self.currentShowBigView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    if ([_real_delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [_real_delegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    if ([_real_delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [_real_delegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if ([_real_delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [_real_delegate scrollViewShouldScrollToTop:scrollView];
    }
    return YES;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if ([_real_delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [_real_delegate scrollViewDidScrollToTop:scrollView];
    }
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    if ([_real_delegate respondsToSelector:@selector(scrollViewDidChangeAdjustedContentInset:)]) {
        if (@available(iOS 11.0, *)) {
            [_real_delegate scrollViewDidChangeAdjustedContentInset:scrollView];
        } else {
            // Fallback on earlier versions
        }
    }
}

@end
