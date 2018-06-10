//
//  ListModel.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/3/5.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"covers":[ListModel class],
             };
}
@end
@implementation Cover



@end

@implementation Replys

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"list":[ListModel class],
             };
}

@end
@implementation List



@end
