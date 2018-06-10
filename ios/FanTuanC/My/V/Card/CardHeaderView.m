//
//  CardHeaderView.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/3/2.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "CardHeaderView.h"

@implementation CardHeaderView
{
    UILabel *_nameLabel;
    UIImageView *_authorImageV;
    UILabel *_introLabel;
    UILabel *_followLabel;
    UIView *_line;
    UILabel *_fansLabel;
}

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr defaultIndex:(NSInteger)defaultIndex
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViewWithTitleArr:titleArr defaultIndex:defaultIndex];
    }
    return self;
}

- (void)createSubViewWithTitleArr:(NSArray *)titleArr defaultIndex:(NSInteger)defaultIndex
{
    _BgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 282 * Swidth)];
    _BgImgV.image = [UIImage imageNamed:@"我的社交名片背景"];
    _BgImgV.userInteractionEnabled = YES;
    _BgImgV.clipsToBounds = YES;
    _BgImgV.contentMode = UIViewContentModeScaleAspectFill;
    _tap = [[UITapGestureRecognizer alloc] init];
    [_BgImgV addGestureRecognizer:_tap];
    [self addSubview:_BgImgV];
    
    _headerImgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_BgImgV.frame) - 38, 90, 90)];
    _headerImgV.layer.borderWidth = 2.f;
    _headerImgV.layer.borderColor = [UIColor whiteColor].CGColor;
    _headerImgV.layer.masksToBounds = YES;
    _headerImgV.layer.cornerRadius = 45;
    _headerImgV.clipsToBounds = YES;
    _headerImgV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_headerImgV];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLabel.textColor = [MyTool colorWithString:@"333333"];
    _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:21];
    [self addSubview:_nameLabel];
    
    _authorImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    _authorImageV.image = [UIImage imageNamed:@"头条作者标签"];
    [self addSubview:_authorImageV];
    
    
    _introLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _introLabel.textColor = [MyTool colorWithString:@"999999"];
    _introLabel.font = [UIFont systemFontOfSize:14];
    _introLabel.numberOfLines = 2;
    [self addSubview:_introLabel];
    
    
    _followLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _followLabel.textColor = [MyTool colorWithString:@"333333"];
    _followLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    [self addSubview:_followLabel];
    
    _line = [[UIView alloc] initWithFrame:CGRectZero];
    _line.backgroundColor = [MyTool colorWithString:@"999999"];
    [self addSubview:_line];
    
    _fansLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _fansLabel.textColor = [MyTool colorWithString:@"333333"];
    _fansLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    [self addSubview:_fansLabel];
    
    _piecewiseView = [[QYPiecewiseView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.frame) - 44, kScreenW - 30, 44) tittleArr:titleArr.mutableCopy font:[UIFont systemFontOfSize:19] defaultIndex:defaultIndex];
    [self addSubview:_piecewiseView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, kScreenW, 0.5)];
    line.backgroundColor = [MyTool colorWithString:@"e5e5e5"];
    [self addSubview:line];
    
}

- (void)setIsNews:(BOOL)isNews
{
    if (isNews) {
        _authorImageV.hidden = NO;
    } else {
        _authorImageV.hidden = YES;
    }
}

- (void)setNameStr:(NSString *)nameStr
{
    _nameLabel.text = nameStr;
    _nameLabel.frame = CGRectMake(15, CGRectGetMaxY(_headerImgV.frame) + 20, [MyTool widthOfLabel:nameStr ForFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:21] labelHeight:25], 25);
    _authorImageV.frame = CGRectMake(CGRectGetMaxX(_nameLabel.frame) + 5, _nameLabel.frame.origin.y + 5, 54, 16);
}

- (void)setIntroStr:(NSString *)introStr
{
    _introLabel.text = introStr;
    _introLabel.frame = CGRectMake(15, CGRectGetMaxY(_nameLabel.frame) + 10, kScreenW - 30, [MyTool heightOfLabel:introStr forFont:[UIFont systemFontOfSize:14] labelLength:kScreenW - 30]);
}

- (void)setFollowNum:(NSString *)followNum
{
    NSString *followText = [NSString stringWithFormat:@"关注 %@", followNum];
    _followLabel.attributedText = [MyTool labelWithText:followText Color:[MyTool colorWithString:@"666666"] Font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] range:NSMakeRange(0, 2)];
    _followLabel.frame = CGRectMake(_introLabel.frame.origin.x, CGRectGetMaxY(_introLabel.frame) + 12, [MyTool widthOfLabel:followText ForFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:14] labelHeight:14], 14);
    _line.frame = CGRectMake(CGRectGetMaxX(_followLabel.frame) + 14, _followLabel.frame.origin.y + 2, 0.5, 10);
}

- (void)setFansNum:(NSString *)fansNum
{
    NSString *fansText = [NSString stringWithFormat:@"粉丝 %@", fansNum];
    _fansLabel.attributedText = [MyTool labelWithText:fansText Color:[MyTool colorWithString:@"666666"] Font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] range:NSMakeRange(0, 2)];
    _fansLabel.frame = CGRectMake(CGRectGetMaxX(_line.frame) + 14, _followLabel.frame.origin.y, [MyTool widthOfLabel:fansText ForFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:14] labelHeight:14], 14);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
