//
//  WithdrawalViewController.h
//  FanTuanC
//
//  Created by 梁其运 on 2018/1/9.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "ChildBaseViewController.h"

@interface WithdrawalViewController : ChildBaseViewController <UITextFieldDelegate>

@property (nonatomic, strong) NSString *wechat_nickname;
@property (nonatomic, strong) NSString *withdraw_money_min;
@property (nonatomic, strong) NSString *moneyStr;
@property (nonatomic, strong) NSString *phoneStr;

@end
