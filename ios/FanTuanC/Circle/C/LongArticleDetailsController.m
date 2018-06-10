//
//  LongArticleDetailsController.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/4/19.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "LongArticleDetailsController.h"
#import "LongArticleDetailsImageCell.h"
#import "LongArticleDetailsTextCell.h"
#import "LongArticleHeaderView.h"
#import "LongArticleHeaderCell.h"
#import "AllPraiseCell.h"
#import "CardNullTableViewCell.h"
#import "CircleCommentsCell.h"
#import "LongArticleBottomView.h"
#import "GKPhotoBrowser.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "CircleDetailsController.h"
@interface LongArticleDetailsController ()<UITableViewDelegate,UITableViewDataSource,CircleCommentsCellDelegate>
{
    CircleModel *_model;
    UIBarButtonItem * _rightItem;
    UIButton *_praisebnt;
    UIView *_maskView;
    UIView *_textBgView;
    YYTextView *_textView;
    LongArticleBottomView *_bottomView;
    NSMutableArray *_ImageAtt;
    NSMutableArray *_subscriptArr;
    MBProgressHUD *_hud;

}
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) LongArticleHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *tableDataArr;
@property (nonatomic, strong) NSMutableArray *tableCommentsArr;
@property (nonatomic, strong) NSMutableArray *allPraiseArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) ListModel *replyModel;


@end

@implementation LongArticleDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];

    self.navigationItem.title = @"长文详情";
    _tableDataArr = [NSMutableArray array];
    _tableCommentsArr = [NSMutableArray array];

    [self createUI];
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}
-(void)setArticleId:(NSString *)articleId
{
    _articleId = articleId;
    _page = 1;
    [self loadingWithText:@"加载中"];
    [self getDataIsDown:YES isPraise:NO isReply:NO];

}
- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    _myTableView = myTableView;
    
    
    myTableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 50, 0 ));
    
    WeakSelf(weakSelf);
    _myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page = weakSelf.page + 1;
        [weakSelf getDataIsDown:NO isPraise:NO isReply:NO];
    }];

    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"circleDot"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(moreCircle) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn sizeToFit];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    _rightItem = rightItem;
    
    
    
    LongArticleBottomView *bottomView = [[LongArticleBottomView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:bottomView];
    [bottomView.praisebnt addTarget:self action:@selector(clickPraisecWith:) forControlEvents:UIControlEventTouchDown];
    [bottomView.commentsbnt addTarget:self action:@selector(clickCommentsWith:) forControlEvents:UIControlEventTouchDown];
    _bottomView = bottomView;
    
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickReply:)];
    [bottomView addGestureRecognizer:singleTap];
    bottomView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view,0)
    .heightIs(50);
  
    
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
//点击评论图标
-(void)clickCommentsWith:(UIButton *)btn
{
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    [_myTableView scrollToRowAtIndexPath:scrollIndexPath
                        atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_textBgView]) {
        return NO;
    }
    return YES;
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
-(void)sendAction:(UIButton *)btn
{
    if (_textView.text.length == 0) {
        [MyTool showHUDWithStr:@"评论不能为空哦~"];
        return;
    }
    [self replyDynamic];
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
-(void)maskViewTap
{
    _textBgView.frame = CGRectMake(0, kScreenH , kScreenW, 121);
    _maskView.hidden = YES;
    [_textView resignFirstResponder];
}
#pragma mark -- tableViewDelegate  &&  tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return _tableDataArr.count;
    }else if(section == 3){
        return _tableCommentsArr.count ==0?1:_tableCommentsArr.count;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if(_model.data.like_list.count == 0){
            return 40;
        }
        //计算不同机型最多一行多少个头像
        int w = (kScreenW - 30 - 10) / 30.0;
        float h = ceilf((CGFloat)_model.data.like_list.count/(CGFloat)w == 0?1:(CGFloat)_model.data.like_list.count/(CGFloat)w ) * 35 + 15;
        return h;
    }
    if (_model.data.comment_list.count == 0 && indexPath.section == 3) {
        return 240;
    }
    if (indexPath.section == 0) {
        return [self.myTableView cellHeightForIndexPath:indexPath model:_model.data keyPath:@"model" cellClass:[LongArticleHeaderCell class] contentViewWidth:kScreenW];
    }
    if (indexPath.section == 1) {
        Comment *model = _tableDataArr[indexPath.row];
        if ([model.type isEqualToString:@"1"]) {
            return [self.myTableView cellHeightForIndexPath:indexPath model:_tableDataArr[indexPath.row] keyPath:@"model" cellClass:[LongArticleDetailsTextCell class] contentViewWidth:kScreenW];
        }else{
            return [self.myTableView cellHeightForIndexPath:indexPath model:_tableDataArr[indexPath.row] keyPath:@"model" cellClass:[LongArticleDetailsImageCell class] contentViewWidth:kScreenW];
            
        }
    }
    if (indexPath.section == 3) {
        if (_tableCommentsArr.count == 0) {
            return 240;
        }else{
            return [self.myTableView cellHeightForIndexPath:indexPath model:_tableCommentsArr[indexPath.row] keyPath:@"model" cellClass:[CircleCommentsCell class] contentViewWidth:kScreenW];
        }
        
        
    }
    return 100;

//    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:kScreenW tableView:_myTableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *textcellIdentifier = @"LongArticleDetailsTextCell";
    static NSString *imagecellIdentifier = @"LongArticleDetailsImageCell";
    static NSString *headerCellIdentifier = @"headerCellIdentifier";
    static NSString *allPraiseCellIdentifier = @"allPraiseCellIdentifier";
    static NSString *nullCellIdentifier = @"nullCellIdentifier";
    static NSString *commentsCellIdentifier = @"commentsCellIdentifier";

    if (indexPath.section == 0) {
        //长文头部cell
        LongArticleHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:headerCellIdentifier];
        if (cell == nil) {
            cell = [[LongArticleHeaderCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:headerCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _model.data;
        return cell;
    }else if(indexPath.section == 1){
        //文章cell
        Comment *model = _tableDataArr[indexPath.row];
        if ([model.type isEqualToString:@"1"]) {
            
            LongArticleDetailsTextCell *cell = [tableView dequeueReusableCellWithIdentifier:textcellIdentifier];
            if (cell == nil) {
                cell = [[LongArticleDetailsTextCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:textcellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //        cell.backgroundColor = [UIColor yellowColor];
            cell.model = model;
            return cell;
        }else{
            
            LongArticleDetailsImageCell *cell = [tableView dequeueReusableCellWithIdentifier:imagecellIdentifier];
            if (cell == nil) {
                cell = [[LongArticleDetailsImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:imagecellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //        cell.backgroundColor = [UIColor redColor];
            cell.model = model;
            cell.picArr = _ImageAtt;
            cell.subscriptArr = _subscriptArr;
            cell.row = indexPath.row;
            return cell;
        }
        
    }else if (indexPath.section == 2){
        //所有点赞cell
        AllPraiseCell *cell = [tableView dequeueReusableCellWithIdentifier:allPraiseCellIdentifier];
        if (cell == nil) {
            cell = [[AllPraiseCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:allPraiseCellIdentifier];
        }
        cell.list = _model.data.like_list;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        //评论cell
        if (_tableCommentsArr.count  == 0) {
            CardNullTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nullCellIdentifier];
            if (cell == nil) {
                cell = [[CardNullTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nullCellIdentifier];
            }
            cell.nameLabel.text = @"沙发已经为你准备好了，请入座~";
            cell.myImageView.image = [UIImage imageNamed:@"TheSofa"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            CircleCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:commentsCellIdentifier];
            if (cell == nil) {
                cell = [[CircleCommentsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:commentsCellIdentifier];
            }
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.navVC = self.navigationController;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            ListModel *model = _tableCommentsArr[indexPath.row];
            cell.model = model;
            cell.is_delete = _model.data.is_manager;
            return cell;
        }

    }
   
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenW, 18)];
    UILabel *readLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    readLabel.font = [UIFont systemFontOfSize:14];
    readLabel.textColor = [MyTool ColorWithColorStr:@"999999"];
    UILabel *releasedLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    releasedLabel.font = [UIFont systemFontOfSize:14];
    releasedLabel.textColor = [MyTool ColorWithColorStr:@"999999"];
    releasedLabel.text = @"发布于圈子:";

    UIButton *circleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [circleBtn setTitleColor:[MyTool ColorWithColorStr:@"05a4be"] forState:UIControlStateNormal];
    circleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [circleBtn addTarget:self action:@selector(circlBtnAction:) forControlEvents:UIControlEventTouchDown];
    [bgView addSubview:readLabel];
    [bgView addSubview:releasedLabel];
    [bgView addSubview:circleBtn];
    
    readLabel.sd_layout
    .topSpaceToView(bgView, 10)
    .leftSpaceToView(bgView, 15)
    .autoHeightRatio(0);
    [readLabel setSingleLineAutoResizeWithMaxWidth:kScreenW-30];

    if (_model.data.circle_name.length != 0) {
        releasedLabel.sd_layout
        .centerYEqualToView(readLabel)
        .leftSpaceToView(readLabel, 15)
        .autoHeightRatio(0);
        [releasedLabel setSingleLineAutoResizeWithMaxWidth:kScreenW-30];
        
        circleBtn.sd_layout
        .centerYEqualToView(readLabel)
        .leftSpaceToView(releasedLabel, 5);
        [circleBtn setupAutoSizeWithHorizontalPadding:0 buttonHeight:40];
    }
    
    readLabel.text = [NSString stringWithFormat:@"%@次浏览",_model.data.read_num];
    [circleBtn setTitle:_model.data.circle_name forState:UIControlStateNormal];
    
    if (section == 1) {
        return bgView;

    }else{
        return [UIView new];
    }
}
-(void)circlBtnAction:(UIButton *)btn
{
    CircleDetailsController *detailsVC = [[CircleDetailsController alloc] init];
    detailsVC.hidesBottomBarWhenPushed = YES;
    detailsVC.circleID = _model.data.circle_id;
    [self.navigationController pushViewController:detailsVC animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenW, 18)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, kScreenW - 30, 18)];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [bgView addSubview:label];
    if(section == 2){
        label.text = [NSString stringWithFormat:@"%ld人点赞",_model.data.like_list.count];
    }else if(section == 3){
        label.text = [_model.data.comment_num intValue] >0? [NSString stringWithFormat:@"%@条评论",_model.data.comment_num]:@"暂无评论";
    }
    return bgView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return .01;
    }else{
        return 33;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 40;
    }else{
        return .01;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {

    }
    if (indexPath.section == 3 && _tableCommentsArr.count != 0) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] != YES)
        {
            [self pushLoginVC];
        }else{
            _replyModel = _model.data.comment_list[indexPath.row];
            
            if (_replyModel.is_owner) {
                [self alertVcWithIndexPath:indexPath.row];
                return;
            }
            
            _textView.placeholderText = [NSString stringWithFormat:@"回复 %@:",_replyModel.username];
            [_textView becomeFirstResponder];
        }
    }
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
#pragma marks -- CircleCommentsCellDelegate --
-(void)selectedDeleteButtonWithCell:(NSIndexPath *)indexPath
{
    ListModel *model = _tableCommentsArr[indexPath.row];
    [self requestDeleteDynamicWithType:@"0" Type_id:model.id Content:[NSString stringWithFormat:@"%ld",indexPath.row]];
    
}
#pragma marks -- UIAlertViewDelegate --
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 3000 && buttonIndex == 1) {
        [self requestDeleteDynamicWithType:@"1" Type_id:_model.data.id Content:@""];
    }else{
        if (buttonIndex == 1) {
            ListModel *model = _model.data.comment_list[alertView.tag];
            [self requestDeleteCommentWithID:model.id row:alertView.tag];
        }
        
    }
    
}

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
            [weakSelf alerViewWithTitle:@"确定删除该长文" tag:3000];
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
                [weakSelf requestToReportWithType:@"1" Type_id:_model.data.id Content:@"欺诈骗钱"];

                break;
            case 5000:
                [weakSelf requestDeleteDynamicWithType:@"1" Type_id:_model.data.id Content:@"欺诈骗钱"];

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
-(void)requestDeleteCommentWithID:(NSString *)ID row:(NSInteger)row
{
    [self loadingWithText:@"删除中"];
    NSString *urlStr = [NetRequest DeleteComments];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"comment_id": ID};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [self endLoading];
        if ([JSON[@"error"] integerValue] == 0) {
            [MyTool showHUDWithStr:[NSString stringWithFormat:@"%@",JSON[@"msg"]]];
            [_tableCommentsArr removeObjectAtIndex:row];
            _model.data.comment_num = [NSString stringWithFormat:@"%d",[_model.data.comment_num intValue] -1];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
            [_myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];        }
        
    } failure:^(NSError *error) {
        [self endLoading];
        
    }];
}
-(void)getDataIsDown:(BOOL)down isPraise:(BOOL)isPraise isReply:(BOOL)isReply
{
    NSString *urlStr = [NetRequest LongArticleDetails];
    NSDictionary *paramsDic = @{@"id":_articleId,@"pn":[NSString stringWithFormat:@"%ld",_page]};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        CircleModel *model = [CircleModel yy_modelWithJSON:JSON];
        [self endLoading];
        if ([model.error integerValue] == 0) {
            _model = model;
            self.headerView.model = model.data;
            _bottomView.model = model;
            _allPraiseArr = _model.data.like_list.mutableCopy;
            _tableDataArr = _model.data.contents.mutableCopy;
            [self processingPictureArr:_tableDataArr];
            if (!down) {
                _tableCommentsArr = [[_tableCommentsArr arrayByAddingObjectsFromArray:model.data.comment_list]mutableCopy];
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
                [_myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            } else{
                _tableCommentsArr = [model.data.comment_list mutableCopy];
               
                [self.myTableView reloadData];

            }
            if (isReply) {
                //滚动到评论区
//                NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:3];
//                [_myTableView scrollToRowAtIndexPath:scrollIndexPath
//                                    atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            if (isPraise) {
                _bottomView.model = model;
            }
            [_myTableView.mj_header endRefreshing];
            model.data.paging.is_end == YES?[_myTableView.mj_footer endRefreshingWithNoMoreData]:[_myTableView.mj_footer endRefreshing];
            
           
        }else{
            [MyTool showHUDWithStr:model.msg];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [self endLoading];

    }];
}
-(void)replyDynamic
{
    [self loadingWithText:@"评论中"];
    NSString *urlStr = [NetRequest ReplyDynamic];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"dy_id": _model.data.id, @"to_uid":_replyModel?_replyModel.uid:@"",@"content":_textView.text};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [self endLoading];
        if ([JSON[@"error"] integerValue] == 0) {
            _page = 1;
//            [_tableDataArr removeAllObjects];
            [_textView resignFirstResponder];
            _maskView.hidden = YES;
            [self getDataIsDown:YES isPraise:NO isReply:YES];
            _textView.text = nil;
            
           
        }
        //        [MyTool showHUDWithStr:[NSString stringWithFormat:@"%@",JSON[@"msg"]]];
        
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
                [_tableCommentsArr removeObjectAtIndex:row];
                _model.data.comment_num = [NSString stringWithFormat:@"%d",[_model.data.comment_num intValue] -1];
                [_myTableView reloadData];
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
                [_myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
        }
        
    } failure:^(NSError *error) {
        [self endLoading];
        
    }];
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
//点赞
-(void)clickPraisecWith:(UIButton *)btn
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] != YES)
    {
        [self pushLoginVC];
    } else {
        //        [self loadingWithText:@"加载中"];
        NSString *urlStr = [NetRequest DynamicLike];
        NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"dy_id": _model.data.id,@"like":[NSString stringWithFormat:@"%d",!_model.data.has_like]};
        [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
            //            [self endLoading];
            if ([JSON[@"error"] integerValue] == 0) {
                btn.selected = !btn.selected;
                [self getDataIsDown:YES isPraise:YES isReply:NO];
                [MyTool showHUDWithStr:[NSString stringWithFormat:@"%@",JSON[@"msg"]]];
            }
            
        } failure:^(NSError *error) {
            [self endLoading];
        }];
    }
}
-(void)processingPictureArr:(NSArray *)dataArr
{
    NSMutableArray *att = [NSMutableArray array];
    NSMutableArray *att2 = [NSMutableArray array];

    for (int i = 0; i < dataArr.count; i ++) {
        ListModel *model = dataArr[i];
        if ([model.type isEqualToString:@"2"]) {
            [att addObject:model];
            [att2 addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
//    for (ListModel *model in dataArr) {
//        if ([model.type isEqualToString:@"2"]) {
//            [att addObject:model];
//        }
//    }
    _ImageAtt = att.mutableCopy;
    _subscriptArr = att2.mutableCopy;
}
-(void)dealloc
{
    [[[UIApplication sharedApplication].keyWindow viewWithTag:5000] removeFromSuperview];
}

- (void)pushLoginVC
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    UINavigationController *loginNaVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:loginNaVC animated:YES completion:nil];
}

-(void)loadingWithText:(NSString *)text
{
    [self endLoading];
    _hud = [[MBProgressHUD alloc] initWithView:ApplicationDelegate.window];
    _hud.removeFromSuperViewOnHide = YES;
    _hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    _hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.6];
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    _hud.label.textColor = [UIColor whiteColor];
    _hud.label.text = text;
    [_hud showAnimated:YES];
    [ApplicationDelegate.window addSubview:_hud];
}
-(void)endLoading
{
    [_hud hideAnimated:YES];
    _hud.hidden=YES;
}

@end
