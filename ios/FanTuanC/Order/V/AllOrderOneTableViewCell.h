//
//  AllOrderOneTableViewCell.h
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/27.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllOrderOneTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIImageView *headerImageV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *refundImageV;
@property (nonatomic, strong) UILabel *memoyLabel;
@property (nonatomic, strong) UIButton *myBtton;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(NSString *)type;


@end
