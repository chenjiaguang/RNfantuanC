//
//  HomeOnePictureCell.h
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/5/2.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeOnePictureCell : UITableViewCell
@property(nonatomic,strong) ListModel *model;
@property (nonatomic, copy) void (^praiseButtonClickedBlock)(UIButton *praiseButton);
@property (nonatomic, assign) BOOL cirleHome;

@end
