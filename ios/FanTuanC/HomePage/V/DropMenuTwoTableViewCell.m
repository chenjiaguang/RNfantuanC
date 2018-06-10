//
//  DropMenuTwoTableViewCell.m
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/22.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "DropMenuTwoTableViewCell.h"

@implementation DropMenuTwoTableViewCell

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
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 0, 44)];
    _nameLabel.textColor = [MyTool colorWithString:@"333333"];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_nameLabel];
    
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 0, 44)];
    _numLabel.textColor = [MyTool colorWithString:@"999999"];
    _numLabel.font = [UIFont systemFontOfSize:12];
    _numLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_numLabel];
}

- (void)setNameLabelText:(NSString *)nameText numLabelText:(NSString *)numText
{
    _nameLabel.frame = CGRectMake(20, 0, [MyTool widthOfLabel:nameText ForFont:[UIFont systemFontOfSize:14] labelHeight:44], 44);
    _nameLabel.text = nameText;
    
    _numLabel.frame = CGRectMake(_nameLabel.frame.origin.x + _nameLabel.frame.size.width + 5, 0, [MyTool widthOfLabel:numText ForFont:[UIFont systemFontOfSize:12] labelHeight:44], 44);
    _numLabel.text = numText;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        _nameLabel.textColor = [MyTool colorWithString:@"ff3f53"];
        _numLabel.textColor = [MyTool colorWithString:@"ff3f53"];
    } else {
        _nameLabel.textColor = [MyTool colorWithString:@"333333"];
        _numLabel.textColor = [MyTool colorWithString:@"999999"];
    }
}

@end
