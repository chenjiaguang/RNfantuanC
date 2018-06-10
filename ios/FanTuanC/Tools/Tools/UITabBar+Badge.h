//
//  UITabBar+Badge.h
//  FanTuanC
//
//  Created by 梁其运 on 2017/12/8.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
