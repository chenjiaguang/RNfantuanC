//
//  NewsTableViewController.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/1/29.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "NewsTableViewController.h"
#import "NewsOneTableViewCell.h"
#import "NewsOnePicTableViewCell.h"
#import "NewsThreePicTableViewCell.h"
#import "NewsPicTableViewCell.h"
#import "NewsPicDetailViewController.h"
#import "RecommendAttentionViewController.h"
#import "NewsFeatureCell.h"
#import "NewProjectController.h"
#import "NewsDetailViewController.h"
static NSString *newsOneCellIdentifier = @"newsOneCellIdentifier";
static NSString *newsOnePicCellIdentifier = @"newsOnePicCellIdentifier";
static NSString *newsThreePicCellIdentifier = @"newsThreePicCellIdentifier";
static NSString *newsPicCellIdentifier = @"newsPicCellIdentifier";
static NSString *newsFeatureCellIdentifier = @"newsFeatureCellIdentifier";

@interface NewsTableViewController ()
{
    UILabel *_upDataLabel;
    MJRefreshAutoNormalFooter *_footer;
    BOOL _isEnd;
    
    UIView *_noLoginView;
    UIView *_noAttentionView;
}

@end

@implementation NewsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _total = @"";
    _pageNum = 1;
    _isUpLoading = NO;
    _listArr = [NSMutableArray array];
    [self createTableView];
    [self createUpDataView];
    [self createNoLoginView];
    [self createNoAttentionView];
    
    [self addNewsHeader];
    [self addNewsFooter];
}

- (void)reloadNewsData
{
    if (_listArr.count != 0) {
        [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    [self.myTableView.mj_header beginRefreshing];
}

- (void)createUpDataView
{
    if (!_upDataLabel) {
        _upDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0.5, kScreenW, 0)];
        _upDataLabel.backgroundColor = [MyTool colorWithString:@"1EB0FD"];
        _upDataLabel.textColor = [MyTool colorWithString:@"ffffff"];
        _upDataLabel.font = [UIFont systemFontOfSize:12];
        _upDataLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_upDataLabel];
    }
}

- (void)createNoLoginView
{
    if (!_noLoginView) {
        _noLoginView = [[UIView alloc] initWithFrame:_myTableView.frame];
        _noLoginView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_CenterX - 70, 120 * Sheight, 140, 140)];
        imageV.image = [UIImage imageNamed:@"头条未登录"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame) + 10, kScreenW, 17)];
        label.text = @"登录后才可查看关注的头条号文章哦~";
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = [MyTool colorWithString:@"333333"];
        label.textAlignment = NSTextAlignmentCenter;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kScreen_CenterX - 65, CGRectGetMaxY(label.frame)+40, 130, 40);
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.layer.cornerRadius = 3.f;
        btn.layer.borderWidth = 0.5f;
        btn.layer.borderColor = [MyTool colorWithString:@"ff3f53"].CGColor;
        [btn setTitleColor:[MyTool colorWithString:@"ff3f53"] forState:UIControlStateNormal];
        [btn setTitle:@"去登录" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pushLoginAction:) forControlEvents:UIControlEventTouchUpInside];
        [_noLoginView addSubview:btn];
        [_noLoginView addSubview:label];
        [_noLoginView addSubview:imageV];
        [self.view addSubview:_noLoginView];
        _noLoginView.hidden = YES;
    }
}

- (void)pushLoginAction:(UIButton *)btn
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *loginNaVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNaVC animated:YES completion:nil];
}

- (void)createNoAttentionView
{
    if (!_noAttentionView) {
        _noAttentionView = [[UIView alloc] initWithFrame:_myTableView.frame];
        _noAttentionView.backgroundColor = [UIColor whiteColor];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_CenterX - 60, 120 * Sheight, 120, 120)];
        imageV.image = [UIImage imageNamed:@"头条未关注"];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageV.frame) + 10, kScreenW, 14)];
        label.text = @"你还没有关注头条号哦~";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [MyTool colorWithString:@"999999"];
        label.textAlignment = NSTextAlignmentCenter;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kScreen_CenterX - 90, CGRectGetMaxY(label.frame)+30, 180, 40);
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.layer.cornerRadius = 3.f;
        btn.layer.borderWidth = 0.5f;
        btn.layer.borderColor = [MyTool colorWithString:@"1EB0FD"].CGColor;
        [btn setTitleColor:[MyTool colorWithString:@"1EB0FD"] forState:UIControlStateNormal];
        [btn setTitle:@"关注感兴趣的头条号" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pushAttentionAction:) forControlEvents:UIControlEventTouchUpInside];
        [_noAttentionView addSubview:btn];
        [_noAttentionView addSubview:label];
        [_noAttentionView addSubview:imageV];
        [_myTableView addSubview:_noAttentionView];
        _noAttentionView.hidden = YES;
    }
}

- (void)pushAttentionAction:(UIButton *)btn
{
    RecommendAttentionViewController *recommendAttentionVC = [[RecommendAttentionViewController alloc] init];
    recommendAttentionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recommendAttentionVC animated:YES];
}

- (void)createTableView
{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0.5, kScreenW, kScreenH - 64 - 49) style:UITableViewStylePlain];
    if (iPhoneX) {
        _myTableView.frame = CGRectMake(0, 0.5, kScreenW, kScreenH - 88 - 83);
    }
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (@available(iOS 11.0, *)) {
        _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:_myTableView];
    
    
    if ([_ID isEqualToString:@"-1"]) {
        UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headerBtn.frame = CGRectMake(0, 0, kScreenW, 45);
        [headerBtn setTitleColor:[MyTool colorWithString:@"333333"] forState:UIControlStateNormal];
        [headerBtn setTitle:@"关注更多头条号" forState:UIControlStateNormal];
        [headerBtn setImage:[UIImage imageNamed:@"关注更多头条号"] forState:UIControlStateNormal];
        headerBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [headerBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [headerBtn addTarget:self action:@selector(pushAttentionAction:) forControlEvents:UIControlEventTouchUpInside];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, 44.5, kScreenW - 30, 0.5)];
        line.backgroundColor = [MyTool colorWithString:@"e5e5e5"];
        [headerBtn addSubview:line];
        _myTableView.tableHeaderView = headerBtn;
    } else {
        _myTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_listArr[indexPath.row][@"type"] isEqualToString:@"1"]) {
        return [tableView cellHeightForIndexPath:indexPath model:_listArr[indexPath.row] keyPath:@"dataDic" cellClass:[NewsOnePicTableViewCell class] contentViewWidth:kScreenW];
    } else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"3"]){
        return [tableView cellHeightForIndexPath:indexPath model:_listArr[indexPath.row] keyPath:@"dataDic" cellClass:[NewsThreePicTableViewCell class] contentViewWidth:kScreenW];
    } else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"2"]){
        return [tableView cellHeightForIndexPath:indexPath model:_listArr[indexPath.row] keyPath:@"dataDic" cellClass:[NewsPicTableViewCell class] contentViewWidth:kScreenW];
    }else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"5"]){
        return [tableView cellHeightForIndexPath:indexPath model:_listArr[indexPath.row] keyPath:@"dataDic" cellClass:[NewsFeatureCell class] contentViewWidth:kScreenW];
    }
    return (kScreenW - 30) / 345 * 80 + 15;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArr.count;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == _listArr.count-5 && !_isEnd) {
        //在这个地方调用加载更多数据的方法
        [_footer beginRefreshing];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_listArr[indexPath.row][@"type"] isEqualToString:@"0"]) {
        NewsOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newsOneCellIdentifier];
        if (cell == nil) {
            cell = [[NewsOneTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:newsOneCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.headerImageV sd_setImageWithURL:[NSURL URLWithString:_listArr[indexPath.row][@"banner"][0][@"img"]] placeholderImage:[UIImage imageNamed:@"新闻单图占位图"]];
        return cell;
    } else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"1"]) {
        
        NewsOnePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newsOnePicCellIdentifier];
        if (cell == nil) {
            cell = [[NewsOnePicTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:newsOnePicCellIdentifier];
        }
        
        cell.dataDic = _listArr[indexPath.row];
        return cell;
    } else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"2"]) {
        
        NewsPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newsPicCellIdentifier];
        if (cell == nil) {
            cell = [[NewsPicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newsPicCellIdentifier];
        }
        
        cell.dataDic = _listArr[indexPath.row];
        return cell;
    } else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"5"]){
        NewsFeatureCell *cell = [tableView dequeueReusableCellWithIdentifier:newsFeatureCellIdentifier];
        if (cell == nil) {
            cell = [[NewsFeatureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newsFeatureCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataDic = _listArr[indexPath.row];
        return cell;
    } else {
        NewsThreePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newsThreePicCellIdentifier];
        if (cell == nil) {
            cell = [[NewsThreePicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newsThreePicCellIdentifier];
        }
        
        cell.dataDic = _listArr[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if ([_listArr[indexPath.row][@"type"] isEqualToString:@"2"]) {
        NewsPicDetailViewController *newsPicDetailVC = [[NewsPicDetailViewController alloc] init];
        newsPicDetailVC.article_id = _listArr[indexPath.row][@"id"];
        newsPicDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newsPicDetailVC animated:YES];
        
        NSMutableDictionary *dic = [_listArr[indexPath.row] mutableCopy];
        [dic setObject:@1 forKey:@"is_readed"];
        [_listArr replaceObjectAtIndex:indexPath.row withObject:dic];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self getReadedWithID:_listArr[indexPath.row][@"id"]];
    }else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"5"]) {
        NewProjectController *vc = [[NewProjectController alloc]init];
        vc.dataDic = _listArr[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (![_listArr[indexPath.row][@"type"] isEqualToString:@"0"]) {
        NewsDetailViewController *newsDetailVC = [[NewsDetailViewController alloc] init];
        newsDetailVC.article_id = _listArr[indexPath.row][@"id"];
        newsDetailVC.urlStr = _listArr[indexPath.row][@"article_url"];
        newsDetailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newsDetailVC animated:YES];
        
        NSMutableDictionary *dic = [_listArr[indexPath.row] mutableCopy];
        [dic setObject:@1 forKey:@"is_readed"];
        [_listArr replaceObjectAtIndex:indexPath.row withObject:dic];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self getReadedWithID:_listArr[indexPath.row][@"id"]];
    }
}

- (void)getReadedWithID:(NSString *)Id
{
    NSString *urlStr = [NetRequest NewsReaded];
    NSDictionary *paramsDic = @{@"id": Id};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
    } failure:^(NSError *error) {
    }];
}

- (void)getNewsData
{
    if ([_ID isEqualToString:@"-1"] && [[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] != YES) {
        _myTableView.hidden = YES;
        _noAttentionView.hidden = YES;
        _noLoginView.hidden = NO;
        return;
    }
    _myTableView.hidden = NO;
    _noLoginView.hidden = YES;
    NSString *urlStr = [NetRequest News];
    NSDictionary *paramsDic = @{@"cid": _ID, @"total": _total, @"pn": [NSString stringWithFormat:@"%ld", _pageNum]};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        if ([[JSON objectForKeyNotNull:@"error"] integerValue] == 0) {
            if (_isUpLoading == NO) {
                [_listArr removeAllObjects];
                _pageNum = 1;
            }
            
            _total = JSON[@"data"][@"paging"][@"total"];
            [_listArr addObjectsFromArray:[JSON[@"data"][@"list"] mutableCopy]];
            
            
            if (![JSON[@"data"][@"update_num"] isEqualToString:@"0"]) {
                [UIView animateWithDuration:0.6f animations:^{
                    _upDataLabel.text = [NSString stringWithFormat:@"范团为您推荐了%@条新内容", JSON[@"data"][@"update_num"]];
                    _upDataLabel.frame = CGRectMake(0, 0.5, kScreenW, 30);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.6f delay:2.f options:UIViewAnimationOptionTransitionNone animations:^{
                        _upDataLabel.frame = CGRectMake(0, 0.5, kScreenW, 0);
                    } completion:nil];
                }];
            }
            
            
            _noAttentionView.hidden = _listArr.count == 0 && [_ID isEqualToString:@"-1"]?NO:YES;
            _myTableView.tableHeaderView.hidden = [_ID isEqualToString:@"-1"]?NO:YES;
            
            [_myTableView reloadData];
           
            _isEnd = [JSON[@"data"][@"paging"][@"is_end"] boolValue];
            if ([JSON[@"data"][@"paging"][@"is_end"] boolValue] == YES) {
                [_myTableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [_myTableView.mj_footer endRefreshing];
            }
        }else{
            [MyTool showHUDWithStr:JSON[@"msg"]];
            [_myTableView.mj_footer endRefreshing];
        }
        [_myTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self endLoading];
        [_myTableView.mj_header endRefreshing];
        [_myTableView.mj_footer endRefreshing];
    }];
}

- (void)addNewsHeader
{
    __block NewsTableViewController *newsVC = self;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        newsVC.isUpLoading = NO;
        newsVC.pageNum = 1;
        [self getNewsData];
    }];
    
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.stateLabel.textColor = [MyTool colorWithString:@"999999"];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    header.lastUpdatedTimeLabel.textColor = [MyTool colorWithString:@"999999"];
    
    self.myTableView.mj_header = header;
    
    [self.myTableView.mj_header beginRefreshing];
}

- (void)addNewsFooter
{
    __block NewsTableViewController *newsVC = self;
    
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        newsVC.isUpLoading = YES;
        newsVC.pageNum++;
        
        [self getNewsData];
    }];
    
    [_footer setTitle:@"已经到底了~" forState:MJRefreshStateNoMoreData];
    _footer.stateLabel.textColor = [MyTool colorWithString:@"999999"];
    self.myTableView.mj_footer = _footer;
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
