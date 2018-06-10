//
//  LongArticleDetailsImageCell.h
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/4/20.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LongArticleDetailsImageCell : UITableViewCell

@property(nonatomic,strong)Comment *model;

@property(nonatomic,strong)NSMutableArray *picArr;

@property(nonatomic,strong)NSMutableArray *subscriptArr;

@property(nonatomic,assign)NSInteger row;


@end
