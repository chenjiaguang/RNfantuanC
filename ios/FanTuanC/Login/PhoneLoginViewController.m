//
//  PhoneLoginViewController.m
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/3.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "PhoneLoginViewController.h"
#import "JPUSHService.h"
#import "RootTabBarController.h"

@interface PhoneLoginViewController ()
@property (nonatomic, strong) UITextField *phoneTextF;
@property (nonatomic, strong) UITextField *passWordTextF;
@property (nonatomic, strong) UIButton *visibleBtn;
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation PhoneLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"账号密码登录";
    [self createUI];
    
}

- (void)createUI
{
    _phoneTextF = [[UITextField alloc] initWithFrame:CGRectMake(40, 25, kScreenW - 80, 52)];
    _phoneTextF.backgroundColor = [UIColor clearColor];
    _phoneTextF.textColor = [MyTool colorWithString:@"333333"];
    _phoneTextF.placeholder = @"请输手机号";
    [_phoneTextF setValue:[MyTool colorWithString:@"999999"] forKeyPath:@"_placeholderLabel.textColor"];
    [_phoneTextF setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    _phoneTextF.font = [UIFont systemFontOfSize:15];
    _phoneTextF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_phoneTextF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_phoneTextF];
    
    UIImageView *phoneImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 59, 20)];
    phoneImageV.image = [UIImage imageNamed:@"+86黑"];
    _phoneTextF.leftView = phoneImageV;
    _phoneTextF.leftViewMode = UITextFieldViewModeAlways;
    _phoneTextF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UIButton *clearButton = [_phoneTextF valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage imageNamed:@"手机号删除灰"] forState:UIControlStateNormal];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_phoneTextF.frame), kScreenW - 60, 0.5)];
    line.backgroundColor = [MyTool colorWithString:@"BBBBBB"];
    [self.view addSubview:line];
    
    
    
    _visibleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _visibleBtn.frame = CGRectMake(kScreenW - 36 - 21, CGRectGetMaxY(_phoneTextF.frame) + 12, 21, 52);
    [_visibleBtn setImage:[UIImage imageNamed:@"密码闭眼"] forState:UIControlStateNormal];
    [_visibleBtn setImage:[UIImage imageNamed:@"密码睁眼"] forState:UIControlStateSelected];
    _visibleBtn.selected = NO;
    [_visibleBtn addTarget:self action:@selector(visibleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_visibleBtn];
    
    
    _passWordTextF = [[UITextField alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(_phoneTextF.frame) + 12, kScreenW - 76 -21 -15, 52)];
    _passWordTextF.backgroundColor = [UIColor clearColor];
    _passWordTextF.textColor = [MyTool colorWithString:@"333333"];
    _passWordTextF.placeholder = @"请输入密码";
    [_passWordTextF setValue:[MyTool colorWithString:@"999999"] forKeyPath:@"_placeholderLabel.textColor"];
    [_passWordTextF setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    _passWordTextF.font = [UIFont systemFontOfSize:15];
    _passWordTextF.secureTextEntry = YES;
    _passWordTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_passWordTextF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_passWordTextF];
    
    UIButton *clearButton1 = [_passWordTextF valueForKey:@"_clearButton"];
    [clearButton1 setImage:[UIImage imageNamed:@"手机号删除灰"] forState:UIControlStateNormal];
    
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_passWordTextF.frame), kScreenW - 60, 0.5)];
    line1.backgroundColor = [MyTool colorWithString:@"BBBBBB"];
    [self.view addSubview:line1];
    
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(30, CGRectGetMaxY(line1.frame) + 40, kScreenW - 60, 45);
    _loginBtn.backgroundColor = [MyTool colorWithString:@"97DBFF"];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 3;
    [_loginBtn addTarget:self action:@selector(okBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
}

- (void)textFieldDidChange:(UIButton *)btn
{
    if (_phoneTextF.text.length != 0 && _passWordTextF.text.length != 0) {
        _loginBtn.backgroundColor = [MyTool colorWithString:@"1EB0FD"];
    } else {
        _loginBtn.backgroundColor = [MyTool colorWithString:@"97DBFF"];
    }
}

- (void)visibleBtnAction:(UIButton *)btn
{
    _passWordTextF.secureTextEntry = _visibleBtn.isSelected;
    _visibleBtn.selected = !_visibleBtn.isSelected;
}

- (void)okBtnAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    if ([_phoneTextF.text isEqualToString:@""]) {
        [MyTool showHUDWithStr:@"请输入手机号"];
    } else if ([_passWordTextF.text isEqualToString:@""]) {
        [MyTool showHUDWithStr:@"请输入密码"];
    } else {
        [self Login];
    }
}

- (void)Login
{
    [self loadingWithText:@"登录中"];
    NSString *urlStr = [NetRequest Login];
    NSDictionary *paramsDic = @{@"phone": _phoneTextF.text, @"password": _passWordTextF.text};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [self endLoading];
        if ([[JSON objectForKeyNotNull:@"error"] integerValue] == 0) {
            
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserHasLogin];
            [[NSUserDefaults standardUserDefaults] setObject:JSON[@"data"][@"token"] forKey:kToken];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:reloadOrderListView object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:reloadBusinessDetailsView object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:reloadNewsTitleList object:nil];
            
            [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
                if(resCode == 0){
                    NSLog(@"registrationID获取成功：%@",registrationID);
                    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] == YES) {
                        NSString *urlStr = [NetRequest PushBind];
                        NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"push_token": registrationID, @"platform": @"2"};
                        [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
                            if ([[JSON objectForKeyNotNull:@"error"] integerValue] == 0) {
                                NSLog(@"%@", JSON[@"msg"]);
                            }
                        } failure:^(NSError *error) {
                        }];
                    }
                }
                else{
                    NSLog(@"registrationID获取失败，code：%d",resCode);
                }
            }];
            
            ApplicationDelegate.window.rootViewController = [[RootTabBarController alloc] init];
        } else {
            [MyTool showHUDWithStr:JSON[@"msg"]];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:webViewLoginCallBack object:JSON];
        
    } failure:^(NSError *error) {
        [self endLoading];
    }];
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
