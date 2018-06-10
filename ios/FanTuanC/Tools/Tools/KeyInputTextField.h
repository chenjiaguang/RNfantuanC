//
//  KeyInputTextField.h
//  Portal
//
//  Created by 程党威 on 16/1/25.
//  Copyright © 2016年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>

@protocol  KeyInputTextFieldDelegate<NSObject>

@optional

- (void)deleteBackWard:(UITextField *)TextFiled;

@end

@interface KeyInputTextField : UITextField

@property (nonatomic ,assign)id<KeyInputTextFieldDelegate>KeyInputDelegate;

@end
