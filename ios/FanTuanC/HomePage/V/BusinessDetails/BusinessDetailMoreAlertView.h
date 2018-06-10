//
//  BusinessDetailMoreAlertView.h
//  FanTuanC
//
//  Created by 梁其运 on 2018/1/4.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoreAlertViewDelegate <NSObject>

- (void)cellGetBtnAction:(UIButton *)btn;
- (void)cellBuyBtnAction:(UIButton *)btn;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface BusinessDetailMoreAlertView : UIView <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) id <MoreAlertViewDelegate> delegate;

@property (nonatomic, assign) NSInteger sectionInt;

- (instancetype)initWithFrame:(CGRect)frame titleDic:(NSDictionary *)dic;

@end
