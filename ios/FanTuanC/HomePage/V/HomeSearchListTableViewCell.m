//
//  HomeSearchListTableViewCell.m
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/13.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "HomeSearchListTableViewCell.h"

@implementation HomeSearchListTableViewCell
{
    UIView *_promotionBGV;
    UIView *_voucherGrouponBGV;
    
    NSMutableArray *_voucher_grouponArr;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    _headerImgaeV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 80, 80)];
    _headerImgaeV.layer.masksToBounds = YES;
    _headerImgaeV.contentMode = UIViewContentModeScaleAspectFill;
    _headerImgaeV.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_headerImgaeV];
    
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerImgaeV.frame.origin.x + 80 + 10, 15, kScreenW - 120, 16)];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [MyTool colorWithString:@"333333"];
    _nameLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:_nameLabel];
    
    
    _myStarRateV = [[LQYStarRateView alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 9, 64, 12)];
    _myStarRateV.isAnimation = YES;
    _myStarRateV.rateStyle = 2;
    _myStarRateV.numberOfStars = 5;
    [self.contentView addSubview:_myStarRateV];
    
    
    _avgpriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_myStarRateV.frame.size.width + _myStarRateV.frame.origin.x + 5, _myStarRateV.frame.origin.y, 100, 12)];
    _avgpriceLabel.textColor = [MyTool colorWithString:@"666666"];
    _avgpriceLabel.font = [UIFont systemFontOfSize:12];
    _avgpriceLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_avgpriceLabel];
    
    
    _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 100, _myStarRateV.frame.origin.y, 85, 12)];
    _distanceLabel.textColor = [MyTool colorWithString:@"666666"];
    _distanceLabel.font = [UIFont systemFontOfSize:12];
    _distanceLabel.backgroundColor = [UIColor clearColor];
    _distanceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_distanceLabel];
    
    
    _businessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_businessBtn setTitleColor:[MyTool colorWithString:@"ff3f53"] forState:UIControlStateNormal];
    _businessBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _businessBtn.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_businessBtn];
    
    
    _categoryLabel = [[UILabel alloc] init];
    _categoryLabel.textColor = [MyTool colorWithString:@"666666"];
    _categoryLabel.font = [UIFont systemFontOfSize:12];
    _categoryLabel.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_categoryLabel];
    
    
    // 需求变更
//    _FTImageV = [[UIImageView alloc] init];
//    _FTImageV.backgroundColor = [UIColor clearColor];
//    _FTImageV.image = [UIImage imageNamed:@"范团商家"];
//    [self.contentView addSubview:_FTImageV];
    
    
    _moreBtn = [MoreButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setTitleColor:[MyTool colorWithString:@"666666"] forState:UIControlStateNormal];
    _moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _moreBtn.backgroundColor = [UIColor clearColor];
    [_moreBtn setImage:[UIImage imageNamed:@"向下箭头"] forState:UIControlStateNormal];
    _moreBtn.hidden = YES;
    [self.contentView addSubview:_moreBtn];
}

- (void)businessText:(NSString *)businessText categoryText:(NSString *)categoryText isSpider:(NSString *)isSpider promotion:(NSMutableArray *)promotionArr voucher_groupon:(NSMutableArray *)voucher_grouponArr type:(NSString *)type
{
    _voucher_grouponArr = voucher_grouponArr;
    
    if (![businessText isEqualToString:@""]) {
        _businessBtn.frame = CGRectMake(_nameLabel.frame.origin.x, _myStarRateV.frame.origin.y + 12 + 9, [MyTool widthOfLabel:businessText ForFont:[UIFont systemFontOfSize:12] labelHeight:12], 12);
        [_businessBtn setTitle:businessText forState:UIControlStateNormal];
        
        _categoryLabel.frame = CGRectMake(_businessBtn.frame.origin.x + _businessBtn.frame.size.width + 10, _businessBtn.frame.origin.y, 80, 12);
    } else {
        _businessBtn.frame = CGRectZero;
        _categoryLabel.frame = CGRectMake(_nameLabel.frame.origin.x, _myStarRateV.frame.origin.y + 12 + 9, 80, 12);
    }
    _categoryLabel.text = categoryText;
    
    // 需求变更
    CGFloat promotionView_y = _categoryLabel.frame.origin.y + 12 + 9 + 14;
    /*
     CGFloat promotionView_y = _categoryLabel.frame.origin.y + 12;
    if ([isSpider isEqualToString:@"0"]) {
        _FTImageV.frame = CGRectMake(_nameLabel.frame.origin.x, _categoryLabel.frame.origin.y + 12 + 9, 49, 14);
        promotionView_y = _FTImageV.frame.origin.y + 14;
    } else {
        _FTImageV.frame = CGRectZero;
    }
    */
    
    
    [_promotionBGV removeFromSuperview];
    _promotionBGV = [[UIView alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, promotionView_y, kScreenW - 120, 23 * promotionArr.count)];
    [self.contentView addSubview:_promotionBGV];
    
    for (NSInteger i = 0; i < promotionArr.count; i++) {
        PromotionView *promotionV = [[PromotionView alloc] initWithFrame:CGRectMake(0, 23 * i, kScreenW - 120, 23) icon:promotionArr[i][@"ico"] name:promotionArr[i][@"name"]];
        [_promotionBGV addSubview:promotionV];
    }
    
    
    [_voucherGrouponBGV removeFromSuperview];
    _voucherGrouponBGV = [[UIView alloc] init];
    [self.contentView addSubview:_voucherGrouponBGV];
    
    if ([type isEqualToString:@"1"] || voucher_grouponArr.count <= 2) {
        _voucherGrouponBGV.frame = CGRectMake(_nameLabel.frame.origin.x, promotionView_y + 15 + 23 * promotionArr.count, kScreenW - 120, 55 * voucher_grouponArr.count);
        for (NSInteger i = 0; i < voucher_grouponArr.count; i++) {
            VoucherGrouponView *voucherGrouponV = [[VoucherGrouponView alloc] initWithFrame:CGRectMake(0, 55 * i, kScreenW - 120, 55) num:[NSString stringWithFormat:@"¥ %@", voucher_grouponArr[i][@"amount"]] name:voucher_grouponArr[i][@"name"] sales:voucher_grouponArr[i][@"sales"]];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapVoucherGrouponV:)];
            [voucherGrouponV addGestureRecognizer:tap];
            tap.view.tag = 100 + i;
            [_voucherGrouponBGV addSubview:voucherGrouponV];
        }
        _moreBtn.hidden = YES;
    } else {
        _voucherGrouponBGV.frame = CGRectMake(_nameLabel.frame.origin.x, promotionView_y + 15 + 23 * promotionArr.count, kScreenW - 120, 55 * 2);
        for (NSInteger i = 0; i < 2; i++) {
            VoucherGrouponView *voucherGrouponV = [[VoucherGrouponView alloc] initWithFrame:CGRectMake(0, 55 * i, kScreenW - 120, 55) num:[NSString stringWithFormat:@"¥ %@", voucher_grouponArr[i][@"amount"]] name:voucher_grouponArr[i][@"name"] sales:voucher_grouponArr[i][@"sales"]];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapVoucherGrouponV:)];
            [voucherGrouponV addGestureRecognizer:tap];
            tap.view.tag = 100 + i;
            [_voucherGrouponBGV addSubview:voucherGrouponV];
        }
        
        _moreBtn.hidden = NO;
        _moreBtn.frame = CGRectMake(_nameLabel.frame.origin.x, promotionView_y + 15 + 23 * promotionArr.count + 55 * 2, kScreenW - 120, 40);
        [_moreBtn setTitle:[NSString stringWithFormat:@"查看其他%ld个套餐", voucher_grouponArr.count - 2] forState:UIControlStateNormal];
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _moreBtn.frame.size.width, 1)];
        line.backgroundColor = [MyTool colorWithString:@"e5e5e5"];
        [_moreBtn addSubview:line];
    }
}

- (void)TapVoucherGrouponV:(UITapGestureRecognizer *)tap
{
    [self.delegate TapVoucherGrouponV:tap voucher_grouponArr:_voucher_grouponArr];
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
