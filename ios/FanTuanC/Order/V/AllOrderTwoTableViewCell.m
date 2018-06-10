//
//  AllOrderTwoTableViewCell.m
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/27.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "AllOrderTwoTableViewCell.h"

@implementation AllOrderTwoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(NSString *)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviewsWithType:type];
    }
    return self;
}

- (void)createSubviewsWithType:(NSString *)type
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 41, kScreenW, 185)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bgView];
    
    
    if (![type isEqualToString:@"0"]) {
        bgView.frame = CGRectMake(0, 10, kScreenW, 185);
    } else {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, kScreenW - 30, 16)];
        _typeLabel.backgroundColor = [UIColor clearColor];
        _typeLabel.textColor = [MyTool colorWithString:@"666666"];
        _typeLabel.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_typeLabel];
    }
    
    
    _headerImageV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 36, 36)];
    _headerImageV.backgroundColor = [UIColor clearColor];
    _headerImageV.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageV.layer.masksToBounds = YES;
    _headerImageV.layer.cornerRadius = 18;
    [bgView addSubview:_headerImageV];
    
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + _headerImageV.frame.origin.x + _headerImageV.frame.size.width, _headerImageV.frame.origin.y, 242 * Swidth, _headerImageV.frame.size.height)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [MyTool colorWithString:@"333333"];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16];
    [bgView addSubview:_nameLabel];
    
    
    _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 72, _nameLabel.frame.origin.y, 72, _nameLabel.frame.size.height)];
    _stateLabel.backgroundColor = [UIColor clearColor];
    _stateLabel.font = [UIFont systemFontOfSize:14];
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:_stateLabel];
    
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(15, _headerImageV.frame.origin.y + _headerImageV.frame.size.height + 15, kScreenW - 30, 1)];
    line.layer.backgroundColor = [MyTool colorWithString:@"e5e5e5"].CGColor;
    [bgView addSubview:line];
    
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, line.frame.origin.y + 1 + 15, kScreenW - 30, 14)];
    _numLabel.backgroundColor = [UIColor clearColor];
    _numLabel.textColor = [MyTool colorWithString:@"666666"];
    _numLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:_numLabel];
    
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _numLabel.frame.origin.y + 14 + 10, kScreenW - 30, 14)];
    _timeLabel.backgroundColor = [UIColor clearColor];
    _timeLabel.textColor = [MyTool colorWithString:@"666666"];
    _timeLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:_timeLabel];
    
    
    _refundImageV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW - 15 - 38, line.frame.origin.y + 16, 38, 14)];
    _refundImageV.backgroundColor = [UIColor clearColor];
    _refundImageV.image = [UIImage imageNamed:@"有退款"];
    [bgView addSubview:_refundImageV];
    
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(15, line.frame.origin.y + 69, kScreenW - 30, 1)];
    line1.layer.backgroundColor = [MyTool colorWithString:@"e5e5e5"].CGColor;
    [bgView addSubview:line1];
    
    
    _memoyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, line1.frame.origin.y + 1, 200, 185 - line1.frame.origin.y - 1)];
    _memoyLabel.backgroundColor = [UIColor clearColor];
    _memoyLabel.textColor = [MyTool colorWithString:@"ff3f53"];
    _memoyLabel.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:_memoyLabel];
    
    
    _myBtton = [UIButton buttonWithType:UIButtonTypeCustom];
    _myBtton.frame = CGRectMake(kScreenW - 15 - 80, _memoyLabel.frame.origin.y + (_memoyLabel.frame.size.height - 27) / 2, 80, 27);
    _myBtton.titleLabel.font = [UIFont systemFontOfSize:14];
    _myBtton.layer.cornerRadius = 2;
    _myBtton.layer.borderColor = [MyTool colorWithString:@"bbbbbb"].CGColor;
    [bgView addSubview:_myBtton];
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
