//
//  NewsSegmentTitleView.h
//  FanTuanC
//
//  Created by 梁其运 on 2018/4/24.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsSegmentTitleView;

@protocol LXSegmentTitleViewDelegate <NSObject>

@optional

- (void)segmentTitleView:(NewsSegmentTitleView *)segmentView selectedIndex:(NSInteger)selectedIndex lastSelectedIndex:(NSInteger)lastSelectedIndex;

@end

@interface NewsSegmentTitleView : UIView

@property (nonatomic, weak) id<LXSegmentTitleViewDelegate> delegate;

// 加号按钮
@property (nonatomic, strong) UIButton *extraBtn;

/**
 文字未选中颜色，默认black
 */
@property (nonatomic, strong) UIColor *titleNormalColor;

/**
 文字选中和下方滚动条颜色，默认red
 */
@property (nonatomic, strong) UIColor *titleSelectedColor;


/**
 第几个标题处于选中状态，默认第0个
 */
@property (nonatomic, assign) NSInteger selectedIndex;


/**
 标题font，默认[UIFont systemFontOfSize:14.f]
 */
@property (nonatomic, strong) UIFont *titleFont;


/**
 下方指示条颜色，默认red
 */
@property (nonatomic, strong) UIColor *indicatorColor;

/**
 下方滚动指示条高度，默认2.f
 */
@property (nonatomic, assign) CGFloat indicatorHeight;


/**
 下方指示条延伸宽度，默认5.f
 */
@property (nonatomic, assign) CGFloat indicatorExtraW;


/**
 下方指示条距离底部距离，默认为0
 */
@property (nonatomic, assign) CGFloat indicatorBottomMargin;

/**
 每个item之间最小间隔，默认25.f
 */
@property (nonatomic, assign) CGFloat itemMinMargin;

/**
 选项卡标题数组
 */
@property (nonatomic, strong) NSArray<NSString *> *segmentTitles;

@end
