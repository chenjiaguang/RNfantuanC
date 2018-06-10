//
//  ShoppingCenterViewController.h
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/7.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "ChildBaseViewController.h"
#import "ShoppingCenterTableViewCell.h"
#import "LBBanner.h"

@interface ShoppingCenterViewController : ChildBaseViewController<UITableViewDelegate, UITableViewDataSource, LBBannerDelegate>

@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *listArr;

@end
