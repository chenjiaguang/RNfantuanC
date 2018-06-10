//
//  NewsTableViewController.h
//  FanTuanC
//
//  Created by 梁其运 on 2018/1/29.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "BaseViewController.h"

@interface NewsTableViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *total;

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *listArr;

@property (nonatomic, assign) BOOL isUpLoading;
@property (nonatomic, assign) NSInteger pageNum;

- (void)reloadNewsData;

@end
