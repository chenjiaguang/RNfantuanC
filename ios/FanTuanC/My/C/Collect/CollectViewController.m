//
//  CollectViewController.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/2/28.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "CollectViewController.h"
#import "SGPagingView.h"
#import "NewsCollectViewController.h"
#import "MerchantCollectViewController.h"

@interface CollectViewController ()<SGPageTitleViewDelegate, SGPageContentViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的收藏";
    
    [self createTitleView];
}

- (void)createTitleView
{
    NSArray *titleArr = @[@"文章", @"商家"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.indicatorScrollStyle = SGIndicatorScrollStyleHalf;
    configure.titleFont = [UIFont systemFontOfSize:16];
    configure.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    configure.titleColor = [MyTool colorWithString:@"333333"];
    configure.titleSelectedColor = [MyTool colorWithString:@"333333"];
    
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, kScreenW, 44) delegate:self titleNames:titleArr configure:configure];
    [self.view addSubview:_pageTitleView];
    _pageTitleView.isTitleGradientEffect = NO;
    _pageTitleView.isNeedBounces = NO;
    
    NewsCollectViewController *newsCollectVC = [[NewsCollectViewController alloc] init];
    MerchantCollectViewController *merchantCollectVC = [[MerchantCollectViewController alloc] init];
    NSArray *childArr = @[newsCollectVC, merchantCollectVC];
    /// pageContentView
    
    CGFloat contentViewHeight = kScreenH - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, contentViewHeight) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
}
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
}

- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
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
