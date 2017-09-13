//
//  LZXBigImageView.h
//  ShowBigImage
//
//  Created by 海底捞lzx on 2017/9/12.
//  Copyright © 2017年 海底捞. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface LZXBigImageView : UIView

+ (instancetype)bigImageViewWithImageNamed:(NSString *)imgName;

- (instancetype)initWithImageNamed:(NSString *)imgName;
- (instancetype)initWithImage:(UIImage *)img;

/**
 缓存单元的大小
  单位：点
 */
@property (nonatomic, assign) CGSize cacheImageSize;

/**
 收到内存警告时调用
 */
- (void)receiveMemoryWarning;

@end
