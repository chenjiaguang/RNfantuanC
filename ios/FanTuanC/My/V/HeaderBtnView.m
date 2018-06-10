//
//  HeaderBtnView.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/3/27.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "HeaderBtnView.h"

@implementation HeaderBtnView
{
    UIView *_redBage;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLabel.font = [UIFont systemFontOfSize:12];
    _nameLabel.textColor = [MyTool colorWithString:@"A4A4A4"];
    [self addSubview:_nameLabel];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _numLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
    _numLabel.textColor = [MyTool colorWithString:@"333333"];
    [self addSubview:_numLabel];
    
    _redBage = [[UIView alloc] initWithFrame:CGRectZero];
    _redBage.backgroundColor = [MyTool colorWithString:@"FE5273"];
    _redBage.hidden = YES;
    [self addSubview:_redBage];
    
    _tap = [[UITapGestureRecognizer alloc] init];
    [self addGestureRecognizer:_tap];
    
    
    _nameLabel.sd_layout
    .bottomSpaceToView(self, 20)
    .rightEqualToView(self)
    .leftEqualToView(self)
    .heightIs(12);
    
    _numLabel.sd_layout
    .bottomSpaceToView(_nameLabel, 5)
    .leftEqualToView(self)
    .heightIs(18);
    [_numLabel setSingleLineAutoResizeWithMaxWidth:self.frame.size.width];
    
    _redBage.sd_layout
    .leftSpaceToView(_numLabel, 2)
    .topEqualToView(_numLabel)
    .widthIs(6)
    .heightEqualToWidth();
    _redBage.sd_cornerRadius = @3;
}

- (void)setHas_new_fans:(BOOL)has_new_fans
{
    _redBage.hidden = !has_new_fans;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
