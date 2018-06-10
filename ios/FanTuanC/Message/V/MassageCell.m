//
//  MassageCell.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/5/9.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "MassageCell.h"
@interface MassageCell ()
{
    UIImageView *_avatarImageView;
    UILabel *_nameLabell;
    UILabel *_contentLabel;
    UIImageView *_contentImageView;
    UILabel *_timerLabel;
}
@end
@implementation MassageCell

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
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatar]];
    [_contentImageView sd_setImageWithURL:[NSURL URLWithString:_model.dynamic_image]];
    _nameLabell.text = _model.title;
    _contentLabel.text = _model.content;
    _timerLabel.text = _model.time;
}
-(void)createUI
{
    UIImageView *avatarImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    avatarImageView.backgroundColor = [MyTool ColorWithColorStr:@"EEEEEE"];
    _avatarImageView = avatarImageView;
    
    UIImageView *contentImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    contentImageView.backgroundColor = [MyTool ColorWithColorStr:@"EEEEEE"];
    _contentImageView = contentImageView;
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [MyTool colorWithString:@"333333"];
    nameLabel.text = @"鮰鱼小妹妹评论了你的动态";
    _nameLabell = nameLabel;
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    contentLabel.textColor = [MyTool colorWithString:@"666666"];
    contentLabel.font = [UIFont systemFontOfSize:12];
    contentLabel.text = @"看着就好好吃啊~流口水啊流口水六六看着就好好吃啊~流口水啊流口水六六看着就好好吃啊~流口水啊流口水六六";
    _contentLabel = contentLabel;
    
    UILabel *timerLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    timerLabel.textColor = [MyTool colorWithString:@"999999"];
    timerLabel.font = [UIFont systemFontOfSize:12];
    timerLabel.text = @"2018-01-09";
    _timerLabel = timerLabel;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = [MyTool colorWithString:@"E5E5E5"];
    [self.contentView sd_addSubviews:@[avatarImageView,contentImageView,nameLabel,contentLabel,timerLabel,lineView]];
    
    avatarImageView.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(kScreenW * 38/375)
    .heightEqualToWidth();
    avatarImageView.sd_cornerRadiusFromWidthRatio = @(0.5);

    contentImageView.sd_layout
    .topSpaceToView(self.contentView, 23)
    .rightSpaceToView(self.contentView, 15)
    .widthIs(kScreenW * 40/375)
    .heightEqualToWidth();
    
    nameLabel.sd_layout
    .topEqualToView(contentImageView)
    .leftSpaceToView(avatarImageView, 15)
    .rightSpaceToView(contentImageView, 27)
    .heightIs(15);
    
    contentLabel.sd_layout
    .topSpaceToView(nameLabel, 10)
    .leftSpaceToView(avatarImageView, 15)
    .rightSpaceToView(contentImageView, 27)
    .autoHeightRatio(0);
    
    timerLabel.sd_layout
    .topSpaceToView(contentLabel, 10)
    .leftSpaceToView(avatarImageView, 15)
    .heightIs(12);
    [timerLabel setSingleLineAutoResizeWithMaxWidth:kScreenW];
    
    lineView.sd_layout
    .topSpaceToView(timerLabel, 12)
    .leftSpaceToView(avatarImageView, 15)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomView:lineView bottomMargin:0];
}
@end
