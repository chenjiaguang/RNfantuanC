//
//  AttentionTableViewCell.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/4/2.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "AttentionTableViewCell.h"

@implementation AttentionTableViewCell

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
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [MyTool colorWithString:@"333333"];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    
    _line = [[UIImageView alloc] initWithFrame:CGRectZero];
    _line.image = [UIImage imageNamed:@"蓝色竖线"];
    _line.hidden = YES;
    [self.contentView addSubview:_line];
    
    
    _titleLabel.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .bottomEqualToView(self.contentView);
    
    _line.sd_layout
    .leftSpaceToView(self.contentView, 2)
    .centerYEqualToView(self.contentView)
    .widthIs(2)
    .heightIs(15);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    _line.hidden = !selected;
    _titleLabel.backgroundColor = selected ? [UIColor whiteColor] : [MyTool colorWithString:@"f1f1f1"];
}

@end
