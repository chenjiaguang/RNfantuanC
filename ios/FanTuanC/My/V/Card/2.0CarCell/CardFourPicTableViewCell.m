//
//  CardFourPicTableViewCell.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/5/14.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "CardFourPicTableViewCell.h"
#import <KSPhotoBrowser.h>
#import "CircleDetailTwoViewController.h"

@implementation CardFourPicTableViewCell
{
    UILabel *_yearLabel;
    UILabel *_timeLabel;
    UILabel *_contentLabel;
    NSMutableArray *_imageViews; //九宫格imageView存储数组
    UIView *_iamgeBgView;
    UIImageView *_locationImageV;
    UILabel *_locationLabel;
    UILabel *_circleLabel;
    UIButton *_circleBtn;
    UIButton *_commentsBtn;
    UIImageView *_stateImageV;
}

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
    [self.contentView addSubview:yearLabel];
    _yearLabel = yearLabel;
    
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    timeLabel.textColor = [MyTool colorWithString:@"333333"];
    timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:timeLabel];
    _timeLabel = timeLabel;
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    contentLabel.textColor = [MyTool colorWithString:@"333333"];
    contentLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:contentLabel];
    _contentLabel = contentLabel;
    
    UIImageView *stateImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:stateImageV];
    _stateImageV = stateImageV;
    
    UIView *iamgeBgView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:iamgeBgView];
    _iamgeBgView = iamgeBgView;
    
    _imageViews = [NSMutableArray array];
    for (int i = 0; i<4; i++) {
        UIImageView *imgView = [[UIImageView alloc]init];
        [_imageViews addObject:imgView];
        imgView.backgroundColor = [MyTool colorWithString:@"EEEEEE"];
        [iamgeBgView addSubview:imgView];
        imgView.hidden = YES;
        imgView.sd_layout.autoHeightRatio(1);
        imgView.userInteractionEnabled=YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds  = YES;
        imgView.tag = 1000+i;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
        [imgView addGestureRecognizer:singleTap];
    }
    
    UIImageView *locationImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_位置"]];
    locationImageV.hidden = YES;
    [self.contentView addSubview:locationImageV];
    _locationImageV = locationImageV;
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    locationLabel.textColor = [MyTool colorWithString:@"999999"];
    locationLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:locationLabel];
    _locationLabel = locationLabel;
    
    UILabel *circleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    circleLabel.textColor = [MyTool colorWithString:@"999999"];
    circleLabel.text = @"发布于";
    circleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:circleLabel];
    _circleLabel = circleLabel;
    
    UIButton *circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [circleBtn setTitleColor:[MyTool colorWithString:@"1EB0FD"] forState:UIControlStateNormal];
    circleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [circleBtn addTarget:self action:@selector(circleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:circleBtn];
    _circleBtn = circleBtn;
    
    UIButton *praisebnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [praisebnt setTitleColor:[MyTool colorWithString:@"666666"] forState:UIControlStateNormal];
    praisebnt.titleLabel.font = [UIFont systemFontOfSize:12];
    [praisebnt setImage:[UIImage imageNamed:@"icon_点赞"] forState:UIControlStateNormal];
    [praisebnt setTitle:@"点赞" forState:UIControlStateNormal];
    [self.contentView addSubview:praisebnt];
    _praiseBtn = praisebnt;
    
    UIButton *commentsbnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentsbnt setTitleColor:[MyTool colorWithString:@"666666"] forState:UIControlStateNormal];
    commentsbnt.titleLabel.font = [UIFont systemFontOfSize:12];
    [commentsbnt setImage:[UIImage imageNamed:@"icon_评论"] forState:UIControlStateNormal];
    [commentsbnt addTarget:self action:@selector(commentsbntAction:) forControlEvents:UIControlEventTouchUpInside];
    [commentsbnt setTitle:@"评论" forState:UIControlStateNormal];
    [self.contentView addSubview:commentsbnt];
    _commentsBtn = commentsbnt;
    
    
    _yearLabel.sd_layout
    .topSpaceToView(self.contentView, 30)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(kScreenW - 30)
    .autoHeightRatio(0);
    
    _timeLabel.sd_layout
    .topSpaceToView(_yearLabel, 30)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(56)
    .heightIs(26);
    _timeLabel.isAttributedContent = YES;
    
    _stateImageV.sd_layout
    .topSpaceToView(_timeLabel, 10)
    .leftSpaceToView(self.contentView, 47)
    .widthIs(15)
    .heightIs(15);
    
    _contentLabel.sd_layout
    .topSpaceToView(_yearLabel, 30)
    .leftSpaceToView(self.contentView, 75)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    _contentLabel.isAttributedContent = YES;
    
    [self setupAutoHeightWithBottomView:_praiseBtn bottomMargin:0];
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    
    _yearLabel.text = _dataDic[@"year"];
    if ([_yearLabel.text isEqualToString:@""]) {
        [_yearLabel sd_resetLayout];
        _yearLabel.sd_layout.topEqualToView(self.contentView);
    }
    NSMutableAttributedString *timeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@月", _dataDic[@"day"], _dataDic[@"month"]]];
    [timeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Semibold" size:24]range:NSMakeRange(0, [_dataDic[@"day"] length])];
    [timeString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Semibold" size:12]range:NSMakeRange([_dataDic[@"day"] length], [_dataDic[@"month"] length])];
    _timeLabel.attributedText= timeString;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    NSString *contentStr = [_dataDic[@"content"] length] > 100 ? [NSString stringWithFormat:@"%@...全文", [_dataDic[@"content"] substringWithRange:NSMakeRange(0, 100)]]: _dataDic[@"content"];
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:contentStr];
    if ([_dataDic[@"content"] length] > 100) {
        [setString addAttribute:NSForegroundColorAttributeName value:[MyTool colorWithString:@"1EB0FD"] range:NSMakeRange(contentStr.length - 2, 2)];
    }
    [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentStr length])];
    [_contentLabel setAttributedText:setString];
    
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
    
    CGFloat itemWidth = (kScreenW-90-6)/3;
    _iamgeBgView.sd_layout
    .leftSpaceToView(self.contentView,75)
    .topSpaceToView(_contentLabel,[_dataDic[@"content"] length]==0?0:12)
    .widthIs(itemWidth *2 +3);
    
    [_iamgeBgView clearAutoWidthFlowItemsSettings];
    
    [_iamgeBgView setupAutoMarginFlowItems:[_imageViews subarrayWithRange:NSMakeRange(0, [_dataDic[@"covers"] count])]
                      withPerRowItemsCount:2
                                 itemWidth:itemWidth
                            verticalMargin:3
                         verticalEdgeInset:0
                       horizontalEdgeInset:0];
    
    [self autoLayot];
    
    [_locationLabel sd_resetLayout];
    if ([_dataDic[@"location"] isEqualToString:@""]) {
        _locationImageV.hidden = YES;
        _locationLabel.sd_layout
        .topSpaceToView(_iamgeBgView, 0)
        .leftSpaceToView(_locationImageV, 5)
        .heightIs(12);
    } else {
        _locationImageV.hidden = NO;
        _locationLabel.sd_layout
        .leftSpaceToView(_locationImageV, 5)
        .centerYEqualToView(_locationImageV)
        .heightIs(12);
    }
    _locationLabel.text = _dataDic[@"location"];
    
    [_circleBtn sd_resetLayout];
    [_circleBtn setTitle:_dataDic[@"circle_name"] forState:UIControlStateNormal];
    if ([_dataDic[@"circle_name"] isEqualToString:@""]) {
        _circleLabel.hidden = YES;
        _circleBtn.sd_layout
        .topSpaceToView(_locationLabel, 0)
        .leftSpaceToView(_circleLabel, 0)
        .heightIs(12);
    } else {
        _circleLabel.hidden = NO;
        _circleBtn.sd_layout
        .topSpaceToView(_locationLabel, 12)
        .leftSpaceToView(_circleLabel, 0)
        .heightIs(12);
    }
    
    [_praiseBtn setImage:[UIImage imageNamed:[_dataDic[@"has_like"] boolValue]?@"icon_点赞1":@"icon_点赞"] forState:UIControlStateNormal];
    [_praiseBtn setTitleColor:[MyTool colorWithString:[_dataDic[@"has_like"] boolValue]?@"FF3F53":@"666666"] forState:UIControlStateNormal];
    [_praiseBtn setTitle:[_dataDic[@"like_num"] integerValue] == 0?@"点赞":_dataDic[@"like_num"] forState:UIControlStateNormal];
    
    [_commentsBtn setTitle:[_dataDic[@"comment_num"] integerValue] == 0?@"评论":_dataDic[@"comment_num"] forState:UIControlStateNormal];
}

- (void)autoLayot
{
    _locationImageV.sd_layout
    .leftSpaceToView(self.contentView, 75)
    .topSpaceToView(_iamgeBgView, 12)
    .widthIs(10)
    .heightIs(12);
    
    _locationLabel.sd_layout
    .leftSpaceToView(_locationImageV, 5)
    .centerYEqualToView(_locationImageV)
    .heightIs(12);
    [_locationLabel setSingleLineAutoResizeWithMaxWidth:kScreenW-90-15];
    
    _circleLabel.sd_layout
    .leftSpaceToView(self.contentView, 75)
    .topSpaceToView(_locationLabel, 12)
    .heightIs(12);
    [_circleLabel setSingleLineAutoResizeWithMaxWidth:kScreenW-75-15];
    
    _circleBtn.sd_layout
    .leftSpaceToView(_circleLabel, 0)
    .centerYEqualToView(_circleLabel)
    .heightIs(12);
    [_circleBtn setupAutoSizeWithHorizontalPadding:0 buttonHeight:12];
    
    
    _praiseBtn.sd_layout
    .leftSpaceToView(self.contentView, 75)
    .topSpaceToView(_circleBtn, 12)
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
}


-(void)onClickImage:(id)sender
{
    NSMutableArray *items = @[].mutableCopy;
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger tag = views.tag;
    for (int i = 0; i < [_dataDic[@"covers"] count]; i++) {
        UIImageView *imageView = _imageViews[i];
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:_dataDic[@"covers"][i][@"url"]]];
        [items addObject:item];
        
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:tag - 1000];
    //下拉消失样式
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    //预览背景
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
    
    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
    //分页显示
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleDot;
    //Q弹效果  感觉有bug
    //    browser.bounces = YES;
    [browser showFromViewController:[MyTool topViewController]];
}


// 点击圈子
- (void)circleBtnAction:(UIButton *)btn
{
    CircleDetailTwoViewController *detailsVC = [[CircleDetailTwoViewController alloc] init];
    detailsVC.circleID = _dataDic[@"circle_id"];
    [[MyTool topViewController].navigationController pushViewController:detailsVC animated:YES];
}

// 动态评论点击
-(void)commentsbntAction:(UIButton *)btn
{
    
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
