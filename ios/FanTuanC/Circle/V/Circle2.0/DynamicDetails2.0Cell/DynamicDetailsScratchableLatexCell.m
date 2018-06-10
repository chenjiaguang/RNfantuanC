//
//  DynamicDetailsScratchableLatexCell.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/5/9.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "DynamicDetailsScratchableLatexCell.h"
#import <KSPhotoBrowser.h>

@interface DynamicDetailsScratchableLatexCell ()
{
    
    UIImageView *_headerIamgeView;  //头像
    UILabel *_contentLabel;         //内容
    UILabel *_timeLabel;            //时间
    UILabel *_nameLabel;            //用户名
    UIButton *_addressbnt;          //地址
    UIButton *_focusbnt;            //关注
    UIButton *_praisebnt;           //点赞
    UILabel *_browseNumLabel;       //浏览次数
    NSMutableArray *_imageViews;    //
    NSMutableArray *_likeImageViews;//点赞头像数组
    UILabel *_praiseNumLabel;       //点赞人数
    UIView *_iamgeBgView;
    UIView *_likeIamgeBgView;
}
@end
@implementation DynamicDetailsScratchableLatexCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
//头像、用户名称点击
- (void)headImageTapAction:(UITapGestureRecognizer *)tap
{
    
}
//动态来源点击
-(void)sourcebntAction:(UIButton *)btn
{
    
}
//点赞
-(void)praisebntAction:(UIButton *)btn
{
    if (self.praiseButtonClickedBlock) {
        self.praiseButtonClickedBlock(btn);
    }
}
//动态评论点击
-(void)commentsbntAction:(UIButton *)btn
{
    
}
//关注点击
-(void)focusbntAction:(UIButton *)btn
{
    if (self.fousButtonClickedBlock) {
        self.fousButtonClickedBlock(btn);
    }
}
-(void)setLike_list:(NSArray<ListModel *> *)like_list
{
    _like_list = like_list;
    if (_like_list.count >0) {
        _praiseNumLabel.text = [NSString stringWithFormat:@"%ld人点了赞",_like_list.count];
    }else{
        _praiseNumLabel.text = @"";
    }
    _praiseNumLabel.sd_layout
    .leftSpaceToView(self.contentView, 20*_like_list.count + 8 *_like_list.count +15)
    .centerYEqualToView(_praisebnt)
    .heightIs(12);
    [_praiseNumLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    for (int i =0 ; i< _like_list.count; i ++) {
        UIImageView *imageView = _likeImageViews[i];
        [imageView yy_setImageWithURL:[NSURL URLWithString:_like_list[i].avatar] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation];
        imageView.hidden = NO;
    }
}
-(void)setModel:(ListModel *)model
{
    _model = model;
    [_headerIamgeView sd_setImageWithURL:[NSURL URLWithString:_model.avatar]];
    _nameLabel.text = _model.username;
    _timeLabel.text = _model.time;
    _browseNumLabel.text = [NSString stringWithFormat:@"%@次浏览",_model.read_num];
    _praisebnt.selected = _model.has_like;
    _focusbnt.hidden = _model.is_following;
    if (_model.location.length > 0) {
        _addressbnt.hidden = NO;
        [_addressbnt setTitle:_model.location forState:UIControlStateNormal];
        _browseNumLabel.sd_layout
        .leftSpaceToView(_addressbnt, 15);
    }else{
        _addressbnt.hidden = YES;
        _browseNumLabel.sd_layout
        .leftSpaceToView(self.contentView, 15);
    }
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为30
    [paragraphStyle  setLineSpacing:6];
    NSString  *testString = _model.content;
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:testString];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [testString length])];
    [_contentLabel  setAttributedText:setString];
    [_iamgeBgView setupAutoMarginFlowItems:[_imageViews subarrayWithRange:NSMakeRange(0, _model.covers.count)] withPerRowItemsCount:3 itemWidth:(kScreenW- 6)/3 verticalMargin:3 verticalEdgeInset:0 horizontalEdgeInset:0];

    for (int i = 0; i < _model.covers.count; i ++) {
        UIImageView *imageView = _imageViews[i];
        [imageView yy_setImageWithURL:[NSURL URLWithString:_model.covers[i].url] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation];
    }
    [self.contentView updateLayout];
    
}
-(void)onClickImage:(id)sender
{
    NSMutableArray *items = @[].mutableCopy;
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger tag = views.tag;
    for (int i = 0; i < _model.covers.count; i++) {
        UIImageView *imageView = _imageViews[i];
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:_model.covers[i].url]];
        [items addObject:item];
        
    }
    //    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:url]];
    //    [items addObject:item];
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
-(void)createUI
{
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    headImageView.userInteractionEnabled = YES;
    headImageView.backgroundColor = [MyTool ColorWithColorStr:@"EEEEEE"];
    _headerIamgeView = headImageView;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageTapAction:)];
    [headImageView addGestureRecognizer:singleTap];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    nameLabel.textColor = [MyTool colorWithString:@"333333"];
    nameLabel.userInteractionEnabled = YES;
    nameLabel.text = @"东方不败";
    _nameLabel = nameLabel;
    UITapGestureRecognizer *singleTap3 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageTapAction:)];
    [nameLabel addGestureRecognizer:singleTap3];
    
    UIButton *focusbnt = [UIButton buttonWithType:UIButtonTypeCustom];
    focusbnt.titleLabel.font =[UIFont systemFontOfSize:12 ];
    [focusbnt setTitle:@"关注" forState:UIControlStateNormal];
    [focusbnt.layer setBorderWidth:1.0];
    focusbnt.layer.borderColor=[MyTool ColorWithColorStr:@"1EB0FD"].CGColor;
    [focusbnt addTarget:self action:@selector(focusbntAction:) forControlEvents:UIControlEventTouchUpInside];
    //    focusbnt.backgroundColor = [UIColor redColor];
    [focusbnt setTitleColor:[MyTool ColorWithColorStr:@"1EB0FD"] forState:UIControlStateNormal];
    
    _focusbnt = focusbnt;
    
    UILabel *timerLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+15, CGRectGetMaxY(nameLabel.frame) + 8, kScreenW - 45 -40, 16)];
    timerLabel.font = [UIFont systemFontOfSize:12];
    timerLabel.textColor = [MyTool colorWithString:@"999999"];
    timerLabel.text = @"8分钟前";
    _timeLabel = timerLabel;
    
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    contentLabel.textColor = [MyTool colorWithString:@"333333"];
    contentLabel.font = [UIFont systemFontOfSize:16];
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为30
    [paragraphStyle  setLineSpacing:6];
    
    NSString  *testString = @"“海口”一名最早出现于宋代，已有九百多年的历 史，意为南渡江入海口处的一块浦滩之地。海口 历史上隶属琼山县，名称沿革有宋代的海口浦， 元代的海口港，明代的海口都、海口所、海口所 城，清代的琼州口等明代的海口都、海口州口等 明代的海口都、海口";
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:testString];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [testString length])];
    [contentLabel  setAttributedText:setString];
    _contentLabel = contentLabel;
    
    //创建九宫格图片
    UIView *iamgeBgView = [[UIView alloc]init];
    _iamgeBgView = iamgeBgView;
    _imageViews = [NSMutableArray array];
    for (int i = 0; i<9; i++) {
        UIImageView *imgView = [YYAnimatedImageView new];
        [_imageViews addObject:imgView];
        imgView.backgroundColor = [MyTool colorWithString:@"EEEEEE"];
        [iamgeBgView addSubview:imgView];
        imgView.sd_layout.autoHeightRatio(1);
        imgView.userInteractionEnabled = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds  = YES;
        imgView.tag = 1000+i;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
        [imgView addGestureRecognizer:singleTap];
    }
    
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
    
    UIButton *praisebnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [praisebnt setImage:[UIImage imageNamed:@"icon_点赞"] forState:UIControlStateNormal];
    [praisebnt setImage:[UIImage imageNamed:@"icon_点赞1"] forState:UIControlStateSelected];
    [praisebnt addTarget:self action:@selector(praisebntAction:) forControlEvents:UIControlEventTouchUpInside];
    _praisebnt = praisebnt;
    
    UIButton *commentsbnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentsbnt setImage:[UIImage imageNamed:@"icon_评论"] forState:UIControlStateNormal];
    _commentsbnt = commentsbnt;
    
    
    UILabel *praiseNumLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    praiseNumLabel.textColor = [MyTool colorWithString:@"666666"];
    praiseNumLabel.font = [UIFont systemFontOfSize:12];
    praiseNumLabel.text = @"等123人点了赞";
    _praiseNumLabel = praiseNumLabel;
    
    UIView *likeIamgeBgView = [[UIView alloc]init];
    _likeIamgeBgView = likeIamgeBgView;
    _likeImageViews = [NSMutableArray array];
    for (int i = 0; i<3; i++) {
        UIImageView *imgView = [YYAnimatedImageView new];
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
    [self.contentView sd_addSubviews:@[headImageView,nameLabel,focusbnt,timerLabel,contentLabel,iamgeBgView,praisebnt,commentsbnt,addressbnt,browseNumLabel,likeIamgeBgView,praiseNumLabel]];
    
    headImageView.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 20)
    .widthIs(kScreenW * 38/375)
    .heightEqualToWidth();
    headImageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    [nameLabel setSingleLineAutoResizeWithMaxWidth:kScreenW - 45 - 40 - 5 -34 - 15];
    nameLabel.sd_layout
    .leftSpaceToView(headImageView, 15)
    .topSpaceToView(self.contentView, 22)
    .autoHeightRatio(0);
    
    timerLabel.sd_layout
    .leftSpaceToView(headImageView, 15)
    .topSpaceToView(nameLabel, 5)
    .heightIs(16);
    [timerLabel setSingleLineAutoResizeWithMaxWidth:kScreenW];
    
    focusbnt.sd_layout
    .centerYEqualToView(headImageView)
    .rightSpaceToView(self.contentView, 15)
    .widthIs(kScreenW * 50/375)
    .heightIs(23);
    focusbnt.sd_cornerRadius = @(4);
    
    contentLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(headImageView, 15)
    .autoHeightRatio(0);
    contentLabel.isAttributedContent = YES;
    
    iamgeBgView.sd_layout
    .topSpaceToView(contentLabel, 15)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0);
    
    addressbnt.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(iamgeBgView, 12);
    [addressbnt setupAutoSizeWithHorizontalPadding:0 buttonHeight:12];
    addressbnt.titleLabel.sd_layout
    .leftSpaceToView(addressbnt.imageView, 5);
    
    browseNumLabel.sd_layout
    .leftSpaceToView(addressbnt, 15)
    .centerYEqualToView(addressbnt)
    .heightIs(12);
    [browseNumLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    likeIamgeBgView.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(browseNumLabel, 30)
    .widthIs(80);
    
    commentsbnt.sd_layout
    .topSpaceToView(browseNumLabel, 32)
    .rightSpaceToView(self.contentView, 15)
    .widthIs(18)
    .heightIs(17);
    
    praisebnt.sd_layout
    .centerYEqualToView(commentsbnt)
    .rightSpaceToView(commentsbnt, 30)
    .widthIs(18)
    .heightIs(18);
    [likeIamgeBgView clearAutoWidthFlowItemsSettings];
    
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
    
    [self setupAutoHeightWithBottomViewsArray:@[praisebnt,commentsbnt] bottomMargin:15];
    
}
@end
