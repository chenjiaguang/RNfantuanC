//
//  NewsPicBottomView.h
//  FanTuanC
//
//  Created by 梁其运 on 2018/3/28.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"

@interface NewsPicBottomView : UIView
@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) void(^commentBlock)(void);

@end
