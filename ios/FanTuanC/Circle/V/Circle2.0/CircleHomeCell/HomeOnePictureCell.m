//
//  HomeOnePictureCell.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/5/2.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "HomeOnePictureCell.h"
#import <KSPhotoBrowser.h>

@interface HomeOnePictureCell ()
{
    UIImageView *_headImageView; //用户头像
    UILabel *_nameLabel;         //用户名称
    UILabel *_timerLabel;        //时间
    UILabel *_contentLabel;      //内容
    UILabel *_sourceLabel;       //发布于Label
    UIButton *_sourcebnt;        //数据发布源按钮
    UIImageView *_picIamgeView;  //动态内容图片
    UIButton *_praisebnt;        //点赞按钮
    UIButton *_commentsbnt;      //评论按钮
    UIButton *_addressbnt;       //动态位置按钮
    UIView *_lienView;           //分割线
    UILabel *_longPic;           //长图标签
    UIImageView *_adminIamgeView;//管理员图标

}
@end
@implementation HomeOnePictureCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createUI];

    }
    return self;
}
-(void)setModel:(ListModel *)model
{
    _model = model;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatar]];
    _nameLabel.text = _model.username;
    _timerLabel.text = _model.time;
    _praisebnt.selected = _model.has_like;
    [_picIamgeView yy_setImageWithURL:[NSURL URLWithString:_model.covers.firstObject.compress] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation];
    [_sourcebnt setTitle:_model.circle_name forState:UIControlStateNormal];
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为30
    [paragraphStyle  setLineSpacing:6];
    NSString  *testString = _model.content;
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:testString];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [testString length])];
    [_contentLabel  setAttributedText:setString];
    if(_model.circle_name.length >0){
        _sourceLabel.hidden = NO;
    }else{
        _sourceLabel.hidden = YES;
    }
    [_praisebnt setTitle:[_model.like_num isEqualToString:@"0"]?@"点赞":_model.like_num forState:UIControlStateNormal];
    [_commentsbnt setTitle:[_model.like_num isEqualToString:@"0"]?@"评论":_model.comment_num forState:UIControlStateNormal];
    [_addressbnt setTitle:_model.location forState:UIControlStateNormal];
    if (!_model.is_circle_owner && !_model.is_circle_owner ) {
        _adminIamgeView.hidden = YES;
    }else{
        _adminIamgeView.hidden = NO;
        if (_model.is_circle_owner) {
            _adminIamgeView.image = [UIImage imageNamed:@"master2.0"];
        }else{
            _adminIamgeView.image = [UIImage imageNamed:@"administrator-1"];
        }
    }
    if(_model.covers.firstObject.longCover){
        _longPic.hidden = NO;
        _picIamgeView.sd_layout
        .widthIs(kScreenW *125/375)
        .heightIs(kScreenH *180/667);
    }else if([_model.covers.firstObject.width floatValue] > kScreenW  *180/375){
        _longPic.hidden = YES;
        _picIamgeView.sd_layout
        .widthIs( kScreenW  *180/375)
        .heightIs((kScreenW  *180/375) * [_model.covers.firstObject.height floatValue]/[_model.covers.firstObject.width floatValue]);
    }else{
        _longPic.hidden = YES;
        _picIamgeView.sd_layout
        .heightIs([_model.covers.firstObject.height floatValue])
        .widthIs([_model.covers.firstObject.width floatValue]);
    }
    [self.contentView updateLayout];

}
-(void)setCirleHome:(BOOL)cirleHome
{
    _cirleHome = cirleHome;
    if (_cirleHome) {
        _sourceLabel.hidden = YES;
        _sourcebnt.hidden = YES;
    }else{
        _sourceLabel.hidden = NO;
        _sourcebnt.hidden = NO;
    }
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
-(void)onClickImage:(id)sender
{
    NSMutableArray *items = @[].mutableCopy;
    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:_picIamgeView imageUrl:[NSURL URLWithString:_model.covers.firstObject.url]];
    [items addObject:item];
    //    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:url]];
    //    [items addObject:item];
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:0];
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
//自动布局
-(void)autoLayoutView
{
    [self.contentView sd_resetLayout];
    _headImageView.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 20)
    .widthIs(35)
    .heightEqualToWidth();
    _headImageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:kScreenW - 45 - 40 - 5 -34 - 15];
    _nameLabel.sd_layout
    .leftSpaceToView(_headImageView, 15)
    .topSpaceToView(self.contentView, 22)
    .autoHeightRatio(0);
    
    _adminIamgeView.sd_layout
    .leftSpaceToView(_nameLabel, 5)
    .centerYEqualToView(_nameLabel)
    .widthIs(37)
    .heightIs(14);
    
    _timerLabel.sd_layout
    .leftSpaceToView(_headImageView, 15)
    .topSpaceToView(_nameLabel, 5)
    .heightIs(16);
    [_timerLabel setSingleLineAutoResizeWithMaxWidth:kScreenW];

    _sourceLabel.sd_layout
    .leftSpaceToView(_timerLabel, 15)
    .centerYEqualToView(_timerLabel)
    .autoHeightRatio(0);
    [_sourceLabel setSingleLineAutoResizeWithMaxWidth:40];

    _sourcebnt.sd_layout
    .leftSpaceToView(_sourceLabel, 0)
    .centerYEqualToView(_timerLabel)
    .heightIs(12);
    [_sourcebnt setupAutoSizeWithHorizontalPadding:0 buttonHeight:12];
    
    //设置约束自适应label
    _contentLabel.sd_layout.autoHeightRatio(0);
    //设置约束 最多5行
    //    [contentLabel setMaxNumberOfLinesToShow:5];
    _contentLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(_headImageView, 15);
    _contentLabel.isAttributedContent = YES;

    _picIamgeView.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(_contentLabel, 15);
    
    _longPic.sd_layout
    .bottomSpaceToView(_picIamgeView, 0)
    .rightSpaceToView(_picIamgeView, 0)
    .widthIs(31)
    .heightIs(17);
    if (_model.location.length > 0) {
        _addressbnt.sd_layout
        .leftSpaceToView(self.contentView, 15)
        .topSpaceToView(_picIamgeView, 15);
        [_addressbnt setupAutoSizeWithHorizontalPadding:0 buttonHeight:12];
        _addressbnt.titleLabel.sd_layout
        .leftSpaceToView(_addressbnt.imageView, 5);
    }
    
    
    _praisebnt.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .topSpaceToView(_model.location.length > 0?_addressbnt:_picIamgeView, 15)
    .heightIs(15)
    .widthIs(89);
    
    _praisebnt.imageView.sd_layout
    .heightIs(15)
    .leftSpaceToView(_praisebnt, 0)
    .widthEqualToHeight();
    
    _praisebnt.titleLabel.sd_layout
    .rightSpaceToView(_praisebnt, 0)
    .leftSpaceToView(_praisebnt.imageView, 8);
    
    _commentsbnt.sd_layout
    .leftSpaceToView(_praisebnt, 0)
    .centerYEqualToView(_praisebnt)
    .heightIs(15)
    .widthIs(89);
    
    _commentsbnt.imageView.sd_layout
    .heightIs(15)
    .leftSpaceToView(_commentsbnt, 0)
    .widthEqualToHeight();
    
    _commentsbnt.titleLabel.sd_layout
    .rightSpaceToView(_commentsbnt, 0)
    .leftSpaceToView(_commentsbnt.imageView, 8);
    

    
    _lienView.sd_layout
    .topSpaceToView(_commentsbnt, 17)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(0.5);
    
    [self setupAutoHeightWithBottomView:_lienView bottomMargin:0];
    
}
-(void)createUI
{
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    headImageView.userInteractionEnabled = YES;
    headImageView.layer.masksToBounds = YES;
    headImageView.backgroundColor = [MyTool ColorWithColorStr:@"EEEEEE"];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    //头像点击事件
    UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageTapAction:)];
    [headImageView addGestureRecognizer:headerTap];
    _headImageView = headImageView;
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    nameLabel.userInteractionEnabled = YES;
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    nameLabel.textColor = [MyTool colorWithString:@"333333"];
    nameLabel.text = @"Coconut";
    //用户名点击事件
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageTapAction:)];
    [nameLabel addGestureRecognizer:nameTap];
    _nameLabel = nameLabel;
    UIImageView *adminIamgeView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"administrator-1"]];
    _adminIamgeView = adminIamgeView;
    UILabel *timerLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+15, CGRectGetMaxY(nameLabel.frame) + 8, kScreenW - 45 -40, 16)];
    timerLabel.font = [UIFont systemFontOfSize:12];
    timerLabel.textColor = [MyTool colorWithString:@"999999"];
    timerLabel.text = @"8分钟前";
    _timerLabel = timerLabel;
    
    UILabel *sourceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    sourceLabel.font = [UIFont systemFontOfSize:12];
    sourceLabel.textColor = [MyTool colorWithString:@"999999"];
    sourceLabel.text = @"发布于";
    _sourceLabel = sourceLabel;
    
    UIButton *sourcebnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [sourcebnt setTitleColor:[MyTool colorWithString:@"1EB0FD"] forState:UIControlStateNormal];
    [sourcebnt addTarget:self action:@selector(sourcebntAction:) forControlEvents:UIControlEventTouchUpInside];
    sourcebnt.titleLabel.font = [UIFont systemFontOfSize:12];
    [sourcebnt setTitle:@"国贸混混" forState:UIControlStateNormal];
    _sourcebnt = sourcebnt;
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    contentLabel.textColor = [MyTool colorWithString:@"333333"];
    contentLabel.font = [UIFont systemFontOfSize:16];
    contentLabel.text = @"阿里妹导读：随着手淘流量红利时代的结束，如何通过精细化运营、不断提升App用户体验，成了我们新的目标。手淘技术团队童鞋在有限的条件下，巧妙利用Weex，实现了以往用纯native才能实现的卡片式交互形态，给用户创造了小惊喜（该技术已开源）。下面让我们一起来深入了解。";
    _contentLabel = contentLabel;
    
    UIImageView *picIamgeView = [YYAnimatedImageView new];
    picIamgeView.backgroundColor = [MyTool ColorWithColorStr:@"EEEEEE"];
    picIamgeView.contentMode = UIViewContentModeScaleAspectFill;
    picIamgeView.clipsToBounds  = YES;
    picIamgeView.userInteractionEnabled=YES;
    picIamgeView.clipsToBounds  = YES;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
    [picIamgeView addGestureRecognizer:singleTap];
    _picIamgeView =picIamgeView;
    
    UILabel *longPic = [[UILabel alloc]initWithFrame:CGRectZero];
    longPic.text = @"长图";
    longPic.font = [UIFont systemFontOfSize:12];
    longPic.textColor = [UIColor whiteColor];
    longPic.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    longPic.hidden = YES;
    [picIamgeView addSubview:longPic];
    _longPic = longPic;
    
    UIButton *addressbnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [addressbnt setTitleColor:[MyTool colorWithString:@"999999"] forState:UIControlStateNormal];
    addressbnt.titleLabel.font = [UIFont systemFontOfSize:12];
    [addressbnt setTitle:@"百方大厦" forState:UIControlStateNormal];
    [addressbnt setImage:[UIImage imageNamed:@"icon_位置"] forState:UIControlStateNormal];
    _addressbnt = addressbnt;
    
    UIButton *praisebnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [praisebnt setTitleColor:[MyTool colorWithString:@"666666"] forState:UIControlStateNormal];
    [praisebnt setTitleColor:[MyTool colorWithString:@"FF3F53"] forState:UIControlStateSelected];
    praisebnt.titleLabel.font = [UIFont systemFontOfSize:12];
    [praisebnt setImage:[UIImage imageNamed:@"icon_点赞"] forState:UIControlStateNormal];
    [praisebnt setImage:[UIImage imageNamed:@"icon_点赞1"] forState:UIControlStateSelected];
    [praisebnt setTitle:@"点赞" forState:UIControlStateNormal];
    [praisebnt addTarget:self action:@selector(praisebntAction:) forControlEvents:UIControlEventTouchUpInside];

    _praisebnt = praisebnt;
    
    UIButton *commentsbnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentsbnt setTitleColor:[MyTool colorWithString:@"666666"] forState:UIControlStateNormal];
    commentsbnt.titleLabel.font = [UIFont systemFontOfSize:12];
    [commentsbnt setImage:[UIImage imageNamed:@"icon_评论"] forState:UIControlStateNormal];
    [commentsbnt addTarget:self action:@selector(commentsbntAction:) forControlEvents:UIControlEventTouchUpInside];
    [commentsbnt setTitle:@"评论" forState:UIControlStateNormal];
    _commentsbnt = commentsbnt;
    
    UIView *lienView = [[UIView alloc]initWithFrame:CGRectZero];
    lienView.backgroundColor = [MyTool colorWithString:@"E5E5E5"];
    _lienView = lienView;
    [self.contentView sd_addSubviews:@[headImageView,nameLabel,adminIamgeView,timerLabel,contentLabel,praisebnt,commentsbnt,sourceLabel,sourcebnt,addressbnt,picIamgeView,lienView]];
    [self autoLayoutView];

}
@end
