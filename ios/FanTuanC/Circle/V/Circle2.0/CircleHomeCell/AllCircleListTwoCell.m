//
//  AllCircleListTwoCell.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/5/4.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "AllCircleListTwoCell.h"
@interface AllCircleListTwoCell ()
{
    UIImageView *_avatarImageView;
    UILabel *_nameLabell;
    UILabel *_contentLabel;
    UILabel *_fousNumberLabel;
    UIButton *_fousBtn;
}
@end
@implementation AllCircleListTwoCell

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
    _contentLabel.text = _model.intro;
    _fousNumberLabel.text = [NSString stringWithFormat:@"%@人关注",_model.following_num];
    _fousBtn.selected = _model.followed;
}
-(void)fousBtnAction:(UIButton *)btn
{
    if (btn.selected) {
        return;
    }
    [self.delegate selectedFousButtonWithCell:btn];
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
    
    UIButton *fousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fousBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [fousBtn setTitle:@"+关注" forState:UIControlStateNormal];
    [fousBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [fousBtn setTitleColor:[MyTool ColorWithColorStr:@"1EB0FD"] forState:UIControlStateNormal];
    [fousBtn setTitleColor:[MyTool ColorWithColorStr:@"999999"] forState:UIControlStateSelected];
    [fousBtn addTarget: self action:@selector(fousBtnAction:) forControlEvents:UIControlEventTouchDown];
    _fousBtn = fousBtn;
    
    UILabel *fousNumberLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    fousNumberLabel.textColor = [MyTool colorWithString:@"999999"];
    fousNumberLabel.font = [UIFont systemFontOfSize:10];
    fousNumberLabel.text = @"10人关注";
    _fousNumberLabel = fousNumberLabel;
    
    [self.contentView sd_addSubviews:@[avatarImageView,nameLabel,contentLabel,fousBtn,fousNumberLabel]];
    
    avatarImageView.sd_cornerRadius = @(5);
    avatarImageView.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(60)
    .heightEqualToWidth();
    
    nameLabel.sd_layout
    .topSpaceToView(self.contentView, 20)
    .leftSpaceToView(avatarImageView, 15)
    .rightSpaceToView(self.contentView, 15);
    
    
    fousBtn.sd_layout
    .topSpaceToView(self.contentView, 29)
    .rightSpaceToView(self.contentView, 15);
    [fousBtn setupAutoSizeWithHorizontalPadding:0 buttonHeight:15];
    
    fousNumberLabel.sd_layout
    .topSpaceToView(fousBtn, 8)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(10);
    [fousNumberLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    
    contentLabel.sd_layout
    .topSpaceToView(nameLabel, 5.5)
    .leftSpaceToView(avatarImageView, 15)
    .rightSpaceToView(fousNumberLabel, 15)
    .autoHeightRatio(0);
    [contentLabel setMaxNumberOfLinesToShow:2];
    [self setupAutoHeightWithBottomViewsArray:@[avatarImageView,contentLabel] bottomMargin:15];
//    [self setupAutoHeightWithBottomView:avatarImageView bottomMargin:15];
    
}
@end
