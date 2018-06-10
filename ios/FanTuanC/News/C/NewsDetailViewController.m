//
//  NewsDetailViewController.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/5/21.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NewsDetailLikeTableViewCell.h"
#import "NewsDetailRecommendTableViewCell.h"
#import "NewsDetailCommentTableViewCell.h"

@interface NewsDetailViewController () <UIWebViewDelegate, UITableViewDelegate, UITableViewDataSource>

@end

@implementation NewsDetailViewController
{
    UITableView *_myTableView;
    UIWebView *_myWebView;
    
    BOOL _isFirst;
    NSInteger _pageNum;
    NSMutableArray *_recommendArr;
    NSMutableArray *_commentArr;
    NSMutableDictionary *_dataDic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _isFirst = YES;
    _pageNum = 1;
    _recommendArr = [NSMutableArray array];
    _commentArr = [NSMutableArray array];
    _dataDic = [NSMutableDictionary dictionary];
    
    [self createTableView];
    [self createHeaderView];
    
    [self getListData];
}

- (void)createHeaderView
{
    _myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0)];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://mp.weixin.qq.com/s?__biz=MzA4NDI3NjcyNA==&mid=2649395420&idx=1&sn=f1092e82ac58909d64628084e00b8a7f&chksm=87f79447b0801d513d6a2ffad1e74bd4fab891d1544818e8026fb701de1a276785cd8c3e8675&scene=27#wechat_redirect"] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    [_myWebView loadRequest:urlRequest];
    _myWebView.delegate = self;
    UIScrollView *first_tempView  = (UIScrollView *)[_myWebView.subviews objectAtIndex:0];
    first_tempView.scrollEnabled = NO;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = webView.frame;
    frame.size.height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] floatValue];
    webView.frame = frame;
    _myTableView.tableHeaderView = webView;
}

- (void)createTableView
{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-(iPhoneX?88:64)-50) style:UITableViewStyleGrouped];
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
    
    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _isFirst?0:3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return _recommendArr.count;
    } else if (section == 2) {
        return _commentArr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 98;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 98)];
    bgView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 50, kScreenW-30, 18)];
    titleLabel.textColor = [MyTool colorWithString:@"333333"];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    if (section == 1) {
        titleLabel.text = @"推荐阅读";
    } else if (section == 2) {
        titleLabel.text = @"热门评论";
    }
    [bgView addSubview:titleLabel];
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return [tableView cellHeightForIndexPath:indexPath model:_recommendArr[indexPath.row] keyPath:@"dataDic" cellClass:[NewsDetailRecommendTableViewCell class] contentViewWidth:kScreenW];
    } else if (indexPath.section == 2) {
        return [tableView cellHeightForIndexPath:indexPath model:_commentArr[indexPath.row] keyPath:@"dataDic" cellClass:[NewsDetailCommentTableViewCell class] contentViewWidth:kScreenW];
    }
    return 244;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NewsDetailLikeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsDetailLikeTableViewCell"];
        if (cell == nil) {
            cell = [[NewsDetailLikeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NewsDetailLikeTableViewCell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataDic = _dataDic;
        return cell;
    } else if (indexPath.section == 1) {
        NewsDetailRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsDetailRecommendTableViewCell"];
        if (cell == nil) {
            cell = [[NewsDetailRecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NewsDetailRecommendTableViewCell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataDic = _recommendArr[indexPath.row];
        cell.line.hidden = _recommendArr.count-1 == indexPath.row ?YES:NO;
        return cell;
    } else if (indexPath.section == 2) {
        NewsDetailCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsDetailCommentTableViewCell"];
        if (cell == nil) {
            cell = [[NewsDetailCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NewsDetailCommentTableViewCell"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dataDic = _commentArr[indexPath.row];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"tableViewCell"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NewsDetailViewController *newsDetailVC = [[NewsDetailViewController alloc] init];
        newsDetailVC.article_id = _recommendArr[indexPath.row][@"id"];
        newsDetailVC.urlStr = _recommendArr[indexPath.row][@"article_url"];
        [self.navigationController pushViewController:newsDetailVC animated:YES];
    }
}


- (void)getListData
{
    NSString *urlStr = [NetRequest NewsTextDetail];
    NSDictionary *paramsDic = @{@"id": _article_id, @"pn": [NSString stringWithFormat:@"%ld", _pageNum]};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        if ([JSON[@"error"] integerValue] == 0) {
            _isFirst = NO;
            
            _recommendArr = [JSON[@"data"][@"recommends"] mutableCopy];
            _dataDic = [JSON[@"data"][@"article"] mutableCopy];
            [_commentArr addObjectsFromArray:[JSON[@"data"][@"list"] mutableCopy]];
            [_myTableView reloadData];
        }
    } failure:^(NSError *error) {
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
