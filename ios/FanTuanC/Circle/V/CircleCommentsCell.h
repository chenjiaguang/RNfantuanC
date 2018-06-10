//
//  CircleCommentsCell.h
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/3/1.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CircleCommentsCellDelegate<NSObject>
- (void)selectedDeleteButtonWithCell:(NSIndexPath *)indexPath;

@end
@interface CircleCommentsCell : UITableViewCell
@property (nonatomic, strong) ListModel *model;
@property (nonatomic, strong) UINavigationController *navVC;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL is_delete;
@property (nonatomic,weak)id<CircleCommentsCellDelegate> delegate;

@end
