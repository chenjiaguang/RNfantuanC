//
//  LongArticleSectionFooterView.h
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/5/21.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LongArticleSectionFooterViewDelegate<NSObject>
- (void)clickOnTheWitnBtn:(UIButton *)btn Index:(NSInteger)index;

@end
@interface LongArticleSectionFooterView : UITableViewHeaderFooterView

@property (nonatomic,weak)id<LongArticleSectionFooterViewDelegate> delegate;

@property (nonatomic,strong)CircleModel *model;

@property (nonatomic, copy) void (^praiseButtonClickedBlock)(UIButton *praiseButton);

@end
