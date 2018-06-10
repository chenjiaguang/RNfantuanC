//
//  NewsFourTableViewCell.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/1/31.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "NewsFourTableViewCell.h"

@implementation NewsFourTableViewCell

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
    _headerImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, kScreenW - 30, (kScreenW - 30) / 345 * 135)];
    _headerImageV.userInteractionEnabled = YES;
    _headerImageV.layer.masksToBounds = YES;
    _headerImageV.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_headerImageV];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _headerImageV.frame.size.height - 38, _headerImageV.frame.size.width - 20, 28)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20];
    [_headerImageV addSubview:_nameLabel];
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
