//
//  HomePageNewsOneTableViewCell.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/3/5.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "HomePageNewsOneTableViewCell.h"

@implementation HomePageNewsOneTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 5)];
    line.backgroundColor = [MyTool colorWithString:@"f5f5f5"];
    [self.contentView addSubview:line];
    
    
    CGFloat imageViewW = (kScreenW - 42) / 3;
    _headerImageV = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(kScreenW - imageViewW - 15, 25, imageViewW, imageViewW / 111 * 80)];
    _headerImageV.layer.masksToBounds = YES;
    _headerImageV.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_headerImageV];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textColor = [MyTool colorWithString:@"333333"];
    _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    _titleLabel.numberOfLines = 2;
    [self.contentView addSubview:_titleLabel];
    
    _authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _authorLabel.textColor = [MyTool colorWithString:@"999999"];
    _authorLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:_authorLabel];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.textColor = [MyTool colorWithString:@"999999"];
    _timeLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:_timeLabel];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _numLabel.textColor = [MyTool colorWithString:@"999999"];
    _numLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:_numLabel];
}

- (void)setTitle:(NSString *)title author:(NSString *)author time:(NSString *)time read_num:(NSString *)read_num
{
    _titleLabel.text = title;
    CGFloat titleLabelH = [MyTool heightOfLabel:title forFont:[UIFont fontWithName:@"PingFangSC-Medium" size:17] labelLength:_headerImageV.frame.origin.x - 30];
    if (titleLabelH > 47.6) {
        titleLabelH = 48;
    }
    _titleLabel.frame = CGRectMake(15, 25,  _headerImageV.frame.origin.x - 30, titleLabelH);
    
    
    _authorLabel.text = author;
    _authorLabel.frame = CGRectMake(15, 45 + _headerImageV.frame.size.height - 20 - 12, [MyTool widthOfLabel:author ForFont:[UIFont systemFontOfSize:11] labelHeight:12], 12);
    
    _timeLabel.text = time;
    CGFloat timeLabelX = CGRectGetMaxX(_authorLabel.frame);
    if (timeLabelX > 15) {
        timeLabelX = timeLabelX + 10;
    }
    _timeLabel.frame = CGRectMake(timeLabelX, _authorLabel.frame.origin.y, [MyTool widthOfLabel:time ForFont:[UIFont systemFontOfSize:11] labelHeight:12], 12);
    
    _numLabel.text = read_num;
    _numLabel.frame = CGRectMake(10 + CGRectGetMaxX(_timeLabel.frame), _authorLabel.frame.origin.y, [MyTool widthOfLabel:read_num ForFont:[UIFont systemFontOfSize:11] labelHeight:12], 12);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
