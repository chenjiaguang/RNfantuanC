//
//  WeixinInforViewController.m
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/10.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "WeixinInforViewController.h"

@interface WeixinInforViewController ()

@end

@implementation WeixinInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"微信绑定";
    self.view.backgroundColor = [MyTool colorWithString:@"f5f5f5"];
    
    [self createUI];
}

- (void)createUI
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kScreenW, 160)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 60)];
    label1.text = @"微信头像";
    label1.textColor = [MyTool colorWithString:@"333333"];
    label1.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:label1];
    
    UIImageView *headerImageV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW - 15 - 40, 10, 40, 40)];
    headerImageV.layer.masksToBounds = YES;
    headerImageV.layer.cornerRadius = 40 / 2;
    headerImageV.contentMode = UIViewContentModeScaleAspectFill;
    headerImageV.backgroundColor = [UIColor clearColor];
    [headerImageV sd_setImageWithURL:[NSURL URLWithString:_weixinDic[@"avatar"]] placeholderImage:nil];
    [bgView addSubview:headerImageV];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15, 59.5, kScreenW - 30, 0.5)];
    line1.backgroundColor = [MyTool colorWithString:@"e1e1e1"];
    [bgView addSubview:line1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, kScreenW - 30, 50)];
    label2.text = @"微信昵称";
    label2.textColor = [MyTool colorWithString:@"333333"];
    label2.font = [UIFont systemFontOfSize:15];
    label2.backgroundColor = [UIColor clearColor];
    [bgView addSubview:label2];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 60, kScreenW - 30, 50)];
    nameLabel.text = _weixinDic[@"nickname"];
    nameLabel.textColor = [MyTool colorWithString:@"999999"];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:nameLabel];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, 109.5, kScreenW - 30, 0.5)];
    line2.backgroundColor = [MyTool colorWithString:@"e1e1e1"];
    [bgView addSubview:line2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 110, kScreenW - 30, 50)];
    label3.text = @"绑定时间";
    label3.textColor = [MyTool colorWithString:@"333333"];
    label3.font = [UIFont systemFontOfSize:15];
    label3.backgroundColor = [UIColor clearColor];
    [bgView addSubview:label3];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:label3.frame];
    dateLabel.text = _weixinDic[@"time"];
    dateLabel.textColor = [MyTool colorWithString:@"999999"];
    dateLabel.font = [UIFont systemFontOfSize:15];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textAlignment = NSTextAlignmentRight;
    [bgView addSubview:dateLabel];
    
    
    UIButton *relieveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    relieveBtn.frame = CGRectMake(15, bgView.frame.origin.y + bgView.frame.size.height + 40, kScreenW - 30, 45);
    relieveBtn.backgroundColor = [MyTool colorWithString:@"ff3f53"];
    [relieveBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
    relieveBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [relieveBtn addTarget:self action:@selector(relieveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    relieveBtn.layer.cornerRadius = 3;
    [self.view addSubview:relieveBtn];
    
}

- (void)relieveBtnAction:(UIButton *)btn
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"是否解除绑定微信号" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"解除绑定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self getUserWeixinUnbind];
    }
}

- (void)getUserWeixinUnbind
{
    [self loadingWithText:@"加载中"];
    NSString *urlStr = [NetRequest UserWeixinUnbind];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken]};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        if ([[JSON objectForKeyNotNull:@"error"] integerValue] == 0) {
            
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MyTool showHUDWithStr:JSON[@"msg"]];
        }
        [self endLoading];
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
