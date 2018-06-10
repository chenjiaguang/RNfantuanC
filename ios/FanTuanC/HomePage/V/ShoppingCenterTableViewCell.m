//
//  ShoppingCenterTableViewCell.m
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/7.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "ShoppingCenterTableViewCell.h"

@implementation ShoppingCenterTableViewCell

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
    _headerImgaeV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 45, 45)];
    _headerImgaeV.layer.masksToBounds = YES;
    _headerImgaeV.layer.cornerRadius = 45 / 2;
    _headerImgaeV.contentMode = UIViewContentModeScaleAspectFill;
    _headerImgaeV.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_headerImgaeV];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, kScreenW - 70 - 115, 45)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [MyTool colorWithString:@"333333"];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:_titleLabel];
    
    _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 115, 20, 100, 45)];
    _distanceLabel.backgroundColor = [UIColor clearColor];
    _distanceLabel.textColor = [MyTool colorWithString:@"999999"];
    _distanceLabel.font = [UIFont systemFontOfSize:12];
    _distanceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_distanceLabel];
    
    
    CGFloat imageW = (kScreenW - 30 - 20) / 3;
    _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, _headerImgaeV.frame.origin.y + 45 + 15, imageW, 80)];
    _imageView1.userInteractionEnabled = YES;
    _imageView1.backgroundColor = [UIColor clearColor];
    _imageView1.contentMode = UIViewContentModeScaleAspectFill;
    _imageView1.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageView1];
    
    _tap1 = [[UITapGestureRecognizer alloc] init];
    [_imageView1 addGestureRecognizer:_tap1];
    
    _huodong1 = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageView1.frame.size.height - 20, imageW, 20)];
    _huodong1.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _huodong1.textColor = [UIColor whiteColor];
    _huodong1.font = [UIFont systemFontOfSize:12];
    _huodong1.textAlignment = NSTextAlignmentCenter;
    [_imageView1 addSubview:_huodong1];
    
    _name1 = [[UILabel alloc] initWithFrame:CGRectMake(_imageView1.frame.origin.x, _imageView1.frame.size.height + _imageView1.frame.origin.y + 10, imageW, 15)];
    _name1.textColor = [MyTool colorWithString:@"333333"];
    _name1.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_name1];
    
    
    _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(15 + imageW + 10, _headerImgaeV.frame.origin.y + 45 + 15, imageW, 80)];
    _imageView2.userInteractionEnabled = YES;
    _imageView2.backgroundColor = [UIColor clearColor];
    _imageView2.contentMode = UIViewContentModeScaleAspectFill;
    _imageView2.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageView2];
    
    _tap2 = [[UITapGestureRecognizer alloc] init];
    [_imageView2 addGestureRecognizer:_tap2];
    
    _huodong2 = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageView2.frame.size.height - 20, imageW, 20)];
    _huodong2.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _huodong2.textColor = [UIColor whiteColor];
    _huodong2.font = [UIFont systemFontOfSize:12];
    _huodong2.textAlignment = NSTextAlignmentCenter;
    [_imageView2 addSubview:_huodong2];
    
    _name2 = [[UILabel alloc] initWithFrame:CGRectMake(_imageView2.frame.origin.x, _imageView2.frame.size.height + _imageView2.frame.origin.y + 10, imageW, 15)];
    _name2.textColor = [MyTool colorWithString:@"333333"];
    _name2.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_name2];
    
    
    _imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(15 + imageW * 2 + 20, _headerImgaeV.frame.origin.y + 45 + 15, imageW, 80)];
    _imageView3.userInteractionEnabled = YES;
    _imageView3.backgroundColor = [UIColor clearColor];
    _imageView3.contentMode = UIViewContentModeScaleAspectFill;
    _imageView3.layer.masksToBounds = YES;
    [self.contentView addSubview:_imageView3];
    
    _tap3 = [[UITapGestureRecognizer alloc] init];
    [_imageView3 addGestureRecognizer:_tap3];
    
    _huodong3 = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageView3.frame.size.height - 20, imageW, 20)];
    _huodong3.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _huodong3.textColor = [UIColor whiteColor];
    _huodong3.font = [UIFont systemFontOfSize:12];
    _huodong3.textAlignment = NSTextAlignmentCenter;
    [_imageView3 addSubview:_huodong3];
    
    _name3 = [[UILabel alloc] initWithFrame:CGRectMake(_imageView3.frame.origin.x, _imageView3.frame.size.height + _imageView3.frame.origin.y + 10, imageW, 15)];
    _name3.textColor = [MyTool colorWithString:@"333333"];
    _name3.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_name3];
    
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _name3.frame.origin.y + 15 + 20, 200, 27)];
    _numLabel.textColor = [MyTool colorWithString:@"333333"];
    _numLabel.backgroundColor = [UIColor clearColor];
    _numLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_numLabel];
    
    
    _myBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _myBtn.frame = CGRectMake(kScreenW - 15 - 70, _numLabel.frame.origin.y, 70, 27);
    _myBtn.backgroundColor = [MyTool colorWithString:@"ff3f53"];
    [_myBtn setTitle:@"逛一逛" forState:UIControlStateNormal];
    _myBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _myBtn.layer.cornerRadius = 2;
    [self.contentView addSubview:_myBtn];
    
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
