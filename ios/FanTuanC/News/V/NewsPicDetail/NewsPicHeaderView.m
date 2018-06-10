//
//  NewsPicHeaderView.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/3/28.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "NewsPicHeaderView.h"
#import "MyCardViewController.h"

@implementation NewsPicHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    
    _headImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    _headImageV.clipsToBounds = YES;
    _headImageV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_headImageV];
    
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLabel.textColor = [MyTool colorWithString:@"ffffff"];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_nameLabel];
    
    
    
    _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_followBtn setBackgroundImage:[UIImage imageNamed:@"FousBtn"] forState:UIControlStateNormal];
    [_followBtn addTarget:self action:@selector(followBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _followBtn.hidden = YES;
    [self addSubview:_followBtn];
    
    
    [_headImageV setSd_cornerRadiusFromWidthRatio:@(0.5)];
    _headImageV.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self, 5)
    .widthIs(27)
    .heightIs(27);
    
    _nameLabel.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(_headImageV, 10)
    .rightSpaceToView(self, 70)
    .autoHeightRatio(0);
    
    _followBtn.sd_layout
    .centerYEqualToView(self)
    .rightSpaceToView(self, 15)
    .widthIs(52)
    .heightIs(25);
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    MyCardViewController *myCardVC = [[MyCardViewController alloc] init];
    myCardVC.hidesBottomBarWhenPushed = YES;
    myCardVC.titleStr = _dataDic[@"news_name"];
    myCardVC.uid = _dataDic[@"uid"];
    myCardVC.type = 2;
    myCardVC.isNews = YES;
    [[MyTool topViewController].navigationController pushViewController:myCardVC animated:YES];
}

- (void)followBtnAction:(UIButton *)btn
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] != YES) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *loginNaVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [[MyTool topViewController] presentViewController:loginNaVC animated:YES completion:nil];
    } else {
        [self getFollowData];
    }
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    [_headImageV sd_setImageWithURL:[NSURL URLWithString:dataDic[@"avatar"]]];
    _nameLabel.text = dataDic[@"news_name"];
    _followBtn.hidden = [dataDic[@"is_following"] boolValue];
}


- (void)getFollowData
{
    NSString *urlStr = [NetRequest UserFollow];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"following_id": _dataDic[@"uid"], @"follow": @"1"};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [MyTool showHUDWithStr:JSON[@"msg"]];
        if ([JSON[@"error"] boolValue] == 0) {
            _followBtn.hidden = YES;
        }
    } failure:^(NSError *error) {
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
