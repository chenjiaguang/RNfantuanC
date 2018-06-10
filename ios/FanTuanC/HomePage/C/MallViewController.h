//
//  MallViewController.h
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/29.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "ChildBaseViewController.h"

@interface MallViewController : ChildBaseViewController <UITableViewDelegate, UITableViewDataSource, LQYDropMenuViewDelegate, LQYDropMenuViewDataSource>

@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, assign) BOOL isUpLoading;
@property (nonatomic, assign) NSInteger pageNum;

@end
