//
//  CircleDetailsController.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/2/28.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "CircleDetailsController.h"
#import "MainTouchTableTableView.h"
#import "ParentClassScrollViewController.h"
#import "CircleTableViewController.h"
#import "CircleDataController.h"
#import "ReleaseDynamicViewController.h"
#import "DynamicDetailsViewController.h"
#import "LGSegment.h"
#import "RootNavigationController.h"
#import "UIView+XYMenu.h"
#import "LongTextEditViewController.h"
#import "ProgerssView.h"

static CGFloat const headViewHeight = 133;

@interface CircleDetailsController ()<UIScrollViewDelegate,SegmentDelegate,UITableViewDelegate,UITableViewDataSource,scrollDelegate>

@property(nonatomic ,strong)MainTouchTableTableView * mainTableView;
@property(nonatomic,strong) UIScrollView * parentScrollView;

@property(nonatomic,strong)UIImageView *headImageView;//头部图片
@property(nonatomic,strong)UIImageView * avatarImage;
@property(nonatomic,strong)UILabel *countentLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *focusbnt;
@property(nonatomic,strong)UILabel *Label;
@property(nonatomic,strong)CircleModel *model;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property(nonatomic,strong)NSMutableArray *buttonList;
@property (nonatomic, weak) LGSegment *segment;
@property(nonatomic,weak)CALayer *LGLayer;

@property (nonatomic, strong) ProgerssView *progerssView;

@end

@implementation CircleDetailsController
@synthesize mainTableView;

- (void)viewWillDisappear:(BOOL)animated
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *rButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rButton setBackgroundImage:[UIImage imageNamed:@"publishedIcon"] forState:UIControlStateNormal];
    rButton.frame = CGRectMake(0, 0, 30, 30);
    [rButton addTarget:self action:@selector(rButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rButton];
    [self createBackButton];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainTableView];
    
    [self.mainTableView addSubview:self.headImageView];
    
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    _progerssView = [[ProgerssView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 35)];
    _progerssView.hidden = YES;
    [self.view addSubview:_progerssView];

}

- (void)createBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 60);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    backBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)backBtnAction:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma scrollDelegate
-(void)scrollViewLeaveAtTheTop:(UIScrollView *)scrollView
{
    self.parentScrollView = scrollView;
    //离开顶部 主View 可以滑动
    
    self.parentScrollView.scrollEnabled = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _contentScrollView) {
        CGFloat offsetX = scrollView.contentOffset.x;
        [self.segment moveToOffsetX:offsetX];
        return;
    }
    
    //获取滚动视图y值的偏移量
    CGFloat tabOffsetY = [mainTableView rectForSection:0].origin.y;
    CGFloat offsetY = scrollView.contentOffset.y;
    //计算标题透明度
    CGFloat ap = 1 - fabs(offsetY)/133;
    _Label.alpha = ap;
//    NSLog(@"%lf",ap);
    if (offsetY>=tabOffsetY ) {
        self.navigationItem.title = _model.data.name;
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        self.parentScrollView.scrollEnabled = YES;
    }else if(offsetY <= -133){
        //关闭回弹 -133是表头高度
        self.navigationItem.title = @"";
        scrollView.contentOffset = CGPointMake(0, -133);
        self.parentScrollView.scrollEnabled = YES;
    }else{
        self.navigationItem.title = @"";

    }
    
    /**
     * 处理头部视图
     */
    CGFloat yOffset  = scrollView.contentOffset.y;
    if(yOffset < -headViewHeight) {
        
        CGRect f = self.headImageView.frame;
        f.origin.y= yOffset ;
        f.size.height=  -yOffset;
        f.origin.y= yOffset;
        //改变头部视图的fram
        self.headImageView.frame= f;
        CGRect avatarF = CGRectMake(20, (f.size.height-headViewHeight)+29.5, 50, 50);
        _avatarImage.frame = avatarF;
        _countentLabel.frame = CGRectMake(85, (f.size.height-headViewHeight)+60.5, kScreenW-85 - 15, 36);
        _titleLabel.frame = CGRectMake(85, (f.size.height-headViewHeight)+30.5, kScreenW-85 - 15, 36);

    }
}

#pragma mark --tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kScreenH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /* 添加pageView
     * 这里可以任意替换你喜欢的pageView
     *作者这里使用一款github较多人使用的 WMPageController 地址https://github.com/wangmchn/WMPageController
     */
//    [cell.contentView addSubview:self.setPageViewControllers];
    
//    [self buttonList];
    //初始化
    LGSegment *segment = [[LGSegment alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44) TitleArr:@[@"热门动态", @"最新动态",@"最新回复"]];
    segment.delegate = self;
    self.segment = segment;
    [self.view addSubview:segment];
    [self.buttonList addObject:segment.buttonList];
    self.LGLayer = segment.LGLayer;
    [cell.contentView addSubview:segment];
    [self addChildViewController];
    CGFloat contentViewHeight = kScreenH  -44;

    UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, contentViewHeight)];
    [cell.contentView addSubview:sv];
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
//    sv.contentOffset = CGPointMake(kScreenW, 0);
    self.contentScrollView = sv;
    
    [self.segment moveToOffsetX:0];

    return cell;
}
-(void)addChildViewController{
    
    CircleTableViewController *articleVC = [[CircleTableViewController alloc] init];
    articleVC.circleID = _circleID;
    articleVC.dataTyp = @"1";
    [self addChildViewController:articleVC];

    CircleTableViewController *dynamicVC = [[CircleTableViewController alloc] init];
    dynamicVC.circleID = _circleID;
    dynamicVC.dataTyp = @"2";
    [self addChildViewController:dynamicVC];

    CircleTableViewController *newReplyVC = [[CircleTableViewController alloc] init];
    newReplyVC.circleID = _circleID;
    newReplyVC.dataTyp = @"3";
    [self addChildViewController:newReplyVC];

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

-(void)setCircleID:(NSString *)circleID
{
    _circleID = circleID;
    [self getHeaderData];
}

-(void)getHeaderData
{
    NSString *urlStr = [NetRequest DynamicHeader];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] == YES ? [[NSUserDefaults standardUserDefaults] objectForKey:kToken] : @"",@"circle_id":_circleID};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        _model = [CircleModel yy_modelWithJSON:JSON];
        if ([_model.error integerValue] == 0) {
            [_avatarImage sd_setImageWithURL:[NSURL URLWithString:_model.data.cover_url]];
            _countentLabel.text = _model.data.intro;
            [_countentLabel sizeToFit];
            _titleLabel.text = _model.data.name;
            _focusbnt.hidden = _model.data.is_follow;
        }
    } failure:^(NSError *error) {
       
    }];
}
-(void)onClickHeadImageView
{
    CircleDataController *vc = [[CircleDataController alloc]init];
    vc.circleID = _circleID;
    [self.navigationController pushViewController:vc animated:YES];
}
//点击关注
-(void)focusbntAction:(UIButton *)btn
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] != YES) {
        [self pushLoginVC];
    } else {
        NSString *urlStr = [NetRequest FollowCircle];
        NSDictionary *paramsDic = @{@"id":_circleID,@"follow":@"1"};
        [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
            [MyTool showHUDWithStr:JSON[@"msg"]];
            CircleModel *model = [CircleModel yy_modelWithJSON:JSON];
            if ([model.error integerValue] == 0) {
                _focusbnt.hidden  = YES;
            }
        } failure:^(NSError *error) {
            
        }];
    }
}
#pragma mark - 发布动态
- (void)rButtonAction:(UIButton *)btn
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] != YES) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *loginNaVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNaVC animated:YES completion:nil];
    } else {
        if ([UpdataSingleton sharedInstance].isUploading) {
            [MyTool showHUDWithStr:@"文章上传中，请稍后再发~"];
        } else {
            [self showMenu:(UIView *)btn menuType:XYMenuRightNormal];
        }
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
    ReleaseDynamicViewController *reDynamicVC = [[ReleaseDynamicViewController alloc] init];
    reDynamicVC.circle_id = _circleID;
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

- (void)releaseLongText
{
    LongTextEditViewController *longTextEditVC = [[LongTextEditViewController alloc] init];
    longTextEditVC.circle_id = _circleID;
    longTextEditVC.formText = _model.data.name;
    WeakSelf(weakSelf);
    longTextEditVC.ProgressBlock = ^(CGFloat progress) {
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
    longTextEditVC.uploadCompleteBlock = ^{
        self.progerssView.hidden = YES;
    };
    RootNavigationController *naVC = [[RootNavigationController alloc] initWithRootViewController:longTextEditVC];
    [self presentViewController:naVC animated:YES completion:nil];
}

-(UIImageView *)headImageView
{
    if (_headImageView == nil)
    {
        _headImageView= [[UIImageView alloc]init];
        _headImageView.frame=CGRectMake(0, -headViewHeight ,kScreenW,headViewHeight);
        _headImageView.userInteractionEnabled = YES;
        _headImageView.backgroundColor = [MyTool colorWithString:@"f6f6f6"];
        
        _avatarImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 29.5, 50, 50)];
        [_headImageView addSubview:_avatarImage];
        _avatarImage.userInteractionEnabled = YES;
        _avatarImage.layer.masksToBounds = YES;
        _avatarImage.layer.borderWidth = 1;
        _avatarImage.layer.borderColor =[[UIColor colorWithRed:255/255. green:253/255. blue:253/255. alpha:1.] CGColor];
        _avatarImage.layer.cornerRadius = 5;
//        _avatarImage.sd_layout
//        .topSpaceToView(_headImageView, 29.5)
//        .leftSpaceToView(_headImageView, 20)
//        .widthIs(50)
//        .heightEqualToWidth();
        _focusbnt = [UIButton buttonWithType:UIButtonTypeCustom];
        _focusbnt.frame = CGRectMake(kScreenW - 15 -52, 29.5, 52, 25);
        [_focusbnt setTitleColor:[MyTool colorWithString:@"999999"] forState:UIControlStateNormal];
        [_focusbnt setImage:[UIImage imageNamed:@"新闻关注"] forState:UIControlStateNormal];
        [_focusbnt setImage:[UIImage imageNamed:@"新闻已关注"] forState:UIControlStateSelected];
        [_focusbnt addTarget:self action:@selector(focusbntAction:) forControlEvents:UIControlEventTouchUpInside];
        _focusbnt.titleLabel.font = [UIFont systemFontOfSize:14];
        [_headImageView addSubview:_focusbnt];

        _countentLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 60.5, kScreenW-85-15, 12)];
        _countentLabel.font = [UIFont systemFontOfSize:12.];
        _countentLabel.textColor = [MyTool colorWithString:@"999999"];
        _countentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _countentLabel.numberOfLines = 0;
        [_headImageView addSubview:_countentLabel];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 31.5, kScreenW-85-15, 21)];
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
        _titleLabel.textColor = [MyTool colorWithString:@"333333"];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [_headImageView addSubview:_titleLabel];
        
        _headImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickHeadImageView)];
        [_headImageView addGestureRecognizer:singleTap];
    }
    return _headImageView;
}


-(MainTouchTableTableView *)mainTableView
{
    if (mainTableView == nil)
    {
        mainTableView= [[MainTouchTableTableView alloc]initWithFrame:CGRectMake(0,0,kScreenW,kScreenH)];
        mainTableView.delegate=self;
        mainTableView.dataSource=self;
        mainTableView.showsVerticalScrollIndicator = NO;
        mainTableView.contentInset = UIEdgeInsetsMake(headViewHeight,0, 0, 0);
        mainTableView.backgroundColor = [UIColor clearColor];
    }
    return mainTableView;
}

@end
