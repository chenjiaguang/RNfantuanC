//
//  MyFriendViewController.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/3/26.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "MyFriendViewController.h"
#import "SGPagingView.h"
#import "MyFriendTableViewController.h"
#import "LGSegment.h"

@interface MyFriendViewController ()<UIScrollViewDelegate,SegmentDelegate>


@property (nonatomic, strong) UIScrollView *contentScrollView;
@property(nonatomic,strong)NSMutableArray *buttonList;
@property (nonatomic, weak) LGSegment *segment;
@property(nonatomic,weak)CALayer *LGLayer;
@end

@implementation MyFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的好友";
//    [self createUI];
    // Do any additional setup after loading the view.
    
    [super viewDidLoad];
    //加载Segment
    [self setSegment];
    //加载ViewController
    [self addChildViewController];
    //加载ScrollView
    [self setContentScrollView];
}
-(void)setSegment {
    
    [self buttonList];
    //初始化
    LGSegment *segment = [[LGSegment alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40) TitleArr:@[@"好友", @"关注",@"粉丝"]];
    segment.delegate = self;
    self.segment = segment;
    [self.view addSubview:segment];
    [self.buttonList addObject:segment.buttonList];
    self.LGLayer = segment.LGLayer;
    [segment moveToOffsetX:kScreenW];
    
}
//加载ScrollView
-(void)setContentScrollView {
    
    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, kScreenW,kScreenH - 40)];
    [self.view addSubview:sv];
    sv.bounces = NO;
    sv.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    sv.contentOffset = CGPointMake(0, 0);
    sv.pagingEnabled = YES;
    sv.showsHorizontalScrollIndicator = NO;
    sv.scrollEnabled = YES;
    sv.userInteractionEnabled = YES;
    sv.delegate = self;
    
    for (int i=0; i<self.childViewControllers.count; i++) {
        UIViewController * vc = self.childViewControllers[i];
        vc.view.frame = CGRectMake(i * kScreenW, 0, kScreenW, kScreenH - 40);
        [sv addSubview:vc.view];
        
    }
    
    sv.contentSize = CGSizeMake(3 * kScreenW, 0);
    sv.contentOffset = CGPointMake(kScreenW * _index, 0);
    self.contentScrollView = sv;
}
//加载3个ViewController
-(void)addChildViewController{
    
    MyFriendTableViewController *friendVC = [[MyFriendTableViewController alloc] init];
    friendVC.tableTyp = @"好友";
    [self addChildViewController:friendVC];

    MyFriendTableViewController *focusVC = [[MyFriendTableViewController alloc] init];
    focusVC.tableTyp = @"关注";
    [self addChildViewController:focusVC];

    MyFriendTableViewController *fansVC = [[MyFriendTableViewController alloc] init];
    fansVC.tableTyp = @"粉丝";
    [self addChildViewController:fansVC];
}

#pragma mark - UIScrollViewDelegate
//实现LGSegment代理方法
-(void)scrollToPage:(int)Page {
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = self.view.frame.size.width * Page;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentScrollView.contentOffset = offset;
    }];
}
// 只要滚动UIScrollView就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    [self.segment moveToOffsetX:offsetX];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableArray *)buttonList
{
    if (!_buttonList)
    {
        _buttonList = [NSMutableArray array];
    }
    return _buttonList;
}


@end
