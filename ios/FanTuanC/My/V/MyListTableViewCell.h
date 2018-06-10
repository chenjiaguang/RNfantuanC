//
//  MyListTableViewCell.h
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/3.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *myImgaeV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowsImage;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UILabel *contentLabel;

- (void)setNumLabelText:(NSString *)numStr;

@end
