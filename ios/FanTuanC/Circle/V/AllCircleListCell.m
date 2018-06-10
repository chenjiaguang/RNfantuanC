//
//  AllCircleListCell.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/3/6.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "AllCircleListCell.h"
@interface AllCircleListCell ()
{
    UIImageView *_avatarImageView;
    UILabel *_nameLabell;
    UILabel *_contentLabel;
}
@end

@implementation AllCircleListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)setModel:(ListModel *)model
{
    _model = model;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_model.cover.compress]];
    _nameLabell.text = _model.name;
    _contentLabel.text = [NSString stringWithFormat:@"今日:%@",_model.today_num];
    _contentLabel.text = _model.intro;
}
-(void)createUI
{
    UIImageView *avatarImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    avatarImageView.backgroundColor = [MyTool ColorWithColorStr:@"EEEEEE"];
    _avatarImageView = avatarImageView;
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [MyTool colorWithString:@"333333"];
    nameLabel.text = @"今日旅游攻略";
    _nameLabell = nameLabel;
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    contentLabel.textColor = [MyTool colorWithString:@"999999"];
    contentLabel.font = [UIFont systemFontOfSize:12];
    contentLabel.text = @"今日:1000";
    _contentLabel = contentLabel;
    [self.contentView sd_addSubviews:@[avatarImageView,nameLabel,contentLabel]];
    
    avatarImageView.sd_cornerRadius = @(5);
    avatarImageView.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(45)
    .heightEqualToWidth();
    
    nameLabel.sd_layout
    .topSpaceToView(self.contentView, 20)
    .leftSpaceToView(avatarImageView, 15)
    .rightSpaceToView(self.contentView, 15);
    
    contentLabel.sd_layout
    .topSpaceToView(nameLabel, 5.5)
    .leftSpaceToView(avatarImageView, 15)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomView:contentLabel bottomMargin:15];

}



@end
