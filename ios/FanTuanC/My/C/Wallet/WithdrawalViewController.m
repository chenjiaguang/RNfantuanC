//
//  WithdrawalViewController.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/1/9.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "WithdrawalViewController.h"
#import "PayPasswordView.h"

@interface WithdrawalViewController ()
{
    UITextField *_moneyTextF;
}
@property (nonatomic, strong) PayPasswordView *payPasswordV;


@end

@implementation WithdrawalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"余额提现";
    [self createUI];
    
}

- (void)createUI
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 45)];
    label.backgroundColor = [MyTool colorWithString:@"fff9dd"];
    label.text = @"金额将打到您绑定的微信钱包中";
    label.textColor = [MyTool colorWithString:@"ff3f53"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    
    
    UILabel *txLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label.frame), kScreenW - 30, 50)];
    txLabel.textColor = [MyTool colorWithString:@"333333"];
    txLabel.text = @"提现至";
    txLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:txLabel];
    
    UILabel *wxNameLabel = [[UILabel alloc] initWithFrame:txLabel.frame];
    wxNameLabel.textColor = [MyTool colorWithString:@"333333"];
    wxNameLabel.text = [NSString stringWithFormat:@"微信昵称：%@", _wechat_nickname];
    wxNameLabel.font = [UIFont systemFontOfSize:15];
    wxNameLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:wxNameLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(wxNameLabel.frame), kScreenW, 10)];
    line.backgroundColor = [MyTool colorWithString:@"f5f5f5"];
    [self.view addSubview:line];
    
    
    
    UILabel *txjeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(line.frame) + 20, kScreenW - 30, 15)];
    txjeLabel.textColor = [MyTool colorWithString:@"333333"];
    txjeLabel.text = @"提现金额";
    txjeLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:txjeLabel];
    
    UILabel *RMBLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(txjeLabel.frame) + 17, 35, 46)];
    RMBLabel.text = @"￥";
    RMBLabel.textColor = [MyTool colorWithString:@"333333"];
    RMBLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:40];
    [self.view addSubview:RMBLabel];
    
    
    _moneyTextF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(RMBLabel.frame), RMBLabel.frame.origin.y, kScreenW - 30 - CGRectGetMaxX(RMBLabel.frame), RMBLabel.frame.size.height)];
    _moneyTextF.textColor = [MyTool colorWithString:@"333333"];
    _moneyTextF.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:40];
    _moneyTextF.keyboardType = UIKeyboardTypeDecimalPad;
    [_moneyTextF addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    _moneyTextF.delegate = self;
    [self.view addSubview:_moneyTextF];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_moneyTextF.frame) + 6, kScreenW - 30, 0.5)];
    line1.backgroundColor = [MyTool colorWithString:@"bbbbbb"];
    [self.view addSubview:line1];
    
    UILabel *qbyeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(line1.frame) + 10, 72, 14)];
    qbyeLabel.text = @"钱包余额：";
    qbyeLabel.textColor = [MyTool colorWithString:@"666666"];
    qbyeLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:qbyeLabel];
    
    UILabel *yueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(qbyeLabel.frame), qbyeLabel.frame.origin.y, 100, qbyeLabel.frame.size.height)];
    yueLabel.text = [NSString stringWithFormat:@"￥%@", _moneyStr];
    yueLabel.textColor = [MyTool colorWithString:@"333333"];
    yueLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    [self.view addSubview:yueLabel];
    
    UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allBtn.frame = CGRectMake(kScreenW - 15 - 60, yueLabel.frame.origin.y, 60, 14);
    [allBtn setTitle:@"全部提现" forState:UIControlStateNormal];
    [allBtn setTitleColor:[MyTool colorWithString:@"0076FF"] forState:UIControlStateNormal];
    allBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    allBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [allBtn addTarget:self action:@selector(allBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allBtn];
    
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(15, CGRectGetMaxY(allBtn.frame) + 50, kScreenW - 30, 45);
    okBtn.backgroundColor = [MyTool colorWithString:@"ff3f53"];
    [okBtn setTitle:@"确认提现" forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    okBtn.layer.cornerRadius = 3;
    [okBtn addTarget:self action:@selector(okBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
}

#pragma mark - 输入框数据
- (void)textFieldWithText:(UITextField *)textField
{
    if ([textField.text isEqualToString:@"."]) {
        _moneyTextF.text = @"0.";
    }
    _moneyTextF.text = [MyTool textFiledEditChangedWith:textField MaxLength:9];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //如果输入的是“.”  判断之前已经有"."
    if ([string isEqualToString:@"."] && ([textField.text rangeOfString:@"."].location != NSNotFound)) {
        return NO;
    }
    //拼出输入完成的str,判断str的长度大于等于“.”的位置＋4,则返回false,此次插入string失败 （"379132.424",长度10,"."的位置6, 10>=6+4）
    NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
    [str insertString:string atIndex:range.location];
    if (str.length >= [str rangeOfString:@"."].location + 4){
        return NO;
    }
    return YES;
}

#pragma mark - 全部提现
- (void)allBtnAction:(UIButton *)btn
{
    _moneyTextF.text = _moneyStr;
}

#pragma mark - 确认提现
- (void)okBtnAction:(UIButton *)btn
{
    if ([_moneyTextF.text floatValue] < [_withdraw_money_min floatValue]) {
        [MyTool showHUDWithStr:[NSString stringWithFormat:@"提现金额需大于等于%@元", _withdraw_money_min]];
    } else if ([_moneyTextF.text floatValue] > [_moneyStr floatValue]) {
        [MyTool showHUDWithStr:@"提现金额大于账户余额"];
    } else {
        _payPasswordV = [[PayPasswordView alloc] initWithFrame:[[UIScreen mainScreen] bounds] moneyStr:_moneyTextF.text];
        [ApplicationDelegate.window addSubview:_payPasswordV];
        
        
        WeakSelf(weakSelf);
        _payPasswordV.forgetBtnAction = ^{
            SettingPassWordViewController *settingPWVC = [[SettingPassWordViewController alloc] init];
            settingPWVC.navigationItem.title = @"验证手机号";
            settingPWVC.phoneStr = weakSelf.phoneStr;
            [weakSelf.navigationController pushViewController:settingPWVC animated:YES];
        };
        
        _payPasswordV.passwordAction = ^(NSString *password) {
            NSLog(@"支付密码:%@", password);
            [weakSelf getWalletBalanceCashoutWithPwd:password];
        };
    }
}

- (void)getWalletBalanceCashoutWithPwd:(NSString *)pwd
{
    [self loadingWithText:@"提现中"];
    NSString *urlStr = [NetRequest WalletBalanceCashout];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"money": _moneyTextF.text, @"pwd": pwd};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [self endLoading];
        if ([[JSON objectForKeyNotNull:@"error"] integerValue] == 0) {
            [MyTool showHUDWithStr:JSON[@"msg"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:reloadWalletViewData object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self createErrorAlert];
        }
    } failure:^(NSError *error) {
        [self endLoading];
    }];
}

- (void)createErrorAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"支付密码错误"   message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"忘记密码" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        SettingPassWordViewController *settingPWVC = [[SettingPassWordViewController alloc] init];
        settingPWVC.navigationItem.title = @"验证手机号";
        settingPWVC.phoneStr = _phoneStr;
        [self.navigationController pushViewController:settingPWVC animated:YES];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.payPasswordV.pv clearPassword];
        [self.payPasswordV.pv beginInput];
        self.payPasswordV.hidden = NO;
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
