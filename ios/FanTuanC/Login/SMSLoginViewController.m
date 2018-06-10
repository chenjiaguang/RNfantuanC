//
//  SMSLoginViewController.m
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/3.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "SMSLoginViewController.h"
#import "JPUSHService.h"

@interface SMSLoginViewController ()
@property (nonatomic, strong) UITextField *phoneTextF;
@property (nonatomic, strong) UITextField *codeTextF;
@property (nonatomic, strong) UIButton *sendBtn;
@end

@implementation SMSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"短信验证码登录";
    [self createUI];
}

- (void)createUI
{
    _phoneTextF = [[UITextField alloc] initWithFrame:CGRectMake(15, 30, kScreenW - 30, 45)];
    _phoneTextF.backgroundColor = [MyTool colorWithString:@"f5f5f5"];
    _phoneTextF.textColor = [MyTool colorWithString:@"333333"];
    _phoneTextF.placeholder = @"请输手机号";
    [_phoneTextF setValue:[MyTool colorWithString:@"999999"] forKeyPath:@"_placeholderLabel.textColor"];
    [_phoneTextF setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    _phoneTextF.layer.cornerRadius = 3;
    _phoneTextF.font = [UIFont systemFontOfSize:15];
    _phoneTextF.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_phoneTextF];
    
    UIImageView *phoneImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 71, 45)];
    phoneImageV.image = [UIImage imageNamed:@"+86"];
    _phoneTextF.leftView = phoneImageV;
    _phoneTextF.leftViewMode = UITextFieldViewModeAlways;
    _phoneTextF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.frame = CGRectMake(kScreenW - 15 - 100, _phoneTextF.frame.size.height + _phoneTextF.frame.origin.y + 20, 100, 45);
    _sendBtn.backgroundColor = [MyTool colorWithString:@"ff3f53"];
    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _sendBtn.layer.masksToBounds = YES;
    _sendBtn.layer.cornerRadius = 3;
    [_sendBtn addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendBtn];
    
    
    _codeTextF = [[UITextField alloc] initWithFrame:CGRectMake(15, _sendBtn.frame.origin.y, kScreenW - 30 - _sendBtn.frame.size.width - 10, 45)];
    _codeTextF.backgroundColor = [MyTool colorWithString:@"f5f5f5"];
    _codeTextF.textColor = [MyTool colorWithString:@"333333"];
    _codeTextF.placeholder = @"请输入验证码";
    [_codeTextF setValue:[MyTool colorWithString:@"999999"] forKeyPath:@"_placeholderLabel.textColor"];
    [_codeTextF setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    _codeTextF.layer.cornerRadius = 3;
    _codeTextF.font = [UIFont systemFontOfSize:15];
    _codeTextF.keyboardType = UIKeyboardTypeNumberPad;
    _codeTextF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 45)];
    _codeTextF.leftViewMode = UITextFieldViewModeAlways;
    _codeTextF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:_codeTextF];
    
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _codeTextF.frame.origin.y + 45 + 10, kScreenW - 30, 14)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.text = @"未注册的手机号将在登录后自动注册";
    textLabel.textColor = [MyTool colorWithString:@"666666"];
    textLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:textLabel];
    
    
    UIButton *notReceiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    notReceiveBtn.frame = CGRectMake(_sendBtn.frame.origin.x, textLabel.frame.origin.y, 100, 14);
    [notReceiveBtn setTitle:@"收不到验证码" forState:UIControlStateNormal];
    notReceiveBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [notReceiveBtn setTitleColor:[MyTool colorWithString:@"3599ff"] forState:UIControlStateNormal];
    [notReceiveBtn addTarget:self action:@selector(notReceiveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:notReceiveBtn];
    
    
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    okBtn.frame = CGRectMake(15, textLabel.frame.origin.y + 14 + 30, kScreenW - 30, 45);
    okBtn.backgroundColor = [MyTool colorWithString:@"ff3f53"];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    okBtn.layer.masksToBounds = YES;
    okBtn.layer.cornerRadius = 3;
    [okBtn addTarget:self action:@selector(okBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:okBtn];
    
    
    UIButton *phoneLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneLoginBtn.frame = CGRectMake(0, okBtn.frame.origin.y + 45 + 30, kScreenW, 12);
    phoneLoginBtn.backgroundColor = [UIColor clearColor];
    phoneLoginBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [phoneLoginBtn setTitle:@"使用密码登录" forState:UIControlStateNormal];
    [phoneLoginBtn setTitleColor:[MyTool colorWithString:@"ff3f53"] forState:UIControlStateNormal];
    [phoneLoginBtn addTarget:self action:@selector(phoneLoginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneLoginBtn];
    
}

- (void)phoneLoginBtnAction:(UIButton *)btn
{
    PhoneLoginViewController *phoneLoginVC = [[PhoneLoginViewController alloc] init];
    [self.navigationController pushViewController:phoneLoginVC animated:YES];
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

#pragma mark - 收不到验证码
- (void)notReceiveBtnAction:(UIButton *)btn
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请联系客服处理" message:@"客服电话：400-3663-2552" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:actionConfirm];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)okBtnAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    if ([_phoneTextF.text isEqualToString:@""]) {
        [MyTool showHUDWithStr:@"请输入手机号"];
    } else if (![MyTool phoneNumberIsLegal:_phoneTextF.text]) {
        [MyTool showHUDWithStr:@"请输入正确手机号"];
    } else if ([_codeTextF.text isEqualToString:@""]) {
        [MyTool showHUDWithStr:@"请输入验证码"];
    } else {
        [self LoginVcode];
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
            
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [MyTool showHUDWithStr:JSON[@"msg"]];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:webViewLoginCallBack object:JSON];
        
    } failure:^(NSError *error) {
        [self endLoading];
    }];
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
                _sendBtn.backgroundColor = [MyTool colorWithString:@"ff3f53"];
                _sendBtn.userInteractionEnabled = YES;
            });
        } else {
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [_sendBtn setTitle:[NSString stringWithFormat:@"重新获取(%.2d)", seconds] forState:UIControlStateNormal];
                _sendBtn.backgroundColor = [MyTool colorWithString:@"bbbbbb"];
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
