//
//  LongAtricleDetailsTwoController.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/5/21.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "LongAtricleDetailsTwoController.h"
#import "InputBoxController.h"
#import "LongArticleDetailsImageCell.h"
#import "LongArticleDetailsTextCell.h"
#import "LongArticleHeaderCell.h"
#import "CircleCommentsCell.h"
#import "CommentAddReplyCell.h"
#import "LongArticleSectionFooterView.h"
@interface LongAtricleDetailsTwoController ()< UITableViewDelegate,UITableViewDataSource,InputBoxControllerDelegate,CommentAddReplyCellDelegate,LongArticleSectionFooterViewDelegate>
{
    NSMutableArray *_ImageAtt;
    NSMutableArray *_subscriptArr;
    CircleModel *_model;
    UILabel *_titleViewLabel;
    UIImageView *_titleViewIamgeView;
}
@property (nonatomic, strong) ListModel *listModel;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) InputBoxController * inputBoxVC;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIBarButtonItem * rightItem2;
@property (nonatomic, strong) UIBarButtonItem * rightItem;
@property (nonatomic, strong) NSMutableArray *tableDataArr;
@property (nonatomic, strong) NSMutableArray *tableCommentsArr;
@property (nonatomic, assign) NSInteger page;

@end

@implementation LongAtricleDetailsTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.title = @"长文详情";
    _tableDataArr = [NSMutableArray array];
    _tableCommentsArr = [NSMutableArray array];
    [self createUI];

}
-(void)setArticleId:(NSString *)articleId
{
    _articleId = articleId;
    self.page = 0;
    [self getData];
}
-(void)assignmentTitleView
{
    [_titleViewIamgeView sd_setImageWithURL:[NSURL URLWithString:_listModel.avatar]];
    _titleViewLabel.text = _listModel.username;


}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 60) {
        self.navigationItem.titleView  = _titleView;
        self.navigationItem.rightBarButtonItems = _listModel.is_following? @[_rightItem]:@[_rightItem,_rightItem2];
    }else{
        self.navigationItem.titleView  = nil;
        self.navigationItem.rightBarButtonItems = @[_rightItem];
    }
}
#pragma mark  LongArticleSectionFooterViewDelegate
-(void)clickOnTheWitnBtn:(UIButton *)btn Index:(NSInteger)index
{
    if (index == 1) {
        
    }else if (index == 2){
        
    }else{
        
    }
}

#pragma mark  CommentAddReplyCellDelegate
//删除回复刷新单元格
-(void)clickDeleteBtnWithModel:(ListModel *)model indexPath:(NSIndexPath *)indexPath
{
    [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
}
//点击评论的回复 回调
-(void)clickCellWithModel:(ListModel *)model indexPath:(NSIndexPath *)indexPath
{
    _inputBoxVC.listModel = model;
    _inputBoxVC.commentModel = _tableCommentsArr[indexPath.row];
    _inputBoxVC.indexPath = indexPath;
    [self presentViewController:_inputBoxVC animated:YES completion:nil];
}
//点击评论加载更多
-(void)clickMoreBtnWithModel:(ListModel *)model indexPath:(NSIndexPath *)indexPath pg:(NSString *)pg
{
    [self getMoerReplyWithCommentId:model.id Pn:[NSString stringWithFormat:@"%d",[pg intValue]+1] indexPath:indexPath];
}
#pragma mark   InputBoxControllerDelegate
-(void)commentBack
{
    _page = 0;
    [self getData];
}
-(void)replyToSuccessWith:(NSIndexPath *)indexPath model:(ListModel *)model
{
    ((ListModel *)_tableCommentsArr[indexPath.row]).replys.list  = [[((ListModel *)_tableCommentsArr[indexPath.row]).replys.list  arrayByAddingObjectsFromArray:@[model]] mutableCopy];
    [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
}

-(void)onClickReply:(id)sender
{
    [self pusInputVc];
}
-(void)pusInputVc
{
    InputBoxController *inputBoxVC = [InputBoxController new];
    inputBoxVC.model = _listModel;
    inputBoxVC.delegate = self;
    inputBoxVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    inputBoxVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    inputBoxVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:inputBoxVC animated:YES completion:nil];
}
-(void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64) style:UITableViewStyleGrouped];
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_myTableView];
    WeakSelf(weakSelf);
    
    _myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    //    [_myTableView.mj_footer beginRefreshing];
    // 解决在iOS11上朋友圈demo文字收折或者展开时出现cell跳动问题
    _myTableView.estimatedRowHeight = 0;
    _myTableView.estimatedSectionFooterHeight = 0;
    _myTableView.estimatedSectionHeaderHeight = 0;
    _myTableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 50, 0));
    
    self.inputBoxVC = [InputBoxController new];
//    self.inputBoxVC.model = _model;
    self.inputBoxVC.delegate = self;
    self.inputBoxVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    self.inputBoxVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.inputBoxVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //评论
    UIView *replyBgView = [[UIView alloc]initWithFrame:CGRectZero];
    replyBgView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickReply:)];
    [replyBgView addGestureRecognizer:singleTap];
    UILabel *replyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    replyLabel.font = [UIFont systemFontOfSize:15];
    replyLabel.backgroundColor = [MyTool colorWithString:@"F1F1F1"];
    replyLabel.textColor = [MyTool colorWithString:@"C5C5C5"];
    replyLabel.text = @"    来说点什么吧~";
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectZero];
    lineView.backgroundColor = [MyTool colorWithString:@"e5e5e5"];
    [self.view addSubview:replyBgView];
    [replyBgView sd_addSubviews:@[replyLabel,lineView]];
    
    replyBgView.sd_layout
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .heightIs(50);
    
    replyLabel.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(10, 15, 10, 15));
    replyLabel.sd_cornerRadius = @(8);
    
    lineView.sd_layout
    .leftSpaceToView(replyBgView, 0)
    .rightSpaceToView(replyBgView, 0)
    .topSpaceToView(replyBgView, 0)
    .heightIs(0.5);
    
    
    //titleView
    //    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [titleBtn setTitle:@"这里是名字" forState:UIControlStateNormal];
    //    [titleBtn sizeToFit];
    //    [titleBtn setImage:[UIImage imageNamed:@"GroupRelease"] forState:UIControlStateNormal];
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 130, 40)];
    UIImageView *avatarIamgeView  = [[UIImageView alloc]initWithFrame:CGRectZero];
    _titleViewIamgeView = avatarIamgeView;
    
    UILabel *usernameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    usernameLabel.font = [UIFont systemFontOfSize:14];
    usernameLabel.textColor = [MyTool colorWithString:@"333333"];
    _titleViewLabel = usernameLabel;
    [titleView sd_addSubviews:@[avatarIamgeView,usernameLabel]];
    
    
    usernameLabel.sd_layout
    .centerYEqualToView(titleView)
    .centerXEqualToView(titleView)
    .heightIs(14);
    [usernameLabel setSingleLineAutoResizeWithMaxWidth:100];
    
    avatarIamgeView.sd_layout
    .rightSpaceToView(usernameLabel, 8)
    .centerYEqualToView(titleView)
    .widthIs(20)
    .heightEqualToWidth();
    avatarIamgeView.sd_cornerRadiusFromWidthRatio = @(0.5);
    _titleView = titleView;
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"circleDot"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(moreCircle) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn sizeToFit];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    _rightItem = rightItem;
    
    UIButton *focusbnt = [UIButton buttonWithType:UIButtonTypeCustom];
    [focusbnt setImage:[UIImage imageNamed:@"2.0FousBtnicon"] forState:UIControlStateNormal];
    [focusbnt addTarget:self action:@selector(focusbntAction:) forControlEvents:UIControlEventTouchUpInside];
    [focusbnt sizeToFit];
    //判断是否已经关注 决定是否有按钮显示
    UIBarButtonItem * rightItem2 = [[UIBarButtonItem alloc] initWithCustomView:focusbnt];
    _rightItem2 =  rightItem2;
    self.navigationItem.rightBarButtonItems = @[rightItem];
    
}
-(void)getMoerReplyWithCommentId:(NSString *)commentId Pn:(NSString *)pn indexPath:(NSIndexPath *)indexPath
{
    NSString *urlStr = [NetRequest Replays];
    NSDictionary *paramsDic = @{@"commentId":commentId,@"pn":pn,@"limit":@"10"};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        CircleModel *model = [CircleModel yy_modelWithJSON:JSON];
        if ([model.error integerValue] == 0) {
            ((ListModel *)_tableDataArr[indexPath.row]).replys.list = [[((ListModel *)_tableDataArr[indexPath.row]).replys.list  arrayByAddingObjectsFromArray:model.data.list] mutableCopy];
            ((ListModel *)_tableDataArr[indexPath.row]).replys.paging = model.data.paging;
            //            ((ListModel *)_tableDataArr[indexPath.row]).replys.paging = model.data.paging;
            [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
        }
        [MyTool showHUDWithStr:model.msg];
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)getData
{
    NSString *urlStr = [NetRequest LongArticleDetails];
    NSDictionary *paramsDic = @{@"id":_articleId,@"firstCommentId":_firstCommentId?_firstCommentId:@"",@"pn":[NSString stringWithFormat:@"%ld",_page + 1]};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        CircleModel *model = [CircleModel yy_modelWithJSON:JSON];
        if ([model.error integerValue] == 0) {
            _page = [model.data.paging.pn intValue];
            if ([model.data.paging.pn isEqualToString:@"1"]) {
                ListModel *listModel = [ListModel yy_modelWithJSON:JSON[@"data"]];
                _listModel = listModel;
                _model = model;
                _tableDataArr = model.data.contents.mutableCopy;
                [self processingPictureArr:_tableDataArr];
                [_tableCommentsArr removeAllObjects];
                [self assignmentTitleView];
            }
              _tableCommentsArr = [[_tableCommentsArr arrayByAddingObjectsFromArray:model.data.comment_list] mutableCopy];
            [self.myTableView.mj_footer endRefreshing];
            if (model.data.paging.is_end) {
                [self.myTableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.myTableView reloadData];

            //从消息中心来的 需要滚动到评论区
            if ([model.data.paging.pn isEqualToString:@"1"] && _is_reply) {
                NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:2];
                [_myTableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }
    } failure:^(NSError *error) {
        [self.myTableView.mj_footer endRefreshing];
    }];
}
//导航栏关注按钮
-(void)focusbntAction:(UIButton *)btn
{
    NSString *urlStr = [NetRequest UserFollow];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"following_id":_listModel.uid, @"follow":@"1"};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [MyTool showHUDWithStr:JSON[@"msg"]];
        if ([JSON[@"error"] boolValue] == 0) {
            _listModel.is_following = YES;
            btn.hidden = YES;
            self.navigationItem.rightBarButtonItems = @[_rightItem];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [_myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    } failure:^(NSError *error) {
        
    }];
}
//请求点赞、取消点赞
-(void)requestPraiseDynamic:(BOOL)isLiske
{
    NSString *urlStr = [NetRequest DynamicPraise];
    NSDictionary *paramsDic = @{@"type":@"0",@"id":_model.data.id,@"like":[NSString stringWithFormat:@"%d",!isLiske]};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        CircleModel *model = [CircleModel yy_modelWithJSON:JSON];
        if ([model.error integerValue] == 0) {
            ListModel *listModel = [ListModel yy_modelWithJSON:JSON[@"data"]];
            
            if (_model.data.has_like &&_model.data.like_list.count != 0) {
                //已经赞
                for (int i = 0;i<_model.data.like_list.count ; i++) {
                    //判断头像是否含有当前用户 移除
                    ListModel *model = _model.data.like_list[i];
                    if ([model.uid isEqualToString:listModel.uid]) {
                        [_model.data.like_list removeObjectAtIndex:i];
                    }
                }
            }else{
                [_model.data.like_list insertObject:listModel atIndex:0];
                
            }
            _model.data.has_like = !_model.data.has_like;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [_myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [MyTool showHUDWithStr:model.msg];
        }
    } failure:^(NSError *error) {
    }];
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
    _ImageAtt = att.mutableCopy;
    _subscriptArr = att2.mutableCopy;
}
#pragma mark -- tableViewDelegate  &&  tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return _tableDataArr.count;
    }else{
        return _tableCommentsArr.count ;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:kScreenW tableView:_myTableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *textcellIdentifier = @"LongArticleDetailsTextCell";
    static NSString *imagecellIdentifier = @"LongArticleDetailsImageCell";
    static NSString *headerCellIdentifier = @"headerCellIdentifier";
    static NSString *commentsCellIdentifier = @"commentsCellIdentifier";
    WeakSelf(weakSelf)
    if (indexPath.section == 0) {
        //长文头部cell
        LongArticleHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:headerCellIdentifier];
        if (cell == nil) {
            cell = [[LongArticleHeaderCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:headerCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _model.data;
        cell.fousButtonClickedBlock = ^(UIButton *fousButton) {
            [weakSelf focusbntAction:fousButton];
        };
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
            cell.model = model;
            cell.picArr = _ImageAtt;
            cell.subscriptArr = _subscriptArr;
            cell.row = indexPath.row;
            return cell;
            }
        
    
    }else{
        //评论cell
            CommentAddReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:commentsCellIdentifier];
            if (cell == nil) {
                cell = [[CommentAddReplyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:commentsCellIdentifier];
            }
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            ListModel *model = _tableCommentsArr[indexPath.row];
            cell.model = model;
            if (_is_reply && indexPath.row == 0) {
                cell.contentView.backgroundColor = [MyTool colorWithString:@"FFF8EC"];
            }else{
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }
            return cell;
        }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //点击评论
    if (indexPath.section == 2) {
        _inputBoxVC.commentModel = _tableCommentsArr[indexPath.row];
        _inputBoxVC.indexPath = indexPath;
        [self presentViewController:_inputBoxVC animated:YES completion:nil];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 100;
    }else{
        return .01;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    static NSString * const footerViewId = @"footerViewId";
    WeakSelf(weakSelf)
    if (section == 1) {
        LongArticleSectionFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerViewId];
        if (footer == nil) {
            footer = [[LongArticleSectionFooterView alloc]initWithReuseIdentifier:footerViewId];
        }
        footer.model = _model;
        footer.delegate = self;
        footer.praiseButtonClickedBlock = ^(UIButton *praiseButton) {
            [weakSelf requestPraiseDynamic:praiseButton.selected];
            praiseButton.selected = !praiseButton.selected;
        };
        return footer;
        
    }else{
        return [UIView new];
    }
   
}

//举报删除 操作、逻辑
//右上更多
-(void)moreCircle
{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    WeakSelf(weakSelf);
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:_listModel.is_delete?@"删除":@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //判断是否是自己的 是否是管理员  或者圈主
        if(_listModel.is_owner ){
            //自己的动态
            [weakSelf alerViewWithTitle:@"确定删除该动态" tag:3000];
            return;
        }else if (_listModel.is_delete){
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
            case 5000:
                [weakSelf requestDeleteDynamicWithType:@"1" Type_id:_listModel.id Content:@"欺诈骗钱"];
                break;
            case 4000:
                [weakSelf requestToReportWithType:@"1" Type_id:_listModel.id Content:@"欺诈骗钱"];
                break;
            default:
                break;
        }
        
    }];
    UIAlertAction *sureAction2 = [UIAlertAction actionWithTitle:@"色情暴力" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        switch (tag) {
            case 5000:
                [weakSelf requestDeleteDynamicWithType:@"1" Type_id:_listModel.id Content:@"色情暴力"];
                break;
            case 4000:
                [weakSelf requestToReportWithType:@"1" Type_id:_listModel.id Content:@"色情暴力"];
                break;
            default:
                break;
        }
        
    }];
    UIAlertAction *sureAction3 = [UIAlertAction actionWithTitle:@"广告骚扰" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        switch (tag) {
            case 5000:
                [weakSelf requestDeleteDynamicWithType:@"1" Type_id:_listModel.id Content:@"广告骚扰"];
                break;
            case 4000:
                [weakSelf requestToReportWithType:@"1" Type_id:_listModel.id Content:@"广告骚扰"];
                break;
            default:
                break;
        }
        
    }];
    UIAlertAction *sureAction4 = [UIAlertAction actionWithTitle:@"侵权" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        switch (tag) {
            case 5000:
                [weakSelf requestDeleteDynamicWithType:@"1" Type_id:_listModel.id Content:@"侵权"];
                break;
            case 4000:
                [weakSelf requestToReportWithType:@"1" Type_id:_listModel.id Content:@"侵权"];
                break;
            default:
                break;
        }
        
    }];
    UIAlertAction *sureAction5 = [UIAlertAction actionWithTitle:@"违反圈子规章" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        switch (tag) {
            case 5000:
                [weakSelf requestDeleteDynamicWithType:@"1" Type_id:_listModel.id Content:@"违反圈子规章"];
                break;
            case 4000:
                [weakSelf requestToReportWithType:@"1" Type_id:_listModel.id Content:@"违反圈子规章"];
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
                
                
            }
        }
        
    } failure:^(NSError *error) {
        [self endLoading];
    }];
}
@end
