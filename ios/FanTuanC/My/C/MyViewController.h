//
//  MyViewController.h
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/3.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "BaseViewController.h"
#import "MyListTableViewCell.h"
#import "SettingViewController.h"
#import "WalletViewController.h"
#import "InviterViewController.h"

@interface MyViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *listArr;

@end
