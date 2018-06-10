//
//  MallsView.m
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/24.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "MallsView.h"

@implementation MallsView

- (instancetype)initWithFrame:(CGRect)frame imageUrl:(NSString *)imageUrl name:(NSString *)nameStr distance:(NSString *)distance
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUIWithImageUrl:imageUrl name:nameStr distance:distance];
    }
    return self;
}

- (void)createUIWithImageUrl:(NSString *)imageUrl name:(NSString *)nameStr distance:(NSString *)distance
{
    _bgImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bgImageBtn.userInteractionEnabled = YES;
    _bgImageBtn.frame = CGRectMake(0, 0, 140, 80);
    _bgImageBtn.backgroundColor = [UIColor clearColor];
    _bgImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_bgImageBtn sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal];
    [self addSubview:_bgImageBtn];
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 23, _bgImageBtn.frame.size.width, 16)];
    nameLabel.text = nameStr;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont boldSystemFontOfSize:15];
    [_bgImageBtn addSubview:nameLabel];
    
    
    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nameLabel.frame.origin.y + 16 + 5, _bgImageBtn.frame.size.width, 13)];
    distanceLabel.text = distance;
    distanceLabel.textColor = [UIColor whiteColor];
    distanceLabel.textAlignment = NSTextAlignmentCenter;
    distanceLabel.font = [UIFont systemFontOfSize:12];
    [_bgImageBtn addSubview:distanceLabel];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
