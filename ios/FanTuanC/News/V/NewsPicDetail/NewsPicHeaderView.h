//
//  NewsPicHeaderView.h
//  FanTuanC
//
//  Created by 梁其运 on 2018/3/28.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsPicHeaderView : UIView

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) UIImageView *headImageV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *followBtn;

@end
