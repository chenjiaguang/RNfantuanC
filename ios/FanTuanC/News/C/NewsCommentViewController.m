//
//  NewsCommentViewController.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/3/29.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "NewsCommentViewController.h"
#import "NewsCommentTableViewCell.h"
#import "NewsCommentDetailViewController.h"

@interface NewsCommentViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    NSMutableArray *_listArr;
}
@property (nonatomic, strong) UIView *textBgView;
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, assign) NSInteger pn;

@end

@implementation NewsCommentViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"评论";
    
    _listArr = [NSMutableArray array];
    _pn = 1;
    [self createTableView];
    [self createBottomView];
    [self createTextView];
    
    [self loadingWithText:@"加载中"];
    [self getNewsDetailComment];
}

- (void)createBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_myTableView.frame), kScreenW, 50)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreenW - 30, 30)];
    label.backgroundColor = [MyTool colorWithString:@"F1F1F1"];
    label.text = @"  发表一下高见吧~";
    label.textColor = [MyTool colorWithString:@"C5C5C5"];
    label.font = [UIFont systemFontOfSize:15];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 8.f;
    [bottomView addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.5)];
    line.backgroundColor = [MyTool colorWithString:@"CBCBCB"];
    [bottomView addSubview:line];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBottomViewAction:)];
    [bottomView addGestureRecognizer:tap];
}

- (void)tapBottomViewAction:(UITapGestureRecognizer *)tap
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] != YES) {
        [self pushLoginVC];
    } else {
        [_textView becomeFirstResponder];
    }
}

- (void)createTableView
{
    CGFloat navH = iPhoneX?88:64;
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - navH - 50) style:UITableViewStylePlain];
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
    
    WeakSelf(weakSelf);
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pn += 1;
        [weakSelf getNewsDetailComment];
    }];
    
    [footer setTitle:@"已经到底了~" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = [MyTool colorWithString:@"999999"];
    _myTableView.mj_footer = footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:kScreenW tableView:_myTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCommentTableViewCell"];
    if (cell == nil) {
        cell = [[NewsCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"NewsCommentTableViewCell"];
    }
    
    cell.dataDic = _listArr[indexPath.row];
    cell.likeBtn.tag = 1000+indexPath.row;
    [cell.likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - 点赞
- (void)likeBtnAction:(UIButton *)btn
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] != YES) {
        [self pushLoginVC];
    } else {
        NSInteger index = btn.tag - 1000;
        NSMutableDictionary *dic = [_listArr[index] mutableCopy];
        [dic setObject:[NSString stringWithFormat:@"%d", ![dic[@"is_like"] boolValue]] forKey:@"is_like"];
        [dic setObject:[NSString stringWithFormat:@"%ld", [dic[@"is_like"] boolValue] ? [dic[@"like_num"] integerValue] + 1 : [dic[@"like_num"] integerValue] - 1] forKey:@"like_num"];
        [_listArr replaceObjectAtIndex:index withObject:dic];
        [_myTableView reloadData];
        [self getNewsCommentLikeWithComment_id:_listArr[index][@"id"] like:[_listArr[index][@"is_like"] boolValue]];
    }
}

#pragma mark - 删除
- (void)deleteBtnAction:(UIButton *)btn
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"确认删除该评论？"      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self getNewsCommentDeleteWithIndex:btn.tag - 2000];
    }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [[MyTool topViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewsCommentDetailViewController * newsCommentDetailVC = [[NewsCommentDetailViewController alloc] init];
    newsCommentDetailVC.comment_id = _listArr[indexPath.row][@"id"];
    [self.navigationController pushViewController:newsCommentDetailVC animated:YES];
}

- (void)createTextView
{
    UIView *maskView = [[UIView alloc]initWithFrame:CGRectZero];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];;
    maskView.hidden = YES;
    maskView.tag = 5000;
    [ApplicationDelegate.window addSubview:maskView];
    maskView.userInteractionEnabled = YES;
    UITapGestureRecognizer *maskViewTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewTap)];
    [maskView addGestureRecognizer:maskViewTap];
    maskViewTap.delegate = self;
    _maskView = maskView;
    
    UIView *textBgView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, 121)];
    textBgView.backgroundColor = [UIColor whiteColor];
    textBgView.hidden = YES;
    [maskView addSubview:textBgView];
    _textBgView = textBgView;
    UIView *textBgLineView = [[UIView alloc]initWithFrame:CGRectZero];
    textBgLineView.backgroundColor = [MyTool colorWithString:@"e5e5e5"];
    [textBgView addSubview:textBgLineView];
    
    YYTextView *textView = [[YYTextView alloc]initWithFrame:CGRectZero];
    textView.font = [UIFont systemFontOfSize:14];
    textView.backgroundColor = [MyTool colorWithString:@"f1f1f1"];
    textView.placeholderText = [NSString stringWithFormat:@"发表一下高见吧~"];
    textView.placeholderFont = [UIFont systemFontOfSize:14];
    textView.placeholderTextColor = [MyTool colorWithString:@"999999"];
    [textBgView addSubview:textView];
    _textView = textView;
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitleColor:[MyTool colorWithString:@"333333"] forState:UIControlStateNormal];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchDown];
    [textBgView addSubview:sendBtn];
    
    
    maskView.sd_layout
    .topSpaceToView(ApplicationDelegate.window, 0)
    .leftSpaceToView(ApplicationDelegate.window, 0)
    .rightSpaceToView(ApplicationDelegate.window, 0)
    .bottomSpaceToView(ApplicationDelegate.window, 0);
    
    textBgLineView.sd_layout
    .topSpaceToView(textBgView, 0)
    .leftSpaceToView(textBgView, 0)
    .rightSpaceToView(textBgView, 0)
    .heightIs(0.5);
    
    textView.sd_cornerRadius = @(5);
    textView.sd_layout
    .topSpaceToView(textBgView, 10)
    .leftSpaceToView(textBgView, 15)
    .rightSpaceToView(textBgView, 68)
    .bottomSpaceToView(textBgView, 9.9);
    
    sendBtn.sd_layout
    .topSpaceToView(textBgView, 0)
    .leftSpaceToView(textView, 0)
    .rightSpaceToView(textBgView, 0)
    .bottomSpaceToView(textBgView, 0);
}

-(void)maskViewTap
{
    _textBgView.frame = CGRectMake(0, kScreenH , kScreenW, 121);
    _maskView.hidden = YES;
    [_textView resignFirstResponder];
}

-(void)sendAction:(UIButton *)btn
{
    if (_textView.text.length == 0) {
        [MyTool showHUDWithStr:@"评论不能为空哦~"];
        return;
    }
    [self getNewsCommentIssue];
}

- (void)getNewsCommentIssue
{
    [self loadingWithText:@"加载中"];
    NSString *urlStr = [NetRequest NewsCommentIssue];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"article_id": _article_id, @"content": _textView.text};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [self endLoading];
        if ([JSON[@"error"] integerValue] == 0) {
            [self maskViewTap];
            _textView.text = @"";
            _pn = 1;
            [self getNewsDetailComment];
        }
    } failure:^(NSError *error) {
        [self endLoading];
    }];
}


- (void)getNewsDetailComment
{
    NSString *urlStr = [NetRequest NewsDetailComment];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] == YES ? [[NSUserDefaults standardUserDefaults] objectForKey:kToken] : @"", @"article_id": _article_id, @"pn": [NSString stringWithFormat:@"%ld", _pn]};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [self endLoading];
        if ([JSON[@"error"] integerValue] == 0) {
            if (_pn == 1) {
                [_listArr removeAllObjects];
            }
            [_listArr addObjectsFromArray:[JSON[@"data"][@"list"] mutableCopy]];
            
            [_myTableView reloadData];
            
            if ([JSON[@"data"][@"paging"][@"is_end"] boolValue] == YES) {
                [_myTableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [_myTableView.mj_footer endRefreshing];
            }
            
            if (_pn==1 && _listArr.count != 0) {
                NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
                [_myTableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
    } failure:^(NSError *error) {
        [self endLoading];
    }];
}

- (void)getNewsCommentLikeWithComment_id:(NSString *)comment_id like:(BOOL)like
{
    NSString *urlStr = [NetRequest NewsCommentLike];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"comment_id": comment_id, @"like":[NSString stringWithFormat:@"%d", like]};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
    } failure:^(NSError *error) {
    }];
}

- (void)getNewsCommentDeleteWithIndex:(NSInteger)index
{
    NSString *urlStr = [NetRequest NewsCommentDelete];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"comment_id":_listArr[index][@"id"]};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [self endLoading];
        [MyTool showHUDWithStr:JSON[@"msg"]];
        [_listArr removeObjectAtIndex:index];
        [_myTableView reloadData];
    } failure:^(NSError *error) {
        [self endLoading];
    }];
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    _maskView.hidden = NO;
    _textBgView.hidden = NO;
    
    _textBgView.frame = CGRectMake(0, kScreenH - height - 121, kScreenW, 121);
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    _textBgView.frame = CGRectMake(0, kScreenH , kScreenW, 121);
    _textBgView.hidden = YES;
    _maskView.hidden = YES;
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
