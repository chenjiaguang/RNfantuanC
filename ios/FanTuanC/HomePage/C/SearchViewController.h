//
//  SearchViewController.h
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/8.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "BaseViewController.h"
#import "HomeSearchTableViewCell.h"
#import "SearchListViewController.h"

@interface SearchViewController : BaseViewController <UISearchBarDelegate, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL isSearchList;
@property (nonatomic, strong) NSString *searchBarText;

@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;

@property (nonatomic, strong) NSMutableArray *merchant_hotsArr;
@property (nonatomic, strong) NSMutableArray *mall_hotsArr;

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *listArr;

@end
