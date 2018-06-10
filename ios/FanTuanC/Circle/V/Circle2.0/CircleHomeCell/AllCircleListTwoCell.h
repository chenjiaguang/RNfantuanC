//
//  AllCircleListTwoCell.h
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/5/4.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AllCircleListCellDelegate<NSObject>
- (void)selectedFousButtonWithCell:(UIButton *)btn;

@end
@interface AllCircleListTwoCell : UITableViewCell
@property(nonatomic,strong)ListModel *model;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,weak)id<AllCircleListCellDelegate> delegate;

@end
