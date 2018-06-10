//
//  HomePageNewsTwoTableViewCell.h
//  FanTuanC
//
//  Created by 梁其运 on 2018/3/5.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/FLAnimatedImageView+WebCache.h>

@interface HomePageNewsTwoTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) FLAnimatedImageView *imageView1;
@property (nonatomic, strong) FLAnimatedImageView *imageView2;
@property (nonatomic, strong) FLAnimatedImageView *imageView3;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *numLabel;

- (void)setTitle:(NSString *)title imageViewArr:(NSArray *)imageViewArr author:(NSString *)author time:(NSString *)time read_num:(NSString *)read_num;

@end
