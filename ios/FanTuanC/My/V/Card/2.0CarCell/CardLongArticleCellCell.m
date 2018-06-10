//
//  CardLongArticleCellCell.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/4/19.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "CardLongArticleCellCell.h"
#import "LongArticleDetailsController.h"
#import "CircleDetailTwoViewController.h"

@interface CardLongArticleCellCell()
{
    
    UILabel *_yearLabel;
    UILabel *_timeLabel;
    UIImageView *_locationImageV;
    UILabel *_locationLabel;
    UILabel *_circleLabel;
    UIButton *_circleBtn;
    NSMutableArray *_imageViews; //九宫格imageView存储数组
    UIView *_imageBgView;
    UILabel *_atricleTitleLabe;
    UIImageView *_stateImageV;
}
@end

@implementation CardLongArticleCellCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)createUI
{
   
    UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    yearLabel.textColor = [MyTool colorWithString:@"333333"];
    yearLabel.font = [UIFont systemFontOfSize:24];
    _yearLabel = yearLabel;
    
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    timeLabel.textColor = [MyTool colorWithString:@"333333"];
    timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel = timeLabel;
    
    UIImageView *stateImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:stateImageV];
    _stateImageV = stateImageV;
    
    UILabel *atricleTitleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    atricleTitleLabel.font = [UIFont boldSystemFontOfSize:16];
    atricleTitleLabel.textColor = [MyTool colorWithString:@"333333"];
    _atricleTitleLabe = atricleTitleLabel;
    
    UIView *imageBgView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:imageBgView];
    _imageBgView = imageBgView;
    
    _imageViews = [NSMutableArray array];
    for (int i = 0; i<3; i++) {
        UIImageView *imgView = [[UIImageView alloc]init];
        [_imageViews addObject:imgView];
        imgView.backgroundColor = [MyTool colorWithString:@"EEEEEE"];
        [imageBgView addSubview:imgView];
        imgView.hidden = YES;
        imgView.sd_layout.autoHeightRatio(1);
        imgView.userInteractionEnabled=YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds  = YES;
    }
    
    UIImageView *locationImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_位置"]];
    locationImageV.hidden = YES;
    _locationImageV = locationImageV;
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    locationLabel.textColor = [MyTool colorWithString:@"999999"];
    locationLabel.font = [UIFont systemFontOfSize:12];
    _locationLabel = locationLabel;
    
    UILabel *circleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    circleLabel.textColor = [MyTool colorWithString:@"999999"];
    circleLabel.text = @"发布于";
    circleLabel.font = [UIFont systemFontOfSize:12];
    _circleLabel = circleLabel;
    
    UIButton *circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [circleBtn setTitleColor:[MyTool colorWithString:@"1EB0FD"] forState:UIControlStateNormal];
    circleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [circleBtn addTarget:self action:@selector(circleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _circleBtn = circleBtn;
    
    UIButton *praisebnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [praisebnt setTitleColor:[MyTool colorWithString:@"666666"] forState:UIControlStateNormal];
    praisebnt.titleLabel.font = [UIFont systemFontOfSize:12];
    [praisebnt setImage:[UIImage imageNamed:@"icon_点赞"] forState:UIControlStateNormal];
    _praiseBtn = praisebnt;
    
    
    UIButton *commentsbnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentsbnt setTitleColor:[MyTool colorWithString:@"666666"] forState:UIControlStateNormal];
    commentsbnt.titleLabel.font = [UIFont systemFontOfSize:12];
    [commentsbnt setImage:[UIImage imageNamed:@"icon_评论"] forState:UIControlStateNormal];
    [commentsbnt addTarget:self action:@selector(commentsbntAction:) forControlEvents:UIControlEventTouchUpInside];
    _commentsBtn = commentsbnt;
    
    [self.contentView sd_addSubviews:@[yearLabel,timeLabel,stateImageV,atricleTitleLabel,imageBgView,locationImageV,locationLabel,circleLabel,circleBtn,praisebnt,commentsbnt]];
   
}
- (void)commentsbntAction:(UIButton *)btn
{
    LongArticleDetailsController *vc = [[LongArticleDetailsController alloc]init];
    vc.articleId = _dataDic[@"id"];
    [[MyTool topViewController].navigationController pushViewController:vc animated:YES];
}


-(void)setDataDic:(NSMutableDictionary *)dataDic
{
    _dataDic = dataDic;
    _yearLabel.text = _dataDic[@"year"];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", _dataDic[@"title"]]];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"icon_长文"];
    attch.bounds = CGRectMake(0, -2.5, 27, 15);
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    [attri addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_dataDic[@"title"] length])];
    _atricleTitleLabe.attributedText = attri;
    
    if ([_dataDic[@"range"] isEqualToString:@"0"]) {
        _stateImageV.hidden = YES;
    } else if ([_dataDic[@"range"] isEqualToString:@"1"]) {
        _stateImageV.hidden = NO;
        _stateImageV.image = [UIImage imageNamed:@"好友可见"];
    } else {
        _stateImageV.hidden = NO;
        _stateImageV.image = [UIImage imageNamed:@"仅自己可见"];
    }
    
    
    for (UIImageView *imageView in _imageViews) {
        imageView.hidden = YES;
    }
    for (int i = 0; i < [_dataDic[@"covers"] count]; i ++) {
        UIImageView *imageView = _imageViews[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"covers"][i][@"compress"]]];
        imageView.hidden = NO;
    }
    
    [_imageBgView clearAutoWidthFlowItemsSettings];
    
    CGFloat itemWidth = (kScreenW-90-6)/3;
    [_imageBgView setupAutoMarginFlowItems:[_imageViews subarrayWithRange:NSMakeRange(0, [_dataDic[@"covers"] count])]
                      withPerRowItemsCount:3
                                 itemWidth:itemWidth
                            verticalMargin:3
                         verticalEdgeInset:0
                       horizontalEdgeInset:0];
    
    
    [_commentsBtn setTitle:[_dataDic[@"comment_num"] integerValue] == 0?@"评论":_dataDic[@"comment_num"] forState:UIControlStateNormal];
    [_praiseBtn setImage:[UIImage imageNamed:[_dataDic[@"has_like"] boolValue]?@"icon_点赞1":@"icon_点赞"] forState:UIControlStateNormal];
    [_praiseBtn setTitleColor:[MyTool colorWithString:[_dataDic[@"has_like"] boolValue]?@"FF3F53":@"666666"] forState:UIControlStateNormal];
    [_praiseBtn setTitle:[_dataDic[@"like_num"] integerValue] == 0?@"点赞":_dataDic[@"like_num"] forState:UIControlStateNormal];
    _circleLabel.hidden = [_dataDic[@"circle_name"] isEqualToString:@""]?YES:NO;
    [_circleBtn setTitle:_dataDic[@"circle_name"] forState:UIControlStateNormal];
    _locationImageV.hidden = [_dataDic[@"location"] isEqualToString:@""]?YES:NO;
    _locationLabel.text = _dataDic[@"location"];

    [self redesignLayout];
}
-(void)redesignLayout
{
    _yearLabel.sd_layout
    .topSpaceToView(self.contentView, [_yearLabel.text isEqualToString:@""]?0:30)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(kScreenW - 30)
    .autoHeightRatio(0);
    
    _timeLabel.sd_layout
    .topSpaceToView(_yearLabel, 30)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(56)
    .heightIs(26);
    _timeLabel.isAttributedContent = YES;
    NSMutableAttributedString *timeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@月", _dataDic[@"day"], _dataDic[@"month"]]];
    [timeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Semibold" size:24]range:NSMakeRange(0, [_dataDic[@"day"] length])];
    [timeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Semibold" size:12]range:NSMakeRange([_dataDic[@"day"] length], [_dataDic[@"month"] length])];
    _timeLabel.attributedText= timeString;
    
    _stateImageV.sd_layout
    .topSpaceToView(_timeLabel, 10)
    .leftSpaceToView(self.contentView, 47)
    .widthIs(15)
    .heightIs(15);
    
    _atricleTitleLabe.sd_layout
    .topEqualToView(_timeLabel)
    .leftSpaceToView(self.contentView, 75)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    _atricleTitleLabe.isAttributedContent = YES;
    
    _imageBgView.sd_layout
    .leftSpaceToView(self.contentView,75)
    .rightSpaceToView(self.contentView,15)
    .topSpaceToView(_atricleTitleLabe,12);
    
    _locationImageV.sd_layout
    .leftSpaceToView(self.contentView, 75)
    .topSpaceToView(_imageBgView, 12)
    .widthIs(10)
    .heightIs(12);
    
    _locationLabel.sd_layout
    .leftSpaceToView(_locationImageV, 5)
    .centerYEqualToView(_locationImageV)
    .heightIs(12);
    [_locationLabel setSingleLineAutoResizeWithMaxWidth:kScreenW-90-100];
    
    _circleLabel.sd_layout
    .leftSpaceToView(self.contentView, 75)
    .topSpaceToView(_locationLabel, _circleLabel.isHidden?0:12)
    .heightIs(12);
    [_circleLabel setSingleLineAutoResizeWithMaxWidth:kScreenW-75-15];
    
    _circleBtn.sd_layout
    .leftSpaceToView(_circleLabel, 0)
    .centerYEqualToView(_circleLabel)
    .heightIs(12);
    [_circleBtn setupAutoSizeWithHorizontalPadding:0 buttonHeight:12];
    
    
    _praiseBtn.sd_layout
    .leftSpaceToView(self.contentView, 75)
    .topSpaceToView(_circleLabel.isHidden&&_locationImageV.isHidden?_imageBgView:_circleLabel.isHidden?_locationImageV:_circleBtn, 12)
    .heightIs(15)
    .widthIs(89);
    
    _praiseBtn.imageView.sd_layout
    .heightIs(15)
    .leftSpaceToView(_praiseBtn, 0)
    .widthEqualToHeight();
    
    _praiseBtn.titleLabel.sd_layout
    .rightSpaceToView(_praiseBtn, 0)
    .leftSpaceToView(_praiseBtn.imageView, 10);
    
    _commentsBtn.sd_layout
    .leftSpaceToView(_praiseBtn, 0)
    .centerYEqualToView(_praiseBtn)
    .heightIs(15)
    .widthIs(89);
    
    _commentsBtn.imageView.sd_layout
    .heightIs(15)
    .leftSpaceToView(_commentsBtn, 0)
    .widthEqualToHeight();
    
    _commentsBtn.titleLabel.sd_layout
    .rightSpaceToView(_commentsBtn, 0)
    .leftSpaceToView(_commentsBtn.imageView, 10);
    
    
    [self setupAutoHeightWithBottomViewsArray:@[_commentsBtn] bottomMargin:0];
}

- (void)circleBtnAction:(UIButton *)btn
{
    CircleDetailTwoViewController *detailsVC = [[CircleDetailTwoViewController alloc] init];
    detailsVC.circleID = _dataDic[@"circle_id"];
    [[MyTool topViewController].navigationController pushViewController:detailsVC animated:YES];
}

@end
