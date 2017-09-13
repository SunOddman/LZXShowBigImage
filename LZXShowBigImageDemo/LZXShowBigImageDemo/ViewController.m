//
//  ViewController.m
//  ShowBigImage
//
//  Created by 海底捞lzx on 2017/9/12.
//  Copyright © 2017年 海底捞. All rights reserved.
//

#import "ViewController.h"
#import "LZXBigImageView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configScrollView];
    [self loadBigImage];
}

- (void)configScrollView {
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
}

- (void)loadBigImage {
    LZXBigImageView *bigImgView = [LZXBigImageView bigImageViewWithImageNamed:@"big.jpg"];
    [self.scrollView addSubview:bigImgView];
    self.bigImageView = bigImgView;
    
    self.scrollView.contentSize = bigImgView.frame.size;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
