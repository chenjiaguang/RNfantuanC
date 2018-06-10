//
//  ShopSearchListViewController.m
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/29.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "ShopSearchListViewController.h"

@interface ShopSearchListViewController ()
{
    NSString *_sort;
    NSString *_cid;
    NSString *_floor;
    
    NSMutableArray *_typeArr;
    NSMutableArray *_floorArr;
    NSMutableArray *_categoryArr;
    NSMutableArray *_sortArr;
    
    LQYDropMenuView *_dropMenu;
    UIView *_nullView;
}

@end

@implementation ShopSearchListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _sort = @"0";
    _cid = @"";
    _floor = @"";
    _pageNum = 1;
    _isUpLoading = NO;
    _listArr = [NSMutableArray array];
    _typeArr = [NSMutableArray array];
    _floorArr = [NSMutableArray array];
    _categoryArr = [NSMutableArray array];
    _sortArr = [NSMutableArray array];
    
    [self createSearchBar];
    [self createTableView];
    [self createTitleView];
    [self createNullView];
    [self addSearchListFooter];
    
    [self getSearchResultData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSearchListView:) name:reloadShopSearchListView object:nil];
}

- (void)reloadSearchListView:(NSNotification *)notification
{
    _searchBarText = (NSString *)[notification object];
    [_titleBtn setTitle:_searchBarText forState:UIControlStateNormal];
    _sort = @"0";
    _cid = @"";
    _mall_id = @"";
    [self createTitleView];
    _pageNum = 1;
    [self getSearchResultData];
}

- (void)createSearchBar
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 60, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleBtn.frame = CGRectMake(0, 7, kScreenW - 60, 30);
    _titleBtn.backgroundColor = [MyTool colorWithString:@"f5f5f5"];
    _titleBtn.layer.cornerRadius = 15;
    [_titleBtn setImage:[UIImage imageNamed:@"首页搜索"] forState:UIControlStateNormal];
    [_titleBtn setTitleColor:[MyTool colorWithString:@"333333"] forState:UIControlStateNormal];
    [_titleBtn setTitle:_searchBarText forState:UIControlStateNormal];
    _titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _titleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    _titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 0);
    [_titleBtn addTarget:self action:@selector(titleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [titleView addSubview:_titleBtn];
    self.navigationItem.titleView = titleView;
}

- (void)titleBtnAction:(UIButton *)btn
{
    ShopSearchViewController *searchVC = [[ShopSearchViewController alloc] init];
    searchVC.isSearchList = YES;
    searchVC.latitude = _latitude;
    searchVC.longitude = _longitude;
    searchVC.searchBarText = _searchBarText;
    searchVC.mall_id = _mall_id;
    searchVC.nameStr = _nameStr;
    UINavigationController *searchNaVC = [[UINavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:searchNaVC animated:NO completion:nil];
}

- (void)createTitleView
{
    [_dropMenu removeFromSuperview];
    _dropMenu = [[LQYDropMenuView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    [_dropMenu.otherButton setTitle:@"全部楼层" forState:UIControlStateNormal];
    _dropMenu.otherRowStr = @"";
    _dropMenu.leftRowStr = @"";
    _dropMenu.rightRowStr = @"0";
    _dropMenu.dataSource = self;
    _dropMenu.delegate  = self;
    [self.view addSubview:_dropMenu];
}

- (void)createTableView
{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kScreenW, kScreenH - 64 - 40) style:UITableViewStylePlain];
    if (iPhoneX) {
        _myTableView.frame = CGRectMake(0, 40, kScreenW, kScreenH - 88 - 40);
    }
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
    
    _myTableView.tableFooterView = [[UIView alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *promotionArr = _listArr[indexPath.row][@"promotion_list"];
    NSMutableArray *voucherGrouponArr = _listArr[indexPath.row][@"voucher_groupon_list"];
    
    if (promotionArr.count == 0 && voucherGrouponArr.count == 0) {
        return 110;
    } else if (promotionArr.count != 0 && voucherGrouponArr.count == 0) {
        // 需求变更 （去除范团商家图标）
//        if (![_listArr[indexPath.row][@"spider"] isEqualToString:@"0"]) {
//            return 88 + promotionArr.count * 23;
//        }
        return 110 + promotionArr.count * 23;
    } else {
        // 需求变更 （去除范团商家图标）
//        if (![_listArr[indexPath.row][@"spider"] isEqualToString:@"0"]) {
//            if ([_typeArr[indexPath.row] isEqualToString:@"0"] && voucherGrouponArr.count > 2) {
//                return 88 + promotionArr.count * 23 + 2 * 55 + 40;
//            } else {
//                return 88 + promotionArr.count * 23 + voucherGrouponArr.count * 55;
//            }
//        }
        if ([_typeArr[indexPath.row] isEqualToString:@"0"] && voucherGrouponArr.count > 2) {
            return 110 + promotionArr.count * 23 + 2 * 55 + 40;
        } else {
            return 110 + promotionArr.count * 23 + voucherGrouponArr.count * 55;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ShopSearchListTableViewCell";
    ShopSearchListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ShopSearchListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    [cell.headerImgaeV sd_setImageWithURL:[NSURL URLWithString:_listArr[indexPath.row][@"logo"]] placeholderImage:nil];
    cell.nameLabel.text = _listArr[indexPath.row][@"name"];
    cell.myStarRateV.currentScore = [_listArr[indexPath.row][@"score"] floatValue];
    cell.avgpriceLabel.text = _listArr[indexPath.row][@"average_spend"];
    cell.floorLabel.text = _listArr[indexPath.row][@"floor"];
    cell.moreBtn.tag = indexPath.row + 2000;
    
    [cell.moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell categoryText:_listArr[indexPath.row][@"category_name"] isSpider:_listArr[indexPath.row][@"spider"] promotion:_listArr[indexPath.row][@"promotion_list"] voucher_groupon:_listArr[indexPath.row][@"voucher_groupon_list"] type:_typeArr[indexPath.row]];
    
    cell.delegate = self;
    
    return cell;
}

#pragma mark - 点击代金券
- (void)TapVoucherGrouponV:(UITapGestureRecognizer *)tap voucher_grouponArr:(NSMutableArray *)voucher_grouponArr
{
    MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
    myWebVC.urlStr = voucher_grouponArr[tap.view.tag - 100][@"url"];
    [self.navigationController pushViewController:myWebVC animated:YES];
}

- (void)moreBtnAction:(UIButton *)btn
{
    [_typeArr replaceObjectAtIndex:btn.tag - 2000 withObject:@"1"];
    NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:btn.tag - 2000 inSection:0];
    [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BusinessDetailsViewController *businessDetailsVC = [[BusinessDetailsViewController alloc] init];
    businessDetailsVC.mid = _listArr[indexPath.row][@"mid"];
    businessDetailsVC.nameStr = _listArr[indexPath.row][@"name"];
    [self.navigationController pushViewController:businessDetailsVC animated:YES];
}


#pragma mark - WSDropMenuView DataSource
- (NSInteger)dropMenuView:(LQYDropMenuView *)dropMenuView numberWithIndexPath:(LQYIndexPath *)indexPath{
    
    //WSIndexPath 类里面有注释
    if (indexPath.column == 2) {
        
        return _floorArr.count;
    }
    
    
    if (indexPath.column == 0 && indexPath.row == WSNoFound) {
        
        return _categoryArr.count;
    }
    if (indexPath.column == 0 && indexPath.row != WSNoFound && indexPath.item == WSNoFound) {
        if (indexPath.row >= _categoryArr.count) {
            return 0;
        }
        NSArray *subcatesArr = _categoryArr[indexPath.row][@"subcates"];
        return subcatesArr.count;
    }
    
    
    if (indexPath.column == 1) {
        
        return _sortArr.count;
    }
    
    return 0;
}

- (NSDictionary *)dropMenuView:(WSDropMenuView *)dropMenuView titleWithIndexPath:(WSIndexPath *)indexPath{
    
    if (indexPath.column == 2 && indexPath.row != WSNoFound) {
        
        return _floorArr[indexPath.row];
    }
    
    
    if (indexPath.column == 0 && indexPath.row != WSNoFound && indexPath.item == WSNoFound) {
        
        return _categoryArr[indexPath.row];
    }
    
    if (indexPath.column == 0 && indexPath.row != WSNoFound && indexPath.item != WSNoFound && indexPath.rank == WSNoFound) {
        
        return _categoryArr[indexPath.row][@"subcates"][indexPath.item];
    }
    
    
    
    if (indexPath.column == 1 && indexPath.row != WSNoFound ) {
        
        return _sortArr[indexPath.row];
    }
    
    return NULL;
    
}

#pragma mark - WSDropMenuView Delegate
- (void)dropMenuView:(WSDropMenuView *)dropMenuView didSelectWithIndexPath:(WSIndexPath *)indexPath
{
    if (indexPath.column == 2 && indexPath.row != WSNoFound) {
        
        _floor =  _floorArr[indexPath.row][@"id"];
    }
    
    
    if (indexPath.column == 0 && indexPath.row != WSNoFound && indexPath.item == WSNoFound) {
        
        _cid = _categoryArr[indexPath.row][@"id"];
    }
    
    if (indexPath.column == 0 && indexPath.row != WSNoFound && indexPath.item != WSNoFound && indexPath.rank == WSNoFound) {
        
        _cid = _categoryArr[indexPath.row][@"subcates"][indexPath.item][@"id"];
    }
    
    
    
    if (indexPath.column == 1 && indexPath.row != WSNoFound ) {
        
        _sort = _sortArr[indexPath.row][@"sort"];
    }
    
    _isUpLoading = YES;
    _pageNum = 1;
    [self getSearchResultData];
}


- (void)getSearchResultData
{
    NSString *urlStr = [NetRequest MallSearchResult];
    NSDictionary *paramsDic = @{@"lng": _longitude, @"lat": _latitude, @"search_word": _titleBtn.titleLabel.text, @"sort": _sort, @"cid": _cid, @"mall_id": _mall_id, @"floor_id": _floor, @"pn": [NSString stringWithFormat:@"%ld", _pageNum]};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        if ([[JSON objectForKeyNotNull:@"error"] integerValue] == 0) {
            
            if (_isUpLoading == NO || _pageNum == 1) {
                [_listArr removeAllObjects];
                [_typeArr removeAllObjects];
                _pageNum = 1;
            }
            _categoryArr = [JSON[@"data"][@"category"] mutableCopy];
            _floorArr = [JSON[@"data"][@"floor"] mutableCopy];
            _sortArr = [JSON[@"data"][@"sort"] mutableCopy];
            _dropMenu.categoryArr = _categoryArr;
            _dropMenu.floorArr = _floorArr;
            _dropMenu.sortArr = _sortArr;
            
            [_listArr addObjectsFromArray:[JSON[@"data"][@"merchants"] mutableCopy]];
            for (NSInteger i = 0; i < _listArr.count; i++) {
                [_typeArr addObject:@"0"];
            }
            
            [_myTableView.mj_footer endRefreshing];
            if ([JSON[@"data"][@"paging"][@"is_end"] boolValue] == YES) {
                [_myTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [_myTableView reloadData];
            [_dropMenu reloadOtherTableView];
            [_dropMenu reloadLeftTableView];
            [_dropMenu reloadRightTableView];
            [_dropMenu reloadLeft1TabelView];
            
            
            if (_listArr.count != 0) {
                if (_isUpLoading == NO || _pageNum == 1) {
                    NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
                    [_myTableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
                
                _nullView.hidden = YES;
            } else {
                _nullView.hidden = NO;
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)addSearchListFooter
{
    __block ShopSearchListViewController *searchListVC = self;
    
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        searchListVC.isUpLoading = YES;
        searchListVC.pageNum++;
        
        [self getSearchResultData];
        
    }];
}

- (void)createNullView
{
    if (!_nullView) {
        _nullView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, _myTableView.frame.size.height + 40)];
        _nullView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_nullView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 170 * Sheight, kScreen_Width, 20)];
        label.text = @"对不起，暂无符合搜索的内容～";
        label.textColor = [MyTool colorWithString:@"999999"];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        [_nullView addSubview:label];
        _nullView.hidden = YES;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:reloadShopSearchListView object:nil];
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
