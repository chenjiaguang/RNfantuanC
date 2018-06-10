//
//  DynamicDetailsOnePictureCell.h
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/5/9.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicDetailsOnePictureCell : UITableViewCell
@property(nonatomic,strong)ListModel *model;
@property (nonatomic, strong) NSArray <ListModel *> *like_list;
@property (nonatomic, strong) UIButton *commentsbnt;
@property (nonatomic, copy) void (^praiseButtonClickedBlock)(UIButton *praiseButton);
@property (nonatomic, copy) void (^fousButtonClickedBlock)(UIButton *fousButton);

@end
