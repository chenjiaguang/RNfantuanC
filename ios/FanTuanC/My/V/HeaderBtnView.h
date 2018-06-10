//
//  HeaderBtnView.h
//  FanTuanC
//
//  Created by 梁其运 on 2018/3/27.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderBtnView : UIView

@property (nonatomic, assign) BOOL has_new_fans;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end
