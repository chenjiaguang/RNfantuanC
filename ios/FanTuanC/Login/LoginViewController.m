//
//  LoginViewController.m
//  FanTuanSJ
//
//  Created by 冫柒Yun on 2017/8/28.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "LoginViewController.h"
#import "JPUSHService.h"
#import <TTTAttributedLabel.h>
#import "UIButton+ImageTitleSpacing.h"
#import "RootTabBarController.h"

@interface LoginViewController () <TTTAttributedLabelDelegate>
{
    MBProgressHUD *_hud;
    NSString *_token;
}

@property (nonatomic, strong) UITextField *phoneTextF;
@property (nonatomic, strong) UITextField *codeTextF;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = NO;
    self.jz_navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.jz_navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self createUI];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinLogin:) name:weixinLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveLoginSuccessData) name:saveLoginSuccessData object:nil];
    
}

- (void)weixinLogin:(NSNotification *)notification
{
    [self loadingWithText:@"登录中"];
    NSString *urlStr = [NetRequest WeixinLogin];
    NSDictionary *paramsDic = @{@"code": (NSString *)[notification object]};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [self endLoading];
        
        if ([[JSON objectForKeyNotNull:@"error"] integerValue] == 0) {
            
            _token = JSON[@"data"][@"token"];
            
            // 判断是否绑定手机，不绑定需跳转绑定界面
            if (![JSON[@"data"][@"phone"] isEqualToString:@""]) {
                
                [self saveLoginSuccessData];
            } else {
                MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
                myWebVC.urlStr = JSON[@"data"][@"bind_phone_url"];
                [self.navigationController pushViewController:myWebVC animated:YES];
            }
            
        } else {
            [MyTool showHUDWithStr:JSON[@"msg"]];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:webViewLoginCallBack object:JSON];
        
    } failure:^(NSError *error) {
        [self endLoading];
    }];
    
}

// 登录成功本地处理
- (void)saveLoginSuccessData
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserHasLogin];
    [[NSUserDefaults standardUserDefaults] setObject:_token forKey:kToken];
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
    
    ApplicationDelegate.window.rootViewController = [[RootTabBarController alloc]init];
}


- (void)createUI
{
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imageV.userInteractionEnabled = YES;
    if (iPhone4) {
        imageV.image = [UIImage imageNamed:@"登录背景_4"];
    } else if (iPhone5) {
        imageV.image = [UIImage imageNamed:@"登录背景_5"];
    } else if (iPhone6) {
        imageV.image = [UIImage imageNamed:@"登录背景_6"];
    } else if (iPhone6P) {
        imageV.image = [UIImage imageNamed:@"登录背景_6P"];
    } else {
        imageV.image = [UIImage imageNamed:@"登录背景_X"];
    }
    [self.view addSubview:imageV];
    
    
    UIImageView *loginImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"登录页logo"]];
    loginImageV.frame = CGRectMake((kScreenW - 143 * Swidth) /2, 106 * Sheight, 143 * Swidth, 59 * Swidth);
    [imageV addSubview:loginImageV];
    
    
    _phoneTextF = [[UITextField alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(loginImageV.frame) + 52, kScreenW - 80, 52)];
    _phoneTextF.backgroundColor = [UIColor clearColor];
    _phoneTextF.textColor = [MyTool colorWithString:@"ffffff"];
    _phoneTextF.placeholder = @"请输手机号";
    [_phoneTextF setValue:[[MyTool colorWithString:@"ffffff"] colorWithAlphaComponent:0.45] forKeyPath:@"_placeholderLabel.textColor"];
    [_phoneTextF setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    _phoneTextF.font = [UIFont systemFontOfSize:15];
    _phoneTextF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_phoneTextF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_phoneTextF];
    
    UIImageView *phoneImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 59, 20)];
    phoneImageV.image = [UIImage imageNamed:@"+86"];
    _phoneTextF.leftView = phoneImageV;
    _phoneTextF.leftViewMode = UITextFieldViewModeAlways;
    _phoneTextF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    UIButton *clearButton = [_phoneTextF valueForKey:@"_clearButton"];
    [clearButton setImage:[UIImage imageNamed:@"手机号删除"] forState:UIControlStateNormal];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_phoneTextF.frame), kScreenW - 60, 0.5)];
    line.backgroundColor = [MyTool colorWithString:@"BBBBBB"];
    [self.view addSubview:line];
    
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.frame = CGRectMake(kScreenW - 35 - 95, CGRectGetMaxY(_phoneTextF.frame) + 12, 95, 52);
    _sendBtn.backgroundColor = [UIColor clearColor];
    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendBtn];
    
    
    _codeTextF = [[UITextField alloc] initWithFrame:CGRectMake(40, _sendBtn.frame.origin.y, kScreenW - 40 - _sendBtn.frame.size.width - 35 - 10, _phoneTextF.frame.size.height)];
    _codeTextF.backgroundColor = [UIColor clearColor];
    _codeTextF.textColor = [MyTool colorWithString:@"ffffff"];
    _codeTextF.placeholder = @"请输入验证码";
    [_codeTextF setValue:[[MyTool colorWithString:@"ffffff"] colorWithAlphaComponent:0.45] forKeyPath:@"_placeholderLabel.textColor"];
    [_codeTextF setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    _codeTextF.font = [UIFont systemFontOfSize:15];
    _codeTextF.keyboardType = UIKeyboardTypeNumberPad;
    [_codeTextF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_codeTextF];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(_sendBtn.frame.origin.x, _codeTextF.frame.origin.y + 16, 0.5, 20)];
    line2.backgroundColor = [MyTool colorWithString:@"CCCCCC"];
    [self.view addSubview:line2];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_codeTextF.frame), kScreenW - 60, 0.5)];
    line3.backgroundColor = [MyTool colorWithString:@"BBBBBB"];
    [self.view addSubview:line3];
    
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(30, CGRectGetMaxY(line3.frame) + 40, kScreenW - 60, 45);
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 3;
    _loginBtn.backgroundColor = [[MyTool colorWithString:@"1EB0FD"] colorWithAlphaComponent:0.7];
    [_loginBtn addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    
    UIButton *passWordLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    passWordLoginBtn.frame = CGRectMake(30, CGRectGetMaxY(_loginBtn.frame) + 20, kScreenW - 60, 12);
    [passWordLoginBtn setTitle:@"账号密码登录" forState:UIControlStateNormal];
    passWordLoginBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [passWordLoginBtn addTarget:self action:@selector(passWordLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:passWordLoginBtn];
    
    
    TTTAttributedLabel *label3 = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, kScreenH - 20 - 12, kScreenW, 12)];
    label3.backgroundColor = [UIColor clearColor];
    label3.textColor = [[MyTool colorWithString:@"ffffff"] colorWithAlphaComponent:0.68];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont systemFontOfSize:12];
    label3.text = @"登录即代表您已经同意范团用户协议";
    UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:12];
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
    label3.linkAttributes = @{(NSString *)kCTFontAttributeName:(__bridge id)font, (id)kCTForegroundColorAttributeName:[MyTool colorWithString:@"ffffff"], (NSString *)kCTUnderlineStyleAttributeName:[NSNumber numberWithInt:kCTUnderlineStyleSingle]};//NSForegroundColorAttributeName  不能改变颜色 必须用   (id)kCTForegroundColorAttributeName,此段代码必须在前设置
    label3.activeLinkAttributes = @{(NSString *)kCTFontAttributeName:(__bridge id)font, (id)kCTForegroundColorAttributeName:[MyTool colorWithString:@"ffffff"], (NSString *)kCTUnderlineStyleAttributeName:[NSNumber numberWithInt:kCTUnderlineStyleSingle]};
    label3.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    label3.delegate = self;
    NSRange range = [label3.text rangeOfString:@"范团用户协议"];
    [label3 addLinkToURL:[NSURL URLWithString:@"http://fant.fantuanlife.com/index.html#/user/agreement"] withRange:range];
    [imageV addSubview:label3];
    
    
    UIButton *wxLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wxLoginBtn.frame = CGRectMake(kScreen_CenterX - 25, label3.frame.origin.y - 30 - 50, 50, 50);
    [wxLoginBtn setTitle:@"微信登录" forState:UIControlStateNormal];
    [wxLoginBtn setTitleColor:[[MyTool colorWithString:@"ffffff"] colorWithAlphaComponent:0.68] forState:UIControlStateNormal];
    [wxLoginBtn setImage:[UIImage imageNamed:@"微信登录"] forState:UIControlStateNormal];
    wxLoginBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [wxLoginBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:8];
    [wxLoginBtn addTarget:self action:@selector(weixinBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wxLoginBtn];
    
    
    UIImageView *orImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"或者"]];
    orImageV.frame = CGRectMake(kScreen_CenterX - 225 / 2, wxLoginBtn.frame.origin.y - 30, 225, 12);
    [self.view addSubview:orImageV];
    
    
    if (![WXApi isWXAppInstalled]) {
        orImageV.hidden = YES;
        wxLoginBtn.hidden = YES;
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (_phoneTextF.text.length != 0 && _codeTextF.text.length != 0) {
        _loginBtn.backgroundColor = [MyTool colorWithString:@"1EB0FD"];
    } else {
        _loginBtn.backgroundColor = [[MyTool colorWithString:@"1EB0FD"] colorWithAlphaComponent:0.7];
    }
}

#pragma mark - 验证码登录
- (void)loginBtnAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    if (_phoneTextF.text.length != 0 && _codeTextF.text.length != 0) {
        [self LoginVcode];
    }
}

#pragma mark - 微信登录
- (void)weixinBtnAction:(UIButton *)btn
{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"范团";
    [WXApi sendReq:req];
}

- (void)passWordLoginBtn:(UIButton *)btn
{
    PhoneLoginViewController *phoneLoginVC = [[PhoneLoginViewController alloc] init];
    [self.navigationController pushViewController:phoneLoginVC animated:YES];
}

#pragma mark - TTTAttributedLabelDelegate
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
    myWebVC.urlStr = [NSString stringWithFormat:@"%@", url];
    [self.navigationController pushViewController:myWebVC animated:YES];
}

#pragma mark - 获取验证码
- (void)sendBtnAction:(UIButton *)btn
{
    if (![MyTool phoneNumberIsLegal:_phoneTextF.text]) {
        [MyTool showHUDWithStr:@"请输入正确手机号"];
    } else {
        NSString *urlStr = [NetRequest SmsSend];
        NSDictionary *paramsDic = @{@"phone": _phoneTextF.text};
        [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {

            [MyTool showHUDWithStr:JSON[@"msg"]];
            if ([[JSON objectForKeyNotNull:@"error"] integerValue] == 0) {
                [_codeTextF becomeFirstResponder];
                [self openCountdown];
            }
        } failure:^(NSError *error) {

        }];
    }
}

- (void)LoginVcode
{
    [self loadingWithText:@"登录中"];
    NSString *urlStr = [NetRequest LoginVcode];
    NSDictionary *paramsDic = @{@"phone": _phoneTextF.text, @"code": _codeTextF.text};
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


-(void)loadingWithText:(NSString *)text
{
    [self endLoading];
    _hud = [[MBProgressHUD alloc] initWithView:ApplicationDelegate.window];
    _hud.removeFromSuperViewOnHide = YES;
    _hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    _hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.6];
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    _hud.label.textColor = [UIColor whiteColor];
    _hud.label.text = text;
    [_hud showAnimated:YES];
    [ApplicationDelegate.window addSubview:_hud];
}
-(void)endLoading
{
    [_hud hideAnimated:YES];
    _hud.hidden=YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:weixinLogin object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:saveLoginSuccessData object:nil];
}

// 开启倒计时效果
-(void)openCountdown
{
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [_sendBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _sendBtn.userInteractionEnabled = YES;
            });
        } else {
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [_sendBtn setTitle:[NSString stringWithFormat:@"重新获取(%.2d)", seconds] forState:UIControlStateNormal];
                [_sendBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.45] forState:UIControlStateNormal];
                _sendBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
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
