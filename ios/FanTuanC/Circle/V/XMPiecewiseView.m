//
//  XMPiecewiseView.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/2/27.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "XMPiecewiseView.h"
@interface XMPiecewiseView ()
{
    UIView *_lineView;
    NSInteger _seleButTag;
}
@end
@implementation XMPiecewiseView
- (instancetype)initWithFrame:(CGRect)frame tittleArr:(NSMutableArray *)titleArr font:(UIFont *)font returnButtonTag:(SelectedButtonBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedButtonBlock = block;
        [self createUiTittleArr:titleArr font:font returnButtonTag:block];
    }
    return self;
}

//创建UI
-(void)createUiTittleArr:(NSMutableArray *)titleArr font:(UIFont *)font returnButtonTag:(SelectedButtonBlock)block
{
    self.backgroundColor = [UIColor whiteColor];
    CGFloat itemWidth = kScreenW/titleArr.count;
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW/titleArr.count/2 -18, self.bounds.size.height - 3, 36, 3)];
    _lineView.backgroundColor = [MyTool colorWithString:@"ff3f53"];
    [self addSubview:_lineView];
    for (int i = 0; i< titleArr.count; i++) {
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(i * itemWidth, 0, itemWidth, 44)];
        [but setTitle:titleArr[i] forState:UIControlStateNormal];
        but.titleLabel.font = font;
//        [but setTitleColor:[MyTool colorWithString:@"ff3f53"] forState:UIControlStateSelected];
        [but setTitleColor:[MyTool colorWithString:@"333333"] forState:UIControlStateNormal];
        but.tag = 100 + i;
        i == 0? but.selected = YES:NO;
        i == 0? but.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16]:[UIFont systemFontOfSize:16];
        i == 0? _seleButTag = 100 + i:100;
        [but addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:but];
    }
}
-(void)buttonAction:(UIButton *)but
{
    if(but.tag == _seleButTag){
        return;
    }else{
        UIButton *button = (UIButton *)[self viewWithTag:_seleButTag];
        button.selected = NO;
        but.selected = YES;
        _seleButTag = but.tag;
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        but.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [UIView animateWithDuration:0.1 animations:^{
            _lineView.centerX = but.centerX;
        }];
        if (self.selectedButtonBlock != nil) {
            self.selectedButtonBlock(but.titleLabel.text);
        }
    }
}

@end
