//
//  NewsScrollContentView.h
//  FanTuanC
//
//  Created by 梁其运 on 2018/4/24.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsScrollContentView;

@protocol LXScrollContentViewDelegate <NSObject>

@optional

- (void)contentViewDidScroll:(NewsScrollContentView *)contentView fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(float)progress;

- (void)contentViewDidEndDecelerating:(NewsScrollContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;

@end

@interface NewsScrollContentView : UIView

/**
 加载滚动视图的界面
 
 @param childVcs 当前View需要装入的控制器集合
 @param parentVC 当前View所在的父控制器
 */
- (void)reloadViewWithChildVcs:(NSArray<UIViewController *> *)childVcs parentVC:(UIViewController *)parentVC;

@property (nonatomic, weak) id<LXScrollContentViewDelegate> delegate;

/**
 设置当前滚动到第几个页面，默认为第0页
 */
@property (nonatomic, assign) NSInteger currentIndex;

@end
