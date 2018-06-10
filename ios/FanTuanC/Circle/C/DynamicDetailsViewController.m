//
//  DynamicDetailsViewController.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/3/1.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "DynamicDetailsViewController.h"
#import "CircleCellContentView.h"
#import "AllPraiseCell.h"
#import "CircleCommentsCell.h"
#import "CardNullTableViewCell.h"
#import "ReleaseDynamicViewController.h"

@interface DynamicDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,CircleCommentsCellDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *tableDataArr;
@property (nonatomic, strong) NSMutableArray *allPraiseArr;
@property (nonatomic, strong) UIView *textBgView;
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) CircleModel *model;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) CircleCellContentView *hederView;
@property (nonatomic, strong) UIButton *praisebnt;
@property (nonatomic, strong) ListModel *replyModel;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIBarButtonItem * rightItem;
@end

@implementation DynamicDetailsViewController

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
    self.navigationItem.title = @"动态详情";
    UIScrollView *scView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.view = scView;

    [self createUI];
}

-(void)createUI
{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_myTableView];
    _myTableView.sd_layout
    .topSpaceToView(self.view, 0)
    .leftSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 50)
    .rightSpaceToView(self.view, 0);
    _hederView = [[CircleCellContentView alloc]initWithFrame:CGRectZero];
    _hederView.width = [UIScreen mainScreen].bounds.size.width;
    _hederView.height = 300;
//    [_hederView setupAutoHeightWithBottomView:_hederView.sourceLabel bottomMargin:15];
    _myTableView.tableHeaderView = _hederView;
    _tableDataArr = [NSMutableArray array];
    _page = 1;
    WeakSelf(weakSelf);
    _myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page = weakSelf.page + 1;
        [weakSelf getDataIsDown:NO isPraise:NO];
    }];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftBtn.backgroundColor = [UIColor orangeColor];
    [rightBtn setImage:[UIImage imageNamed:@"circleDot"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(moreCircle) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn sizeToFit];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    _rightItem = rightItem;
    

    UIView *replyBgView = [[UIView alloc]initWithFrame:CGRectZero];
    replyBgView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickReply:)];
    [replyBgView addGestureRecognizer:singleTap];
    
    UIImageView *replyLogoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"replyIcon"]];
    
    UILabel *replyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    replyLabel.font = [UIFont systemFontOfSize:16];
    replyLabel.textColor = [MyTool colorWithString:@"999999"];
    replyLabel.text = @"评论动态";
    
    UIButton *praisebnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [praisebnt setTitleColor:[MyTool colorWithString:@"999999"] forState:UIControlStateNormal];
//    [praisebnt setTitle:@"999+" forState:UIControlStateNormal];
    praisebnt.titleLabel.font = [UIFont systemFontOfSize:14];
    [praisebnt setImage:[UIImage imageNamed:@"praiseIconOff"] forState:UIControlStateNormal];
    [praisebnt setImage:[UIImage imageNamed:@"praiseIconOn"] forState:UIControlStateSelected];
    [praisebnt addTarget:self action:@selector(clickPraisecWith:) forControlEvents:UIControlEventTouchDown];
    _praisebnt = praisebnt;
    [self.view addSubview:replyBgView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = [MyTool colorWithString:@"e5e5e5"];
    [replyBgView sd_addSubviews:@[replyLogoView,replyLabel,praisebnt,lineView]];
    
    
    replyBgView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .heightIs(50);
    
    lineView.sd_layout
    .leftSpaceToView(replyBgView, 0)
    .rightSpaceToView(replyBgView, 0)
    .topSpaceToView(replyBgView, 0)
    .heightIs(0.5);
    
    replyLogoView.sd_layout
    .leftSpaceToView(replyBgView, 15)
    .topSpaceToView(replyBgView, 13)
    .widthIs(24)
    .heightEqualToWidth();
    
    [replyLabel setSingleLineAutoResizeWithMaxWidth:kScreenW-15 -24 -11 ];
    replyLabel.sd_layout
    .leftSpaceToView(replyLogoView, 11)
    .centerYEqualToView(replyLogoView)
    .heightIs(16);

    praisebnt.sd_layout
    .rightSpaceToView(replyBgView, 15)
    .topSpaceToView(replyBgView, 13)
    .widthIs(67)
    .heightIs(24.5);

    UIView *maskView = [[UIView alloc]initWithFrame:CGRectZero];
    maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7f];
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
    textView.font = [UIFont systemFontOfSize:17];
    textView.backgroundColor = [MyTool colorWithString:@"f1f1f1"];
    [textBgView addSubview:textView];
    _textView = textView;
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitleColor:[MyTool colorWithString:@"333333"] forState:UIControlStateNormal];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchDown];
    [textBgView addSubview:sendBtn];

//    textBgView.sd_layout
//    .leftSpaceToView(self.view, 0)
//    .rightSpaceToView(self.view, 0)
//    .bottomSpaceToView(self.view, 0)
//    .heightIs(0);
    
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
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_textBgView]) {
        return NO;
    }
    return YES;
}
-(void)setCircleID:(NSString *)circleID
{
    _circleID = circleID;
    [self loadingWithText:@"加载中"];
    [self getDataIsDown:YES isPraise:NO];
}
-(void)sendAction:(UIButton *)btn
{
    if (_textView.text.length == 0) {
        [MyTool showHUDWithStr:@"评论不能为空哦~"];
        return;
    }
    [self replyDynamic];
}
-(void)getDataIsDown:(BOOL)down isPraise:(BOOL)isPraise
{
//    [self loadingWithText:@"加载中"];
    NSString *urlStr = [NetRequest DynamicDetail];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] == YES ? [[NSUserDefaults standardUserDefaults] objectForKey:kToken] : @"", @"id": _circleID, @"pn":[NSString stringWithFormat:@"%ld",_page]};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        _model = [CircleModel yy_modelWithJSON:JSON];
        if ([_model.error integerValue] == 0) {
            if(isPraise){
                _allPraiseArr = _model.data.like_list.mutableCopy;
                [_praisebnt setTitle:_model.data.like_num forState:UIControlStateNormal];
            }else{
                if(!_model.data.is_owner ){
//                    self.navigationItem.rightBarButtonItem = nil;

//                    self.navigationItem.rightBarButtonItem = _rightItem;
                }
                _hederView.model = _model.data;
                _allPraiseArr = _model.data.like_list.mutableCopy;
                [_praisebnt setTitle:_model.data.like_num forState:UIControlStateNormal];
                _tableDataArr = [[_tableDataArr arrayByAddingObjectsFromArray:_model.data.comment_list] mutableCopy];
                _praisebnt.selected = _model.data.has_like;
                _hederView.height = [self calculateCellHeight:_model.data];
                [_myTableView.mj_header endRefreshing];
                _model.data.paging.is_end  == YES?[_myTableView.mj_footer endRefreshingWithNoMoreData]:[_myTableView.mj_footer endRefreshing];
            }
            [_myTableView reloadData];

            
        }else{
            [MyTool showHUDWithStr:[NSString stringWithFormat:@"%@",JSON[@"msg"]]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [self endLoading];
    } failure:^(NSError *error) {
        [self endLoading];
        [_myTableView.mj_header endRefreshing];
        [_myTableView.mj_footer endRefreshing];
    }];
}

-(void)replyDynamic
{
    [self loadingWithText:@"评论中"];
    NSString *urlStr = [NetRequest ReplyDynamic];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"dy_id": _circleID, @"to_uid":_replyModel?_replyModel.uid:@"",@"content":_textView.text};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [self endLoading];
        if ([JSON[@"error"] integerValue] == 0) {
            _page = 1;
            [_tableDataArr removeAllObjects];
            [_textView resignFirstResponder];
            _maskView.hidden = YES;
            [self getDataIsDown:YES isPraise:NO];
            _textView.text = nil;
        }
//        [MyTool showHUDWithStr:[NSString stringWithFormat:@"%@",JSON[@"msg"]]];

    } failure:^(NSError *error) {
        [self endLoading];
    }];
}
-(void)clickPraisecWith:(UIButton *)btn
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] != YES)
    {
        [self pushLoginVC];
    } else {
//        [self loadingWithText:@"加载中"];
        NSString *urlStr = [NetRequest DynamicLike];
        NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"dy_id": _circleID,@"like":[NSString stringWithFormat:@"%d",!_model.data.has_like]};
        [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
//            [self endLoading];
            if ([JSON[@"error"] integerValue] == 0) {
                btn.selected = !btn.selected;
                [self getDataIsDown:NO isPraise:YES];
                [MyTool showHUDWithStr:[NSString stringWithFormat:@"%@",JSON[@"msg"]]];
            }
            
        } failure:^(NSError *error) {
            [self endLoading];
        }];
    }
}
#pragma mark -- tableViewDelegate  &&  tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1:_tableDataArr.count == 0?1:_tableDataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(_allPraiseArr.count == 0){
            return 40;
        }
        //计算不同机型最多一行多少个头像
        int w = (kScreenW - 30 - 10) / 30.0;
        float h = ceilf((CGFloat)_allPraiseArr.count/(CGFloat)w == 0?1:(CGFloat)_allPraiseArr.count/(CGFloat)w ) * 35 + 15;
        return h;
    }else{
        if (_tableDataArr.count == 0) {
            return 220;
        }
        return [self.myTableView cellHeightForIndexPath:indexPath cellContentViewWidth:kScreenW tableView:_myTableView];
//        ListModel *model = [ListModel yy_modelWithJSON:_tableDataArr[indexPath.row]];
//        return [self.myTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[CircleCommentsCell class] contentViewWidth:kScreenW];
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 38;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenW, 18)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, kScreenW - 30, 18)];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [bgView addSubview:label];
    if(section == 0){
        label.text = [NSString stringWithFormat:@"%ld人点赞",_allPraiseArr.count];
    }else{
        label.text = [_model.data.comment_num intValue] >0? [NSString stringWithFormat:@"%@条评论",_model.data.comment_num]:@"暂无评论";
    }
    return bgView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HomePageListTableViewCell";
    static NSString *cellIdentifier2 = @"CircleCommentsCell";
    static NSString *cellIdentifier3 = @"CardNullTableViewCell";

    if (indexPath.section == 0) {
        AllPraiseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[AllPraiseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        cell.list = _model.data.like_list;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        if (_tableDataArr.count  == 0) {
            CardNullTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
            if (cell == nil) {
                cell = [[CardNullTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier3];
            }
            cell.nameLabel.text = @"沙发已经为你准备好了，请入座~";
            cell.myImageView.image = [UIImage imageNamed:@"TheSofa"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            CircleCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
            if (cell == nil) {
                cell = [[CircleCommentsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier2];
            }
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.navVC = self.navigationController;
            cell.is_delete = _model.data.is_delete;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            ListModel *model = _tableDataArr[indexPath.row];
            cell.model = model;
            return cell;
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || _tableDataArr.count == 0) {
        return;
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] != YES)
    {
        [self pushLoginVC];
    }else{
        _replyModel = _tableDataArr[indexPath.row];

        if (_replyModel.is_owner) {
            [self alertVcWithIndexPath:indexPath.row];
            return;
        }
       
        _textView.placeholderText = [NSString stringWithFormat:@"回复 %@:",_replyModel.username];
        [_textView becomeFirstResponder];
    }
   
}
#
-(void)scrollViewDidScroll:(UIScrollView *)scrollView

{
//    [_textView resignFirstResponder];
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
    
    _textBgView.frame = CGRectMake(0, kScreenH - height  -121, kScreenW, 121);
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    [self maskViewTap];
}
-(void)onClickReply:(id)sender
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] != YES)
    {
        [self pushLoginVC];
    }else{
    _replyModel = nil;
    _textView.placeholderText = [NSString stringWithFormat:@"评论动态"];
    [_textView becomeFirstResponder];
    }
}
-(void)maskViewTap
{
    _textBgView.frame = CGRectMake(0, kScreenH , kScreenW, 121);
    _maskView.hidden = YES;
    [_textView resignFirstResponder];
}
//右上更多
-(void)moreCircle
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] == NO) {
        [self pushLoginVC];
        return;
    }
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    WeakSelf(weakSelf);
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:_model.data.is_delete?@"删除":@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //判断是否是自己的 是否是管理员  或者圈主
        if(_model.data.is_owner ){
            //自己的动态
            [weakSelf alerViewWithTitle:@"确定删除该动态" tag:3000];
            return;
        }else if (_model.data.is_delete){
            //管理员或者圈主
            [weakSelf selectDeleteWithTitle:@"选择删除原因" tag:5000];
            return;
        } else{
            //路人
            [weakSelf selectDeleteWithTitle:@"选择举报原因" tag:4000];
            return;
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVc addAction:deleteAction];
    [alertVc addAction:cancelAction];
    
    [self presentViewController:alertVc animated:YES completion:^{
        
        
    }];
    
}
-(void)selectDeleteWithTitle:(NSString *)title tag:(NSInteger )tag
{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];//UIAlertControllerStyleActionSheet
    
    WeakSelf(weakSelf);
    UIAlertAction *sureAction1 = [UIAlertAction actionWithTitle:@"欺诈骗钱" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        switch (tag) {
            case 4000:
                [weakSelf requestDeleteDynamicWithType:@"1" Type_id:_model.data.id Content:@"欺诈骗钱"];
                break;
            case 5000:
                [weakSelf requestToReportWithType:@"1" Type_id:_model.data.id Content:@"欺诈骗钱"];
                break;
            default:
                break;
        }

    }];
    UIAlertAction *sureAction2 = [UIAlertAction actionWithTitle:@"色情暴力" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        switch (tag) {
            case 5000:
                [weakSelf requestDeleteDynamicWithType:@"1" Type_id:_model.data.id Content:@"色情暴力"];
                break;
            case 4000:
                [weakSelf requestToReportWithType:@"1" Type_id:_model.data.id Content:@"色情暴力"];
                break;
            default:
                break;
        }
        
    }];
    UIAlertAction *sureAction3 = [UIAlertAction actionWithTitle:@"广告骚扰" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        switch (tag) {
            case 5000:
                [weakSelf requestDeleteDynamicWithType:@"1" Type_id:_model.data.id Content:@"广告骚扰"];
                break;
            case 4000:
                [weakSelf requestToReportWithType:@"1" Type_id:_model.data.id Content:@"广告骚扰"];
                break;
            default:
                break;
        }
        
    }];
    UIAlertAction *sureAction4 = [UIAlertAction actionWithTitle:@"侵权" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        switch (tag) {
            case 5000:
                [weakSelf requestDeleteDynamicWithType:@"1" Type_id:_model.data.id Content:@"侵权"];
                break;
            case 4000:
                [weakSelf requestToReportWithType:@"1" Type_id:_model.data.id Content:@"侵权"];
                break;
            default:
                break;
        }
        
    }];
    UIAlertAction *sureAction5 = [UIAlertAction actionWithTitle:@"违反圈子规章" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        switch (tag) {
            case 5000:
                [weakSelf requestDeleteDynamicWithType:@"1" Type_id:_model.data.id Content:@"违反圈子规章"];
                break;
            case 4000:
                [weakSelf requestToReportWithType:@"1" Type_id:_model.data.id Content:@"违反圈子规章"];
                break;
            default:
                break;
        }
        
    }];
   
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVc addAction:sureAction1];
    [alertVc addAction:sureAction2];
    [alertVc addAction:sureAction3];
    [alertVc addAction:sureAction4];
    [alertVc addAction:sureAction5];
    [alertVc addAction:cancelAction];
    [self presentViewController:alertVc animated:YES completion:^{
        
        
    }];
}

-(void)alerViewWithTitle:(NSString *)title tag:(NSInteger)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定删除",nil];
    alert.tag = tag;
    [alert show];
}
-(void)alertVcWithIndexPath:(NSInteger)row
{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];//UIAlertControllerStyleActionSheet
  
    WeakSelf(weakSelf);
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        _textView.placeholderText = [NSString stringWithFormat:@"回复 %@:",weakSelf.replyModel.username];
        [_textView becomeFirstResponder];
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf alerViewWithTitle:@"确定删除该评论" tag:row];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVc addAction:sureAction];
    [alertVc addAction:deleteAction];
    [alertVc addAction:cancelAction];

    [self presentViewController:alertVc animated:YES completion:^{
        
        
    }];
   
}
#pragma marks -- CircleCommentsCellDelegate --
-(void)selectedDeleteButtonWithCell:(NSIndexPath *)indexPath
{
    ListModel *model = _tableDataArr[indexPath.row];
    [self requestDeleteDynamicWithType:@"0" Type_id:model.id Content:[NSString stringWithFormat:@"%ld",indexPath.row]];
   
}
#pragma marks -- UIAlertViewDelegate --
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3000 && buttonIndex == 1) {
        [self requestDeleteDynamicWithType:@"1" Type_id:_model.data.id Content:@""];
    }else{
        if (buttonIndex == 1) {
            ListModel *model = _tableDataArr[alertView.tag];
            [self requestDeleteCommentWithID:model.id row:alertView.tag];
        }
    }
  
}
//举报
-(void)requestToReportWithType:(NSString *)type Type_id:(NSString *)type_id Content:(NSString *)content
{
    [self loadingWithText:@"举报中"];
    NSString *urlStr = [NetRequest ToReport];
    NSDictionary *paramsDic = @{@"type":type, @"type_id": type_id,@"content":content};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [self endLoading];
        if ([JSON[@"error"] integerValue] == 0) {
            [MyTool showHUDWithStr:[NSString stringWithFormat:@"%@",JSON[@"msg"]]];
        }
        
    } failure:^(NSError *error) {
        [self endLoading];
        
    }];
}
//删除评论 /动态
-(void)requestDeleteDynamicWithType:(NSString *)type Type_id:(NSString *)type_id Content:(NSString *)content
{
    [self loadingWithText:@"删除中"];
    NSString *urlStr = [NetRequest DeleteDynamic];
    NSDictionary *paramsDic = @{@"type":type, @"type_id": type_id,@"content":content};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [self endLoading];
        [MyTool showHUDWithStr:[NSString stringWithFormat:@"%@",JSON[@"msg"]]];

        if ([JSON[@"error"] integerValue] == 0) {

            //删除动态
            if ([type isEqualToString:@"1"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else if([type isEqualToString:@"0"]){
                //删除评论
                NSInteger row = [content integerValue];
                [_tableDataArr removeObjectAtIndex:row];
                _model.data.comment_num = [NSString stringWithFormat:@"%d",[_model.data.comment_num intValue] -1];
                [_myTableView reloadData];
            }
           
        }
        
    } failure:^(NSError *error) {
        [self endLoading];
        
    }];
}
-(void)requestDeleteCommentWithID:(NSString *)ID row:(NSInteger)row
{
    [self loadingWithText:@"删除中"];
    NSString *urlStr = [NetRequest DeleteComments];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"comment_id": ID};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [self endLoading];
        if ([JSON[@"error"] integerValue] == 0) {
            [MyTool showHUDWithStr:[NSString stringWithFormat:@"%@",JSON[@"msg"]]];
            [_tableDataArr removeObjectAtIndex:row];
            _model.data.comment_num = [NSString stringWithFormat:@"%d",[_model.data.comment_num intValue] -1];
            [_myTableView reloadData];
        }
        
    } failure:^(NSError *error) {
        [self endLoading];
        
    }];
}
-(CGFloat)calculateCellHeight:(Data *)model
{
    NSArray *picArr = model.cover.mutableCopy;
    //每个Item宽高
    CGFloat W = (kScreenW-30 -20)/3;
    CGFloat H = W * 0.72;
    CGFloat picH = picArr.count %3 == 0?picArr.count / 3 * (H + 10):(picArr.count / 3 +1)* (H + 10) ;
    if (picArr.count == 1) {
        picH = (kScreenW-30)*0.463 +10;
    }
    CGFloat labelW = kScreenW -15 - 15;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, labelW, 999)];
    label.numberOfLines = 0;
    label.text = model.content;
    CGFloat labelH = [MyTool heightOfLabel:model.content forFont:[UIFont systemFontOfSize:17] labelLength:labelW];
    label.text.length == 0?labelH = 0:labelH;
    CGFloat addressBtnH = model.location.length >0?30:0;
    CGFloat cellH = labelH + picH + 75  + 15 + 14  +15 + 15 +addressBtnH;
    return cellH;
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [[[UIApplication sharedApplication].keyWindow viewWithTag:5000] removeFromSuperview];
}
@end
