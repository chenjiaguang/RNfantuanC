//
//  ShoppingCenterViewController.m
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/7.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "ShoppingCenterViewController.h"

#define bannerImageW (kScreenW-30)

@interface ShoppingCenterViewController ()
{
    UIView *_headerView;
    UILabel *_countLabel;
    
    NSMutableArray *_bannerArray;
}

@end

@implementation ShoppingCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"购物中心";
    
    _listArr = [NSMutableArray array];
    _bannerArray = [NSMutableArray array];
    [self createRButton];
    [self createTableView];
    [self getMallData];
}

- (void)createRButton
{
    UIButton *rButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rButton setBackgroundImage:[UIImage imageNamed:@"购物中心搜索"] forState:UIControlStateNormal];
    rButton.frame = CGRectMake(0, 0, 30, 30);
    [rButton addTarget:self action:@selector(rButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rButton];
}

- (void)rButtonAction:(UIButton *)btn
{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.latitude = _latitude;
    searchVC.longitude = _longitude;
    UINavigationController *searchNaVC = [[UINavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:searchNaVC animated:NO completion:nil];
}

- (void)createTableView
{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_myTableView];
    
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 58 + bannerImageW / 23 * 8)];
    _headerView.backgroundColor = [UIColor whiteColor];
    _myTableView.tableHeaderView = _headerView;
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, _headerView.frame.size.height - 18, kScreenW - 30, 18)];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textColor = [MyTool colorWithString:@"333333"];
    _countLabel.font = [UIFont boldSystemFontOfSize:18];
    [_headerView addSubview:_countLabel];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 245;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ShoppingCenterTableViewCell";
    ShoppingCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ShoppingCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.headerImgaeV sd_setImageWithURL:[NSURL URLWithString:_listArr[indexPath.row][@"logo"]] placeholderImage:nil];
    cell.titleLabel.text = _listArr[indexPath.row][@"name"];
    cell.distanceLabel.text = _listArr[indexPath.row][@"distance"];
    [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:_listArr[indexPath.row][@"merchants"][0][@"logo"]]];
    if ([_listArr[indexPath.row][@"merchants"][0][@"total"] isEqualToString:@""]) {
        cell.huodong1.hidden = YES;
    } else {
        cell.huodong1.hidden = NO;
        cell.huodong1.text = _listArr[indexPath.row][@"merchants"][0][@"total"];
    }
    cell.name1.text = _listArr[indexPath.row][@"merchants"][0][@"name"];
    
    [cell.imageView2 sd_setImageWithURL:[NSURL URLWithString:_listArr[indexPath.row][@"merchants"][1][@"logo"]]];
    if ([_listArr[indexPath.row][@"merchants"][1][@"total"] isEqualToString:@""]) {
        cell.huodong2.hidden = YES;
    } else {
        cell.huodong2.hidden = NO;
        cell.huodong2.text = _listArr[indexPath.row][@"merchants"][1][@"total"];
    }
    cell.name2.text = _listArr[indexPath.row][@"merchants"][1][@"name"];
    
    [cell.imageView3 sd_setImageWithURL:[NSURL URLWithString:_listArr[indexPath.row][@"merchants"][2][@"logo"]]];
    if ([_listArr[indexPath.row][@"merchants"][2][@"total"] isEqualToString:@""]) {
        cell.huodong3.hidden = YES;
    } else {
        cell.huodong3.hidden = NO;
        cell.huodong3.text = _listArr[indexPath.row][@"merchants"][2][@"total"];
    }
    cell.name3.text = _listArr[indexPath.row][@"merchants"][2][@"name"];
    cell.numLabel.text = _listArr[indexPath.row][@"num"];
    cell.myBtn.tag = indexPath.row + 1000;
    [cell.myBtn addTarget:self action:@selector(myBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.tap1.view.tag = indexPath.row + 100;
    cell.tap2.view.tag = indexPath.row + 200;
    cell.tap3.view.tag = indexPath.row + 300;
    [cell.tap1 addTarget:self action:@selector(tap1Action:)];
    [cell.tap2 addTarget:self action:@selector(tap2Action:)];
    [cell.tap3 addTarget:self action:@selector(tap3Action:)];
    
    return cell;
}

- (void)tap1Action:(UITapGestureRecognizer *)tap
{
    BusinessDetailsViewController *businessDetailsVC = [[BusinessDetailsViewController alloc] init];
    businessDetailsVC.mid = _listArr[tap.view.tag - 100][@"merchants"][0][@"mid"];
    businessDetailsVC.nameStr = _listArr[tap.view.tag - 100][@"merchants"][0][@"name"];
    [self.navigationController pushViewController:businessDetailsVC animated:YES];
}
- (void)tap2Action:(UITapGestureRecognizer *)tap
{
    BusinessDetailsViewController *businessDetailsVC = [[BusinessDetailsViewController alloc] init];
    businessDetailsVC.mid = _listArr[tap.view.tag - 200][@"merchants"][1][@"mid"];
    businessDetailsVC.nameStr = _listArr[tap.view.tag - 200][@"merchants"][1][@"name"];
    [self.navigationController pushViewController:businessDetailsVC animated:YES];
}
- (void)tap3Action:(UITapGestureRecognizer *)tap
{
    BusinessDetailsViewController *businessDetailsVC = [[BusinessDetailsViewController alloc] init];
    businessDetailsVC.mid = _listArr[tap.view.tag - 300][@"merchants"][2][@"mid"];
    businessDetailsVC.nameStr = _listArr[tap.view.tag - 300][@"merchants"][2][@"name"];
    [self.navigationController pushViewController:businessDetailsVC animated:YES];
}

- (void)myBtnAction:(UIButton *)btn
{
    MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
    myWebVC.urlStr = _listArr[btn.tag - 1000][@"mall_list_url"];
    [self.navigationController pushViewController:myWebVC animated:YES];
}


- (void)getMallData
{
    [self loadingWithText:@"加载中"];
    NSString *urlStr = [NetRequest Mall];
    NSDictionary *paramsDic = @{@"lng": _longitude, @"lat": _latitude};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        if ([[JSON objectForKeyNotNull:@"error"] integerValue] == 0) {
            _countLabel.text = JSON[@"data"][@"count"];
            NSMutableArray *imageUrlArr = [NSMutableArray array];
            _bannerArray = JSON[@"data"][@"banner"];
            for (NSDictionary *dic in _bannerArray) {
                [imageUrlArr addObject:dic[@"img"]];
            }
            if (imageUrlArr.count > 1) {
                LBBanner * banner = [[LBBanner alloc] initWithImageURLArray:imageUrlArr andFrame:CGRectMake(15, 10, bannerImageW, bannerImageW / 23 * 8)];
                banner.pageTurnTime = 3.0;
                banner.delegate = self;
                [_headerView addSubview:banner];
            } else {
                UIImageView *imageView = [[UIImageView alloc] init];
                imageView.frame = CGRectMake(15, 10, bannerImageW, bannerImageW / 23 * 8);
                imageView.contentMode = UIViewContentModeScaleToFill;
                [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlArr[0]]];
                [_headerView addSubview:imageView];
            }
            
            _listArr = JSON[@"data"][@"list"];
            [_myTableView reloadData];
        }
        [self endLoading];
    } failure:^(NSError *error) {
        [self endLoading];
    }];
}

-(void)banner:(LBBanner *)banner didClickViewWithIndex:(NSInteger)index
{
    if (![_bannerArray[index - 1][@"url"] isEqualToString:@""]) {
        MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
        myWebVC.urlStr = _bannerArray[index - 1][@"url"];
        [self.navigationController pushViewController:myWebVC animated:YES];
    }
}

- (void)banner:(LBBanner *)banner didChangeViewWithIndex:(NSInteger)index
{
    
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
