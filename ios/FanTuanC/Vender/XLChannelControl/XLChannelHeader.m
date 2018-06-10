//
//  XLChannelHeaderView.m
//  XLChannelControlDemo
//
//  Created by MengXianLiang on 2017/3/3.
//  Copyright © 2017年 MengXianLiang. All rights reserved.
//

#import "XLChannelHeader.h"

@interface XLChannelHeader ()
{
    UILabel *_titleLabel;
    
    UILabel *_subtitleLabel;
}
@end

@implementation XLChannelHeader

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}

-(void)buildUI
{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [MyTool colorWithString:@"333333"];
    _titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [self addSubview:_titleLabel];
    
    _subtitleLabel = [[UILabel alloc] init];
    _subtitleLabel.textColor = [MyTool colorWithString:@"999999"];
    _subtitleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:_subtitleLabel];
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = title;
    
    CGFloat marginX = 10.0f;
    _titleLabel.frame = CGRectMake(marginX, 25, [MyTool widthOfLabel:title ForFont:[UIFont systemFontOfSize:18.f] labelHeight:18], 18);
    _subtitleLabel.frame = CGRectMake(CGRectGetMaxX(_titleLabel.frame) + 18, 25, 90, 18);
}

-(void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    _subtitleLabel.text = subTitle;
}

@end
