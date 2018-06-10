//
//  NewsPicBottomView.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/3/28.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "NewsPicBottomView.h"
#import "NewsCommentViewController.h"
#import "ShareAlertView.h"

@implementation NewsPicBottomView
{
    UIButton *_collectBtn;
    UIButton *_commentBtn;
    UILabel *_commentNumLabel;
    
    BOOL _isCollect;
    
    NSMutableArray *_shareArr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"  发表一下高见吧~";
    label.textColor = [MyTool colorWithString:@"999999"];
    label.font = [UIFont systemFontOfSize:15];
    label.layer.borderWidth = 0.5f;
    label.layer.borderColor = [MyTool colorWithString:@"CBCBCB"].CGColor;
    label.layer.cornerRadius = 8.f;
    [self addSubview:label];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"图集分享"] forState: UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareBtn];
    
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectBtn setImage:[UIImage imageNamed:@"图集收藏"] forState:UIControlStateNormal];
    [_collectBtn addTarget:self action:@selector(collectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commentBtn setImage:[UIImage imageNamed:@"图集评论"] forState:UIControlStateNormal];
    [_commentBtn addTarget:self action:@selector(commentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_commentBtn];
    [self addSubview:_collectBtn];
    
    
    _commentNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _commentNumLabel.backgroundColor = [UIColor blackColor];
    _commentNumLabel.font = [UIFont systemFontOfSize:10];
    _commentNumLabel.textColor = [MyTool colorWithString:@"FB1B1B"];
    _commentNumLabel.textAlignment = NSTextAlignmentCenter;
    [_commentBtn addSubview:_commentNumLabel];
    
    
    
    label.sd_layout
    .leftSpaceToView(self, 15)
    .centerYEqualToView(self)
    .widthIs(205*Swidth)
    .heightIs(30);
    
    shareBtn.sd_layout
    .rightSpaceToView(self, 5)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthIs(40);
    
    _collectBtn.sd_layout
    .rightSpaceToView(shareBtn, 0)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthIs(40);
    
    _commentBtn.sd_layout
    .rightSpaceToView(_collectBtn, 0)
    .topEqualToView(self)
    .bottomEqualToView(self)
    .widthIs(40);
    
    _commentNumLabel.sd_layout
    .topEqualToView(_commentBtn.imageView)
    .heightIs(8);
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    _isCollect = [dataDic[@"is_collect"] boolValue];
    [_collectBtn setImage:[UIImage imageNamed:[dataDic[@"is_collect"] boolValue] ? @"图集已收藏" : @"图集收藏"] forState:UIControlStateNormal];
    _commentNumLabel.text = dataDic[@"comment_num"];
    CGFloat numLabelW = [MyTool widthOfLabel:_commentNumLabel.text ForFont:_commentNumLabel.font labelHeight:8];
    _commentNumLabel.sd_layout
    .leftSpaceToView(_commentBtn.imageView, -(numLabelW+4)/2)
    .widthIs(numLabelW + 4);
    _commentNumLabel.hidden = [_commentNumLabel.text integerValue]==0?YES:NO;
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
    
    [self shareViewWithShareTitle:_dataDic[@"name"] ShareDescription:_dataDic[@"atlas_content"][0][@"content"]];
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
    message.text = [NSString stringWithFormat:@"分享来自范团APP的《%@》 %@", shareTitle, _dataDic[@"atlas_url"]];
    
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_dataDic[@"cover"]]];
    message.imageObject = imageObject;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    [WeiboSDK sendRequest:request];
}

- (void)QQshareWtihShareTitle:(NSString *)shareTitle ShareDescription:(NSString *)shareDescription Scene:(int)scene
{
    QQApiURLObject *urlObject = [QQApiURLObject objectWithURL:[NSURL URLWithString:_dataDic[@"atlas_url"]] title:shareTitle description:shareDescription previewImageURL:[NSURL URLWithString:_dataDic[@"cover"]] targetContentType:QQApiURLTargetTypeNews];
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
    webPageObject.webpageUrl = _dataDic[@"atlas_url"];
    message.mediaObject = webPageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"cover"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        message.thumbData = [MyTool compressOriginalImage:imageV.image toMaxDataSizeKBytes:32*1000];
        [WXApi sendReq:req];
    }];
}
// 复制链接
- (void)copyUrl
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _dataDic[@"atlas_url"];
    [MyTool showHUDWithStr:@"复制成功"];
}

- (void)collectBtnAction:(UIButton *)btn
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] != YES) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *loginNaVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [[MyTool topViewController] presentViewController:loginNaVC animated:YES completion:nil];
    } else {
        [self getNewsCollect];
    }
}

- (void)commentBtnAction:(UIButton *)btn
{
    if ([_dataDic[@"comment_num"] integerValue] > 0) {
        NewsCommentViewController *newsCommentVC = [[NewsCommentViewController alloc] init];
        newsCommentVC.article_id = _dataDic[@"id"];
        [[MyTool topViewController].navigationController pushViewController:newsCommentVC animated:YES];
    } else {
        self.commentBlock();
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    self.commentBlock();
}

- (void)getNewsCollect
{
    NSString *urlStr = [NetRequest NewsCollect];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"article_id": _dataDic[@"id"], @"collect": [NSString stringWithFormat:@"%d", !_isCollect]};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [MyTool showHUDWithStr:JSON[@"msg"]];
        if ([JSON[@"error"] boolValue] == 0) {
            [_collectBtn setImage:[UIImage imageNamed:!_isCollect ? @"图集已收藏" : @"图集收藏"] forState:UIControlStateNormal];
            
            _isCollect = !_isCollect;
        }
    } failure:^(NSError *error) {
    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
