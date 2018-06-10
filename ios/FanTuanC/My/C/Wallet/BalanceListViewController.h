//
//  BalanceListViewController.h
//  FanTuanC
//
//  Created by 梁其运 on 2018/1/9.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "ChildBaseViewController.h"

@interface BalanceListViewController : ChildBaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, assign) NSInteger pageNum;

@end
