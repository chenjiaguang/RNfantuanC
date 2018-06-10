//
//  WalletViewController.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/1/5.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "WalletViewController.h"
#import "BalanceListViewController.h"
#import "WithdrawalViewController.h"

@interface WalletViewController ()
{
    UIView *_bgView;
    UILabel *_moneyLabel;
    UILabel *_tsLabel;
    
    NSDictionary *_dic;
}

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的钱包";
    self.view.backgroundColor = [MyTool colorWithString:@"f5f5f5"];
    
    _dic = [NSDictionary dictionary];
    [self createRightBtn];
    
    [self loadingWithText:@"加载中"];
    [self getWalletData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinBind:) name:reloadWalletView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWalletData) name:reloadWalletViewData object:nil];
}

- (void)weixinBind:(NSNotification *)notification
{
    [self loadingWithText:@"绑定中"];
    NSString *urlStr = [NetRequest UserWeixinBind];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"code": (NSString *)[notification object]};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        
        [self endLoading];
        if ([[JSON objectForKeyNotNull:@"error"] integerValue] == 0) {
            [self getWalletData];
        } else {
            [MyTool showHUDWithStr:JSON[@"msg"]];
        }
    } failure:^(NSError *error) {
        [self endLoading];
    }];
}

- (void)createRightBtn
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 70, 16);
    [rightBtn setTitle:@"余额明细" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[MyTool colorWithString:@"333333"] forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}

- (void)rightBtnAction:(UIButton *)btn
{
    BalanceListViewController *balanceListVC = [[BalanceListViewController alloc] init];
    [self.navigationController pushViewController:balanceListVC animated:YES];
}

- (void)createUI
{
    [_bgView removeFromSuperview];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64)];
    if (iPhoneX) {
        _bgView.frame = CGRectMake(0, 0, kScreenW, kScreenW - 88);
    }
    [self.view addSubview:_bgView];
    
    UIImageView *bgImgaeV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 182)];
    bgImgaeV.image = [UIImage imageNamed:@"我的钱包背景"];
    bgImgaeV.clipsToBounds = YES;
    bgImgaeV.contentMode = UIViewContentModeScaleAspectFill;
    [_bgView addSubview:bgImgaeV];
    
    
    UILabel *zhyeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 60, 14)];
    zhyeLabel.text = @"账户余额";
    zhyeLabel.textColor = [MyTool colorWithString:@"ffffff"];
    zhyeLabel.font = [UIFont systemFontOfSize:14];
    [bgImgaeV addSubview:zhyeLabel];
    
    UILabel *rmbLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(zhyeLabel.frame) + 18, 14, 22)];
    rmbLabel.text = @"¥";
    rmbLabel.textColor = [MyTool colorWithString:@"ffffff"];
    rmbLabel.font = [UIFont systemFontOfSize:22];
    [bgImgaeV addSubview:rmbLabel];
    
    _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(rmbLabel.frame) + 2, CGRectGetMaxY(zhyeLabel.frame) + 10, kScreenW - CGRectGetMaxX(rmbLabel.frame) - 15, 50)];
    _moneyLabel.textColor = [MyTool colorWithString:@"ffffff"];
    _moneyLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:50];
    _moneyLabel.text = _dic[@"money"];
    [bgImgaeV addSubview:_moneyLabel];
    
    
    UIView *tsBgView = [[UIView alloc] initWithFrame:CGRectMake(0, bgImgaeV.frame.size.height - 48, kScreenW, 48)];
    tsBgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    [bgImgaeV addSubview:tsBgView];
    
    UIImageView *tsImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 35 / 2, 13, 13)];
    tsImageV.image = [UIImage imageNamed:@"我的钱包提示icon"];
    [tsBgView addSubview:tsImageV];
    
    _tsLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tsImageV.frame) + 5, 0, kScreenW - CGRectGetMaxX(tsImageV.frame) - 20, 48)];
    _tsLabel.textColor = [MyTool colorWithString:@"ffffff"];
    _tsLabel.text = [NSString stringWithFormat:@"余额需大于等于%@元才可提现哦~", _dic[@"withdraw_money_min"]];
    _tsLabel.font = [UIFont systemFontOfSize:12];
    [tsBgView addSubview:_tsLabel];
    
    
    
    UIView *payPassBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgImgaeV.frame) + 10, kScreenW, 50)];
    payPassBgView.backgroundColor = [UIColor whiteColor];
    [_bgView addSubview:payPassBgView];
    
    UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
    payLabel.text = @"支付密码";
    payLabel.textColor = [MyTool colorWithString:@"333333"];
    payLabel.font = [UIFont systemFontOfSize:15];
    [payPassBgView addSubview:payLabel];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW - 15 - 6, 20, 6, 10)];
    imageV.image = [UIImage imageNamed:@"箭头"];
    [payPassBgView addSubview:imageV];
    
    UITapGestureRecognizer *payPassWTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(payPassWTap:)];
    [payPassBgView addGestureRecognizer:payPassWTap];
    
    
    UIButton *withdrawBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    withdrawBtn.frame = CGRectMake(15, CGRectGetMaxY(payPassBgView.frame) + 40, kScreenW - 30, 45);
    [withdrawBtn setTitle:@"提现到微信号" forState:UIControlStateNormal];
    withdrawBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    withdrawBtn.backgroundColor = [MyTool colorWithString:@"ff3f53"];
    withdrawBtn.layer.masksToBounds = YES;
    withdrawBtn.layer.cornerRadius = 3;
    [withdrawBtn addTarget:self action:@selector(withdrawBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:withdrawBtn];
    
}

#pragma mark - 支付密码
- (void)payPassWTap:(UITapGestureRecognizer *)tap
{
    if ([_dic[@"has_set_pwd"] isEqualToString:@"1"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定修改支付密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
        alertView.tag = 1000;
        [alertView show];
    } else {
        SettingPassWordViewController *settingPWVC = [[SettingPassWordViewController alloc] init];
        settingPWVC.navigationItem.title = @"设置支付密码";
        [self.navigationController pushViewController:settingPWVC animated:YES];
    }
}

#pragma mark - 提现
- (void)withdrawBtnAction:(UIButton *)btn
{
    if ([_dic[@"money"] floatValue] < [_dic[@"withdraw_money_min"] floatValue]) {
        [MyTool showHUDWithStr:@"余额需大于或等于100元才可提现"];
    } else if (![_dic[@"has_bind_wechat"] isEqualToString:@"1"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"将提现到微信钱包中\n因此需要绑定微信号哦" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即绑定", nil];
        alertView.tag = 2000;
        [alertView show];
    } else if (![_dic[@"has_set_pwd"] isEqualToString:@"1"]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"需设置支付密码后才可提现哦" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置支付密码", nil];
        alertView.tag = 3000;
        [alertView show];
    } else {
        WithdrawalViewController *withdrawalVC = [[WithdrawalViewController alloc] init];
        withdrawalVC.wechat_nickname = _dic[@"wechat_nickname"];
        withdrawalVC.moneyStr = _dic[@"money"];
        withdrawalVC.withdraw_money_min = _dic[@"withdraw_money_min"];
        withdrawalVC.phoneStr = _dic[@"phone"];
        [self.navigationController pushViewController:withdrawalVC animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (alertView.tag == 1000) {
            SettingPassWordViewController *settingPWVC = [[SettingPassWordViewController alloc] init];
            settingPWVC.navigationItem.title = @"验证手机号";
            settingPWVC.phoneStr = _dic[@"phone"];
            [self.navigationController pushViewController:settingPWVC animated:YES];
        } else if (alertView.tag == 2000) {
            if ([WXApi isWXAppInstalled]) {
                SendAuthReq *req = [[SendAuthReq alloc] init];
                req.scope = @"snsapi_userinfo";
                req.state = @"范团";
                [WXApi sendReq:req];
            }
        } else if (alertView.tag == 3000) {
            SettingPassWordViewController *settingPWVC = [[SettingPassWordViewController alloc] init];
            settingPWVC.navigationItem.title = @"设置支付密码";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:settingPWVC animated:YES];
            });
        }
    }
}


- (void)getWalletData
{
    NSString *urlStr = [NetRequest WalletBalance];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken]};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [self endLoading];
        if ([[JSON objectForKeyNotNull:@"error"] integerValue] == 0) {
            _dic = JSON[@"data"];
            [self createUI];
        }
    } failure:^(NSError *error) {
        [self endLoading];
    }];
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:reloadWalletView object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:reloadWalletViewData object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
