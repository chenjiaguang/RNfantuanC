//
//  MyCardViewController.h
//  FanTuanC
//
//  Created by 梁其运 on 2018/3/2.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "ChildBaseViewController.h"

@interface MyCardViewController : ChildBaseViewController

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, assign) BOOL isNews;
@property (nonatomic, assign) NSInteger type;
//@property (nonatomic, assign) BOOL has_articles;
@property (nonatomic, strong) NSString *titleStr;

@property (nonatomic, assign) NSInteger pageNum;

// 切换标签
@property (nonatomic, assign) BOOL isChangeType;

@end
