//
//  UITableView+reloadDataAnimated.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/5/7.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "UITableView+reloadDataAnimated.h"

@implementation UITableView (reloadDataAnimated)
- (void)reloadDataWithAnimated:(BOOL)animated
{
    [self reloadData];
    
    if (animated) {
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionFade];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [animation setDuration:0.3];
        [[self layer] addAnimation:animation forKey:@"UITableViewReloadDataAnimationKey"];
    }
}

@end
