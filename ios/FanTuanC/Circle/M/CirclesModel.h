//
//  CirclesModel.h
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/3/5.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RootModel.h"

@interface CirclesModel : RootModel
@property (nonatomic, copy) ListModel *cover;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *num;

@end
