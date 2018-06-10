//
//  BusinessDetailsFooterView.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/1/3.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "BusinessDetailsFooterView.h"

@implementation BusinessDetailsFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (UIView *)footerViewWithAffiche:(NSString *)affiche Business_hours:(NSString *)business_hours
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, kScreenW - 30, 20)];
    titleLabel.text = @"更多信息";
    titleLabel.textColor = [MyTool colorWithString:@"333333"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:19]];
    [bgView addSubview:titleLabel];
    
    if (![affiche isEqualToString:@""] && ![business_hours isEqualToString:@""]) {
        bgView.frame = CGRectMake(0, 0, kScreenW, 90 + 40 + [MyTool heightOfLabel:affiche forFont:[UIFont systemFontOfSize:14] labelLength:kScreenW - 55] + 15 + [MyTool heightOfLabel:business_hours forFont:[UIFont systemFontOfSize:14] labelLength:kScreenW - 55 - 72]);
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame) + 20, 14, 14)];
        imageV.image = [UIImage imageNamed:@"公告喇叭"];
        [bgView addSubview:imageV];
        
        UILabel *afficheLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame) + 11, imageV.frame.origin.y - 2, kScreenW - 55, [MyTool   heightOfLabel:affiche forFont:[UIFont systemFontOfSize:14] labelLength:kScreenW - 55])];
        afficheLabel.textColor = [MyTool colorWithString:@"333333"];
        afficheLabel.font = [UIFont systemFontOfSize:14];
        afficheLabel.text = affiche;
        afficheLabel.numberOfLines = 0;
        [bgView addSubview:afficheLabel];
        
        
        UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(afficheLabel.frame) + 15, 14, 14)];
        imageV2.image = [UIImage imageNamed:@"营业时间"];
        [bgView addSubview:imageV2];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageV2.frame) + 11, imageV2.frame.origin.y - 2, 72, [MyTool heightOfLabel:@"营业时间：" forFont:[UIFont systemFontOfSize:14] labelLength:72])];
        timeLabel.text = @"营业时间：";
        timeLabel.font = [UIFont systemFontOfSize:14];
        timeLabel.textColor = [MyTool colorWithString:@"333333"];
        [bgView addSubview:timeLabel];
        
        UILabel *business_hoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeLabel.frame), timeLabel.frame.origin.y, kScreenW - 55 - 72, [MyTool heightOfLabel:business_hours forFont:[UIFont systemFontOfSize:14] labelLength:kScreenW - 55 - 72])];
        business_hoursLabel.text = business_hours;
        business_hoursLabel.font = [UIFont systemFontOfSize:14];
        business_hoursLabel.textColor = [MyTool colorWithString:@"333333"];
        business_hoursLabel.numberOfLines = 0;
        [bgView addSubview:business_hoursLabel];
        
    } else if (![affiche isEqualToString:@""]) {
        bgView.frame = CGRectMake(0, 0, kScreenW, 90 + 40 + [MyTool heightOfLabel:affiche forFont:[UIFont systemFontOfSize:14] labelLength:kScreenW - 55]);
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame) + 20, 14, 14)];
        imageV.image = [UIImage imageNamed:@"公告喇叭"];
        [bgView addSubview:imageV];
        
        UILabel *afficheLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame) + 11, imageV.frame.origin.y - 2, kScreenW - 55, [MyTool   heightOfLabel:affiche forFont:[UIFont systemFontOfSize:14] labelLength:kScreenW - 55])];
        afficheLabel.textColor = [MyTool colorWithString:@"333333"];
        afficheLabel.font = [UIFont systemFontOfSize:14];
        afficheLabel.text = affiche;
        afficheLabel.numberOfLines = 0;
        [bgView addSubview:afficheLabel];
        
    } else if (![business_hours isEqualToString:@""]) {
        bgView.frame = CGRectMake(0, 0, kScreenW, 90 + 40 + [MyTool heightOfLabel:business_hours forFont:[UIFont systemFontOfSize:14] labelLength:kScreenW - 55 - 72]);
        
        UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame) + 20, 14, 14)];
        imageV2.image = [UIImage imageNamed:@"营业时间"];
        [bgView addSubview:imageV2];
        
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageV2.frame) + 11, imageV2.frame.origin.y - 2, 72, [MyTool heightOfLabel:@"营业时间：" forFont:[UIFont systemFontOfSize:14] labelLength:72])];
        timeLabel.text = @"营业时间：";
        timeLabel.font = [UIFont systemFontOfSize:14];
        timeLabel.textColor = [MyTool colorWithString:@"333333"];
        [bgView addSubview:timeLabel];
        
        UILabel *business_hoursLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeLabel.frame), timeLabel.frame.origin.y, kScreenW - 55 - 72, [MyTool heightOfLabel:business_hours forFont:[UIFont systemFontOfSize:14] labelLength:kScreenW - 55 - 72])];
        business_hoursLabel.text = business_hours;
        business_hoursLabel.font = [UIFont systemFontOfSize:14];
        business_hoursLabel.textColor = [MyTool colorWithString:@"333333"];
        business_hoursLabel.numberOfLines = 0;
        [bgView addSubview:business_hoursLabel];
    } else {
        titleLabel.hidden = YES;
    }
    
    
    return bgView;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
