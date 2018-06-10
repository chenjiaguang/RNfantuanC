//
//  XMPiecewiseView.h
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/2/27.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMPiecewiseView : UIView
typedef void(^SelectedButtonBlock)(NSString *buttonTag);

@property (nonatomic, copy) SelectedButtonBlock selectedButtonBlock;


- (instancetype)initWithFrame:(CGRect)frame tittleArr:(NSMutableArray *)titleArr font:(UIFont *)font returnButtonTag:(SelectedButtonBlock)block;

@end
