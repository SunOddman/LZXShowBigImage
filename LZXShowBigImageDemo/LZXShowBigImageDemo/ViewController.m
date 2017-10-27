//
//  ViewController.m
//  ShowBigImage
//
//  Created by 海底捞lzx on 2017/9/12.
//  Copyright © 2017年 海底捞. All rights reserved.
//

#import "ViewController.h"
#import "LZXBigImageView.h"
#import "LZXBigImageScrollView.h"

@interface ViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) LZXBigImageView *bigImgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configScrollView];
    [self loadBigImage];
}

- (void)configScrollView {
    self.scrollView.delegate = self;
    
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    self.scrollView.minimumZoomScale = 0.05;
    self.scrollView.maximumZoomScale = 1;
}

- (void)loadBigImage {
    LZXBigImageView *bigImgView = [LZXBigImageView bigImageViewWithImageNamed:@"big.jpg"];
    [self.scrollView addSubview:bigImgView];
    self.bigImgView = bigImgView;
    
    self.scrollView.contentSize = bigImgView.frame.size;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.bigImgView;
}


@end
