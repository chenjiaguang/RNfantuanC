//
//  HomeFousCircleCell.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/4/12.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "HomeFousCircleCell.h"

@implementation HomeFousCircleCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    _myImageV = [[UIImageView alloc] initWithFrame:CGRectMake((self.contentView.frame.size.width - 50) / 2, 7, 50, 50)];
    _myImageV.backgroundColor = [UIColor clearColor];
    _myImageV.contentMode = UIViewContentModeScaleAspectFill;
    _myImageV.layer.masksToBounds = YES;
    [self.contentView addSubview:_myImageV];
    
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_myImageV.frame) + 7, self.contentView.frame.size.width, 12)];
    _nameLabel.textColor = [MyTool colorWithString:@"666666"];
    _nameLabel.font = [UIFont systemFontOfSize:12];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.text = @"这里圈子名";
    [self.contentView addSubview:_nameLabel];
}
@end
