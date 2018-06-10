//
//  LongArticleSectionFooterView.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/5/21.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "LongArticleSectionFooterView.h"

@interface LongArticleSectionFooterView ()
{
    
    UIImageView *_headerIamgeView;  //头像
    UIButton *_addressbnt;          //地址
    UIButton *_focusbnt;            //关注
    UIButton *_praisebnt;           //点赞
    UILabel *_browseNumLabel;       //浏览次数
    NSMutableArray *_likeImageViews;//点赞头像数组
    UILabel *_praiseNumLabel;       //点赞人数
    UIView *_likeIamgeBgView;
    UIButton *_commentsbnt;
    UIButton *_shareBnt;
    UILabel *_commentsNumLabel;
}
@end
@implementation LongArticleSectionFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}
//点赞
-(void)praisebntAction:(UIButton *)btn
{
    if (self.praiseButtonClickedBlock) {
        self.praiseButtonClickedBlock(btn);
    }
}
-(void)setModel:(CircleModel *)model
{
    _model = model;
    _browseNumLabel.text = [NSString stringWithFormat:@"%@次浏览",_model.data.read_num];
    _commentsNumLabel.text = [NSString stringWithFormat:@"%@条评论",_model.data.comment_num];
    _praisebnt.selected = _model.data.has_like;
    if (_model.data.location.length > 0) {
        _addressbnt.hidden = NO;
        [_addressbnt setTitle:_model.data.location forState:UIControlStateNormal];
        _browseNumLabel.sd_layout
        .leftSpaceToView(_addressbnt, 15);
    }else{
        _addressbnt.hidden = YES;
        _browseNumLabel.sd_layout
        .leftSpaceToView(self.contentView, 15);
    }
    if (_model.data.like_list.count >0) {
        _praiseNumLabel.text = [NSString stringWithFormat:@"%ld人点了赞",_model.data.like_list.count];
    }else{
        _praiseNumLabel.text = @"";
    }
    _praiseNumLabel.sd_layout
    .leftSpaceToView(self.contentView, 20*_model.data.like_list.count + 8 *_model.data.like_list.count +15)
    .centerYEqualToView(_praisebnt)
    .heightIs(12);
    [_praiseNumLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    for (int i =0 ; i< _model.data.like_list.count; i ++) {
        UIImageView *imageView = _likeImageViews[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:_model.data.like_list[i].avatar]];
        imageView.hidden = NO;
    }
}
-(void)bntAction:(UIButton *)btn
{
    [self.delegate clickOnTheWitnBtn:btn Index:btn.tag-5000];
}
-(void)createUI
{
    UIButton *addressbnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [addressbnt setTitleColor:[MyTool colorWithString:@"999999"] forState:UIControlStateNormal];
    addressbnt.titleLabel.font = [UIFont systemFontOfSize:12];
    [addressbnt setTitle:@"百方大厦" forState:UIControlStateNormal];
    [addressbnt setImage:[UIImage imageNamed:@"icon_位置"] forState:UIControlStateNormal];
    _addressbnt = addressbnt;
    
    UILabel *browseNumLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    browseNumLabel.textColor = [MyTool colorWithString:@"999999"];
    browseNumLabel.font = [UIFont systemFontOfSize:12];
    browseNumLabel.text = @"323次浏览";
    _browseNumLabel = browseNumLabel;
    
    UIView *likeIamgeBgView = [[UIView alloc]init];
    _likeIamgeBgView = likeIamgeBgView;
    _likeImageViews = [NSMutableArray array];
    for (int i = 0; i<3; i++) {
        UIImageView *imgView = [[UIImageView alloc]init];
        [_likeImageViews addObject:imgView];
        imgView.backgroundColor = [MyTool colorWithString:@"EEEEEE"];
        [likeIamgeBgView addSubview:imgView];
        imgView.sd_layout.autoHeightRatio(1);
        imgView.userInteractionEnabled=YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds  = YES;
        imgView.tag = 1000+i;
        imgView.hidden = YES;
    }
    UILabel *praiseNumLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    praiseNumLabel.textColor = [MyTool colorWithString:@"666666"];
    praiseNumLabel.font = [UIFont systemFontOfSize:12];
    praiseNumLabel.text = @"等123人点了赞";
    _praiseNumLabel = praiseNumLabel;
    
    UIButton *praisebnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [praisebnt setImage:[UIImage imageNamed:@"icon_点赞"] forState:UIControlStateNormal];
    [praisebnt setImage:[UIImage imageNamed:@"icon_点赞1"] forState:UIControlStateSelected];
    [praisebnt addTarget:self action:@selector(praisebntAction:) forControlEvents:UIControlEventTouchUpInside];
    praisebnt.tag = 5001;
    _praisebnt = praisebnt;
    
    UIButton *commentsbnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentsbnt setImage:[UIImage imageNamed:@"icon_评论"] forState:UIControlStateNormal];
    [commentsbnt addTarget:self action:@selector(bntAction:) forControlEvents:UIControlEventTouchUpInside];
    commentsbnt.tag = 5002;
    _commentsbnt = commentsbnt;
    
    UIButton *shareBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBnt setImage:[UIImage imageNamed:@"新闻分享"] forState:UIControlStateNormal];
    [shareBnt addTarget:self action:@selector(bntAction:) forControlEvents:UIControlEventTouchUpInside];
    shareBnt.tag = 5003;
    _shareBnt = shareBnt;
    
    
    UILabel *commentsNumLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    commentsNumLabel.textColor = [MyTool colorWithString:@"333333"];
    commentsNumLabel.font = [UIFont boldSystemFontOfSize:14];
    commentsNumLabel.text = @"43条评论";
    _commentsNumLabel = commentsNumLabel;
    
    [self.contentView sd_addSubviews:@[addressbnt,browseNumLabel,likeIamgeBgView,praiseNumLabel,praisebnt,commentsbnt,shareBnt,commentsNumLabel]];
    
    addressbnt.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 0);
    [addressbnt setupAutoSizeWithHorizontalPadding:0 buttonHeight:12];
    addressbnt.titleLabel.sd_layout
    .leftSpaceToView(addressbnt.imageView, 5);
    
    browseNumLabel.sd_layout
    .leftSpaceToView(addressbnt, 15)
    .centerYEqualToView(addressbnt)
    .heightIs(12);
    
    likeIamgeBgView.sd_layout
    .centerYEqualToView(shareBnt)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(80);
    
    [browseNumLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    for (UIImageView *imageView in _likeImageViews) {
        imageView.sd_layout
        .widthIs(20)
        .heightEqualToWidth();
        imageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    }
     [likeIamgeBgView setupAutoWidthFlowItems:_likeImageViews withPerRowItemsCount:3 verticalMargin:0 horizontalMargin:8 verticalEdgeInset:0 horizontalEdgeInset:0];
    
    praiseNumLabel.sd_layout
    .leftSpaceToView(likeIamgeBgView, 15)
    .centerYEqualToView(likeIamgeBgView)
    .heightIs(12);
    [praiseNumLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    shareBnt.sd_layout
    .topSpaceToView(browseNumLabel, 34)
    .rightSpaceToView(self.contentView, 15)
    .widthIs(17)
    .heightEqualToWidth();
    
    commentsbnt.sd_layout
    .centerYEqualToView(shareBnt)
    .rightSpaceToView(shareBnt, 23)
    .widthIs(17)
    .heightEqualToWidth();
    
    praisebnt.sd_layout
    .centerYEqualToView(shareBnt)
    .rightSpaceToView(commentsbnt, 23)
    .widthIs(17)
    .heightEqualToWidth();
    
    commentsNumLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(shareBnt, 21)
    .heightIs(14);
    [commentsNumLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    [self setupAutoHeightWithBottomView:commentsNumLabel bottomMargin:5];

}

@end
