//
//  CircleModel.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/3/5.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "CircleModel.h"


@implementation CircleModel



@end

@implementation Data


// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"circles" : [CirclesModel class],
             @"list" : [ListModel class],
             @"reply" : [Comment class],
             @"follow_circles" : [Comment class],
             @"contents" :[ListModel class],
             @"comment_list":[ListModel class],
             @"like_list":[ListModel class],
             @"banner":[ListModel class],
             @"notmiss":[ListModel class],
              };
}
@end
@implementation Comment


@end
@implementation Paging



@end
@implementation User



@end
@implementation Reply_object



@end
@implementation Banner



@end
