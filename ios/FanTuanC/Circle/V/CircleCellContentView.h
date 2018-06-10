//
//  CircleCellContentView.h
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/3/1.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CircleCellContentView : UIView
@property(nonatomic,strong)UIView *multipleBgView;
@property(nonatomic,strong)UILabel *sourceLabel;
@property(nonatomic,strong)UIButton *commentsbnt;
@property(nonatomic,assign)NSDictionary *dataDic;
@property(nonatomic,strong)Data *model;

@end
