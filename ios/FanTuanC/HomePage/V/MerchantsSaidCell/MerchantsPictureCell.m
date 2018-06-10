//
//  MerchantsPictureCell.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/1/29.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "MerchantsPictureCell.h"
#import <KSPhotoBrowser.h>
@interface MerchantsPictureCell ()
{
    NSMutableArray *_imageViews;
    UIImageView *_headerIamgeView;
    UILabel *_contentLabel;
    UILabel *_timeLabel;
    NSArray *_picArr;
    NSArray *_bigPicArr;
}

@end
@implementation MerchantsPictureCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
    }
    return self;
}
-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    [self assignment];
}
-(void)assignment
{
    _contentLabel.text = _dataDic[@"content"];
    [_contentLabel sizeToFit];
    [_headerIamgeView sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"avatar"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        _headerIamgeView.image = [self imageWithSourceImage:_headerIamgeView.image];
    }];
//    [_headerIamgeView sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"avatar"]]];
    _timeLabel.text = _dataDic[@"create_at"];

    _picArr = [_dataDic[@"imageUrl"]mutableCopy];
    _bigPicArr = [_dataDic[@"imageUrl_big"]mutableCopy];
    [self redesignLayout];
}
- (void)createSubviews
{
    UIImageView *headerIamgeView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 50, 50)];
    headerIamgeView.image = [UIImage imageNamed:@"默认头像"];
    [self.contentView addSubview:headerIamgeView];
    _headerIamgeView = headerIamgeView;
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headerIamgeView.frame) + 10, 29, 100, 15)];
    nameLabel.text = @"商家";
    nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:nameLabel];
    

    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame) + 10, kScreenW -15 -10 -50 - 15, 0)];
    contentLabel.font = [UIFont systemFontOfSize:14];
//    contentLabel.backgroundColor = [UIColor yellowColor];
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    contentLabel.sd_layout
    .leftSpaceToView(headerIamgeView, 10)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(nameLabel, 10);
    
    _contentLabel = contentLabel;
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW - 110 - 15, nameLabel.frame.origin.y, 110, 12)];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = [MyTool colorWithString:@"999999"];
    [self.contentView addSubview:timeLabel];
    _timeLabel = timeLabel;
    //每个Item宽高
    CGFloat W = (kScreenW - 75 - 20 - 15)/3;
    CGFloat H = W * 0.745;
    //每行列数
    NSInteger rank = 3;
    //每列间距
    CGFloat rankMargin = (kScreenW - rank * W -75 -15) / (rank - 1);
    //每行间距
    CGFloat rowMargin = 10;
    //Item索引 ->根据需求改变索引
    NSUInteger index = 9;
    _imageViews = @[].mutableCopy;
    for (int i = 0 ; i< index; i++) {
        //Item X轴
        CGFloat X = 15 + 50 + 10 + (i % rank) * (W + rankMargin);
        //Item Y轴
        NSUInteger Y = CGRectGetMaxY(contentLabel.frame) + (i / rank) * (H +rowMargin);
        //Item top
        CGFloat top = 10;
        UIImageView *speedView = [[UIImageView alloc] init];
//        speedView.backgroundColor = [UIColor redColor];
        speedView.frame = CGRectMake(X, Y+top, W, H);
//        [speedView sd_setImageWithURL:urls[i]];
        speedView.userInteractionEnabled = YES;
        speedView.layer.masksToBounds = YES;
        speedView.contentMode = UIViewContentModeScaleAspectFill;
        speedView.tag = 1000+i;
        // 隐藏点击查看大图功能
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
//        [speedView addGestureRecognizer:singleTap];
        [_imageViews addObject:speedView];
        [self.contentView addSubview:speedView];
    }
}
//重新布局
-(void)redesignLayout
{
    CGFloat W = (kScreenW - 75 - 20 - 15)/3;
    CGFloat H = W * 0.745;
    NSInteger rank = 3;
    CGFloat rankMargin = (kScreenW - rank * W -75 -15) / (rank - 1);
    CGFloat rowMargin = 10;
    for (int i = 0 ; i< _imageViews.count; i++) {
        CGFloat X = 15 + 50 + 10 + (i % rank) * (W + rankMargin);
        NSUInteger Y = CGRectGetMaxY(_contentLabel.frame) + (i / rank) * (H +rowMargin);
        CGFloat top = 10;
        UIImageView *speedView = _imageViews[i];
        speedView.frame = CGRectMake(X, Y+top, W, H);
        speedView.hidden = YES;

    }
    for (int i = 0 ; i< _picArr.count; i++) {
        UIImageView *speedView = _imageViews[i];
        [speedView sd_setImageWithURL:[NSURL URLWithString:_picArr[i]]];
        speedView.hidden = NO;
    }
}
-(void)onClickImage:(id)sender
{
    NSMutableArray *items = @[].mutableCopy;
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger tag = views.tag;
    for (int i = 0; i < _bigPicArr.count; i++) {
        UIImageView *imageView = _imageViews[i];
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:_bigPicArr[i]]];
        [items addObject:item];
    }
//    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView imageUrl:[NSURL URLWithString:url]];
//    [items addObject:item];
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:tag - 1000];
    //下拉消失样式
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    //预览背景
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlur;
    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleIndeterminate;
    //分页显示
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleDot;
    //Q弹效果  感觉有bug
//    browser.bounces = YES;
    
    [browser showFromViewController:[MyTool topViewController]];
}

- (UIImage *)imageWithSourceImage:(UIImage *)sourceImage {
    UIGraphicsBeginImageContext(sourceImage.size);
    //bezierPathWithOvalInRect方法后面传的Rect,可以看作(x,y,width,height),前两个参数是裁剪的中心点,后面两个决定裁剪的区域是圆形还是椭圆.
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height)];
    //把路径设置为裁剪区域(超出裁剪区域以外的内容会自动裁剪掉)
    [path addClip];
    //把图片绘制到上下文当中
    [sourceImage drawAtPoint:CGPointZero];
    //从上下文当中生成一张新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //结束上下文
    UIGraphicsEndImageContext();
    //返回新的图片
    return newImage;
}



@end
