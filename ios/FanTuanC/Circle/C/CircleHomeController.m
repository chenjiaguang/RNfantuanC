//
//  CircleHomeController.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/2/26.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "CircleHomeController.h"
#import "SGPagingView.h"
#import "XMPiecewiseView.h"
#import "CircleCell.h"
#import "CircleDetailsController.h"
#import "DynamicDetailsViewController.h"
#import "CircleModel.h"
#import "ListModel.h"
#import <YYModel.h>
#import "AllCircleListController.h"
#import "ReleaseDynamicViewController.h"
#import "BadgeBarButtonItem.h"
#import "HomeInterestController.h"
#import "HomeFocusController.h"
#import "RootNavigationController.h"
#import "UIView+XYMenu.h"
#import "LongTextEditViewController.h"
#import "ProgerssView.h"

@interface CircleHomeController ()<UIGestureRecognizerDelegate,SGPageContentViewDelegate,SGPageTitleViewDelegate>
@property (nonatomic, strong) BadgeBarButtonItem *badgeBtn;

@property (nonatomic, assign) BOOL beingLoaded; //正在加载更多
@property (nonatomic, assign) BOOL more; //还有更多数据

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentView *pageContentView;

@property (nonatomic, strong) ProgerssView *progerssView;

@end

@implementation CircleHomeController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
    [self getNumData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"兴趣圈子";
    _beingLoaded = NO;
    _more = NO;
    
    _currentIndex = 0;
    [self createUI];
    
    [self getNumData];
}


- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    _currentIndex = selectedIndex;
    [self.pageContentView setPageCententViewCurrentIndex:selectedIndex];
}

- (void)pageContentView:(SGPageContentView *)pageContentView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    _currentIndex = targetIndex;
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}
- (void)createUI
{
    
    NSArray *titleArr = @[@"兴趣圈子", @"关注"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.titleSelectedColor = [MyTool colorWithString:@"333333"];
    configure.indicatorStyle = SGIndicatorStyleFixed;
    configure.indicatorScrollStyle = SGIndicatorScrollStyleHalf;
    configure.titleColor =[MyTool colorWithString:@"333333"];
    configure.indicatorFixedWidth = 36.f;
    configure.indicatorHeight = 3;
    configure.titleFont = [UIFont systemFontOfSize:16];
    configure.titleSelectedFont = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, kScreenW/2, 44) delegate:self titleNames:titleArr configure:configure];
    self.navigationItem.titleView = self.pageTitleView;
    _pageTitleView.isTitleGradientEffect = NO;
    _pageTitleView.isNeedBounces = NO;
    _pageTitleView.isShowBottomSeparator = NO;
    HomeInterestController *interestVC = [[HomeInterestController alloc] init];
    
    HomeFocusController *focusVC = [[HomeFocusController alloc] init];
  
    
    NSArray *childArr = @[interestVC, focusVC];
   
    self.pageContentView = [[SGPageContentView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kScreenH) parentVC:self childVCs:childArr];
    _pageContentView.delegatePageContentView = self;
    [self.view addSubview:_pageContentView];
    
    UIButton *rButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rButton setBackgroundImage:[UIImage imageNamed:@"publishedIcon"] forState:UIControlStateNormal];
    rButton.frame = CGRectMake(0, 0, 30, 30);
    [rButton addTarget:self action:@selector(rButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rButton];
    
    UIButton *lButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lButton setBackgroundImage:[UIImage imageNamed:@"notificationIcon"] forState:UIControlStateNormal];
    lButton.frame = CGRectMake(0, 0, 30, 30);
    [lButton addTarget:self action:@selector(lButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _badgeBtn = [[BadgeBarButtonItem alloc] initWithCustomUIButton:lButton];
    self.navigationItem.leftBarButtonItem = _badgeBtn;
    
    
    _progerssView = [[ProgerssView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 35)];
    _progerssView.hidden = YES;
    [self.view addSubview:_progerssView];
}

#pragma mark - 点击消息中心
- (void)lButtonAction:(UIButton *)btn
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] != YES) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *loginNaVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNaVC animated:YES completion:nil];
    } else {
        MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
        myWebVC.urlStr = UserMessageURL;
        myWebVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myWebVC animated:YES];
    }
}

#pragma mark - 发布动态
- (void)rButtonAction:(UIButton *)btn
{
    if ([UpdataSingleton sharedInstance].isUploading) {
        [MyTool showHUDWithStr:@"文章上传中，请稍后再发~"];
    } else {
        [self showMenu:(UIView *)btn menuType:XYMenuRightNormal];
    }
}

- (void)getNumData
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] == YES) {
        NSString *urlStr = [NetRequest UserNoticeUnread];
        NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken]};
        [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
            if ([[JSON objectForKeyNotNull:@"error"] integerValue] == 0) {
                _badgeBtn.badgeValue = JSON[@"data"][@"num"];
            }
        } failure:^(NSError *error) {
        }];
    } else {
        _badgeBtn.badgeValue = @"";
    }
}

- (void)showMenu:(UIView *)sender menuType:(XYMenuType)type
{
    NSArray *imageArr = @[@"CircleTheCameraicon", @"longIcon"];
    NSArray *titleArr = @[@"短动态", @"长文章"];
    [sender xy_showMenuWithImages:imageArr titles:titleArr menuType:type withItemClickIndex:^(NSInteger index) {
        [self showMessage:index];
    }];
    
}
- (void)showMessage:(NSInteger)index
{
    switch (index) {
        case 1:
        {
            [self releaseTheDynamic];
        }
            break;
        case 2:
        {
            [self releaseLongText];
        }
            break;
        default:
            break;
    }
}
- (void)releaseTheDynamic
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] != YES) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *loginNaVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNaVC animated:YES completion:nil];
    } else {
        ReleaseDynamicViewController *reDynamicVC = [[ReleaseDynamicViewController alloc] init];
        reDynamicVC.circle_id = @"";
        WeakSelf(weakSelf);
        reDynamicVC.ProgressBlock = ^(CGFloat progress) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (progress==100) {
                    weakSelf.progerssView.hidden = YES;
                    [UpdataSingleton sharedInstance].isUploading = NO;
                } else {
                    weakSelf.progerssView.hidden = NO;
                    [UpdataSingleton sharedInstance].isUploading = YES;
                }
                weakSelf.progerssView.titleLabel.text = [NSString stringWithFormat:@"文章上传中，请不要离开%ld%@…", (NSInteger)progress, @"%"];
            });
        };
        RootNavigationController *naVC = [[RootNavigationController alloc] initWithRootViewController:reDynamicVC];
        [self presentViewController:naVC animated:YES completion:nil];
    }
}

- (void)releaseLongText
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] != YES) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *loginNaVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNaVC animated:YES completion:nil];
    } else {
        LongTextEditViewController *longTextEditVC = [[LongTextEditViewController alloc] init];
        longTextEditVC.circle_id = @"";
        longTextEditVC.formText = @"";
        WeakSelf(weakSelf);
        longTextEditVC.ProgressBlock = ^(CGFloat progress) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                if (progress==100) {
                    [UpdataSingleton sharedInstance].isUploading = NO;
                    weakSelf.progerssView.hidden = YES;
                } else {
                    [UpdataSingleton sharedInstance].isUploading = YES;
                    weakSelf.progerssView.hidden = NO;
                }
                weakSelf.progerssView.titleLabel.text = [NSString stringWithFormat:@"文章上传中，请不要离开%ld%@…", (NSInteger)progress, @"%"];
            });
        };
        longTextEditVC.uploadCompleteBlock = ^{
            self.progerssView.hidden = YES;
        };
        RootNavigationController *naVC = [[RootNavigationController alloc] initWithRootViewController:longTextEditVC];
        [self presentViewController:naVC animated:YES completion:nil];
    }
}


@end
