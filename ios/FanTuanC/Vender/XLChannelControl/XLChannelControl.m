//
//  XLChannelControl.m
//  XLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "XLChannelControl.h"
#import "XLChannelView.h"

@interface XLChannelControl ()
{
    UINavigationController *_nav;
    
    XLChannelView *_channelView;
    
    ChannelBlock _block;
}
@end

@implementation XLChannelControl

+(XLChannelControl*)shareControl{
    static XLChannelControl *control = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        control = [[XLChannelControl alloc] init];
    });
    return control;
}

-(instancetype)init
{
    if (self = [super init]) {
        [self buildChannelView];
    }
    return self;
}

-(void)buildChannelView{
    
    _channelView = [[XLChannelView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    _nav = [[UINavigationController alloc] initWithRootViewController:[UIViewController new]];
    _nav.navigationBar.tintColor = [UIColor blackColor];
    _nav.topViewController.title = @"编辑频道";
    [_nav.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [_nav.navigationBar setShadowImage:[[UIImage alloc]init]];
    _nav.topViewController.view = _channelView;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"频道关闭"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backMethod) forControlEvents:UIControlEventTouchUpInside];
    _nav.topViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    _nav.navigationBar.barTintColor = [UIColor whiteColor];
    [_nav.navigationBar setShadowImage:[UIImage new]];
}

-(void)backMethod
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _nav.view.frame;
        frame.origin.y = - _nav.view.bounds.size.height;
        _nav.view.frame = frame;
    }completion:^(BOOL finished) {
        [_nav.view removeFromSuperview];
    }];
    _block(_channelView.inUseTitles, _channelView.unUseTitles);
}

-(void)showChannelViewWithInUseTitles:(NSArray*)inUseTitles unUseTitles:(NSArray*)unUseTitles finish:(ChannelBlock)block{
    _block = block;
    _channelView.inUseTitles = [NSMutableArray arrayWithArray:inUseTitles];
    _channelView.unUseTitles = [NSMutableArray arrayWithArray:unUseTitles];
    [_channelView reloadData];

    CGRect frame = _nav.view.frame;
    frame.origin.y = - _nav.view.bounds.size.height;
    _nav.view.frame = frame;
    _nav.view.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:_nav.view];
    [UIView animateWithDuration:0.3 animations:^{
        _nav.view.alpha = 1;
        _nav.view.frame = [UIScreen mainScreen].bounds;
    }];
}

@end
