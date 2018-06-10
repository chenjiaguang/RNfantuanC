//
//  MyWebViewController.h
//  FanTuanSJ
//
//  Created by 冫柒Yun on 2017/8/28.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "DLPanableWebView.h"
#import "LoginViewController.h"
#import "ShopSearchViewController.h"
#import "ShopNewsViewController.h"
#import "MerchantsSaidViewController.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"

@interface MyWebViewController : UIViewController <UIGestureRecognizerDelegate, UIWebViewDelegate, NJKWebViewProgressDelegate, DLPanableWebViewHandler, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, TencentSessionDelegate>

@property (nonatomic, assign) BOOL isNewsDetail;

@property (nonatomic, strong) DLPanableWebView *myWebView;
//@property (nonatomic, strong) UIWebView *myWebView;
@property (nonatomic, strong) NSString *urlStr;

@end
