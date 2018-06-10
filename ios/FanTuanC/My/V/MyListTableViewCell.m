//
//  MyListTableViewCell.m
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/3.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "MyListTableViewCell.h"

@implementation MyListTableViewCell

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
    _myImgaeV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 17.5, 25, 25)];
    _myImgaeV.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_myImgaeV];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25+10+12, 0, 110, 60)];
    _titleLabel.textColor = [MyTool colorWithString:@"333333"];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_titleLabel];
    
    _arrowsImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW - 15 - 6, 25, 6, 10)];
    _arrowsImage.image = [UIImage imageNamed:@"箭头"];
    [self.contentView addSubview:_arrowsImage];
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.layer.backgroundColor = [MyTool colorWithString:@"ff3f53"].CGColor;
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.font = [UIFont systemFontOfSize:11];
    _numLabel.textColor = [UIColor whiteColor];
    _numLabel.layer.masksToBounds = YES;
    _numLabel.layer.cornerRadius = 8;
    _numLabel.hidden = YES;
    [self.contentView addSubview:_numLabel];
    
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame), _titleLabel.frame.origin.y, kScreenW - 5 - CGRectGetMaxX(_titleLabel.frame) - 21, _titleLabel.frame.size.height)];
    _contentLabel.textColor = [MyTool colorWithString:@"999999"];
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.hidden = YES;
    [self.contentView addSubview:_contentLabel];
    
    
    _line = [[UILabel alloc] initWithFrame:CGRectMake(15, 59.5, kScreenW - 30, 0.5)];
    _line.layer.backgroundColor = [MyTool colorWithString:@"E5E5E5"].CGColor;
    [self.contentView addSubview:_line];
    
}

- (void)setNumLabelText:(NSString *)numStr
{
    _numLabel.hidden = NO;
    _numLabel.text = numStr;
    NSInteger num = [numStr integerValue];
    if (num == 0) {
        _numLabel.hidden = YES;
    } else if (num < 10) {
        _numLabel.frame = CGRectMake(_arrowsImage.frame.origin.x - 16 - 5, 17, 16, 16);
    } else if (num >= 10 && num < 100) {
        _numLabel.frame = CGRectMake(_arrowsImage.frame.origin.x - 21 - 5, 17, 21, 16);
    } else {
        _numLabel.text = @"99+";
        _numLabel.frame = CGRectMake(_arrowsImage.frame.origin.x - 30 - 5, 17, 30, 16);
    }
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
