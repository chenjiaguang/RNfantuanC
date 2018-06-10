//
//  CircleDetailHeaderView.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/5/4.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "CircleDetailHeaderView.h"
@interface CircleDetailHeaderView ()
{
    UIImageView *_avatarImageView;
    UILabel *_nameLabell;
    UILabel *_contentLabel;
    UILabel *_fousNumberLabel;
    UILabel *_commentNumberLabel;
    UIImageView *_bgIamgeView;
    UIButton *_fousBtn;
}
@end
@implementation CircleDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)setHeadModel:(CircleModel *)headModel
{
    _headModel = headModel;
    [_bgIamgeView sd_setImageWithURL:[NSURL URLWithString:_headModel.data.cover.url]];
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_headModel.data.cover.url]];
    _nameLabell.text = _headModel.data.name;
    _contentLabel.text = _headModel.data.intro;
    _fousNumberLabel.text = [NSString stringWithFormat:@"%@人关注",_headModel.data.followed_num];
    _commentNumberLabel.text = [NSString stringWithFormat:@"%@条动态",_headModel.data.dynamic_num];
    _fousBtn.hidden = _headModel.data.is_like;
    
}
-(void)createUI
{
    UIImageView *bgIamgeView = [[UIImageView alloc]initWithFrame:CGRectZero];
    bgIamgeView.backgroundColor = [MyTool colorWithString:@"F1F1F1"];
    UIBlurEffect* blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //  毛玻璃视图
    UIVisualEffectView* effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //添加到要有毛玻璃特效的控件中
    effectView.frame= bgIamgeView.bounds;
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
    
    [effectView.contentView addSubview:vibrancyEffectView];

    [bgIamgeView addSubview:effectView];
    _bgIamgeView = bgIamgeView;

    UIImageView *avatarImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    avatarImageView.backgroundColor = [MyTool ColorWithColorStr:@"EEEEEE"];
    _avatarImageView = avatarImageView;
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    nameLabel.font = [UIFont boldSystemFontOfSize:18];
    nameLabel.textColor = [MyTool colorWithString:@"FFFFFF"];
//    nameLabel.text = @"舌尖上的海口";
    _nameLabell = nameLabel;
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    contentLabel.textColor = [MyTool colorWithString:@"FFFFFF"];
    contentLabel.font = [UIFont systemFontOfSize:12];
//    contentLabel.text = @"海南有趣、有料、有温度的生活圈，分分海南有趣、有料、有温度的生活圈，分分海南有趣、有料、有温度的生活圈，分分海南有趣、有料、有温度的生活圈，分分";
    _contentLabel = contentLabel;
    
    UIButton *fousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fousBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [fousBtn setTitle:@"关注" forState:UIControlStateNormal];
    [fousBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [fousBtn setBackgroundColor:[MyTool ColorWithColorStr:@"1EB0FD"]];
//    [fousBtn setTitleColor:[MyTool ColorWithColorStr:@"1EB0FD"] forState:UIControlStateNormal];
//    [fousBtn setTitleColor:[MyTool ColorWithColorStr:@"999999"] forState:UIControlStateSelected];
    _fousBtn = fousBtn;
    
    UILabel *fousNumberLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    fousNumberLabel.textColor = [MyTool colorWithString:@"FFFFFF"];
    fousNumberLabel.font = [UIFont systemFontOfSize:10];
//    fousNumberLabel.text = @"10人关注";
    _fousNumberLabel = fousNumberLabel;
    UILabel *commentNumberLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    commentNumberLabel.textColor = [MyTool colorWithString:@"FFFFFF"];
    commentNumberLabel.font = [UIFont systemFontOfSize:10];
//    commentNumberLabel.text = @"10条动态";
    _commentNumberLabel = commentNumberLabel;
    
    [self sd_addSubviews:@[bgIamgeView,avatarImageView,nameLabel,contentLabel,fousBtn,fousNumberLabel,commentNumberLabel]];
    bgIamgeView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    avatarImageView.sd_cornerRadius = @(5);
    avatarImageView.sd_layout
    .topSpaceToView(self, 72)
    .leftSpaceToView(self, 20)
    .widthIs(kScreenW*0.2)
    .heightEqualToWidth();
    
    nameLabel.sd_layout
    .topSpaceToView(self, 73)
    .leftSpaceToView(avatarImageView, 15)
    .autoHeightRatio(0);
    [nameLabel setSingleLineAutoResizeWithMaxWidth:kScreenW];

    contentLabel.sd_layout
    .topSpaceToView(nameLabel, 15)
    .leftSpaceToView(avatarImageView, 15)
    .rightSpaceToView(self, 15)
    .autoHeightRatio(0);
    
    fousBtn.sd_layout
    .topSpaceToView(avatarImageView, 15)
    .centerXEqualToView(avatarImageView)
    .widthIs(55)
    .heightIs(24);
    fousBtn.sd_cornerRadius = @(4);

    fousNumberLabel.sd_layout
    .topSpaceToView(contentLabel, 15)
    .leftSpaceToView(avatarImageView, 15)
    .heightIs(14);
    [fousNumberLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    commentNumberLabel.sd_layout
    .topSpaceToView(contentLabel, 15)
    .leftSpaceToView(fousNumberLabel, 15)
    .heightIs(14);
    [commentNumberLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    effectView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    vibrancyEffectView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));

    [self setupAutoHeightWithBottomView:fousBtn bottomMargin:15];
}

@end
