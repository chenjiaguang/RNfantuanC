//
//  HomeSearchTableViewCell.m
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/9.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "HomeSearchTableViewCell.h"

@implementation HomeSearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 16, 13, 13)];
    imageV.image = [UIImage imageNamed:@"搜索List"];
    [self.contentView addSubview:imageV];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(38, 0, kScreenW - 38 - 80, 45)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [MyTool colorWithString:@"333333"];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_nameLabel];
    
    _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 80, 0, 65, 45)];
    _distanceLabel.backgroundColor = [UIColor clearColor];
    _distanceLabel.textColor = [MyTool colorWithString:@"999999"];
    _distanceLabel.textAlignment = NSTextAlignmentRight;
    _distanceLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_distanceLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(15, 44, kScreenW - 30, 1)];
    line.layer.backgroundColor = [MyTool colorWithString:@"e1e1e1"].CGColor;
    [self.contentView addSubview:line];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
