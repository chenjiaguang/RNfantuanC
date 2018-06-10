//
//  ShopSearchListTableViewCell.h
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/29.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQYStarRateView.h"
#import "PromotionView.h"
#import "VoucherGrouponView.h"
#import "MoreButton.h"

@protocol ShopSearchListTableViewCellDelegate <NSObject>

- (void)TapVoucherGrouponV:(UITapGestureRecognizer *)tap voucher_grouponArr:(NSMutableArray *)voucher_grouponArr;

@end

@interface ShopSearchListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headerImgaeV;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) LQYStarRateView *myStarRateV;
@property (nonatomic, strong) UILabel *avgpriceLabel;
@property (nonatomic, strong) UILabel *floorLabel;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UIImageView *FTImageV;
@property (nonatomic, strong) MoreButton *moreBtn;

@property (nonatomic, assign) id <ShopSearchListTableViewCellDelegate> delegate;

- (void)categoryText:(NSString *)categoryText isSpider:(NSString *)isSpider promotion:(NSMutableArray *)promotionArr voucher_groupon:(NSMutableArray *)voucher_grouponArr type:(NSString *)type;

@end
