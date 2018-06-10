//
//  ReviewTableViewCell.h
//  FanTuanC
//
//  Created by 梁其运 on 2018/1/3.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headerImageV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) LQYStarRateView *myStarRateV;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *contentLabel;

- (void)cellChangeDataDic:(NSMutableDictionary *)Dic;
- (CGFloat)cellForHeight;

@end
