//
//  LongArticleHeaderView.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/4/23.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "LongArticleHeaderView.h"

@implementation LongArticleHeaderView
{
    UILabel *_titleLabel;
    UIImageView *_avatarImageView;
    UILabel *_userNameLabel;
    UILabel *_timeLabel;
    UIButton *_addressbnt;
    UIButton *_focusbnt;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
        
    }
    return self;
}
-(void)setModel:(Data *)model
{
    _model = model;
    _titleLabel.text = _model.title;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatar]];
    _userNameLabel.text = _model.username;
    _timeLabel.text = _model.time;
    [_addressbnt setTitle:_model.location forState:UIControlStateNormal];
    
}
- (void)createSubViews
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    titleLabel.textColor = [MyTool colorWithString:@"333333"];
    _titleLabel = titleLabel;
    
    UIImageView *avatarImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _avatarImageView = avatarImageView;
    
    UIButton *focusbnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [focusbnt setTitleColor:[MyTool colorWithString:@"999999"] forState:UIControlStateNormal];
    [focusbnt setImage:[UIImage imageNamed:@"新闻关注"] forState:UIControlStateNormal];
    [focusbnt setImage:[UIImage imageNamed:@"新闻已关注"] forState:UIControlStateSelected];
    [focusbnt addTarget:self action:@selector(focusbntAction:) forControlEvents:UIControlEventTouchUpInside];
    focusbnt.titleLabel.font = [UIFont systemFontOfSize:14];
    _focusbnt = focusbnt;
    
    UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    userNameLabel.font = [UIFont systemFontOfSize:16];
    userNameLabel.textColor = [MyTool colorWithString:@"333333"];
    _userNameLabel = userNameLabel;
   
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [MyTool colorWithString:@"999999"];
    _timeLabel = timeLabel;
    
    UIButton *addressbnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [addressbnt setTitleColor:[MyTool colorWithString:@"999999"] forState:UIControlStateNormal];
    [addressbnt setImage:[UIImage imageNamed:@"AddressDefault"] forState:UIControlStateNormal];
    addressbnt.titleLabel.font = [UIFont systemFontOfSize:14];
    _addressbnt = addressbnt;
    [self sd_addSubviews:@[titleLabel,avatarImageView,focusbnt,userNameLabel,timeLabel,addressbnt]];
    
    titleLabel.sd_layout
    .topSpaceToView(self, 20)
    .leftSpaceToView(self, 15)
    .rightSpaceToView(self, 15)
    .autoHeightRatio(0);
    
    focusbnt.sd_layout
    .topSpaceToView(self, 69)
    .rightSpaceToView(self, 15)
    .heightIs(25)
    .widthIs(52);
    
    avatarImageView.sd_layout
    .leftSpaceToView(self, 15)
    .topSpaceToView(titleLabel, 25)
    .widthIs(40)
    .heightEqualToWidth();
    avatarImageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    userNameLabel.sd_layout
    .topSpaceToView(titleLabel, 27)
    .leftSpaceToView(avatarImageView, 15)
    .rightSpaceToView(focusbnt, 15)
    .autoHeightRatio(0);
    
    timeLabel.sd_layout
    .topSpaceToView(userNameLabel, 8)
    .leftSpaceToView(avatarImageView, 15)
    .rightSpaceToView(focusbnt, 15)
    .autoHeightRatio(0);
    
    [addressbnt setupAutoSizeWithHorizontalPadding:0 buttonHeight:13];
    addressbnt.sd_layout
    .leftSpaceToView(self, 15)
    .topSpaceToView(avatarImageView, 15);
    
    addressbnt.titleLabel.sd_layout
    .leftSpaceToView(addressbnt.imageView, 5);
    
}

@end
