//
//  SelectRangeTableViewCell.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/5/16.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "SelectRangeTableViewCell.h"

@implementation SelectRangeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [MyTool colorWithString:@"E1E1E1"];
    [self.contentView addSubview:line];
    
    UIImageView *selectImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:selectImageV];
    _selectImageV = selectImageV;
    
    
    line.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .bottomEqualToView(self.contentView)
    .heightIs(0.5);
    
    selectImageV.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .centerYEqualToView(self.contentView)
    .widthIs(20)
    .heightEqualToWidth();
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
