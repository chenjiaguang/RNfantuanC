//
//  HomeInterestController.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/3/26.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "HomeInterestController.h"
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
#import "AlreadyFousCircleView.h"
#import "LongArticleCell.h"
#import "LongArticleDetailsController.h"
@interface HomeInterestController ()<UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) BadgeBarButtonItem *badgeBtn;
@property (nonatomic, strong) UICollectionView *myCollecionView;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIScrollView *myScroView;
@property (nonatomic, strong) NSArray *titileArr;
@property (nonatomic, strong) NSMutableArray *collecionDataArr;
@property (nonatomic, strong) NSMutableArray *tableDataArr;
@property (nonatomic, strong) CircleModel *user;
@property (nonatomic, strong) AlreadyFousCircleView *fousCircleView;
@property (nonatomic, copy) NSString *dataTyp;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL beingLoaded; //正在加载更多
@property (nonatomic, assign) BOOL more; //还有更多数据
@end

@implementation HomeInterestController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [self getNumData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"兴趣圈子";
    [self createUI];
    _beingLoaded = NO;
    _more = NO;
    self.dataTyp = @"1";
    self.page = 1;
    //    [self getDataIsDown:YES];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNewsViewData:) name:reloadNewsViewData object:nil];
    
}

- (void)reloadNewsViewData:(NSNotification *)notification
{
    CircleHomeController *topVC = (CircleHomeController *)[MyTool topViewController];
    if ([[notification object] integerValue] == 2 && topVC.currentIndex == 0) {
        if (_tableDataArr.count != 0) {
            [self.myTableView setContentOffset:CGPointMake(0,0) animated:YES];
        }
        [self.myTableView.mj_header beginRefreshing];
    }
}

- (void)createUI
{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64 - 49) style:UITableViewStylePlain];
    if (iPhoneX) {
        _myTableView.frame = CGRectMake(0, 0, kScreenW, kScreenH - 88 - 83);
    }
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    _myTableView.bounces = NO;
    if (@available(iOS 11.0, *)) {
        _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _myTableView.estimatedRowHeight = 0;
        _myTableView.estimatedSectionHeaderHeight = 0;
        _myTableView.estimatedSectionFooterHeight = 0;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _titileArr = [NSArray arrayWithObjects:@"老爸茶馆",@"舌尖上的海口",@"随手拍海口",@"周末去哪",@"囧事趣图",@"我的奇葩室友",@"单身汪集聚地",@"全部",nil];
    _myTableView.tableHeaderView = [self tableHeadView];
    _myTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_myTableView];
    
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
    
    WeakSelf(weakSelf);
    
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getDataIsDown:YES];
    }];
    [_myTableView.mj_header beginRefreshing];
    
    //    _myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    //        weakSelf.page +=1;
    //        [weakSelf getDataIsDown:NO];
    //    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:nil];
    [footer setTitle:@"已经到底了~" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = [MyTool colorWithString:@"999999"];
    self.myTableView.mj_footer = footer;
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
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] != YES) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *loginNaVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNaVC animated:YES completion:nil];
    } else {
        ReleaseDynamicViewController *reDynamicVC = [[ReleaseDynamicViewController alloc] init];
        reDynamicVC.circle_id = @"";
        reDynamicVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:reDynamicVC animated:YES];
    }
}

//创建表头View
- (UIView *)tableHeadView
{
    UIView *headerBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 419.5)];
    AlreadyFousCircleView *fousCircleView = [[AlreadyFousCircleView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 147)];
    self.fousCircleView = fousCircleView;
    [headerBgView addSubview:fousCircleView];

    
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 162, 20, 20)];
    iconView.image = [UIImage imageNamed:@"recommendedIcon"];
    [headerBgView addSubview:iconView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconView.frame) + 10, 164, kScreenW - 45 -20, 16)];
    label.text = @"推荐圈子";
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];//加粗
    [headerBgView addSubview:label];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((kScreenW - 30) / 4, 80);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0 , 0, 0, 0);
    
    _myCollecionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 193, kScreenW - 30, 172) collectionViewLayout:flowLayout];
    _myCollecionView.backgroundColor = [UIColor whiteColor];
    _myCollecionView.delegate = self;
    _myCollecionView.dataSource = self;
    [_myCollecionView registerClass:[HomePageCollectionViewCell class] forCellWithReuseIdentifier:@"HomePageCollectionViewCell"];
    [headerBgView addSubview:_myCollecionView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_myCollecionView.frame), kScreenW, 10)];
    lineView.backgroundColor = [MyTool colorWithString:@"F5F5F5"];
    [headerBgView addSubview:lineView];
    
    WeakSelf(weakSelf);
    XMPiecewiseView *piecewiseView = [[XMPiecewiseView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), kScreenW, 44) tittleArr:@[@"最新动态",@"热门动态"].mutableCopy font:[UIFont systemFontOfSize:16] returnButtonTag:^(NSString *buttonTag) {
        if ([buttonTag isEqualToString:@"热门动态"]) {
            weakSelf.dataTyp = @"2";
        }else{
            weakSelf.dataTyp = @"1";
        }
        weakSelf.page = 1;
        [weakSelf getDataIsDown:YES];
    }];
    
    [headerBgView addSubview:piecewiseView];
    
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, headerBgView.frame.size.height - 1, kScreenW, 1)];
    lineView2.backgroundColor = [MyTool colorWithString:@"F5F5F5"];
    [headerBgView addSubview:lineView2];
    
    return headerBgView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //    CGPoint point =  [scrollView.panGestureRecognizer translationInView:self.view];
    //    if (point.y > 0 ) {
    //        NSLog(@"------往上滚动");
    //        if ([scrollView isKindOfClass:[UITableView class]] && scrollView.contentOffset.y <= 0){
    //            _myTableView.scrollEnabled = NO;
    //            _myScroView.scrollEnabled = YES;
    //            [_myScroView setContentOffset:CGPointZero animated:YES];
    //        }
    //
    //    }else{
    //        NSLog(@"------往下滚动");
    //        if ([scrollView isEqual:_myScroView] && scrollView.contentOffset.y >= 260) {
    //            _myTableView.scrollEnabled = YES;
    //            _myScroView.scrollEnabled = NO;
    //        }
    //    }
}
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
    
}
#pragma mark -- collectionViewDelegate  &&  collectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _collecionDataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomePageCollectionViewCell" forIndexPath:indexPath];
    
    CirclesModel *model = _collecionDataArr[indexPath.row];
    [cell.myImageV sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    cell.myImageV.layer.cornerRadius = 5;
    
    cell.nameLabel.text = model.name;
    cell.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CirclesModel *model = _collecionDataArr[indexPath.row];
    if ([model.name isEqualToString:@"全部"]) {
        AllCircleListController *detailsVC = [[AllCircleListController alloc] init];
        detailsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailsVC animated:YES];
    }else{
        CircleDetailsController *detailsVC = [[CircleDetailsController alloc] init];
        detailsVC.hidesBottomBarWhenPushed = YES;
        detailsVC.circleID = model.id;
        [self.navigationController pushViewController:detailsVC animated:YES];
    }
    
}
#pragma mark -- tableViewDelegate  &&  tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListModel *listModel = _tableDataArr[indexPath.row];
    if ([listModel.type isEqualToString:@"18"]) {
        if (listModel.location.length &&listModel.circle_name.length) {
            return 276;
        }else if (listModel.location.length &&!listModel.circle_name.length){
            return 246;
        }else if (!listModel.location.length &&listModel.circle_name.length){
            return 246;
        }else if (!listModel.location.length &&!listModel.circle_name.length){
            return 216;
        }
        return 200;
    }else{
        return [self calculateCellHeight:listModel];

    }
    
    //
    //    return [_myTableView cellHeightForIndexPath:indexPath model:_user.data.list[indexPath.row] keyPath:@"model" cellClass:[CircleCell class] contentViewWidth:kScreenW];
    //    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:kScreenW tableView:_myTableView];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HomePageListTableViewCell";
    static NSString *longArticleIdentifier = @"longArticleIdentifier";
    ListModel *listModel = _tableDataArr[indexPath.row];
    if ([listModel.type isEqualToString:@"18"]) {
        LongArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:longArticleIdentifier];
        if (cell == nil) {
            cell = [[LongArticleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:longArticleIdentifier];
        }
        cell.model = listModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.praisebnt.tag = 3000 + indexPath.row;
        [cell.praisebnt addTarget:self action:@selector(praiseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        CircleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[CircleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        cell.isHome = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        //    cell.dataDic = _tableDataArr[indexPath.row];
        cell.model = listModel;
        cell.praisebnt.tag = 3000 + indexPath.row;
        [cell.praisebnt addTarget:self action:@selector(praiseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    
   
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //首先判断是否还有可以刷新的数据
    
    if (indexPath.row==(_tableDataArr.count-5) && !_beingLoaded &&_more &&_tableDataArr.count >=20) {  //如果当用户滑动到倒数第五个的时候，而且当前请求已经结束的时候，去加载更多的数据。
        self.page +=1;
        [self getDataIsDown:NO];
    }
    
}
#pragma mark - 点击点赞按钮
- (void)praiseBtnAction:(UIButton *)btn
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] == YES) {
        NSInteger index = btn.tag - 3000;
        ListModel *listModel = _tableDataArr[index];
        listModel.has_like = !listModel.has_like;
        listModel.like_num = [NSString stringWithFormat:@"%ld", listModel.has_like ? listModel.like_num.integerValue + 1 : listModel.like_num.integerValue - 1];
        [_tableDataArr replaceObjectAtIndex:index withObject:listModel];
        [_myTableView reloadData];
        [self getLikeDataWithIndex:index];
    } else {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *loginNaVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNaVC animated:YES completion:nil];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    ListModel *listModel = _tableDataArr[indexPath.row];
    
    if ([listModel.type isEqualToString:@"18"]) {
        LongArticleDetailsController *vc = [[LongArticleDetailsController alloc]init];
        vc.articleId = listModel.id;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        DynamicDetailsViewController *vc = [[DynamicDetailsViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.circleID = listModel.id;
        [self.navigationController pushViewController:vc animated:YES];

    }
}

- (void)getLikeDataWithIndex:(NSInteger)index
{
    ListModel *listModel = _tableDataArr[index];
    NSString *urlStr = [NetRequest DynamicLike];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"dy_id": listModel.id, @"like": [NSString stringWithFormat:@"%d", listModel.has_like]};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
    } failure:^(NSError *error) {
    }];
}

-(void)getDataIsDown:(BOOL)down
{
    NSString *urlStr = [NetRequest CircleHome];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] == YES ? [[NSUserDefaults standardUserDefaults] objectForKey:kToken] : @"", @"sort": _dataTyp, @"pn":[NSString stringWithFormat:@"%ld",_page]};
    if (!down) {
        _beingLoaded = YES;
    }
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {

        if (_page == 1) {
            _tableDataArr = [NSMutableArray array];
        }
        _user = [CircleModel yy_modelWithJSON:JSON];
        _fousCircleView.follow_circles = _user.data.follow_circles;

        if ([_user.error integerValue] == 0) {
            _user.data.paging.is_end == YES? _more = YES:NO;
            if (down) {
                _tableDataArr = _user.data.list.mutableCopy;
            }else{
                _beingLoaded = NO;
                _tableDataArr = [[_tableDataArr arrayByAddingObjectsFromArray:_user.data.list]mutableCopy];
            }
            _collecionDataArr = _user.data.circles.mutableCopy;
            
            [_myCollecionView reloadData];
            [_myTableView reloadData];
            [_myTableView.mj_header endRefreshing];
            _user.data.paging.is_end == YES?[_myTableView.mj_footer endRefreshingWithNoMoreData]:[_myTableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        [_myTableView.mj_header endRefreshing];
        [_myTableView.mj_footer endRefreshing];
    }];
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

-(CGFloat)calculateCellHeight:(ListModel *)model
{
    NSArray *picArr = model.cover.mutableCopy;
    //每个Item宽高
    CGFloat W = (kScreenW-30 -20)/3;
    CGFloat H = W * 0.72;
    CGFloat picH = picArr.count %3 == 0?picArr.count / 3 * (H + 10):(picArr.count / 3 +1)* (H + 10) ;
    if (picArr.count == 1) {
        picH = (kScreenW-30)*0.562 +10;
    }
    CGFloat labelW = kScreenW -15 - 15;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, labelW, 999)];
    label.numberOfLines = 0;
    if (model.content.length > 100) {
        label.text = [NSString stringWithFormat:@"%@...全文", [model.content substringWithRange:NSMakeRange(0, 100)]];
    } else {
        label.text = model.content;
    }
    CGFloat labelH = [MyTool heightOfLabel:label.text forFont:[UIFont systemFontOfSize:17] labelLength:labelW];
    label.text.length == 0?labelH = 0:labelH;
    CGFloat addressBtnH = model.location.length >0?30:0;
    CGFloat cellH = labelH + picH + 75 + 15 + 15 + 14 + 15 +14 +15 +addressBtnH;
    return cellH;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:reloadNewsViewData object:nil];
}

@end
