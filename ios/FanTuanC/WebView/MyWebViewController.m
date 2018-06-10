//
//  MyWebViewController.m
//  FanTuanSJ
//
//  Created by 冫柒Yun on 2017/8/28.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "MyWebViewController.h"
#import "MallViewController.h"
#import "LLIntegratedPaySDK.h"
#import "LLPayUtil.h"
#import "ShareAlertView.h"
#import "MyCardViewController.h"
#import "DynamicDetailsViewController.h"
#import "NewsPicDetailViewController.h"
#import "LongArticleDetailsController.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface MyWebViewController ()
{
    MBProgressHUD *_hud;
    
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
    
    id navPanTarget_;
    SEL navPanAction_;
    
    UIButton *_rightButton;
    NSMutableArray *_imageArr;
    
    NSDictionary *_searchBtnDic;
    
    NSMutableArray *_shareArr;
    
    UIImageView *_detailNullView;
}

@end

@implementation MyWebViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar addSubview:_progressView];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self createBackBtn];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_progressView removeFromSuperview];
    self.navigationController.navigationBar.barTintColor = [MyTool colorWithString:PositionNavColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    self.view.backgroundColor = [MyTool colorWithString:@"f3f5f9"];
    
    // 获取系统默认手势Handler并保存
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        NSMutableArray *gestureTargets = [self.navigationController.interactivePopGestureRecognizer valueForKey:@"_targets"];
        id gestureTarget = [gestureTargets firstObject];
        navPanTarget_ = [gestureTarget valueForKey:@"_target"];
        navPanAction_ = NSSelectorFromString(@"handleNavigationTransition:");
    }
    
    
    [self createBackBtn];
    
//    [self loadingWithText:@"加载中"];
    [self createWebView];
    if (_isNewsDetail) {
        [self createDetailNullView];
    }
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWebView) name:reloadWebView object:nil];
}

- (void)reloadWebView
{
    [_myWebView reload];
}

- (void)createBackBtn
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];

}

- (void)backBtnAction:(UIButton *)btn
{
    if ([_myWebView canGoBack]) {
        [_myWebView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)createRightBtn
{
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 50, 30);
    _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(webViewRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];
}

#pragma mark - 右侧按钮点击方法
- (void)webViewRightBtnAction:(UIButton *)btn
{
    if (btn.titleLabel.text != NULL) {
        [self executeCallBack:@"onSaveButtonClick()"];
    } else {
        ShopSearchViewController *searchVC = [[ShopSearchViewController alloc] init];
        searchVC.latitude = [[NSUserDefaults standardUserDefaults] objectForKey:KLatitude];
        searchVC.longitude = [[NSUserDefaults standardUserDefaults] objectForKey:KLongitude];
        searchVC.nameStr = _searchBtnDic[@"name"];
        searchVC.mall_id = _searchBtnDic[@"mall_id"];
        UINavigationController *searchNaVC = [[UINavigationController alloc] initWithRootViewController:searchVC];
        [self presentViewController:searchNaVC animated:NO completion:nil];
    }
}


- (void)createWebView
{
    _myWebView = [[DLPanableWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64)];
    _myWebView.backgroundColor = [UIColor whiteColor];
    if (iPhoneX) {
        _myWebView.frame = CGRectMake(0, 0, kScreenW, kScreenH - 88);
    }
    if (@available(iOS 11.0, *)) {
        _myWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _myWebView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    _myWebView.panDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_progressView setProgress:0 animated:YES];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    _myWebView.scalesPageToFit = NO;
    _myWebView.scrollView.bounces = NO;
    [_myWebView loadRequest:urlRequest];
    
    [self.navigationController.navigationBar addSubview:_progressView];
    [self.view addSubview:_myWebView];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self endLoading];
    _detailNullView.hidden = YES;
    if (!_isNewsDetail) {
        self.title = [_myWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self endLoading];
    _detailNullView.hidden = YES;
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}


#pragma mark-监听请求
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"urlString:%@", requestString);
    
    
#pragma mark - Token
    NSRange tokenRange = [requestString rangeOfString:@"_getToken"];
    if (tokenRange.length) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kToken] == NULL) {
            [self executeCallBack:@"receiveToken('')"];
        } else {
            [self executeCallBack:[NSString stringWithFormat:@"receiveToken('%@')", [[NSUserDefaults standardUserDefaults] objectForKey:kToken]]];
        }
    }
    
#pragma mark - 获取经度
    NSRange longitudeRange = [requestString rangeOfString:@"_getLongitude"];
    if (longitudeRange.length) {
        [self executeCallBack:[NSString stringWithFormat:@"receiveLongitude('%@')", [[NSUserDefaults standardUserDefaults] objectForKey:KLongitude]]];
        return NO;
    }
    
#pragma mark - 获取纬度
    NSRange latitudeRange = [requestString rangeOfString:@"_getLatitude"];
    if (latitudeRange.length) {
        [self executeCallBack:[NSString stringWithFormat:@"receiveLatitude('%@')", [[NSUserDefaults standardUserDefaults] objectForKey:KLatitude]]];
        return NO;
    }
    
    
#pragma mark - 右侧按钮
    NSRange rightButton = [requestString rangeOfString:@"_setRightButtonText"];
    if (rightButton.length) {
        NSDictionary *dic = [MyTool DictFromStrCut:requestString Action:@"_setRightButtonText"];
        [self createRightBtn];
        [_rightButton setTitle:dic[@"title"] forState:UIControlStateNormal];
    }
    
#pragma mark - 显示右侧搜索按钮
    NSRange shopSearchPageRange = [requestString rangeOfString:@"_setRightShopSearch"];
    if (shopSearchPageRange.length) {
        _searchBtnDic = [MyTool DictFromStrCut:requestString Action:@"_setRightShopSearch"];
        [self createRightBtn];
        _rightButton.frame = CGRectMake(0, 0, 30, 30);
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"购物中心搜索"] forState:UIControlStateNormal];
    }
    
#pragma mark - 隐藏右侧按钮
    NSRange hideRightButton = [requestString rangeOfString:@"_hideRightButton"];
    if (hideRightButton.length) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
#pragma mark - 显示返回按钮
    NSRange backButtonRange = [requestString rangeOfString:@"_setBackButton"];
    if (backButtonRange.length) {
        [self createBackBtn];
    }
    
#pragma mark - 隐藏返回按钮
    NSRange hideBackButton = [requestString rangeOfString:@"_hideBackButton"];
    if (hideBackButton.length) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
#pragma mark - 刷新订单列表页
    NSRange reloadListRange = [requestString rangeOfString:@"_reloadOrderData"];
    if (reloadListRange.length) {
        [[NSNotificationCenter defaultCenter] postNotificationName:reloadOrderListViewData object:nil];
    }
    
#pragma mark - 跳转到购物中心楼层页
    NSRange mallHomePage = [requestString rangeOfString:@"_goMallHomePage"];
    if (mallHomePage.length) {
        NSDictionary *dic = [MyTool DictFromStrCut:requestString Action:@"_goMallHomePage"];
        MallViewController *mallVC = [[MallViewController alloc] init];
        mallVC.dic = dic;
        [self.navigationController pushViewController:mallVC animated:YES];
    }
    
#pragma mark - 跳转到首页
    NSRange goHomePage = [requestString rangeOfString:@"_goHomePage"];
    if (goHomePage.length) {
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
#pragma mark - 跳转到评论界面
    NSRange goReview = [requestString rangeOfString:@"_goReview"];
    if (goReview.length) {
        NSDictionary *dic = [MyTool DictFromStrCut:requestString Action:@"_goReview"];
        ReleaseReviewViewController *releaseReviewVC = [[ReleaseReviewViewController alloc] init];
        releaseReviewVC.order_id = dic[@"order_id"];
        [self.navigationController pushViewController:releaseReviewVC animated:YES];
    }
    
#pragma mark - 退出webview
    NSRange finishWebView = [requestString rangeOfString:@"_finishWebView"];
    if (finishWebView.length) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
#pragma mark - 微信登录绑定手机成功
    NSRange wxbindPhoneSuccess = [requestString rangeOfString:@"_wxbindPhoneSuccess"];
    if (wxbindPhoneSuccess.length) {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:saveLoginSuccessData object:nil];
    }
    
#pragma mark - token过期
    NSRange pastToken = [requestString rangeOfString:@"_pastToken"];
    if (pastToken.length) {
        [self logoutActionWithBackRootVC:NO];
    }
    
#pragma mark - 调用支付
    NSRange goPayView = [requestString rangeOfString:@"_goPayView"];
    if (goPayView.length) {
        NSDictionary *signedOrder = [MyTool DictFromStrCut:requestString Action:@"_goPayView"];
        [[LLIntegratedPaySDK sharedSdk] presentLLIntegratedPayInViewController:self andPaymentInfo:signedOrder mode:LLIntegratedPayModeStandard complete:^(LLPayResult result, NSDictionary *dic) {
            [self paymentEnd:result withResultDic:dic];
        }];
    }
    
#pragma mark - 跳转登录界面
    NSRange nativeLogin= [requestString rangeOfString:@"_nativeLogin"];
    if (nativeLogin.length) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCallBack:) name:webViewLoginCallBack object:nil];
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *loginNaVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNaVC animated:YES completion:nil];
    }
    
#pragma mark - 退出登录
    NSRange logoutRange = [requestString rangeOfString:@"_logout"];
    if (logoutRange.length) {
        [self logoutActionWithBackRootVC:YES];
    }
    
#pragma mark - 跳转商家详情
    NSRange businessDetailsRange = [requestString rangeOfString:@"_goShopDetail"];
    if (businessDetailsRange.length) {
        NSDictionary *dic = [MyTool DictFromStrCut:requestString Action:@"_goShopDetail"];
        BusinessDetailsViewController *businessDetailsVC = [[BusinessDetailsViewController alloc] init];
        businessDetailsVC.mid = dic[@"mid"];
        businessDetailsVC.nameStr = dic[@"name"];
        [self.navigationController pushViewController:businessDetailsVC animated:YES];
    }
    
#pragma mark - 跳转到邀请首页
    NSRange goInviterCenter = [requestString rangeOfString:@"_goInviterCenter"];
    if (goInviterCenter.length) {
        InviterViewController *inviterVC = [[InviterViewController alloc] init];
        [self.navigationController pushViewController:inviterVC animated:YES];
    }
    
#pragma mark - 跳转到钱包首页
    NSRange goUserWallet = [requestString rangeOfString:@"_goUserWallet"];
    if (goUserWallet.length) {
        WalletViewController *walletVC = [[WalletViewController alloc] init];
        [self.navigationController pushViewController:walletVC animated:YES];
    }
    
#pragma mark - 是否开启定位功能
    NSRange allowLocation = [requestString rangeOfString:@"_allowLocation"];
    if (allowLocation.length) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"需开启定位且位置为海南才可领取红包" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"开启定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //跳转到定位权限页面
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
#pragma mark - 判断扫码领取红包是否在范团App
    NSRange isFanTuan = [requestString rangeOfString:@"_isFanTuan"];
    if (isFanTuan.length) {
        [self executeCallBack:[NSString stringWithFormat:@"receiveIsFantuan('1')"]];
    }
    
#pragma mark - 跳转忘记密码界面
    NSRange goModifyPassword = [requestString rangeOfString:@"_goModifyPassword"];
    if (goModifyPassword.length) {
        NSDictionary *dic = [MyTool DictFromStrCut:requestString Action:@"_goModifyPassword"];
        SettingPassWordViewController *settingPWVC = [[SettingPassWordViewController alloc] init];
        settingPWVC.navigationItem.title = @"验证手机号";
        settingPWVC.phoneStr = dic[@"phone"];
        [self.navigationController pushViewController:settingPWVC animated:YES];
    }
    
#pragma mark - 跳转商圈头条界面
    NSRange goShopNews = [requestString rangeOfString:@"_goShopNews"];
    if (goShopNews.length) {
        NSDictionary *dic = [MyTool DictFromStrCut:requestString Action:@"_goShopNews"];
        ShopNewsViewController *shopNewsVC = [[ShopNewsViewController alloc] init];
        shopNewsVC.mall_id = dic[@"mall_id"];
        [self.navigationController pushViewController:shopNewsVC animated:YES];
    }
    
#pragma mark - 跳转商家说
    NSRange goShopSay = [requestString rangeOfString:@"_goShopSay"];
    if (goShopSay.length) {
        NSDictionary *dic = [MyTool DictFromStrCut:requestString Action:@"_goShopSay"];
        MerchantsSaidViewController *saidVc = [[MerchantsSaidViewController alloc]init];
        saidVc.mid = dic[@"mid"];
        saidVc.dataDic = dic;
        [self.navigationController pushViewController:saidVc animated:YES];
    }
    
#pragma mark - 分享界面集合
    NSRange shareView = [requestString rangeOfString:@"_shareView"];
    if (shareView.length) {
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
        
        NSDictionary *dic = [MyTool DictFromStrCut:requestString Action:@"_shareView"];
        [self shareViewWithShareTitle:dic[@"shareTitle"] ShareDescription:dic[@"shareDescription"] imageUrl:dic[@"url"]];
    }
    
#pragma mark - 微信好友分享
    NSRange shareWXFriends = [requestString rangeOfString:@"_shareWXFriends"];
    if (shareWXFriends.length) {
        NSDictionary *dic = [MyTool DictFromStrCut:requestString Action:@"_shareWXFriends"];
        [self WXshareWtihShareTitle:dic[@"shareTitle"] ShareDescription:dic[@"shareDescription"] Scene:WXSceneSession imageUrl:dic[@"url"]];
    }
#pragma mark - 微信朋友圈分享
    NSRange shareWXTimeline = [requestString rangeOfString:@"_shareWXTimeline"];
    if (shareWXTimeline.length) {
        NSDictionary *dic = [MyTool DictFromStrCut:requestString Action:@"_shareWXTimeline"];
        [self WXshareWtihShareTitle:dic[@"shareTitle"] ShareDescription:dic[@"shareDescription"] Scene:WXSceneTimeline imageUrl:dic[@"url"]];
    }
#pragma mark - 复制链接
    NSRange copyUrl = [requestString rangeOfString:@"_copyUrl"];
    if (copyUrl.length) {
        [self copyUrl];
    }
    
    
#pragma mark - 单图图片上传
    NSRange ImageUPRange = [requestString rangeOfString:@"_goUploadPic"];
    if (ImageUPRange.length) {
        [self addImgae];
    }
    
#pragma mark - 跳转社交名片
    NSRange goUserCard = [requestString rangeOfString:@"_goUserCard"];
    if (goUserCard.length) {
        NSDictionary *dic = [MyTool DictFromStrCut:requestString Action:@"_goUserCard"];
        MyCardViewController *myCardVC = [[MyCardViewController alloc] init];
        myCardVC.hidesBottomBarWhenPushed = YES;
        myCardVC.titleStr = dic[@"title"];
        myCardVC.uid = dic[@"uid"];
        myCardVC.type = [dic[@"type"] integerValue] + 1;
        myCardVC.isNews = [dic[@"isNews"] boolValue];
        [self.navigationController pushViewController:myCardVC animated:YES];
    }
    
#pragma mark - 跳转动态详情
    NSRange goDynamicDetail = [requestString rangeOfString:@"_goDynamicDetail"];
    if (goDynamicDetail.length) {
        NSDictionary *dic = [MyTool DictFromStrCut:requestString Action:@"_goDynamicDetail"];
        DynamicDetailsViewController *vc = [[DynamicDetailsViewController alloc]init];
        vc.circleID = dic[@"id"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
#pragma mark - 跳转新闻图集
    NSRange goGallery = [requestString rangeOfString:@"_goGallery"];
    if (goGallery.length) {
        NSDictionary *dic = [MyTool DictFromStrCut:requestString Action:@"_goGallery"];
        NewsPicDetailViewController *newsPicDetailVC = [[NewsPicDetailViewController alloc] init];
        newsPicDetailVC.article_id = dic[@"id"];
        [self.navigationController pushViewController:newsPicDetailVC animated:YES];
    }
    
#pragma mark - 跳转长文章
    NSRange goLongDynamic = [requestString rangeOfString:@"_goLongDynamic"];
    if (goLongDynamic.length) {
        NSDictionary *dic = [MyTool DictFromStrCut:requestString Action:@"_goLongDynamic"];
        LongArticleDetailsController *vc = [[LongArticleDetailsController alloc]init];
        vc.articleId = dic[@"id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    return YES;
}


#pragma mark - 回调
- (void)executeCallBack:(NSString *)str
{
    NSLog(@"回调内容:%@",str);
    [_myWebView stringByEvaluatingJavaScriptFromString:str];
}

// 登录回调
- (void)loginCallBack:(NSNotification *)notification
{
    NSDictionary *dic = (NSDictionary *)[notification object];
    [self executeCallBack:[NSString stringWithFormat:@"receiveLoginResult('%@')", [LLPayUtil jsonStringOfObj:dic]]];
}

// 分享界面
- (void)shareViewWithShareTitle:(NSString *)shareTitle ShareDescription:(NSString *)shareDescription imageUrl:(NSString *)imageUrl
{
    ShareAlertView *shareAlertV = [[ShareAlertView alloc] initWithFrame:[[UIScreen mainScreen] bounds] listArr:_shareArr];
    [ApplicationDelegate.window addSubview:shareAlertV];
    
    shareAlertV.SelectItem = ^(NSIndexPath *indexPath) {
        if ([_shareArr[indexPath.row] isEqualToString:@"复制链接"]) {
            [self copyUrl];
        } else if ([_shareArr[indexPath.row] isEqualToString:@"微信好友"]) {
            [self WXshareWtihShareTitle:shareTitle ShareDescription:shareDescription Scene:WXSceneSession imageUrl:imageUrl];
        } else if ([_shareArr[indexPath.row] isEqualToString:@"微信朋友圈"]) {
            [self WXshareWtihShareTitle:shareTitle ShareDescription:shareDescription Scene:WXSceneTimeline imageUrl:imageUrl];
        } else if ([_shareArr[indexPath.row] isEqualToString:@"QQ好友"]) {
            [self QQshareWtihShareTitle:shareTitle ShareDescription:shareDescription Scene:1 imageUrl:imageUrl];
        } else if ([_shareArr[indexPath.row] isEqualToString:@"QQ空间"]) {
            [self QQshareWtihShareTitle:shareTitle ShareDescription:shareDescription Scene:2 imageUrl:imageUrl];
        } else if ([_shareArr[indexPath.row] isEqualToString:@"微博"]) {
            [self WBshareWtihShareTitle:shareTitle ShareDescription:shareDescription imageUrl:imageUrl];
        }
    };
}

- (void)WBshareWtihShareTitle:(NSString *)shareTitle ShareDescription:(NSString *)shareDescription imageUrl:(NSString *)imageUrl
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = [NSString stringWithFormat:@"分享来自范团APP的《%@》 %@", shareTitle, _urlStr];
    
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    message.imageObject = imageObject;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    [WeiboSDK sendRequest:request];
}

- (void)QQshareWtihShareTitle:(NSString *)shareTitle ShareDescription:(NSString *)shareDescription Scene:(int)scene imageUrl:(NSString *)imageUrl
{
    QQApiURLObject *urlObject = [QQApiURLObject objectWithURL:[NSURL URLWithString:_urlStr] title:shareTitle description:shareDescription previewImageURL:[NSURL URLWithString:imageUrl] targetContentType:QQApiURLTargetTypeNews];
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
- (void)WXshareWtihShareTitle:(NSString *)shareTitle ShareDescription:(NSString *)shareDescription Scene:(int)scene imageUrl:(NSString *)imageUrl
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = shareTitle;
    message.description = shareDescription;
    
    WXWebpageObject *webPageObject = [WXWebpageObject object];
    webPageObject.webpageUrl = _urlStr;
    message.mediaObject = webPageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        message.thumbData = [MyTool compressOriginalImage:imageV.image toMaxDataSizeKBytes:32*1000];
        [WXApi sendReq:req];
    }];
}
// 复制链接
- (void)copyUrl
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _urlStr;
    [MyTool showHUDWithStr:@"复制成功"];
}

// 退出登录
- (void)logoutActionWithBackRootVC:(BOOL)backRootVC
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUserHasLogin];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:reloadOrderListView object:nil];
    if (backRootVC == YES) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 支付相关
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
    NSString *msg = @"支付异常";
    switch (resultCode) {
        case kLLPayResultSuccess:
            msg = @"支付成功";
            break;
        case kLLPayResultFail:
            msg = @"支付失败";
            break;
        case kLLPayResultCancel:
            msg = @"支付取消";
            return;
            break;
        case kLLPayResultInitError:
            msg = @"sdk初始化异常";
            break;
        case kLLPayResultInitParamError:
            msg = dic[@"ret_msg"];
            break;
        default:
            break;
    }
    
    [self executeCallBack:[NSString stringWithFormat:@"receivePayResult('%@')", [LLPayUtil jsonStringOfObj:dic]]];
    
//    UIAlertController *alert =
//    [UIAlertController alertControllerWithTitle:msg message:[LLPayUtil jsonStringOfObj:dic] preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"好！！！" style:UIAlertActionStyleDefault handler:nil]];
//    [self presentViewController:alert animated:YES completion:nil];
}




- (void)DLPanableWebView:(DLPanableWebView *)webView panPopGesture:(UIPanGestureRecognizer *)pan{
    if (navPanTarget_ && [navPanTarget_ respondsToSelector:navPanAction_]) {
        [navPanTarget_ performSelector:navPanAction_ withObject:pan];
    }
}

- (void)addImgae
{
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [action showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self getImageFromIpcWithCamera:YES];
    } else if (buttonIndex == 1) {
        [self getImageFromIpcWithCamera:NO];
    }
}

// 获取系统相册图片
- (void)getImageFromIpcWithCamera:(BOOL)isCamera
{
    // 1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    /**
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
     UIImagePickerControllerSourceTypePhotoLibrary, // 相册
     UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
     UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
     }
     */
    // 3. 设置打开照片相册类型(显示所有相簿)
    if (isCamera) {
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    // ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    // 照相机
    // ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 4.设置代理
    ipc.delegate = self;
    // 5.modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self uploadImage:info[UIImagePickerControllerOriginalImage]];
}

#pragma mark -- 上传图片
- (void)uploadImage:(UIImage *)image
{
    [self loadingWithText:@"上传图片中"];
    NSString *urlStr = [NetRequest ImageUpload];
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //2.上传文件
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken]};
    [manager POST:urlStr parameters:paramsDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // UIImagePNGRepresentation(image)
        NSData *imageData = UIImageJPEGRepresentation(image, 0.01);
        [formData appendPartWithFileData:imageData name:@"images" fileName:@"images.png" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self endLoading];
        if ([[responseObject objectForKeyNotNull:@"error"] integerValue] == 0) {
            [self executeCallBack:[NSString stringWithFormat:@"returnPicData('{\"id\":[\"%@\"],\"url\":[\"%@\"]}')", responseObject[@"data"][@"id"][0], responseObject[@"data"][@"url"][0]]];
        } else {
            [MyTool showHUDWithStr:responseObject[@"msg"]];
        }
        NSLog(@"请求成功：%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self endLoading];
        NSLog(@"请求失败：%@",error);
    }];
}

-(void)loadingWithText:(NSString *)text
{
    [self endLoading];
    _hud = [[MBProgressHUD alloc] initWithView:ApplicationDelegate.window];
    _hud.removeFromSuperViewOnHide = YES;
    _hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    _hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.6];
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    _hud.label.textColor = [UIColor whiteColor];
    _hud.label.text = text;
    [_hud showAnimated:YES];
    [ApplicationDelegate.window addSubview:_hud];
}
-(void)endLoading
{
    [_hud hideAnimated:YES];
    _hud.hidden=YES;
}

- (void)createDetailNullView
{
    _detailNullView = [[UIImageView alloc] initWithFrame:_myWebView.frame];
    if (iPhone4) {
        _detailNullView.image = [UIImage imageNamed:@"头条详情Null_4"];
    } else if (iPhone5) {
        _detailNullView.image = [UIImage imageNamed:@"头条详情Null_5"];
    } else if (iPhone6) {
        _detailNullView.image = [UIImage imageNamed:@"头条详情Null_6"];
    } else if (iPhone6P) {
        _detailNullView.image = [UIImage imageNamed:@"头条详情Null_6P"];
    } else if (iPhoneX) {
        _detailNullView.image = [UIImage imageNamed:@"头条详情Null_X"];
    }
    [_myWebView addSubview:_detailNullView];
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:reloadWebView object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:webViewLoginCallBack object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
