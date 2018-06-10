//
//  AdimnAvatarView.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/4/11.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "AdimnAvatarView.h"
#import "MyCardViewController.h"
@interface AdimnAvatarView ()
{
   
    UIImageView *_avatarIamgeView;
  
    UILabel *_nameLabel;
    
}
@end
@implementation AdimnAvatarView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    [_avatarIamgeView sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"cover"]]];
    _nameLabel.text = _dataDic[@"username"];
}
-(void)onClickReply:(id)sender
{
    MyCardViewController *vc = [[MyCardViewController alloc]init];
    vc.navigationItem.title = _dataDic[@"username"];
    vc.type = 1;
    vc.uid = _dataDic[@"id"];
    vc.isNews = [_dataDic[@"is_news"]boolValue];
    [[MyTool topViewController].navigationController pushViewController:vc animated:YES];
}
-(void)createUI
{
    UIImageView *avatarIamgeView = [[UIImageView alloc]initWithFrame:CGRectZero];
//    avatarIamgeView.backgroundColor = [UIColor redColor];
    avatarIamgeView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickReply:)];
    [avatarIamgeView addGestureRecognizer:singleTap];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [MyTool colorWithString:@"666666"];
    nameLabel.text = @"我就是大神";
    nameLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:avatarIamgeView];
    [self addSubview:nameLabel];
    _avatarIamgeView = avatarIamgeView;
    _nameLabel = nameLabel;
    avatarIamgeView.sd_cornerRadiusFromWidthRatio = @(0.5);
    avatarIamgeView.sd_layout
    .topSpaceToView(self, 5)
    .centerXEqualToView(self)
    .widthIs((kScreenW-30)/5 - 30)
    .heightEqualToWidth();
    
    nameLabel.sd_layout
    .topSpaceToView(avatarIamgeView, 10)
    .centerXEqualToView(self)
    .widthIs((kScreenW-30)/5)
    .heightIs(12);
}
@end
