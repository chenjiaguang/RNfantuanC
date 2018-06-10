//
//  NewsCollectViewController.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/3/1.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "NewsCollectViewController.h"
#import "NewsOnePicTableViewCell.h"
#import "NewsDeleteTableViewCell.h"
#import "NewsPicDetailViewController.h"

static NSString *newsOnePicCellIdentifier = @"newsOnePicCellIdentifier";
static NSString *newsDeleteCellIdentifier = @"newsDeleteCellIdentifier";

@interface NewsCollectViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIView *_nullView;
    
    NSMutableArray *_listArr;
}

@end

@implementation NewsCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的收藏";
    
    _isUpLoading = NO;
    _pageNum = 1;
    _listArr = [NSMutableArray array];
    
    [self createTableView];
    [self addHeader];
    [self addFooter];
}

- (void)createTableView
{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - (iPhoneX?88:64)) style:UITableViewStylePlain];
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    
    
    _nullView = [[UIView alloc] initWithFrame:_myTableView.frame];
    _nullView.backgroundColor = [UIColor whiteColor];
    _nullView.hidden = YES;
    [self.view addSubview:_nullView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_CenterX - 60, 120 * Sheight, 120, 120)];
    imageView.image = [UIImage imageNamed:@"文章收藏Null"];
    [_nullView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), kScreenW, 20)];
    label.textColor = [MyTool colorWithString:@"999999"];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"暂无收藏文章";
    [_nullView addSubview:label];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_listArr[indexPath.row][@"type"] isEqualToString:@"-1"]) {
        return [tableView cellHeightForIndexPath:indexPath model:_listArr[indexPath.row] keyPath:@"dataDic" cellClass:[NewsDeleteTableViewCell class] contentViewWidth:kScreenW];
    } else {
        return [tableView cellHeightForIndexPath:indexPath model:_listArr[indexPath.row] keyPath:@"dataDic" cellClass:[NewsOnePicTableViewCell class] contentViewWidth:kScreenW];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_listArr[indexPath.row][@"type"] isEqualToString:@"-1"]) {
        NewsDeleteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newsDeleteCellIdentifier];
        if (cell == nil) {
            cell = [[NewsDeleteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newsDeleteCellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.dataDic = _listArr[indexPath.row];
        cell.deleteBtn.tag = 1000 + indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    } else {
        NewsOnePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newsOnePicCellIdentifier];
        if (cell == nil) {
            cell = [[NewsOnePicTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:newsOnePicCellIdentifier];
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
    } else if (![_listArr[indexPath.row][@"type"] isEqualToString:@"0"]) {
        MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
        myWebVC.urlStr = _listArr[indexPath.row][@"article_url"];
        myWebVC.isNewsDetail = YES;
        myWebVC.title = _listArr[indexPath.row][@"news_name"];
        myWebVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myWebVC animated:YES];
    }
}

#pragma mark - 删除新闻
- (void)deleteBtnAction:(UIButton *)btn
{
    [self getDeleteNewsDataWithID:_listArr[btn.tag - 1000][@"id"]];
    [_listArr removeObjectAtIndex:btn.tag - 1000];
    [_myTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)getDeleteNewsDataWithID:(NSString *)article_id
{
    NSString *urlStr = [NetRequest NewsCollect];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"article_id":article_id, @"collect": @"0"};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
    } failure:^(NSError *error) {
    }];
}

- (void)getListData:(NSInteger)page
{
    NSString *urlStr = [NetRequest UserCollectList];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"pn":[NSString stringWithFormat:@"%ld", page]};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        if ([[JSON objectForKeyNotNull:@"error"] integerValue] == 0) {
            if (!_isUpLoading) {
                [_listArr removeAllObjects];
                _pageNum = 1;
            }
            _listArr = [[_listArr arrayByAddingObjectsFromArray:JSON[@"data"][@"list"]] mutableCopy];
            [_myTableView reloadData];
            [_myTableView.mj_footer endRefreshing];
            [_myTableView.mj_header endRefreshing];
            [JSON[@"data"][@"paging"][@"is_end"] intValue] == 1 ?[_myTableView.mj_footer endRefreshingWithNoMoreData]:[_myTableView.mj_footer resetNoMoreData];
            
            _listArr.count == 0 ? [_nullView setHidden:NO] : [_nullView setHidden:YES];
        }
    } failure:^(NSError *error) {
        [_myTableView.mj_header endRefreshing];
        [_myTableView.mj_footer endRefreshingWithNoMoreData];
    }];
    
}

- (void)addHeader
{
    __block NewsCollectViewController *newsCollectVC = self;
    
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        newsCollectVC.isUpLoading = NO;
        newsCollectVC.pageNum = 1;
        [self getListData:newsCollectVC.pageNum];
    }];
    
    [self.myTableView.mj_header beginRefreshing];
}

- (void)addFooter
{
    __block NewsCollectViewController *newsCollectVC = self;
    
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        newsCollectVC.isUpLoading = YES;
        newsCollectVC.pageNum++;
        
        [self getListData:newsCollectVC.pageNum];
        
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
