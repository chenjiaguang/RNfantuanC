//
//  BaseViewController.h
//  FanTuanSJ
//
//  Created by 冫柒Yun on 2017/8/28.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)loadingWithText:(NSString *)text;
- (void)endLoading;
- (void)hidesTabBar:(BOOL)hidden;

@end
