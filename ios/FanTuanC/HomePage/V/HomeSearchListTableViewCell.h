//
//  HomeSearchListTableViewCell.h
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/13.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQYStarRateView.h"
#import "PromotionView.h"
#import "VoucherGrouponView.h"
#import "MoreButton.h"

@protocol HomeSearchListTableViewCellDelegate <NSObject>

- (void)TapVoucherGrouponV:(UITapGestureRecognizer *)tap voucher_grouponArr:(NSMutableArray *)voucher_grouponArr;

@end

@interface HomeSearchListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headerImgaeV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) LQYStarRateView *myStarRateV;
@property (nonatomic, strong) UILabel *avgpriceLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UIButton *businessBtn;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UIImageView *FTImageV;
@property (nonatomic, strong) MoreButton *moreBtn;

@property (nonatomic, assign) id <HomeSearchListTableViewCellDelegate> delegate;

- (void)businessText:(NSString *)businessText categoryText:(NSString *)categoryText isSpider:(NSString *)isSpider promotion:(NSMutableArray *)promotionArr voucher_groupon:(NSMutableArray *)voucher_grouponArr type:(NSString *)type;

@end
