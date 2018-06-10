//
//  MyFriendCell.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/3/26.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "MyFriendCell.h"

@implementation MyFriendCell
{
    UILabel *_nameLabel;
    UIImageView *_avatarIamgeView;
    UIView *_redBage;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews
{
    UIImageView *avatarIamgeView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _avatarIamgeView = avatarIamgeView;
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _nameLabel = nameLabel;
    
    UIButton *focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    focusBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _focusBtn = focusBtn;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [MyTool colorWithString:@"E1E1E1"];
    
    _redBage = [[UIView alloc] initWithFrame:CGRectZero];
    _redBage.backgroundColor = [MyTool colorWithString:@"FF3F53"];
    _redBage.layer.borderWidth = 2;
    _redBage.layer.borderColor = [MyTool colorWithString:@"FFFFFF"].CGColor;
    _redBage.hidden = YES;
    
    
    [self.contentView sd_addSubviews:@[avatarIamgeView,nameLabel,focusBtn,line,_redBage]];
    
    
    avatarIamgeView.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .centerYEqualToView(self.contentView)
    .widthIs(50)
    .heightEqualToWidth();
    avatarIamgeView.sd_cornerRadiusFromWidthRatio = @(0.5);

    nameLabel.sd_layout
    .centerYEqualToView(avatarIamgeView)
    .leftSpaceToView(avatarIamgeView, 10)
    .widthIs(kScreenW -50 -30 -55 -20)
    .heightIs(20);
    
    focusBtn.sd_layout
    .centerYEqualToView(avatarIamgeView)
    .rightSpaceToView(self.contentView, 15)
    .widthIs(55)
    .heightIs(25);
    
    line.sd_layout
    .topSpaceToView(self.contentView, 79.5)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(0.5);
    
    _redBage.sd_layout
    .topEqualToView(avatarIamgeView)
    .rightEqualToView(avatarIamgeView)
    .widthIs(12)
    .heightEqualToWidth();
    [_redBage setSd_cornerRadius:@6];
    
    [self setupAutoHeightWithBottomView:avatarIamgeView bottomMargin:15];

}
-(void)setModel:(ListModel *)model
{
    _model = model;
    _nameLabel.text = _model.username;
    [_avatarIamgeView sd_setImageWithURL:[NSURL URLWithString:_model.avatar]];
    _redBage.hidden = !_model.is_new_one;
}

@end
