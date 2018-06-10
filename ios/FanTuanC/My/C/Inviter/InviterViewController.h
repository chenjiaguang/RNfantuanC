//
//  InviterViewController.h
//  FanTuanC
//
//  Created by 梁其运 on 2018/1/11.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "ChildBaseViewController.h"

@interface InviterViewController : ChildBaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *listArr;

@end
