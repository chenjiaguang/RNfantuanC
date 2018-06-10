//
//  BusinessDetailsHeaderView.m
//  FanTuanC
//
//  Created by 梁其运 on 2017/12/27.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "BusinessDetailsHeaderView.h"

@implementation BusinessDetailsHeaderView
{
    NSString *_phoneStr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)createSubViewWithImageUrl:(NSString *)imageUrl name:(NSString *)name score:(NSString *)score average_spend:(NSString *)average_spend sales:(NSString *)sales category_name:(NSString *)category_name mall:(NSString *)mall distance:(NSString *)distance focus:(BOOL)focus address:(NSString *)address phone:(NSString *)phone
{
    _headerImageV = [UIButton buttonWithType:UIButtonTypeCustom];
    _headerImageV.frame = CGRectMake(15, 15, 90, 90);
    _headerImageV.backgroundColor = [UIColor clearColor];
    _headerImageV.imageView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageV.imageView.clipsToBounds = YES;
    [_headerImageV sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal];
    [self addSubview:_headerImageV];
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headerImageV.frame) + 10, _headerImageV.frame.origin.y, kScreenW - CGRectGetMaxX(_headerImageV.frame) - 15, 18)];
    nameLabel.text = name;
    nameLabel.textColor = [MyTool colorWithString:@"333333"];
    nameLabel.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:nameLabel];
    
    
    LQYStarRateView *myStarRateV = [[LQYStarRateView alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + nameLabel.frame.size.height + 10, 64, 12)];
    myStarRateV.isAnimation = NO;
    myStarRateV.rateStyle = 2;
    myStarRateV.numberOfStars = 5;
    myStarRateV.currentScore = [score floatValue];
    [self addSubview:myStarRateV];
    
    
    UILabel *RJLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(myStarRateV.frame) + 5, myStarRateV.frame.origin.y, 80, 12)];
    RJLabel.textColor = [MyTool colorWithString:@"999999"];
    RJLabel.font = [UIFont systemFontOfSize:12];
    RJLabel.text = average_spend;
    [self addSubview:RJLabel];
    
    
    UILabel *salesLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 70 - 15, myStarRateV.frame.origin.y, 70, 12)];
    salesLabel.textColor = [MyTool colorWithString:@"999999"];
    salesLabel.font = [UIFont systemFontOfSize:12];
    salesLabel.text = sales;
    salesLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:salesLabel];
    
    
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(myStarRateV.frame) + 10, nameLabel.frame.size.width - 80, 12)];
    categoryLabel.textColor = [MyTool colorWithString:@"999999"];
    categoryLabel.font = [UIFont systemFontOfSize:12];
    categoryLabel.text = category_name;
    [self addSubview:categoryLabel];
    
    
    UILabel *mallLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(categoryLabel.frame) + 10, [MyTool widthOfLabel:mall ForFont:[UIFont systemFontOfSize:12] labelHeight:12], 12)];
    mallLabel.textColor = [MyTool colorWithString:@"999999"];
    mallLabel.font = [UIFont systemFontOfSize:12];
    mallLabel.text = mall;
    [self addSubview:mallLabel];
    
    
    CGFloat distanceLabel_X = CGRectGetMaxX(mallLabel.frame) + 10;
    if ([mall isEqualToString:@""]) {
        distanceLabel_X = nameLabel.frame.origin.x;
    }
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(distanceLabel_X, mallLabel.frame.origin.y, 80, 12)];
    distanceLabel.textColor = [MyTool colorWithString:@"999999"];
    distanceLabel.font = [UIFont systemFontOfSize:12];
    distanceLabel.text = distance;
    [self addSubview:distanceLabel];
    
    
    _focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _focusBtn.frame = CGRectMake(kScreenW - 65 - 15, CGRectGetMaxY(_headerImageV.frame) - 27, 65, 27);
    if (focus == YES) {
        [_focusBtn setBackgroundImage:[UIImage imageNamed:@"店铺已关注"] forState:UIControlStateNormal];
    } else {
        [_focusBtn setBackgroundImage:[UIImage imageNamed:@"关注"] forState:UIControlStateNormal];
    }
    [self addSubview:_focusBtn];
    
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_headerImageV.frame) + 23, 13, 17)];
    imageV.image = [UIImage imageNamed:@"地址"];
    [self addSubview:imageV];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageV.frame) + 12, imageV.frame.origin.y, kScreenW - CGRectGetMaxX(imageV.frame) - 12 - 15 - 85, imageV.frame.size.height)];
    addressLabel.textColor = [MyTool colorWithString:@"333333"];
    addressLabel.font = [UIFont systemFontOfSize:14];
    addressLabel.text = address;
    [self addSubview:addressLabel];
    
    UIButton *phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneBtn.frame = CGRectMake(kScreenW - 85, CGRectGetMaxY(_focusBtn.frame) + 5, 85, 50);
    [phoneBtn setBackgroundImage:[UIImage imageNamed:@"拨打电话"] forState:UIControlStateNormal];
    _phoneStr = phone;
    [phoneBtn addTarget:self action:@selector(phoneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:phoneBtn];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(15, 164 - 1, kScreenW - 30, 1)];
    line.backgroundColor = [MyTool colorWithString:@"e1e1e1"];
    [self addSubview:line];
}

- (void)phoneBtnAction:(UIButton *)btn
{
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", _phoneStr]]]];
    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
