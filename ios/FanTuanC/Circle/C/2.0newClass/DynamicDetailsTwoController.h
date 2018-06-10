//
//  DynamicDetailsTwoController.h
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/5/9.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicDetailsTwoController : ChildBaseViewController

@property(nonatomic,strong)ListModel *model;

@property(nonatomic,copy)NSString *firstCommentId;
@property(nonatomic,copy)NSString *article_id;
@property(nonatomic,assign)BOOL is_reply;

@end
