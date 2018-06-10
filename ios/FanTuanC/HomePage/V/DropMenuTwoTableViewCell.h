//
//  DropMenuTwoTableViewCell.h
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/22.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropMenuTwoTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numLabel;

- (void)setNameLabelText:(NSString *)nameText numLabelText:(NSString *)numText;

@end
