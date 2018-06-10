//
//  MyViewController.m
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/3.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "MyViewController.h"
#import "UITabBar+Badge.h"
#import "HongBaoView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "BadgeBarButtonItem.h"
#import "MyCardViewController.h"
#import "NewsCollectViewController.h"
#import "MyFriendViewController.h"
#import "HeaderBtnView.h"
@interface MyViewController ()
{
    UIView *_headerView;
    UIImageView *_headerImageView;
    UILabel *_nameLabel;
    UIImageView *_tagImageV;
    NSMutableDictionary *_userDic;
    
    HeaderBtnView *_dynamicBtn;
    HeaderBtnView *_concernBtn;
    HeaderBtnView *_fansBtn;
    
    NSString *_toutiao_apply_url;
}

@end

@implementation MyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//    self.navigationController.navigationBar.translucent = YES;
    
    [self getMyData];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    
    [self createTableView];
    [self createHeaderView];
    
    [self loadingWithText:@"加载中"];
    [self getMyData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMyData) name:reloadMyListData object:nil];
}

- (void)initData
{
    _userDic = [NSMutableDictionary dictionary];
    _listArr = [NSMutableArray arrayWithArray:@[@"我的收藏", @"申请成为头条号", @"设置", @"关于范团"]];
    _toutiao_apply_url = @"";
}

- (void)createHeaderView
{
    _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _headerImageView.image = [UIImage imageNamed:@"默认头像"];
    _headerImageView.userInteractionEnabled = YES;
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.clipsToBounds = YES;
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_headerView addSubview:_headerImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerViewTapAction:)];
    [_headerImageView addGestureRecognizer:tap];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _nameLabel.textColor = [MyTool colorWithString:@"333333"];
    _nameLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:23];
    [_headerView addSubview:_nameLabel];
    
    _tagImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    _tagImageV.image = [UIImage imageNamed:@"头条作者标签"];
    _tagImageV.hidden = YES;
    [_headerView addSubview:_tagImageV];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor = [[MyTool colorWithString:@"D8D8D8"] colorWithAlphaComponent:0.3];
    [_headerView addSubview:line];
    
    _dynamicBtn = [[HeaderBtnView alloc] initWithFrame:CGRectZero];
    _dynamicBtn.nameLabel.text = @"动态";
    _dynamicBtn.numLabel.text = @"0";
    [_dynamicBtn.tap addTarget:self action:@selector(dynamicBtnAction:)];
    [_headerView addSubview:_dynamicBtn];
    
    _concernBtn = [[HeaderBtnView alloc] initWithFrame:CGRectZero];
    _concernBtn.nameLabel.text = @"关注";
    _concernBtn.numLabel.text = @"0";
    [_concernBtn.tap addTarget:self action:@selector(concernBtnAction:)];
    [_headerView addSubview:_concernBtn];
    
    _fansBtn = [[HeaderBtnView alloc] initWithFrame:CGRectZero];
    _fansBtn.nameLabel.text = @"粉丝";
    _fansBtn.numLabel.text = @"0";
    [_fansBtn.tap addTarget:self action:@selector(fansBtnAction:)];
    [_headerView addSubview:_fansBtn];
    
    
    
    _headerView.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .heightIs(143);
    _myTableView.tableHeaderView = _headerView;
    
    _headerImageView.sd_layout
    .xIs(15)
    .yIs(0)
    .widthIs(60)
    .heightEqualToWidth();
    _headerImageView.sd_cornerRadius = @30;
    
    _nameLabel.sd_layout
    .leftSpaceToView(_headerImageView, 20)
    .centerYEqualToView(_headerImageView)
    .heightIs(23);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:kScreenW-110];
    
    _tagImageV.sd_layout
    .leftSpaceToView(_headerImageView, 20)
    .topSpaceToView(_nameLabel, 10)
    .heightIs(16)
    .widthIs(54);
    
    line.sd_layout
    .leftSpaceToView(_headerView, 0)
    .rightSpaceToView(_headerView, 0)
    .bottomEqualToView(_headerView)
    .heightIs(5);
    
    _dynamicBtn.sd_layout
    .leftSpaceToView(_headerView, 15)
    .topSpaceToView(_headerImageView, 20)
    .bottomSpaceToView(line, 0)
    .widthIs(55);
    
    _concernBtn.sd_layout
    .leftSpaceToView(_dynamicBtn, 0)
    .topSpaceToView(_headerImageView, 20)
    .bottomSpaceToView(line, 0)
    .widthIs(55);
    
    _fansBtn.sd_layout
    .leftSpaceToView(_concernBtn, 0)
    .topSpaceToView(_headerImageView, 20)
    .bottomSpaceToView(line, 0)
    .widthIs(55);
    
}


#pragma mark - 点击头像
- (void)headerViewTapAction:(UITapGestureRecognizer *)tap
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] != YES) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        UINavigationController *loginNaVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:loginNaVC animated:YES completion:nil];
    }
}

- (void)createTableView
{
    CGFloat tableViewH = iPhoneX?kScreenH-88-83:kScreenH-64-49;
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, tableViewH) style:UITableViewStylePlain];
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.showsVerticalScrollIndicator = NO;
    _myTableView.bounces = NO;
    [self.view addSubview:_myTableView];
}

#pragma mark - 动态按钮
- (void)dynamicBtnAction:(UITapGestureRecognizer *)btn
{
    MyCardViewController *myCardVC = [[MyCardViewController alloc] init];
    myCardVC.hidesBottomBarWhenPushed = YES;
    myCardVC.titleStr = _nameLabel.text;
    myCardVC.uid = _userDic[@"id"];
    myCardVC.type = 1;
    myCardVC.isNews = [_userDic[@"is_news"] boolValue];
    [self.navigationController pushViewController:myCardVC animated:YES];
}

#pragma mark - 关注按钮
- (void)concernBtnAction:(UITapGestureRecognizer *)btn
{
    MyFriendViewController *friendVC = [[MyFriendViewController alloc] init];
    friendVC.hidesBottomBarWhenPushed = YES;
    friendVC.index = 1;
    [self.navigationController pushViewController:friendVC animated:YES];
}

#pragma mark - 粉丝按钮
- (void)fansBtnAction:(UITapGestureRecognizer *)btn
{
    MyFriendViewController *friendVC = [[MyFriendViewController alloc] init];
    friendVC.hidesBottomBarWhenPushed = YES;
    friendVC.index = 2;
    [self.navigationController pushViewController:friendVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"myListCell";
    MyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MyListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.myImgaeV.image = [UIImage imageNamed:_listArr[indexPath.row]];
    cell.titleLabel.text = _listArr[indexPath.row];
    cell.numLabel.hidden = YES;
    
    cell.contentLabel.hidden = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_listArr[indexPath.row] isEqualToString:@"我的收藏"]) {
        NewsCollectViewController *newsCollectVC = [[NewsCollectViewController alloc] init];
        newsCollectVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newsCollectVC animated:YES];
    } else if ([_listArr[indexPath.row] isEqualToString:@"申请成为头条号"]) {
        MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
        myWebVC.urlStr = _toutiao_apply_url;
        myWebVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myWebVC animated:YES];
    } else if ([_listArr[indexPath.row] isEqualToString:@"设置"]) {
        SettingViewController *settingVC = [[SettingViewController alloc] init];
        settingVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:settingVC animated:YES];
    } else if ([_listArr[indexPath.row] isEqualToString:@"关于范团"]) {
        AboutUsViewController *aboutUSVC = [[AboutUsViewController alloc] init];
        aboutUSVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aboutUSVC animated:YES];
    }
}


- (void)getMyData
{
    NSString *urlStr = [NetRequest UserProfile];
    NSDictionary *paramsDic = @{};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        
        if ([[JSON objectForKeyNotNull:@"error"] integerValue] == 0) {
            
            _userDic = JSON[@"data"];
            
            _nameLabel.text = JSON[@"data"][@"username"];
            [_headerImageView sd_setImageWithURL:[NSURL URLWithString:JSON[@"data"][@"avatar"]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
            _fansBtn.has_new_fans = [JSON[@"data"][@"has_new_fans"] boolValue];
            
            _dynamicBtn.numLabel.text = JSON[@"data"][@"dynamic_num"];
            _concernBtn.numLabel.text = JSON[@"data"][@"follow_num"];
            _fansBtn.numLabel.text = JSON[@"data"][@"fans_num"];
            
            
            _toutiao_apply_url = JSON[@"data"][@"toutiao_apply_url"];
            
            if ([JSON[@"data"][@"is_news"] boolValue] == YES) {
                [_listArr removeObject:@"申请成为头条号"];
                [_nameLabel sd_resetLayout];
                _nameLabel.sd_layout
                .leftSpaceToView(_headerImageView, 20)
                .heightIs(23)
                .yIs(6);
                _tagImageV.hidden = NO;
                [_tagImageV updateLayout];
            }
            
            [_myTableView reloadData];
        }
        [self endLoading];
    } failure:^(NSError *error) {
        [self endLoading];
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:reloadMyListData object:nil];
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
