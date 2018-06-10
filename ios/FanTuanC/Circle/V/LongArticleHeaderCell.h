//
//  LongArticleHeaderCell.h
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/4/23.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LongArticleHeaderCell : UITableViewCell

@property(nonatomic,strong)Data *model;

@property (nonatomic, copy) void (^fousButtonClickedBlock)(UIButton *fousButton);

@end
