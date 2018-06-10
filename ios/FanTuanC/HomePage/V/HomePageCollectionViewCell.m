//
//  HomePageCollectionViewCell.m
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/24.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "HomePageCollectionViewCell.h"

@implementation HomePageCollectionViewCell

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
    _myImageV = [[UIImageView alloc] initWithFrame:CGRectMake((self.contentView.frame.size.width - 43) / 2, 15, 43, 43)];
    _myImageV.backgroundColor = [UIColor clearColor];
    _myImageV.contentMode = UIViewContentModeScaleAspectFill;
    _myImageV.layer.masksToBounds = YES;
    [self.contentView addSubview:_myImageV];
    
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _myImageV.frame.size.height + 15 + 9, self.contentView.frame.size.width, 12)];
    _nameLabel.textColor = [MyTool colorWithString:@"333333"];
    _nameLabel.font = [UIFont systemFontOfSize:12];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_nameLabel];
}

@end
