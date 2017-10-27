//
//  ScrollViewDemoController.m
//  LZXShowBigImageDemo
//
//  Created by 海底捞lzx on 2017/10/25.
//  Copyright © 2017年 海底捞. All rights reserved.
//

#import "ScrollViewDemoController.h"
#import "LZXBigImageScrollView.h"
@interface ScrollViewDemoController () <UIScrollViewDelegate>

@property (nonatomic, weak) LZXBigImageScrollView *scrollView;

@end

@implementation ScrollViewDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initScrollView];
    [self configScrollView];
}

- (void)initScrollView {
    LZXBigImageScrollView *scrollView = [LZXBigImageScrollView scrollViewWithImageNamed:@"big.jpg"];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    NSString *formatH = @"H:|-(0)-[scrollView]-(0)-|";
    NSString *formatV = @"V:|-[scrollView]-|";
    NSArray<__kindof NSLayoutConstraint *> *consH = [NSLayoutConstraint constraintsWithVisualFormat:formatH options:0 metrics:nil views:NSDictionaryOfVariableBindings(scrollView)];
    NSArray<__kindof NSLayoutConstraint *> *consV = [NSLayoutConstraint constraintsWithVisualFormat:formatV options:0 metrics:nil views:NSDictionaryOfVariableBindings(scrollView)];
    [self.view addConstraints:consH];
    [self.view addConstraints:consV];
}

- (void)configScrollView {
//    self.scrollView.delegate = self;
    
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = YES;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    
    self.scrollView.minimumZoomScale = 0.05;
    self.scrollView.maximumZoomScale = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
