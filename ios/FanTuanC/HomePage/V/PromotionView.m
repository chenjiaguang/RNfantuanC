//
//  PromotionView.m
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/13.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "PromotionView.h"

@implementation PromotionView

- (instancetype)initWithFrame:(CGRect)frame icon:(NSString *)iconUrl name:(NSString *)nameStr
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUIWithIcon:iconUrl name:nameStr];
    }
    return self;
}

- (void)createUIWithIcon:(NSString *)iconUrl name:(NSString *)nameStr
{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 13, 13)];
    imageV.backgroundColor = [UIColor clearColor];
    [imageV sd_setImageWithURL:[NSURL URLWithString:iconUrl]];
    [self addSubview:imageV];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(13 + 5, imageV.frame.origin.y, self.frame.size.width - 18, imageV.frame.size.height)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [MyTool colorWithString:@"666666"];
    nameLabel.text = nameStr;
    nameLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:nameLabel];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
