//
//  RootTabBarController.m
//  FanTuanSJ
//
//  Created by 杨晓铭 on 2017/11/29.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "RootTabBarController.h"
#import "RootNavigationController.h"
#import "OrderViewController.h"
#import "MyViewController.h"
#import "CircleHomeTowController.h"
#import "MessageHomeController.h"

@interface RootTabBarController ()<UITabBarControllerDelegate>{
}

@property (nonatomic, assign) NSInteger index;
@property (nonatomic,assign) NSInteger  indexFlag;　　//记录上一次点击tabbar，使用时，记得先在init或viewDidLoad里 初始化 = 0

@end

@implementation RootTabBarController
-(id)initWithSetUpPayThePassword:(BOOL)password
{
    if (self = [super init]) {
       //预留接口判断是否设置红包密码
       
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = -1;
    [self setupChildViewController];
    [self setupPublic];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //版本检测
//    [MyTool detectAppUpDataWinthAppID:@"1319251152" versonBlock:^(NSString *appStoreVersion, NSString *note, BOOL upData) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self alertViewWithVersion:appStoreVersion Note:note];
//        });
//    }];
   
}
//设置self的子控制器
- (void)setupChildViewController
{
    self.delegate = self;
    [self setupUIWithController:[[CircleHomeTowController alloc] init] title:@"首页" image:@"首页" highlightedImage:@"首页_点击"];
    [self setupUIWithController:[[NewsViewController alloc] init] title:@"微海南" image:@"头条" highlightedImage:@"头条_点击"];
    [self setupUIWithController:[[MessageHomeController alloc] init] title:@"消息" image:@"消息" highlightedImage:@"消息_点击"];
    [self setupUIWithController:[[MyViewController alloc] init] title:@"我的" image:@"我的" highlightedImage:@"我的_点击"];
}
- (void)alertViewWithVersion:(NSString *)Version Note:(NSString *)note
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"提示:有版本%@更新",Version] message:note preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"去更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1319251152"];
        if([[UIApplication sharedApplication]canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            NSLog(@"can not open");
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击取消");
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger index = [self.tabBar.items indexOfObject:item];
    if (index != self.indexFlag) {
        //执行动画
        NSMutableArray *arry = [NSMutableArray array];
        for (UIView *btn in self.tabBar.subviews) {
            if ([btn isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                [arry addObject:btn];
            }
        }
        //添加动画
        //放大效果，并回到原位
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        //速度控制函数，控制动画运行的节奏
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.duration = 0.2;       //执行时间
        animation.repeatCount = 1;      //执行次数
        animation.autoreverses = YES;    //完成动画后会回到执行动画之前的状态
        animation.fromValue = [NSNumber numberWithFloat:1];   //初始伸缩倍数
        animation.toValue = [NSNumber numberWithFloat:1.2];     //结束伸缩倍数
        
        [[arry[index] layer] addAnimation:animation forKey:nil];
        self.indexFlag = index;
    }
}
//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
    //添加切换淡出效果
//    CATransition *transition = [CATransition animation];
//    transition.type = kCATransitionFade;
//    [self.view.layer addAnimation:transition forKey:nil];
//}
- (void)setupUIWithController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image highlightedImage:(NSString *)highlighted{
    RootNavigationController *orderNaVC = [[RootNavigationController alloc] initWithRootViewController:vc];
    orderNaVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:highlighted] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    orderNaVC.navigationBar.translucent = NO;
    orderNaVC.navigationBar.barTintColor = [MyTool colorWithString:PositionNavColor];
    [self addChildViewController:orderNaVC];
}
//公共设置
- (void)setupPublic{
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[MyTool colorWithString:@"333333"]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName:[MyTool colorWithString:@"1EB0FD"]} forState:UIControlStateSelected];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
}
//UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //1.先判断当前点击的index是否与标记的相等
    if (self.index == tabBarController.selectedIndex) {
        //2.通过发通知，交给响应的控制器去做具体的操作，传入self.index是为了具体区分标记做判断
        [[NSNotificationCenter defaultCenter] postNotificationName:reloadNewsViewData object:@(self.index)];
    }
    //3.再把点击的index赋值给标记的self.index
    self.index = tabBarController.selectedIndex;
}

@end
