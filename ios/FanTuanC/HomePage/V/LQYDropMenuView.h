//
//  LQYDropMenuView.h
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/29.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreButton.h"

@interface LQYIndexPath : NSObject


@property (nonatomic,assign) NSInteger column; //区分  0 为中间的   1 是 右边的   3为左边
@property (nonatomic,assign) NSInteger row; //左边第一级的行
@property (nonatomic,assign) NSInteger item; //左边第二级的行
@property (nonatomic,assign) NSInteger rank; //左边第三级的行

+ (instancetype)twIndexPathWithColumn:(NSInteger )column
                                  row:(NSInteger )row
                                 item:(NSInteger )item
                                 rank:(NSInteger )rank;

@end

@class LQYDropMenuView;

@protocol LQYDropMenuViewDataSource <NSObject>


- (NSInteger )dropMenuView:(LQYDropMenuView *)dropMenuView numberWithIndexPath:(LQYIndexPath *)indexPath;

- (NSDictionary *)dropMenuView:(LQYDropMenuView *)dropMenuView titleWithIndexPath:(LQYIndexPath *)indexPath;


@end



@protocol LQYDropMenuViewDelegate <NSObject>


- (void)dropMenuView:(LQYDropMenuView *)dropMenuView didSelectWithIndexPath:(LQYIndexPath *)indexPath;


@end

@interface LQYDropMenuView : UIView

@property (nonatomic,weak) id<LQYDropMenuViewDataSource> dataSource;
@property (nonatomic,weak) id<LQYDropMenuViewDelegate> delegate;

@property (nonatomic, assign) NSString *otherRowStr;
@property (nonatomic, assign) NSString *leftRowStr;
@property (nonatomic, assign) NSString *left1RowStr;
@property (nonatomic, assign) NSString *rightRowStr;

@property (nonatomic, strong) NSMutableArray *categoryArr;
@property (nonatomic, strong) NSMutableArray *floorArr;
@property (nonatomic, strong) NSMutableArray *sortArr;


@property (nonatomic,strong) MoreButton *otherButton;
@property (nonatomic,strong) MoreButton *leftButton;
@property (nonatomic,strong) MoreButton *rightButton;


- (void)reloadOtherTableView;
- (void)reloadLeftTableView;
- (void)reloadRightTableView;
- (void)reloadLeft1TabelView;

@end
