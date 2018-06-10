//
//  CircleCellContentView.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/3/1.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "CircleCellContentView.h"
#import <KSPhotoBrowser.h>
#import "CircleDetailsController.h"
#import "MyCardViewController.h"
@interface CircleCellContentView ()<KSPhotoBrowserDelegate>
{
    NSMutableArray *_imageViews;
    NSMutableArray *_fourImageVs;
    UIImageView *_headerIamgeView;
    UIImageView *_bigIamgeView;
    UILabel *_contentLabel;
    UILabel *_timeLabel;
    UILabel *_nameLabel;
    NSArray *_picArr;
    NSArray *_bigPicArr;
    UIView *_iamgeBgView;
    UIButton *_sourcebnt;
    UILabel *_sourceLabel;
    UIView *_topLineView;
    UIButton *_addressbnt;
    UIButton *_focusbnt;
}
@end
@implementation CircleCellContentView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    headImageView.userInteractionEnabled = YES;
    _headerIamgeView = headImageView;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pusCard)];
    [headImageView addGestureRecognizer:singleTap];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    nameLabel.textColor = [MyTool colorWithString:@"333333"];
    nameLabel.userInteractionEnabled = YES;
    _nameLabel = nameLabel;
    UITapGestureRecognizer *singleTap3 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pusCard)];
    [nameLabel addGestureRecognizer:singleTap3];
    
    UIButton *focusbnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [focusbnt setTitleColor:[MyTool colorWithString:@"999999"] forState:UIControlStateNormal];
    [focusbnt setImage:[UIImage imageNamed:@"新闻关注"] forState:UIControlStateNormal];
    [focusbnt setImage:[UIImage imageNamed:@"新闻已关注"] forState:UIControlStateSelected];

    [focusbnt addTarget:self action:@selector(focusbntAction:) forControlEvents:UIControlEventTouchUpInside];
//    focusbnt.backgroundColor = [UIColor redColor];
    focusbnt.titleLabel.font = [UIFont systemFontOfSize:14];
    focusbnt.hidden = YES;
    _focusbnt = focusbnt;
    
    UILabel *timerLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+15, CGRectGetMaxY(nameLabel.frame) + 8, kScreenW - 45 -40, 16)];
    timerLabel.font = [UIFont systemFontOfSize:12];
    timerLabel.textColor = [MyTool colorWithString:@"999999"];
    _timeLabel = timerLabel;
    
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    contentLabel.textColor = [MyTool colorWithString:@"333333"];
    contentLabel.font = [UIFont systemFontOfSize:17];
    _contentLabel = contentLabel;
    
    UIView *topLineView = [[UIView alloc]initWithFrame:CGRectZero];
    topLineView.backgroundColor = [MyTool colorWithString:@"F5F5F5"];
    _topLineView = topLineView;
    
    UILabel *sourceLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    sourceLabel.font = [UIFont systemFontOfSize:14];
//    sourceLabel.text = @"456次浏览 发布于圈子:";
    sourceLabel.textColor = [MyTool colorWithString:@"999999"];
    _sourceLabel = sourceLabel;
    
    UIButton *sourcebnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [sourcebnt setTitleColor:[MyTool colorWithString:@"05a4be"] forState:UIControlStateNormal];
    //    sourcebnt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [sourcebnt setTitle:@"舌尖上的海口" forState:UIControlStateNormal];
    [sourcebnt addTarget:self action:@selector(ClickCircle) forControlEvents:UIControlEventTouchDown];
    sourcebnt.titleLabel.font = [UIFont systemFontOfSize:14];
    _sourcebnt = sourcebnt;
 
    UIButton *addressbnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [addressbnt setTitleColor:[MyTool colorWithString:@"999999"] forState:UIControlStateNormal];
    //    [addressbnt addTarget:self action:@selector(sourcebntAction:) forControlEvents:UIControlEventTouchUpInside];
    addressbnt.titleLabel.font = [UIFont systemFontOfSize:14];
    _addressbnt = addressbnt;
    
    UIView *iamgeBgView = [[UIView alloc]init];
    _iamgeBgView = iamgeBgView;
    self.multipleBgView = iamgeBgView;
    
    UIImageView *bigIamgeView = [[UIImageView alloc]initWithFrame:CGRectZero];
    bigIamgeView.contentMode = UIViewContentModeScaleAspectFill;
    bigIamgeView.clipsToBounds  = YES;
    [iamgeBgView addSubview:bigIamgeView];
    bigIamgeView.userInteractionEnabled=YES;
    bigIamgeView.tag = 2000;
    UITapGestureRecognizer *singleTap2 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
    [bigIamgeView addGestureRecognizer:singleTap2];
    _bigIamgeView = bigIamgeView;
    
    [self sd_addSubviews:@[headImageView,nameLabel,focusbnt,timerLabel,contentLabel,sourceLabel,sourcebnt,iamgeBgView,addressbnt]];
    
    //*------------------------------------开始自动布局----------------------------------------------------*//
    headImageView.sd_layout
    .leftSpaceToView(self, 15)
    .topSpaceToView(self, 20)
    .widthIs(40)
    .heightEqualToWidth();
    headImageView.sd_cornerRadiusFromWidthRatio = @(0.5);
    
    nameLabel.sd_layout
    .leftSpaceToView(headImageView, 15)
    .topSpaceToView(self, 22)
    .widthIs(kScreenW - 45 -40)
    .autoHeightRatio(0);
    
    focusbnt.sd_layout
    .rightSpaceToView(self, 15)
    .topSpaceToView(self, 22)
    .widthIs(52)
    .heightIs(25);
    
    timerLabel.sd_layout
    .leftSpaceToView(headImageView, 15)
    .topSpaceToView(nameLabel, 4)
    .widthIs(kScreenW - 45 -40)
    .heightIs(16);
    
    //设置约束自适应label
    contentLabel.sd_layout.autoHeightRatio(0);
    //设置约束 最多5行
//    [contentLabel setMaxNumberOfLinesToShow:5];
    contentLabel.sd_layout
    .leftSpaceToView(self, 15)
    .rightSpaceToView(self, 15)
    .topSpaceToView(headImageView, 15);
    
    iamgeBgView.sd_layout
    .leftSpaceToView(self,15)
    .rightSpaceToView(self,15)
    .topSpaceToView(contentLabel,10);
    
//    topLineView.sd_layout
//    .topSpaceToView(self, 0)
//    .leftSpaceToView(self, 0)
//    .rightSpaceToView(self, 0)
//    .heightIs(5);
    
    [sourceLabel setSingleLineAutoResizeWithMaxWidth:kScreenW-30];
    sourceLabel.sd_layout
    .bottomSpaceToView(self, 30)
    .leftSpaceToView(self, 15)
    .heightIs(14);
    
    [sourcebnt setupAutoSizeWithHorizontalPadding:0 buttonHeight:14 ];
    sourcebnt.sd_layout
    .centerYEqualToView(sourceLabel)
    .leftSpaceToView(sourceLabel, 0);
    
    [addressbnt setupAutoSizeWithHorizontalPadding:15 buttonHeight:14 ];
    addressbnt.sd_layout
    .topSpaceToView(_iamgeBgView, 15)
    .bottomSpaceToView(sourcebnt, 15)
    .leftSpaceToView(self, 15);
    
    addressbnt.imageView.sd_layout
    .heightIs(15)
    .widthEqualToHeight()
    .leftSpaceToView(addressbnt, 0);
    
    bigIamgeView.sd_layout
    .topSpaceToView(iamgeBgView, 0)
    .leftSpaceToView(iamgeBgView, 0)
    .rightSpaceToView(iamgeBgView, 0)
    .heightIs((kScreenW-30)*0.463);
    
    _imageViews = [NSMutableArray array];
    for (int i = 0; i<9; i++) {
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.hidden = YES;
        [_imageViews addObject:imgView];
//        imgView.backgroundColor = [UIColor blueColor];
        [iamgeBgView addSubview:imgView];
        imgView.sd_layout.autoHeightRatio(0.72);
        imgView.userInteractionEnabled=YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds  = YES;
        imgView.tag = 1000+i;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
        [imgView addGestureRecognizer:singleTap];
    }
    
    [_imageViews addObject:bigIamgeView];
    [_iamgeBgView setupAutoHeightWithBottomViewsArray:_imageViews  bottomMargin:0];
    
    
    // 四宫格样式
    _fourImageVs = [NSMutableArray array];
    CGFloat imageViewW = (kScreenW-30 -20)/3;
    for (int i = 0; i<4; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((imageViewW+5)*((i+1)%2==0?1:0), (imageViewW * 0.72+5)*((i+1)/3==0?0:1), imageViewW, imageViewW * 0.72)];
        imgView.hidden = YES;
        [_fourImageVs addObject:imgView];
        [iamgeBgView addSubview:imgView];
        imgView.userInteractionEnabled=YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds  = YES;
        imgView.tag = 1000+i;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
        [imgView addGestureRecognizer:singleTap];
    }
}
//点击圈子名字
-(void)ClickCircle
{
    CircleDetailsController *circleVC = [[CircleDetailsController alloc]init];
    circleVC.circleID = _model.circle_id;
    [[MyTool topViewController].navigationController pushViewController:circleVC animated:YES];
}
//点击关注按钮
-(void)focusbntAction:(UIButton *)btn
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] != YES) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *loginNaVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [[MyTool topViewController] presentViewController:loginNaVC animated:YES completion:nil];
    } else {
        [self fous:btn.selected btn:btn];
    }
}
-(void)fous:(BOOL)selected btn:(UIButton *)btn
{
    NSString *urlStr = [NetRequest UserFollow];
    NSDictionary *paramsDic = @{@"token":  [[NSUserDefaults standardUserDefaults] objectForKey:kToken],@"follow":[NSString stringWithFormat:@"%d",!selected],@"following_id":_model.uid};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        CircleModel *model = [CircleModel yy_modelWithJSON:JSON];
        [MyTool showHUDWithStr:model.msg];
        if ([model.error integerValue] == 0) {
            btn.selected = !btn.selected;
        }
    } failure:^(NSError *error) {
        
    }];
}
//进入名片
-(void)pusCard
{
    MyCardViewController *vc = [[MyCardViewController alloc]init];
    vc.navigationItem.title = _model.username;
    vc.type = 1;
    vc.uid = _model.uid;
    vc.isNews = [_model.is_news boolValue];
    [[MyTool topViewController].navigationController pushViewController:vc animated:YES];
}
-(void)setModel:(Data *)model
{
    _model = model;
    [_headerIamgeView sd_setImageWithURL:[NSURL URLWithString:_model.avatar]];
    _nameLabel.text = _model.username;
    _contentLabel.text = _model.content;
    _timeLabel.text = _model.time;
    _focusbnt.hidden = _model.is_owner;
    _focusbnt.selected = _model.is_follow;
    if (_model.location.length != 0) {
        _addressbnt.hidden = NO;
        [_addressbnt setTitle:_model.location forState:UIControlStateNormal];
        [_addressbnt setImage:[UIImage imageNamed:@"AddressDefault"] forState:UIControlStateNormal];
    }else{
        _addressbnt.hidden = YES;
    }
    [_sourcebnt setTitle:_model.circle_name forState:UIControlStateNormal];
    [_commentsbnt setTitle:_model.comment_num forState:UIControlStateNormal];
    _sourceLabel.text = [NSString stringWithFormat:@"%@ 发布于圈子: ",_model.read_num];
    for (UIImageView *imageView in _imageViews) {
        imageView.hidden = YES;
    }
    for (UIImageView *imageView in _fourImageVs) {
        imageView.hidden = YES;
    }
    //子视图只设置高宽比例，
    //用下面两种方法可生成宽间距或等宽的view
    [_iamgeBgView clearAutoWidthFlowItemsSettings];

    if (((NSArray *)_model.cover).count > 1) {
        [_iamgeBgView setupAutoMarginFlowItems:[_imageViews subarrayWithRange:NSMakeRange(0, _model.contents.count)]
                          withPerRowItemsCount:3
                                     itemWidth:(kScreenW-30 -12)/3
                                verticalMargin:6
                             verticalEdgeInset:0
                           horizontalEdgeInset:0];
    }

    if (((NSArray *)_model.cover).count == 0){
        _iamgeBgView.hidden = YES;
//        _iamgeBgView.sd_layout
//        .heightIs(0);
    }
    
   
    if (((NSArray *)_model.cover).count == 1) {
        _iamgeBgView.hidden = NO;
        _bigIamgeView.hidden = NO;
        [_bigIamgeView sd_setImageWithURL:[NSURL URLWithString:((NSArray *)_model.cover).firstObject]];
    }else if(((NSArray *)_model.cover).count == 4){
        _bigIamgeView.hidden = YES;
        for (int i = 0; i< ((NSArray *)_model.cover).count; i ++ ) {
            UIImageView * imageView = _fourImageVs[i];
            imageView.hidden = NO;
            [imageView sd_setImageWithURL:[NSURL URLWithString:_model.cover.mutableCopy[i]]];
        }
    }else{
        _bigIamgeView.hidden = YES;
        for (int i = 0; i< ((NSArray *)_model.cover).count; i ++ ) {
            UIImageView * imageView = _imageViews[i];
            imageView.hidden = NO;
            [imageView sd_setImageWithURL:[NSURL URLWithString:_model.cover.mutableCopy[i]]];
        }
    }
    
    //    [self setupAutoHeightWithBottomViewsArray:@[_commentsbnt, _praisebnt] bottomMargin:15];
    
    
    [self updateLayout];
}
-(void)onClickImage:(id)sender
{
    NSMutableArray *items = @[].mutableCopy;
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger tag = views.tag;
    for (int i = 0; i < ((NSArray *)_model.cover).count; i++) {
        // 特殊处理四张图片的情况
//        if ([_model.cover count] == 4) {
//            UIImageView *imageView = _fourImageVs[i];
//            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:_model.cover.mutableCopy[i]]];
//            [items addObject:item];
//        } else {
//            UIImageView *imageView = _imageViews[i];
//            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:_model.cover.mutableCopy[i]]];
//            [items addObject:item];
//        }
    }
    
    if (tag == 2000) {
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:_bigIamgeView imageUrl:[NSURL URLWithString:_model.cover.mutableCopy[0]]];
        items = @[item].mutableCopy;
        tag = 1000;
    }
  
    //    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:url]];
    //    [items addObject:item];
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:tag - 1000];
    browser.delegate = self;
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
- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didSelectItem:(KSPhotoItem *)item atIndex:(NSUInteger)index
{
}

@end
