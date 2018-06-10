//
//  SelectRangeViewController.h
//  FanTuanC
//
//  Created by 梁其运 on 2018/5/16.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "ChildBaseViewController.h"

@interface SelectRangeViewController : ChildBaseViewController

@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) void(^SelectRangeBlock)(NSInteger selectIndex);

@end
