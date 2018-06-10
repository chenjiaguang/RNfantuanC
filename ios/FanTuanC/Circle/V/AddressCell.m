//
//  AddressCell.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/3/27.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "AddressCell.h"
@interface AddressCell ()
{
    UILabel *_titleLabel;
    UILabel *_detailsLabel;
}
@end
@implementation AddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.textColor = [MyTool ColorWithColorStr:@"333333"];
    titleLabel.text = _model.title;
    titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel = titleLabel;
    
    UILabel *detailsLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    detailsLabel.textColor = [MyTool ColorWithColorStr:@"666666"];
    detailsLabel.font = [UIFont systemFontOfSize:13];
    detailsLabel.text = _model.address;
    _detailsLabel = detailsLabel;
    
    UIImageView *selectedIamgeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"defaultSelected"]];
    selectedIamgeView.hidden = YES;
    _selectedIamgeView = selectedIamgeView;
    
    [self.contentView sd_addSubviews:@[titleLabel,detailsLabel,selectedIamgeView]];
    
    selectedIamgeView.sd_layout
    .topSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(30)
    .widthEqualToHeight();
    
    [titleLabel setSingleLineAutoResizeWithMaxWidth:kScreenW-30 -30 -20];
    titleLabel.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 15)
    .heightIs(17);
    
    [detailsLabel setSingleLineAutoResizeWithMaxWidth:kScreenW-30 -30 -20];
    detailsLabel.sd_layout
    .topSpaceToView(titleLabel, 15)
    .leftSpaceToView(self.contentView, 15)
    .autoWidthRatio(0)
    .heightIs(13);
    
    
    
    [self setupAutoHeightWithBottomView:detailsLabel bottomMargin:15];

}
-(void)setModel:(ListModel *)model
{
    _model = model;
    _titleLabel.text = _model.title;
    _detailsLabel.text = _model.address;
}
@end
