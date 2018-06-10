//
//  BalanceListViewController.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/1/9.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "BalanceListViewController.h"
#import "BalanceListTableViewCell.h"

@interface BalanceListViewController ()
{
    UILabel *_headerLabel;
    UIView *_nullView;
}


@end

@implementation BalanceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"余额明细";
    self.view.backgroundColor = [MyTool colorWithString:@"f5f5f5"];
    
    _pageNum = 1;
    _listArr = [NSMutableArray array];
    
    [self createHeaderLabel];
    [self createTableView];
    [self createNullView];
    
    [self loadingWithText:@"加载中"];
    [self getListData];
    [self addListFooter];
}
- (void)createHeaderLabel
{
    _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, kScreenW, 35)];
    _headerLabel.backgroundColor = [UIColor clearColor];
    _headerLabel.textColor = [MyTool colorWithString:@"666666"];
    _headerLabel.textAlignment = NSTextAlignmentCenter;
    _headerLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_headerLabel];
}

- (void)createTableView
{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kScreenW, kScreenH - 40 - 64) style:UITableViewStylePlain];
    if (iPhoneX) {
        _myTableView.frame = CGRectMake(0, 40, kScreenW, kScreenH - 40 - 88);
    }
    _myTableView.backgroundColor = [MyTool colorWithString:@"f5f5f5"];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:_myTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"BalanceListTableViewCell";
    BalanceListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[BalanceListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSString *nameStr = _listArr[indexPath.row][@"title"];
    if ([MyTool widthOfLabel:nameStr ForFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:15] labelHeight:15] < 180 * Swidth) {
        cell.nameLabel.frame = CGRectMake(15, 17, [MyTool widthOfLabel:nameStr ForFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:15] labelHeight:15], 15);
        cell.refundLabel.frame = CGRectMake(CGRectGetMaxX(cell.nameLabel.frame) + 10, 20, 60, 12);
    }
    cell.nameLabel.text = nameStr;
    cell.refundLabel.text = _listArr[indexPath.row][@"desc"];
    cell.moneyLabel.text = _listArr[indexPath.row][@"money"];
    cell.timeLabel.text = _listArr[indexPath.row][@"time"];
    if (_listArr.count - 1 == indexPath.row) {
        cell.line.hidden = YES;
    } else {
        cell.line.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
    myWebVC.urlStr = _listArr[indexPath.row][@"url"];
    [self.navigationController pushViewController:myWebVC animated:YES];
}

- (void)getListData
{
    NSString *urlStr = [NetRequest WalletBalanceList];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"pn": [NSString stringWithFormat:@"%ld", _pageNum], @"limit": @"10"};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [self endLoading];
        if ([[JSON objectForKeyNotNull:@"error"] integerValue] == 0) {
            
            [_listArr addObjectsFromArray:[JSON[@"data"][@"list"] mutableCopy]];
            _headerLabel.text = [NSString stringWithFormat:@"共%@笔", JSON[@"data"][@"page"][@"total"]];
            
            [_myTableView reloadData];
            
            [_myTableView.mj_footer endRefreshing];
            if ([JSON[@"data"][@"page"][@"is_end"] boolValue] == YES) {
                [_myTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            
            if (_listArr.count == 0) {
                _nullView.hidden = NO;
            } else {
                _nullView.hidden = YES;
            }
            
        }
    } failure:^(NSError *error) {
        [self endLoading];
    }];
}


- (void)createNullView
{
    _nullView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    _nullView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_nullView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenW - 140) / 2, 100 * Sheight, 140, 140)];
    imageView.image = [UIImage imageNamed:@"余额明细null"];
    [_nullView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 10, kScreenW, 14)];
    label.text = @"暂无余额明细";
    label.textColor = [MyTool colorWithString:@"999999"];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    [_nullView addSubview:label];
    
    _nullView.hidden = YES;
}

- (void)addListFooter
{
    __block BalanceListViewController *balanceListVC = self;
    
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        balanceListVC.pageNum++;
        
        [self getListData];
    }];
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
