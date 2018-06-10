//
//  ShareAlertCollectionViewCell.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/1/12.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "ShareAlertCollectionViewCell.h"

@implementation ShareAlertCollectionViewCell

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
    _myImageV = [[UIImageView alloc] initWithFrame:CGRectMake((self.contentView.frame.size.width - 56 * Swidth) / 2, 20, 56 * Swidth, 56 * Swidth)];
    _myImageV.backgroundColor = [UIColor clearColor];
    _myImageV.contentMode = UIViewContentModeScaleAspectFill;
    _myImageV.layer.masksToBounds = YES;
    [self.contentView addSubview:_myImageV];
    
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_myImageV.frame) + 15, self.contentView.frame.size.width, 12)];
    _nameLabel.textColor = [MyTool colorWithString:@"333333"];
    _nameLabel.font = [UIFont systemFontOfSize:11];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
}

@end
