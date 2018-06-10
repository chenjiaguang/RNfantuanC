//
//  ClassifyViewController.h
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/3.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "ChildBaseViewController.h"
#import "ClassifyTableViewCell.h"
#import "ClassifyCollectionViewCell.h"

@interface ClassifyViewController : ChildBaseViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UITableView *listTabelView;
@property (nonatomic, strong) UICollectionView *detailCollecionView;
@property (nonatomic, strong) NSMutableArray *detailArr;
@property (nonatomic, strong) NSMutableArray *allCassifyArr;
@property (nonatomic, strong) NSMutableDictionary *allDic;

@property (nonatomic, assign) NSInteger row;

@end
