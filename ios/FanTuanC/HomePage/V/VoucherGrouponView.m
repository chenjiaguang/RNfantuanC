//
//  VoucherGrouponView.m
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/14.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "VoucherGrouponView.h"

@implementation VoucherGrouponView

- (instancetype)initWithFrame:(CGRect)frame num:(NSString *)numStr name:(NSString *)nameStr sales:(NSString *)salesStr
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUIWithNum:numStr name:nameStr sales:salesStr];
    }
    return self;
}

- (void)createUIWithNum:(NSString *)numStr name:(NSString *)nameStr sales:(NSString *)salesStr
{
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    line.backgroundColor = [MyTool colorWithString:@"e5e5e5"];
    [self addSubview:line];
    
    UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 45, 54)];
    numLabel.textColor = [MyTool colorWithString:@"ff3f53"];
    numLabel.font = [UIFont boldSystemFontOfSize:15];
    numLabel.attributedText = [MyTool labelWithText:numStr Color:[MyTool colorWithString:@"ff3f53"] Font:[UIFont systemFontOfSize:11] range:NSMakeRange(0, 2)];
    [self addSubview:numLabel];
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(numLabel.frame.size.width, 10, self.frame.size.width - numLabel.frame.size.width - 15, 15)];
    nameLabel.textColor = [MyTool colorWithString:@"333333"];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.text = nameStr;
    [self addSubview:nameLabel];
    
    
    if (![salesStr isEqualToString:@""]) {
        UILabel *salesLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + nameLabel.frame.size.height + 8, nameLabel.frame.size.width, 12)];
        salesLabel.textColor = [MyTool colorWithString:@"999999"];
        salesLabel.font = [UIFont systemFontOfSize:12];
        salesLabel.text = salesStr;
        [self addSubview:salesLabel];
    } else {
        nameLabel.frame = CGRectMake(numLabel.frame.size.width, numLabel.frame.origin.y, self.frame.size.width - numLabel.frame.size.width - 15, numLabel.frame.size.height);
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
