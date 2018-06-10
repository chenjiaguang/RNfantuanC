//
//  AboutUsViewController.m
//  FanTuanSJ
//
//  Created by 冫柒Yun on 2017/8/30.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "AboutUsViewController.h"
#import "PersonalInforTableViewCell.h"

@interface AboutUsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    NSMutableArray *_listArr;
}

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"关于范团";
    _listArr = @[@{@"titleName": @"用户协议", @"detail":@""}, @{@"titleName": @"社区协议", @"detail":@""}, @{@"titleName": @"作者协议", @"detail":@""}].mutableCopy;
    [self createTableView];
}

- (void)createTableView
{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64) style:UITableViewStylePlain];
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.showsVerticalScrollIndicator = NO;
    _myTableView.bounces = YES;
    if (@available(iOS 11.0, *)) {
        _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:_myTableView];
    
    [self createHeaderView];
    [self createFooterView];
}

- (void)createHeaderView
{
    UIView *headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 206)];
    headerBgView.backgroundColor = [UIColor whiteColor];
    _myTableView.tableHeaderView = headerBgView;
    
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenW - 80) / 2, 30, 80, 113)];
    logoImage.image = [UIImage imageNamed:@"关于我们logo"];
    [headerBgView addSubview:logoImage];
    
    UILabel *versionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logoImage.frame) + 12, kScreenW, 16)];
    versionsLabel.text = [NSString stringWithFormat:@"version %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    versionsLabel.textColor = [MyTool colorWithString:@"999999"];
    versionsLabel.textAlignment = NSTextAlignmentCenter;
    versionsLabel.font = [UIFont systemFontOfSize:16];
    [headerBgView addSubview:versionsLabel];
}

- (void)createFooterView
{
    UIView *foodView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
    foodView.backgroundColor = [UIColor whiteColor];
    _myTableView.tableFooterView = foodView;
    
    UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneTapAction:)];
    [foodView addGestureRecognizer:phoneTap];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 60)];
    label.text = @"客服电话";
    label.textColor = [MyTool colorWithString:@"333333"];
    label.font = [UIFont systemFontOfSize:15];
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - 120 - 15, 0, 120, 60)];
    phoneLabel.text = @"400-3663-2552";
    phoneLabel.textColor = [MyTool colorWithString:@"999999"];
    phoneLabel.font = [UIFont systemFontOfSize:15];
    phoneLabel.textAlignment = NSTextAlignmentRight;
    [foodView addSubview:label];
    [foodView addSubview:phoneLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 59.5, kScreenW-30, 0.5)];
    line.backgroundColor = [MyTool colorWithString:@"E1E1E1"];
    [foodView addSubview:line];
}

#pragma mark - 拨打客服电话
- (void)phoneTapAction:(UITapGestureRecognizer *)tap
{
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:400-3663-2552"]]];
    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath model:_listArr[indexPath.row] keyPath:@"dataDic" cellClass:[PersonalInforTableViewCell class] contentViewWidth:kScreenW];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"PersonalInforTableViewCell";
    PersonalInforTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[PersonalInforTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.dataDic = _listArr[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
