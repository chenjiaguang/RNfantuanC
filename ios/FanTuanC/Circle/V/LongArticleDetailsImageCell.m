//
//  LongArticleDetailsImageCell.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/4/20.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "LongArticleDetailsImageCell.h"
#import "GKPhotoBrowser.h"
#import <KSPhotoBrowser.h>
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import <SDWebImage/FLAnimatedImageView+WebCache.h>

@interface LongArticleDetailsImageCell ()< GKPhotoBrowserDelegate,KSPhotoBrowserDelegate>
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign) BOOL isCoverShow;

@end
@implementation LongArticleDetailsImageCell
{
    UIImageView *_picIamgeView;
    UILabel *_pictureDescriptionLabel;
    NSInteger _index;
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
    UIImageView *picIamgeView = [[YYAnimatedImageView alloc]initWithFrame:CGRectZero];
    picIamgeView.backgroundColor = [MyTool colorWithString:@"333333"];
    picIamgeView.userInteractionEnabled = YES;
    picIamgeView.contentMode = UIViewContentModeScaleAspectFit;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickReply:)];
    [picIamgeView addGestureRecognizer:singleTap];
    
    _picIamgeView = picIamgeView;
    
    UILabel *pictureDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    pictureDescriptionLabel.textColor = [MyTool colorWithString:@"999999"];
    pictureDescriptionLabel.font = [UIFont systemFontOfSize:12];
    _pictureDescriptionLabel = pictureDescriptionLabel;
    [self.contentView sd_addSubviews:@[picIamgeView,pictureDescriptionLabel]];

  
}
-(void)setModel:(Comment *)model
{
    _model = model;
    CGFloat imageHeight = (kScreenW)*[_model.height floatValue]/[_model.width floatValue];
//    [_picIamgeView sd_setImageWithURL:[NSURL URLWithString:_model.imageUrl]];
//    _picIamgeView.yy_imageURL = [NSURL URLWithString:_model.imageUrl];
    [_picIamgeView yy_setImageWithURL:[NSURL URLWithString:_model.imageUrl] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation];
 
   //    _pictureDescriptionLabel.text = _model.des;
//    [UILabel changeLineSpaceForLabel:_pictureDescriptionLabel WithSpace:6.0];

    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为6
    [paragraphStyle  setLineSpacing:6];
    paragraphStyle.alignment = NSTextAlignmentCenter;//设置对齐方式

    
    NSString  *testString = _model.des;
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:testString];
    [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [testString length])];
    
    [_pictureDescriptionLabel  setAttributedText:setString];
//    _pictureDescriptionLabel.textAlignment = NSTextAlignmentCenter;


   
    CGSize labelSz = [_pictureDescriptionLabel szieAdaptiveWithText:_model.des andTextFont:[UIFont systemFontOfSize:12] andTextMaxSzie:CGSizeMake(kScreenW - 30, 10000) andLineSpacing:6 andTextAlignment:NSTextAlignmentCenter numberOfLines:0];
    
    _picIamgeView.sd_layout
    //    .spaceToSuperView(UIEdgeInsetsMake(15, 15, 15, 15));
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(imageHeight);
    
    _pictureDescriptionLabel.isAttributedContent = YES;
    _pictureDescriptionLabel.sd_layout
    .topSpaceToView(_picIamgeView, 9)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(labelSz.height);
    [_pictureDescriptionLabel setMaxNumberOfLinesToShow:0];

    [self setupAutoHeightWithBottomView:_pictureDescriptionLabel bottomMargin:0];

    
    [self updateLayout];
}
-(void)onClickReply:(id)sender
{
    NSMutableArray *items = @[].mutableCopy;
    for (ListModel *model in self.picArr) {
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:_picIamgeView imageUrl:[NSURL URLWithString:model.imageUrl]];
        [items addObject:item];
    }
    if ([self.subscriptArr containsObject:[NSString stringWithFormat:@"%ld",self.row]]) {
        NSInteger index = [self.subscriptArr indexOfObject:[NSString stringWithFormat:@"%ld",self.row]];
        _index = index;
    }
//    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:_picIamgeView imageUrl:[NSURL URLWithString:_model.imageUrl]];
//    [items addObject:item];
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:_index];
    browser.delegate = self;
    //下拉消失样式
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    //预览背景
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlack;
    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
    //分页显示
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    //Q弹效果  感觉有bug
    //    browser.bounces = YES;
    [browser showFromViewController:[MyTool topViewController]];
    [browser.view addSubview:self.bottomView];

    if (_model.des.length == 0) {
        self.bottomView.hidden = YES;
    }
    _contentLabel.text = _model.des;
    CGSize size = [self sizeWithText:_model.des font:self.contentLabel.font maxW:kScreenW -30];
    self.bottomView.frame = CGRectMake(0, kScreenH - size.height - 30, kScreenW, size.height + 30);
    
    _contentLabel.frame = CGRectMake(15, 15, kScreenW-30, 16);
    _contentLabel.numberOfLines = 0;
    [_contentLabel sizeToFit];
    /*
    NSMutableArray *photos = [NSMutableArray new];
    
    for (ListModel *model in self.picArr) {
        GKPhoto *photo = [GKPhoto new];
        photo.url = [NSURL URLWithString:model.imageUrl];
        photo.sourceImageView = _picIamgeView;
        [photos addObject:photo];
    }
    if ([self.subscriptArr containsObject:[NSString stringWithFormat:@"%ld",self.row]]) {
        NSInteger index = [self.subscriptArr indexOfObject:[NSString stringWithFormat:@"%ld",self.row]];
        _index = index;
    }
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:_index];
    
    browser.showStyle           = GKPhotoBrowserShowStyleNone;
    browser.hideStyle           =  GKPhotoBrowserHideStyleZoomScale;
    browser.isSingleTapDisabled = NO;  // 不响应默认单击事件
    browser.isStatusBarShow     = YES;  // 显示状态栏
    browser.isHideSourceView    = YES;
    browser.delegate            = self;
    [browser setupCoverViews:@[self.bottomView,self.pageLabel] layoutBlock:^(GKPhotoBrowser *photoBrowser, CGRect superFrame) {
        
        [self resetCoverFrame:superFrame index:photoBrowser.currentIndex];
        
    }];
    self.isCoverShow = YES;
    [browser showFromVC:[MyTool topViewController]];
     */
}
- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didSelectItem:(KSPhotoItem *)item atIndex:(NSUInteger)index
{
    ListModel *model = _picArr[index];
    if (model.des.length == 0) {
        self.bottomView.hidden = YES;
    }else{
        self.bottomView.hidden = NO;
        _contentLabel.text = model.des;
    }
}
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxW:(CGFloat)maxW {
    CGSize size = CGSizeMake(maxW, CGFLOAT_MAX);
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:size options:options attributes:attrs context:nil].size;
}
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [_bottomView addSubview:self.contentLabel];
    }
    return _bottomView;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel               = [UILabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor     = [UIColor whiteColor];
        _contentLabel.font          = [UIFont systemFontOfSize:16.0];
    }
    return _contentLabel;
}
- (UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel               = [UILabel new];
        _pageLabel.numberOfLines = 0;
        _pageLabel.textColor     = [UIColor whiteColor];
        _pageLabel.font          = [UIFont systemFontOfSize:16.0];
    }
    return _pageLabel;
}
@end
