//
//  BalanceListTableViewCell.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/1/9.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "BalanceListTableViewCell.h"

@implementation BalanceListTableViewCell

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
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 17, 180 * Swidth, 15)];
    _nameLabel.textColor = [MyTool colorWithString:@"333333"];
    _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    [self.contentView addSubview:_nameLabel];
    
    
    _refundLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame) + 10, 20, 60, 12)];
    _refundLabel.textColor = [MyTool colorWithString:@"ff3f53"];
    _refundLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_refundLabel];
    
    
    _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 100 * Swidth - 15, 0, 100 * Swidth, 72)];
    _moneyLabel.textColor = [MyTool colorWithString:@"333333"];
    _moneyLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:17];
    _moneyLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_moneyLabel];
    
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_nameLabel.frame) + 10, kScreenW - 30 - 100 * Swidth, 12)];
    _timeLabel.textColor = [MyTool colorWithString:@"999999"];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_timeLabel];
    
    
    _line = [[UILabel alloc] initWithFrame:CGRectMake(15, 71.5, kScreenW - 30, 0.5)];
    _line.layer.backgroundColor = [MyTool colorWithString:@"e1e1e1"].CGColor;
    [self.contentView addSubview:_line];
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
