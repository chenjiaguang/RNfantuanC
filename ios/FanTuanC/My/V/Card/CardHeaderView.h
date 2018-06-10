//
//  CardHeaderView.h
//  FanTuanC
//
//  Created by 梁其运 on 2018/3/2.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYPiecewiseView.h"

@interface CardHeaderView : UIView

@property (nonatomic, assign) BOOL isNews;

@property (nonatomic, strong) UIImageView *BgImgV;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIImageView *headerImgV;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *introStr;
@property (nonatomic, strong) NSString *followNum;
@property (nonatomic, strong) NSString *fansNum;

@property (nonatomic, strong) QYPiecewiseView *piecewiseView;

- (instancetype)initWithFrame:(CGRect)frame titleArr:(NSArray *)titleArr defaultIndex:(NSInteger)defaultIndex;

@end
