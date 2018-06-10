//
//  BusinessDetailsHeaderView.h
//  FanTuanC
//
//  Created by 梁其运 on 2017/12/27.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessDetailsHeaderView : UIView

@property (nonatomic, strong) UIButton *headerImageV;
@property (nonatomic, strong) UIButton *focusBtn;

- (void)createSubViewWithImageUrl:(NSString *)imageUrl name:(NSString *)name score:(NSString *)score average_spend:(NSString *)average_spend sales:(NSString *)sales category_name:(NSString *)category_name mall:(NSString *)mall distance:(NSString *)distance focus:(BOOL)focus address:(NSString *)address phone:(NSString *)phone;

@end
