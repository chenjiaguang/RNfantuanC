//
//  BusinessDetailMoreAlertView.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/1/4.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "BusinessDetailMoreAlertView.h"
#import "CouponTableViewCell.h"
#import "GrouponTableViewCell.h"
#import "VoucherTableViewCell.h"

#define animationsTime 0.3

@implementation BusinessDetailMoreAlertView
{
    UIView *_bgView;
    NSMutableDictionary *_dic;
    NSMutableArray *_listArr;
    UITableView *_myTableView;
}

- (instancetype)initWithFrame:(CGRect)frame titleDic:(NSDictionary *)dic
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUIWithTitleDic:dic];
    }
    return self;
}

- (void)createUIWithTitleDic:(NSDictionary *)dic
{
    _dic = [dic mutableCopy];
    _listArr = [dic[@"content"] mutableCopy];
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 420)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    titleLabel.textColor = [MyTool colorWithString:@"333333"];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:titleLabel];
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(kScreenW - 50, 0, 50, 50);
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"关闭弹框"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:cancelBtn];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, kScreenW, 0.5)];
    line.backgroundColor = [MyTool colorWithString:@"e1e1e1"];
    [_bgView addSubview:line];
    
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, kScreenW, 370) style:UITableViewStylePlain];
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = NO;
    _myTableView.estimatedRowHeight = 200;
    _myTableView.rowHeight = UITableViewAutomaticDimension;
    [_bgView addSubview:_myTableView];
    
    
    if ([dic[@"title"] isEqualToString:@"买单优惠活动"]) {
        titleLabel.text = @"优惠券免费领";
        _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    } else {
        titleLabel.text = dic[@"title"];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.frame = CGRectMake(0, kScreenH - 420, kScreenW, 420);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *couponCellID = @"CouponTableViewCell";
    static NSString *grouponCellID = @"GrouponTableViewCell";
    static NSString *voucherCellID = @"VoucherTableViewCell";
    
    if ([_dic[@"title"] isEqualToString:@"买单优惠活动"]) {
        CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:couponCellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CouponTableViewCell" owner:self options:nil] firstObject];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.thresholdLabel.text = [NSString stringWithFormat:@"¥%@", _listArr[indexPath.row][@"amount"]];
        cell.amountLabel.text = [NSString stringWithFormat:@"满%@可用", _listArr[indexPath.row][@"threshold"]];
        if ([_listArr[indexPath.row][@"is_get"] boolValue] == YES) {
            cell.getBtn.backgroundColor = [MyTool colorWithString:@"cccccc"];
            [cell.getBtn setTitle:@"已领取" forState:UIControlStateNormal];
            cell.getBtn.userInteractionEnabled = NO;
        }
        cell.getBtn.tag = 10000 * _sectionInt + indexPath.row;
        [cell.getBtn addTarget:self action:@selector(cellGetBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    } else if ([_dic[@"title"] isEqualToString:@"团购套餐"]) {
        GrouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:grouponCellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"GrouponTableViewCell" owner:self options:nil] firstObject];
        }
        
        [cell.headerImageV sd_setImageWithURL:[NSURL URLWithString:_listArr[indexPath.row][@"imgUrl"]]];
        cell.numLabel.text = _listArr[indexPath.row][@"total_sales"];
        cell.nameLabel.text = _listArr[indexPath.row][@"name"];
        cell.amountLabel.text = _listArr[indexPath.row][@"amount"];
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@", _listArr[indexPath.row][@"market_price"]] attributes:attribtDic];
        cell.market_priceLabel.attributedText = attribtStr;
        cell.buyBtn.tag = 10000 * _sectionInt + indexPath.row;
        [cell.buyBtn addTarget:self action:@selector(cellBuyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    } else {
        VoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:voucherCellID];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"VoucherTableViewCell" owner:self options:nil] firstObject];
        }
        
        cell.numLabel.text = _listArr[indexPath.row][@"total_sales"];
        cell.nameLabel.text = _listArr[indexPath.row][@"name"];
        cell.amountLabel.text = _listArr[indexPath.row][@"amount"];
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@", _listArr[indexPath.row][@"market_price"]] attributes:attribtDic];
        cell.market_priceLabel.attributedText = attribtStr;
        cell.buyBtn.tag = 10000 * _sectionInt + indexPath.row;
        [cell.buyBtn addTarget:self action:@selector(cellBuyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![_dic[@"title"] isEqualToString:@"买单优惠活动"]) {
        [self hiddenAlertView];
    }
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:_sectionInt];
    [self.delegate tableView:tableView didSelectRowAtIndexPath:newIndexPath];
}


- (void)cellGetBtnAction:(UIButton *)btn
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] != YES)
    {
        [self hiddenAlertView];
    } else {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:_listArr];
        [_listArr removeAllObjects];
        for (NSDictionary *dic in arr) {
            [_listArr addObject:[dic mutableCopy]];
        }
        [_listArr[btn.tag % 10000] setObject:@1 forKey:@"is_get"];
        [_myTableView reloadData];
    }
    [self.delegate cellGetBtnAction:btn];
}

- (void)cellBuyBtnAction:(UIButton *)btn
{
    [self hiddenAlertView];
    [self.delegate cellBuyBtnAction:btn];
}

- (void)cancelBtnAction:(UIButton *)btn
{
    [self hiddenAlertView];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self hiddenAlertView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint touchPoint = [touch locationInView:self];
    return !CGRectContainsPoint(_bgView.frame, touchPoint);
}


- (void)hiddenAlertView
{
    [UIView animateWithDuration:animationsTime animations:^{
        _bgView.frame = CGRectMake(0, kScreenH, kScreenW, 420);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationsTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
