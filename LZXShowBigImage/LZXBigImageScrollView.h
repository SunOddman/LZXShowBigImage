//
//  LZXBigImageScrollView.h
//  LZXShowBigImageDemo
//
//  Created by 海底捞lzx on 2017/10/20.
//  Copyright © 2017年 海底捞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZXBigImageView.h"

extern const CGFloat LZXBigImageScrollViewDefaultZipLevel;

@interface LZXBigImageScrollView : UIScrollView

+ (instancetype)scrollViewWithImageNamed:(NSString *)imageName;

- (instancetype)initWithImageNamed:(NSString *)imageName zipSize:(CGFloat)zipLevel;

/**
 图片压缩等级，缩放到对应比例后启用新的缩略图
 */
@property (nonatomic, assign, readonly) CGFloat zipSize;

@end
