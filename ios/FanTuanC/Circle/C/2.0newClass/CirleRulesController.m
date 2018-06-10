//
//  CirleRulesController.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/5/18.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "CirleRulesController.h"

@interface CirleRulesController ()
{
    UIScrollView *_myScrollView;
    UILabel *_contenLabe;
}

@end

@implementation CirleRulesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"圈子规则";
    [self createUI];
}
-(void)setConten:(NSString *)conten
{
    _conten = conten;
}
-(void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView *myScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
    [self.view addSubview: myScrollView];
    _myScrollView = myScrollView;
    
    UILabel *contenLabe = [[UILabel alloc]initWithFrame:CGRectZero];
    contenLabe.textColor = [MyTool colorWithString:@"333333"];
    contenLabe.font = [UIFont systemFontOfSize:16];
    _contenLabe = contenLabe;
    [_myScrollView addSubview:contenLabe];
    _contenLabe.text = _conten;

    _myScrollView.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0);
    
    _contenLabe.sd_layout
    .topSpaceToView(_myScrollView, 15)
    .leftSpaceToView(_myScrollView, 15)
    .rightSpaceToView(_myScrollView, 15)
    .autoHeightRatio(0);
    
    [_myScrollView setupAutoContentSizeWithBottomView:_contenLabe bottomMargin:0];

}

@end
