//
//  MMRichEditAccessoryView.h
//  RichTextEditDemo
//
//  Created by aron on 2017/7/21.
//  Copyright © 2017年 aron. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MMRichEditAccessoryView;
@protocol MMRichEditAccessoryViewDelegate <NSObject>
- (void)mm_didKeyboardTapInaccessoryView:(MMRichEditAccessoryView *)accessoryView;
- (void)mm_didImageTapInaccessoryView:(MMRichEditAccessoryView *)accessoryView;
@end


@interface MMRichEditAccessoryView : UIControl

@property (nonatomic, weak) id<MMRichEditAccessoryViewDelegate> delegate;

typedef void(^AddressBlock)(ListModel *model);
@property (nonatomic, copy) AddressBlock addressBlock;

@property (nonatomic, strong) void(^SelectedButtonBlock)(NSInteger selectIndex);

@property (nonatomic, strong) UIImageView *kbImageIcon;
@property (nonatomic, strong) UIButton *nameBtn;
@property (nonatomic, assign) NSInteger rangeIndex;
@property (nonatomic, strong) NSString *circleName;

@end
