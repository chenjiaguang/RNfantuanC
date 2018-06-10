//
//  LongArticleHeaderCell.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/4/23.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "LongArticleHeaderCell.h"
#import "MyCardViewController.h"
@implementation LongArticleHeaderCell
{
    UILabel *_titleLabel;
    UIImageView *_avatarImageView;
    UILabel *_userNameLabel;
    UILabel *_timeLabel;
    UIButton *_addressbnt;
    UIButton *_focusbnt;
    UILabel *_sourceLabel;
    UIButton *_sourcebnt;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
//点击关注按钮
//关注点击
-(void)focusbntAction:(UIButton *)btn
{
    if (self.fousButtonClickedBlock) {
        self.fousButtonClickedBlock(btn);
    }
}
-(void)fous:(BOOL)selected btn:(UIButton *)btn
{
    NSString *urlStr = [NetRequest UserFollow];
    NSDictionary *paramsDic = @{@"token":  [[NSUserDefaults standardUserDefaults] objectForKey:kToken],@"follow":[NSString stringWithFormat:@"%d",!selected],@"following_id":_model.uid};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        CircleModel *model = [CircleModel yy_modelWithJSON:JSON];
        [MyTool showHUDWithStr:model.msg];
        if ([model.error integerValue] == 0) {
            btn.selected = !btn.selected;
        }
    } failure:^(NSError *error) {
        
    }];
}
-(void)setModel:(Data *)model
{
    _model = model;
    _titleLabel.text = _model.title;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatar]];
    _userNameLabel.text = _model.username;
    _timeLabel.text = _model.time;
    [_sourcebnt setTitle:_model.circle_name forState:UIControlStateNormal];
    if(_model.circle_name.length >0){
        _sourceLabel.hidden = NO;
    }else{
        _sourceLabel.hidden = YES;
    }
    [_addressbnt setTitle:_model.location forState:UIControlStateNormal];
    if (_model.is_owner || _model.is_follow) {
        _focusbnt.hidden = YES;
    }else{
        _focusbnt.hidden = NO;

    }
    [self updateLayout];
    
}
-(void)onClickReply:(id)sender
{
    MyCardViewController *vc = [[MyCardViewController alloc]init];
    vc.navigationItem.title = _model.username;
    vc.type = 1;
    vc.uid = _model.uid;
    vc.isNews = _model.is_news;
    [[MyTool topViewController].navigationController pushViewController:vc animated:YES];
}
-(void)createUI
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.font = [UIFont boldSystemFontOfSize:24];
    titleLabel.textColor = [MyTool colorWithString:@"333333"];
    _titleLabel = titleLabel;
    
    UIImageView *avatarImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _avatarImageView = avatarImageView;
    avatarImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickReply:)];
    [avatarImageView addGestureRecognizer:singleTap];
    

    UILabel *userNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    userNameLabel.font = [UIFont systemFontOfSize:16];
    userNameLabel.textColor = [MyTool colorWithString:@"333333"];
    _userNameLabel = userNameLabel;
    
    
    UIButton *focusbnt = [UIButton buttonWithType:UIButtonTypeCustom];
    focusbnt.titleLabel.font =[UIFont systemFontOfSize:12 ];
    [focusbnt setTitle:@"关注" forState:UIControlStateNormal];
    [focusbnt.layer setBorderWidth:1.0];
    focusbnt.layer.borderColor=[MyTool ColorWithColorStr:@"1EB0FD"].CGColor;
    [focusbnt addTarget:self action:@selector(focusbntAction:) forControlEvents:UIControlEventTouchUpInside];
    //    focusbnt.backgroundColor = [UIColor redColor];
    [focusbnt setTitleColor:[MyTool ColorWithColorStr:@"1EB0FD"] forState:UIControlStateNormal];
    _focusbnt = focusbnt;
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = [MyTool colorWithString:@"999999"];
    _timeLabel = timeLabel;
    
    
    UILabel *sourceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    sourceLabel.font = [UIFont systemFontOfSize:12];
    sourceLabel.textColor = [MyTool colorWithString:@"999999"];
    sourceLabel.text = @"发布于";
    _sourceLabel = sourceLabel;
    
    UIButton *sourcebnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [sourcebnt setTitleColor:[MyTool colorWithString:@"1EB0FD"] forState:UIControlStateNormal];
    [sourcebnt addTarget:self action:@selector(sourcebntAction:) forControlEvents:UIControlEventTouchUpInside];
    sourcebnt.titleLabel.font = [UIFont systemFontOfSize:12];
    [sourcebnt setTitle:@"国贸混混" forState:UIControlStateNormal];
    _sourcebnt = sourcebnt;
    
    
    UIButton *addressbnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [addressbnt setTitleColor:[MyTool colorWithString:@"999999"] forState:UIControlStateNormal];
    [addressbnt setImage:[UIImage imageNamed:@"AddressDefault"] forState:UIControlStateNormal];
    addressbnt.titleLabel.font = [UIFont systemFontOfSize:14];
    _addressbnt = addressbnt;
    [self.contentView sd_addSubviews:@[titleLabel,avatarImageView,focusbnt,userNameLabel,sourceLabel,sourcebnt,timeLabel,addressbnt]];
    
    titleLabel.sd_layout
    .topSpaceToView(self.contentView, 20)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    
   
    
    avatarImageView.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(titleLabel, 25)
    .widthIs(40)
    .heightEqualToWidth();
    avatarImageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    focusbnt.sd_layout
    .centerYEqualToView(avatarImageView)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(25)
    .widthIs(52);
    focusbnt.sd_cornerRadius = @(4);

    userNameLabel.sd_layout
    .topSpaceToView(titleLabel, 27)
    .leftSpaceToView(avatarImageView, 15)
    .rightSpaceToView(focusbnt, 15)
    .heightIs(16);
    [userNameLabel setMaxNumberOfLinesToShow:1];

    
    timeLabel.sd_layout
    .topSpaceToView(userNameLabel, 8)
    .leftSpaceToView(avatarImageView, 15)
    .heightIs(12);
    [timeLabel setSingleLineAutoResizeWithMaxWidth:kScreenW];
    [timeLabel setMaxNumberOfLinesToShow:1];

    sourceLabel.sd_layout
    .centerYEqualToView(timeLabel)
    .leftSpaceToView(timeLabel, 10)
    .heightIs(12);
    [sourceLabel setSingleLineAutoResizeWithMaxWidth:kScreenW];
    [sourceLabel setMaxNumberOfLinesToShow:1];

    [sourcebnt setupAutoSizeWithHorizontalPadding:0 buttonHeight:13];
    sourcebnt.sd_layout
    .leftSpaceToView(sourceLabel, 0)
    .centerYEqualToView(timeLabel);

//    [addressbnt setupAutoSizeWithHorizontalPadding:0 buttonHeight:13];
//    addressbnt.sd_layout
//    .leftSpaceToView(self.contentView, 15)
//    .topSpaceToView(avatarImageView, 15);
//
//    addressbnt.titleLabel.sd_layout
//    .leftSpaceToView(addressbnt.imageView, 5);
//
    
    [self setupAutoHeightWithBottomView:avatarImageView bottomMargin:15];

}

@end
