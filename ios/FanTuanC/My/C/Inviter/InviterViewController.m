//
//  InviterViewController.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/1/11.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "InviterViewController.h"
#import "InviterTableViewCell.h"
#import "InviterHeaderView.h"
#import "InviterQRcodeViewController.h"
#import "InvitedRecordViewController.h"

@interface InviterViewController ()
{
    NSMutableDictionary *_dataDic;
}

@end

@implementation InviterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"邀请有礼";
    self.view.backgroundColor = [MyTool colorWithString:@"f5f5f5"];
    
    _listArr = [NSMutableArray array];
    _dataDic = [NSMutableDictionary dictionary];
    [self createTableView];
    
    [self loadingWithText:@"加载中"];
    [self getInviterData];
}

- (void)createHeaderViewWithTitle:(NSString *)title money:(NSString *)money
{
    CGFloat headerViewH = 166;
    if (![title isEqualToString:@""]) {
        headerViewH = 166 + 45;
    }
    InviterHeaderView *inviterHeaderV = [[InviterHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, headerViewH) title:title money:money];
    _myTableView.tableHeaderView = inviterHeaderV;
    
    WeakSelf(weakSelf);
    inviterHeaderV.pushWalletAction = ^{
        WalletViewController *walletVC = [[WalletViewController alloc] init];
        [weakSelf.navigationController pushViewController:walletVC animated:YES];
    };
}


- (void)createTableView
{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
    _myTableView.backgroundColor = [MyTool colorWithString:@"F5F5F5"];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_myTableView];
    
    if (@available(iOS 11.0, *)) {
        _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:_myTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    bgView.backgroundColor = [MyTool colorWithString:@"f5f5f5"];
    return bgView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listArr[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"InviterTableViewCell";
    InviterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InviterTableViewCell" owner:self options:nil] firstObject];
    }
    
    
    if (indexPath.section == 0) {
        
        cell.titleLabel.text = _listArr[indexPath.section][indexPath.row];
        
        if ([_listArr[indexPath.section] count] - 1 == indexPath.row) {
            cell.line.hidden = YES;
        } else {
            cell.line.hidden = NO;
        }
    } else {
        cell.titleLabel.text = _listArr[indexPath.section][indexPath.row];
        cell.line.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            InviterQRcodeViewController *inviterQRcodeVC = [[InviterQRcodeViewController alloc] init];
            inviterQRcodeVC.imageUrl = _dataDic[@"url_qrcode"];
            inviterQRcodeVC.shareURl = _dataDic[@"url_redbag"];
            [self.navigationController pushViewController:inviterQRcodeVC animated:YES];
        } else if (indexPath.row == 1) {
            InvitedRecordViewController *invitedRecordVC = [[InvitedRecordViewController alloc] init];
            [self.navigationController pushViewController:invitedRecordVC animated:YES];
        } else {
            MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
            myWebVC.urlStr = _dataDic[@"url_cert"];
            [self.navigationController pushViewController:myWebVC animated:YES];
        }
    } else {
        MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
        myWebVC.urlStr = _dataDic[@"url_rule"];
        [self.navigationController pushViewController:myWebVC animated:YES];
    }
}

- (void)getInviterData
{
    NSString *urlStr = [NetRequest UserInviter];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken]};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [self endLoading];
        if ([[JSON objectForKeyNotNull:@"error"] integerValue] == 0) {
            [_listArr addObject:@[@"邀请二维码", @"邀请记录", @"查看实名认证"]];
            [_listArr addObject:@[@"邀请规则"]];
            [self createHeaderViewWithTitle:JSON[@"data"][@"tips"] money:JSON[@"data"][@"total_money"]];
            _dataDic = JSON[@"data"];
            [_myTableView reloadData];
        }
    } failure:^(NSError *error) {
        [self endLoading];
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
