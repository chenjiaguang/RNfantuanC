
//
//  LongArticleBottomView.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/4/23.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "LongArticleBottomView.h"
#import "ShareAlertView.h"

@implementation LongArticleBottomView
{
    UIButton *_praisebnt;
    UIButton *_commentsbnt;
    NSMutableArray *_shareArr;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)setModel:(CircleModel *)model
{
    _model = model;
    [_commentsbnt setTitle:_model.data.comment_num forState:UIControlStateNormal];
    [_praisebnt setTitle:_model.data.like_num forState:UIControlStateNormal];
    _praisebnt.selected = _model.data.has_like;

}
- (void)shareBtnAction:(UIButton *)btn
{
    _shareArr = [NSMutableArray array];
    if ([WXApi isWXAppInstalled]) {
        [_shareArr addObjectsFromArray:@[@"微信好友", @"微信朋友圈"]];
    }
    if ([WeiboSDK isWeiboAppInstalled]) {
        [_shareArr addObjectsFromArray:@[@"微博"]];
    }
    if ([TencentOAuth iphoneQQInstalled]) {
        [_shareArr addObjectsFromArray:@[@"QQ好友", @"QQ空间"]];
    }
    [_shareArr addObject:@"复制链接"];
    
    [self shareViewWithShareTitle:_model.data.title ShareDescription:_model.data.content];
}

// 分享界面
- (void)shareViewWithShareTitle:(NSString *)shareTitle ShareDescription:(NSString *)shareDescription
{
    ShareAlertView *shareAlertV = [[ShareAlertView alloc] initWithFrame:[[UIScreen mainScreen] bounds] listArr:_shareArr];
    [ApplicationDelegate.window addSubview:shareAlertV];
    
    shareAlertV.SelectItem = ^(NSIndexPath *indexPath) {
        if ([_shareArr[indexPath.row] isEqualToString:@"复制链接"]) {
            [self copyUrl];
        } else if ([_shareArr[indexPath.row] isEqualToString:@"微信好友"]) {
            [self WXshareWtihShareTitle:shareTitle ShareDescription:shareDescription Scene:WXSceneSession];
        } else if ([_shareArr[indexPath.row] isEqualToString:@"微信朋友圈"]) {
            [self WXshareWtihShareTitle:shareTitle ShareDescription:shareDescription Scene:WXSceneTimeline];
        } else if ([_shareArr[indexPath.row] isEqualToString:@"QQ好友"]) {
            [self QQshareWtihShareTitle:shareTitle ShareDescription:shareDescription Scene:1];
        } else if ([_shareArr[indexPath.row] isEqualToString:@"QQ空间"]) {
            [self QQshareWtihShareTitle:shareTitle ShareDescription:shareDescription Scene:2];
        } else if ([_shareArr[indexPath.row] isEqualToString:@"微博"]) {
            [self WBshareWtihShareTitle:shareTitle ShareDescription:shareDescription];
        }
    };
}

- (void)WBshareWtihShareTitle:(NSString *)shareTitle ShareDescription:(NSString *)shareDescription
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = [NSString stringWithFormat:@"分享来自范团APP的《%@》 %@", shareTitle, _model.data.article_url];
    
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_model.data.coverStr]];
    message.imageObject = imageObject;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    [WeiboSDK sendRequest:request];
}

- (void)QQshareWtihShareTitle:(NSString *)shareTitle ShareDescription:(NSString *)shareDescription Scene:(int)scene
{
    QQApiURLObject *urlObject = [QQApiURLObject objectWithURL:[NSURL URLWithString:_model.data.article_url] title:shareTitle description:shareDescription previewImageURL:[NSURL URLWithString:_model.data.coverStr] targetContentType:QQApiURLTargetTypeNews];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:urlObject];
    if (scene == 1) {
        // 分享给好友
        [QQApiInterface sendReq:req];
    } else {
        //分享QQ空间
        [QQApiInterface SendReqToQZone:req];
    }
}


// 分享微信相关
- (void)WXshareWtihShareTitle:(NSString *)shareTitle ShareDescription:(NSString *)shareDescription Scene:(int)scene
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = shareTitle;
    message.description = shareDescription;
    
    WXWebpageObject *webPageObject = [WXWebpageObject object];
    webPageObject.webpageUrl = _model.data.article_url;
    message.mediaObject = webPageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:_model.data.coverStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        message.thumbData = [MyTool compressOriginalImage:imageV.image toMaxDataSizeKBytes:32*1000];
        [WXApi sendReq:req];
    }];
}
// 复制链接
- (void)copyUrl
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _model.data.article_url;
    [MyTool showHUDWithStr:@"复制成功"];
}
-(void)createUI
{
    UIView *replyBgView = [[UIView alloc]initWithFrame:CGRectZero];
    replyBgView.backgroundColor = [UIColor whiteColor];
   
    
    UIImageView *replyLogoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"replyIcon"]];
    
    UILabel *replyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    replyLabel.font = [UIFont systemFontOfSize:16];
    replyLabel.textColor = [MyTool colorWithString:@"999999"];
    replyLabel.text = @"评论动态";
    
    UIButton *praisebnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [praisebnt setTitleColor:[MyTool colorWithString:@"999999"] forState:UIControlStateNormal];
    //    [praisebnt setTitle:@"999+" forState:UIControlStateNormal];
    praisebnt.titleLabel.font = [UIFont systemFontOfSize:14];
    [praisebnt setImage:[UIImage imageNamed:@"praiseIconOff"] forState:UIControlStateNormal];
    [praisebnt setImage:[UIImage imageNamed:@"praiseIconOn"] forState:UIControlStateSelected];
//    [praisebnt addTarget:self action:@selector(clickPraisecWith:) forControlEvents:UIControlEventTouchDown];
    _praisebnt = praisebnt;
    
    UIButton *commentsbnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentsbnt setTitleColor:[MyTool colorWithString:@"999999"] forState:UIControlStateNormal];
    //    [praisebnt setTitle:@"999+" forState:UIControlStateNormal];
    commentsbnt.titleLabel.font = [UIFont systemFontOfSize:14];
    [commentsbnt setImage:[UIImage imageNamed:@"commentsIcon"] forState:UIControlStateNormal];
//    [commentsbnt addTarget:self action:@selector(clickPraisecWith:) forControlEvents:UIControlEventTouchDown];
    _commentsbnt = commentsbnt;
    
    UIButton *sharebnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [sharebnt setTitleColor:[MyTool colorWithString:@"999999"] forState:UIControlStateNormal];
    //    [praisebnt setTitle:@"999+" forState:UIControlStateNormal];
    sharebnt.titleLabel.font = [UIFont systemFontOfSize:14];
    [sharebnt setImage:[UIImage imageNamed:@"分享灰"] forState:UIControlStateNormal];
    [sharebnt addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:replyBgView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = [MyTool colorWithString:@"e5e5e5"];
    [replyBgView sd_addSubviews:@[replyLogoView,replyLabel,praisebnt,commentsbnt,sharebnt,lineView]];
    
    
    replyBgView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    lineView.sd_layout
    .leftSpaceToView(replyBgView, 0)
    .rightSpaceToView(replyBgView, 0)
    .topSpaceToView(replyBgView, 0)
    .heightIs(0.5);
    
    replyLogoView.sd_layout
    .leftSpaceToView(replyBgView, 15)
    .topSpaceToView(replyBgView, 13)
    .widthIs(24)
    .heightEqualToWidth();
    
    [replyLabel setSingleLineAutoResizeWithMaxWidth:kScreenW-15 -24 -11 ];
    replyLabel.sd_layout
    .leftSpaceToView(replyLogoView, 11)
    .centerYEqualToView(replyLogoView)
    .heightIs(16);
    
    sharebnt.sd_layout
    .rightSpaceToView(replyBgView, 10)
    .centerYEqualToView(replyBgView)
    .widthIs(24)
    .heightIs(50);
    
    [praisebnt setupAutoSizeWithHorizontalPadding:0 buttonHeight:24];

    praisebnt.sd_layout
    .rightSpaceToView(sharebnt, 15)
    .centerYEqualToView(replyBgView);
    praisebnt.titleLabel.sd_layout
    .leftSpaceToView(praisebnt.imageView, 5);


    [commentsbnt setupAutoSizeWithHorizontalPadding:0 buttonHeight:24];
    commentsbnt.sd_layout
    .rightSpaceToView(praisebnt, 15)
    .centerYEqualToView(replyBgView);
    commentsbnt.titleLabel.sd_layout
    .leftSpaceToView(commentsbnt.imageView, 5);


}

@end
