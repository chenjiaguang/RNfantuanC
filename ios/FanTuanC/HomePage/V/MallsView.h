//
//  MallsView.h
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/24.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MallsView : UIView

@property (nonatomic, strong) UIButton *bgImageBtn;

- (instancetype)initWithFrame:(CGRect)frame imageUrl:(NSString *)imageUrl name:(NSString *)nameStr distance:(NSString *)distance;

@end
