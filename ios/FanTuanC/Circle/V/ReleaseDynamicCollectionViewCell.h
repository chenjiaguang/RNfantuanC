//
//  ReleaseDynamicCollectionViewCell.h
//  FanTuanC
//
//  Created by 梁其运 on 2018/3/12.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReleaseDynamicCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILabel *gifLable;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) id asset;
@property (nonatomic, strong) UILabel *themeLabel;
- (UIView *)snapshotView;

@end
