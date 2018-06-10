//
//  ShopSearchViewController.m
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/28.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "ShopSearchViewController.h"

@interface ShopSearchViewController ()
@property (nonatomic, strong) UISearchBar *mySearchBar;
@property (nonatomic, strong) UIScrollView *myScrollView;

@property (nonatomic, strong) NSURLSessionDataTask *tesk;

@end

@implementation ShopSearchViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    if (![_mySearchBar.text isEqualToString:@""]) {
        [self getSearchDataWithSearch:_mySearchBar.text];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    
    _merchant_hotsArr = [NSMutableArray array];
    _listArr = [NSMutableArray array];
    
    [self createSearchBar];
    [_mySearchBar becomeFirstResponder];
    [self createScrollView];
    [self createTableView];
    
    [self getSearchData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSearchText:) name:reloadShopSearchText object:nil];
}

- (void)reloadSearchText:(NSNotification *)notification
{
    _mySearchBar.text = (NSString *)[notification object];
}

- (void)createTableView
{
    _myTableView = [[UITableView alloc] initWithFrame:_myScrollView.frame style:UITableViewStylePlain];
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.showsVerticalScrollIndicator = NO;
    _myTableView.hidden = YES;
    [_myScrollView addSubview:_myTableView];
}

- (void)createSearchBar
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
    titleView.backgroundColor = [UIColor whiteColor];
    _mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-10, 7, titleView.frame.size.width - 60, 30)];
    _mySearchBar.showsCancelButton = NO;
    _mySearchBar.delegate = self;
    _mySearchBar.placeholder = [NSString stringWithFormat:@"在%@中的搜索结果", _nameStr];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(0, 0, 40, 44);
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancleBtn setTitleColor:[MyTool colorWithString:@"333333"] forState:UIControlStateNormal];
    cancleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [cancleBtn addTarget:self action:@selector(cancleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancleBtn];
    
    UITextField *searchField=[_mySearchBar valueForKey:@"searchField"];
    searchField.frame = CGRectMake(0, 0, 0, 30);
    searchField.layer.masksToBounds = YES;
    if (@available(iOS 11.0, *)) {
        searchField.layer.cornerRadius = 18;
    } else {
        searchField.layer.cornerRadius = 14;
    }
    searchField.font = [UIFont systemFontOfSize:14];
    searchField.backgroundColor = [MyTool ColorWithColorStr:@"f5f5f5"];
    
    _mySearchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:_mySearchBar.bounds.size];
    [titleView addSubview:_mySearchBar];
    self.navigationItem.titleView = titleView;
    
    
    if (_isSearchList) {
        _mySearchBar.text = _searchBarText;
        [self searchBar:_mySearchBar textDidChange:_searchBarText];
    }
}

- (void)createScrollView
{
    [_myScrollView removeFromSuperview];
    _myScrollView = [[UIScrollView alloc] init];
    _myScrollView.backgroundColor = [UIColor whiteColor];
    
#pragma mark - 热门搜索
    CGFloat w = 5;
    CGFloat h = 60;
    for (int i = 0; i < _merchant_hotsArr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.tag = 100 + i;
        button.backgroundColor = [MyTool colorWithString:@"f5f5f5"];
        [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[MyTool colorWithString:@"666666"] forState:UIControlStateNormal];
        button.layer.cornerRadius = 2;
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        //根据计算文字的大小
        
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        CGFloat length = [[NSString stringWithFormat:@"  %@  ", _merchant_hotsArr[i][@"name"]] boundingRectWithSize:CGSizeMake(kScreenW - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //为button赋值
        [button setTitle: _merchant_hotsArr[i][@"name"] forState:UIControlStateNormal];
        //设置button的frame
        button.frame = CGRectMake(10 + w, h, length + 10, 26);
        //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
        if(15 + w + length + 10 > kScreenW - 30){
            w = 15; //换行时将w置为0
            h = h + button.frame.size.height + 10;//距离父视图也变化
            button.frame = CGRectMake(w, h, length + 10, 26);//重设button的frame
        }
        w = button.frame.size.width + button.frame.origin.x;
        [_myScrollView addSubview:button];
    }
    
    if (_merchant_hotsArr.count != 0) {
        UILabel *line1Label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 20)];
        line1Label.text = @"热门搜索";
        line1Label.textColor = [MyTool colorWithString:@"333333"];
        line1Label.font = [UIFont boldSystemFontOfSize:18];
        [_myScrollView addSubview:line1Label];
    }
    
    
#pragma mark - 历史记录
    NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:KShopSearchHistory] mutableCopy];
    if (array.count != 0) {
        CGFloat w3 = 5;
        CGFloat h3 = 60 + h + 40;
        if (_merchant_hotsArr.count == 0) {
            h3 = h;
        }
        for (int i = 0; i < array.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.tag = 300 + i;
            button.backgroundColor = [MyTool colorWithString:@"f5f5f5"];
            [button addTarget:self action:@selector(handleClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[MyTool colorWithString:@"666666"] forState:UIControlStateNormal];
            button.layer.cornerRadius = 2;
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            //根据计算文字的大小
            
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
            NSString *text = array[i];
            if (text.length > 10) {
                text = [text substringToIndex:10];
            }
            CGFloat length = [[NSString stringWithFormat:@"  %@  ", text] boundingRectWithSize:CGSizeMake(kScreenW - 30, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
            //为button赋值
            [button setTitle: text forState:UIControlStateNormal];
            //设置button的frame
            button.frame = CGRectMake(10 + w3, h3, length + 10 , 26);
            //当button的位置超出屏幕边缘时换行 320 只是button所在父视图的宽度
            if(15 + w3 + length + 10 > kScreenW - 30){
                w3 = 15; //换行时将w置为0
                h3 = h3 + button.frame.size.height + 10;//距离父视图也变化
                button.frame = CGRectMake(w3, h3, length + 10, 26);//重设button的frame
            }
            w3 = button.frame.size.width + button.frame.origin.x;
            [_myScrollView addSubview:button];
        }
        
        UILabel *line3Label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20 + h + 40, 150, 20)];
        if (_merchant_hotsArr.count == 0) {
            line3Label.frame = CGRectMake(15, 20, 150, 20);
        }
        line3Label.text = @"搜索记录";
        line3Label.textColor = [MyTool colorWithString:@"333333"];
        line3Label.font = [UIFont boldSystemFontOfSize:18];
        [_myScrollView addSubview:line3Label];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(kScreenW - 35, line3Label.frame.origin.y, 20, 20);
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"搜索记录删除"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_myScrollView addSubview:deleteBtn];
        
        _myScrollView.contentSize = CGSizeMake(kScreenW, h3 + 40);
    }
    
    
    
    if (iPhoneX) {
        _myScrollView.frame = CGRectMake(0, 0, kScreenW, kScreenH - 88);
    } else {
        _myScrollView.frame = CGRectMake(0, 0, kScreenW, kScreenH - 64);
    }
    _myScrollView.showsVerticalScrollIndicator = NO;
    _myScrollView.alwaysBounceVertical = YES;
    _myScrollView.delegate = self;
    [self.view addSubview:_myScrollView];
    [_myScrollView addSubview:_myTableView];
}

- (void)handleClick:(UIButton *)btn
{
    [_mySearchBar endEditing:YES];
    ShopSearchListViewController *searchListVC = [[ShopSearchListViewController alloc] init];
    searchListVC.latitude = _latitude;
    searchListVC.longitude = _longitude;
    searchListVC.mall_id = _mall_id;
    searchListVC.nameStr = _nameStr;
    
    if (btn.tag >= 300) {
        NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:KShopSearchHistory] mutableCopy];
        searchListVC.searchBarText = array[btn.tag - 300];
    } else {
        searchListVC.searchBarText = btn.titleLabel.text;
    }
    
    _mySearchBar.text = searchListVC.searchBarText;
    [self saveHistoryDataWithText:_mySearchBar.text];
    [self.navigationController pushViewController:searchListVC animated:YES];
}

- (void)deleteBtnAction:(UIButton *)btn
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KShopSearchHistory];
    [self createScrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_mySearchBar endEditing:YES];
    [self resignFirstResponder];
}

- (void)cancleBtnAction:(UIButton *)btn
{
    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark - searchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self saveHistoryDataWithText:searchBar.text];
    
    if (_isSearchList) {
        [[NSNotificationCenter defaultCenter] postNotificationName:reloadShopSearchListView object:searchBar.text];
        [[NSNotificationCenter defaultCenter] postNotificationName:reloadShopSearchText object:searchBar.text];
        [self dismissViewControllerAnimated:NO completion:nil];
    } else {
        ShopSearchListViewController *searchListVC = [[ShopSearchListViewController alloc] init];
        searchListVC.searchBarText = searchBar.text;
        searchListVC.latitude = _latitude;
        searchListVC.longitude = _longitude;
        searchListVC.mall_id = _mall_id;
        searchListVC.nameStr = _nameStr;
        [self.navigationController pushViewController:searchListVC animated:YES];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (![searchText isEqualToString:@""]) {
        _myScrollView.scrollEnabled = NO;
        [self getSearchDataWithSearch:searchText];
    } else {
        [_tesk cancel];
        _myTableView.hidden = YES;
        [self createScrollView];
    }
}


#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HomeSearchTableViewCell";
    HomeSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[HomeSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.nameLabel.text = _listArr[indexPath.row][@"name"];
    cell.distanceLabel.text = _listArr[indexPath.row][@"distance"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self saveHistoryDataWithText:_listArr[indexPath.row][@"name"]];
    _mySearchBar.text = _listArr[indexPath.row][@"name"];
    
    BusinessDetailsViewController *businessDetailsVC = [[BusinessDetailsViewController alloc] init];
    businessDetailsVC.mid = _listArr[indexPath.row][@"mid"];
    businessDetailsVC.nameStr = _listArr[indexPath.row][@"name"];
    [self.navigationController pushViewController:businessDetailsVC animated:YES];
}


- (void)getSearchData
{
    NSString *urlStr = [NetRequest Search];
    NSDictionary *paramsDic = @{@"lng": _longitude, @"lat": _latitude, @"mall_id": _mall_id};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        if ([[JSON objectForKeyNotNull:@"error"] integerValue] == 0) {
            _merchant_hotsArr = [JSON[@"data"][@"merchant_hots"] mutableCopy];
            
            [self createScrollView];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getSearchDataWithSearch:(NSString *)searchText
{
    NSString *urlStr = [NetRequest MallSearchSuggest];
    NSDictionary *paramsDic = @{@"search_word": searchText, @"lng": _longitude, @"lat": _latitude, @"mall_id": _mall_id};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [_tesk cancel];
    _tesk = [manager POST:urlStr parameters:paramsDic progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKeyNotNull:@"error"] integerValue] == 0){
            [_myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            _myScrollView.scrollEnabled = NO;
            _myTableView.hidden = NO;
            _listArr = [responseObject[@"data"][@"merchants"] mutableCopy];
            [_myTableView reloadData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}



- (void)saveHistoryDataWithText:(NSString *)text
{
    NSMutableArray *array = [[[NSUserDefaults standardUserDefaults] objectForKey:KShopSearchHistory] mutableCopy];
    if (array.count == 0) {
        array = [NSMutableArray array];
    } else if (array.count == 10) {
        [array removeLastObject];
    }
    for (NSInteger i = 0; i < array.count; i++) {
        if ([array[i] isEqualToString:text]) {
            [array removeObject:text];
        }
    }
    [array insertObject:text atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:KShopSearchHistory];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:reloadShopSearchText object:nil];
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
