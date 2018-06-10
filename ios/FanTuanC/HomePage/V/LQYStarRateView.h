//
//  LQYStarRateView.h
//  fantuan
//
//  Created by 冫柒Yun on 2017/7/5.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LQYStarRateView;

typedef void(^finishBlock)(CGFloat currentScore);

typedef NS_ENUM(NSInteger, RateStyle)
{
    WholeStar = 0, //只能整星评论
    HalfStar = 1,  //允许半星评论
    IncompleteStar = 2  //允许不完整星评论
};

@protocol LQYStarRateViewDelegate <NSObject>

-(void)starRateView:(LQYStarRateView *)starRateView currentScore:(CGFloat)currentScore;

@end

@interface LQYStarRateView : UIView

@property (nonatomic,assign) BOOL isAnimation;       //是否动画显示，默认NO
@property (nonatomic,assign) RateStyle rateStyle;    //评分样式    默认是WholeStar
@property (nonatomic, assign) NSInteger numberOfStars;
@property (nonatomic,assign) CGFloat currentScore;   // 当前评分：0-5  默认0

@property (nonatomic, weak) id<LQYStarRateViewDelegate>delegate;


-(instancetype)initWithFrame:(CGRect)frame;
-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation delegate:(id)delegate;


-(instancetype)initWithFrame:(CGRect)frame finish:(finishBlock)finish;
-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation finish:(finishBlock)finish;

@end
