//
//  UILabel+ChangeLineSpaceAndWordSpace.h
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/4/25.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (ChangeLineSpaceAndWordSpace)
/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

/**
 *  自适应宽高同时调整行距
 *
 *  @param text label.text
 *  @param font label.font
 *  @param size label的最大尺寸
 *
 *  @return 自适应后的到的size
 */
- (CGSize )szieAdaptiveWithText:(NSString *)text andTextFont:(UIFont *)font andTextMaxSzie:(CGSize )size andLineSpacing:(CGFloat )lineSpacing andTextAlignment:(NSTextAlignment )alignment  numberOfLines:(NSInteger)numberOfLines;


@end
