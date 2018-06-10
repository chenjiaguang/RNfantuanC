//
//  HomeCircleTwoController.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/5/2.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "HomeCircleTwoController.h"
#import "CardNullTableViewCell.h"
#import "AllCircleListCell.h"
#import "AllCircleListTwoCell.h"
#import "HomeCirleHeaderInSectionView.h"
#import "CircleDetailTwoViewController.h"

@interface HomeCircleTwoController ()<UITableViewDelegate,UITableViewDataSource,AllCircleListCellDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *listDataArr;
@property (nonatomic, strong) NSMutableArray *notmissDataArr;
@property (nonatomic, strong) CircleModel *model;
@end

@implementation HomeCircleTwoController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    
    _myTableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    if (@available(iOS 11.0, *)) {
        _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _myTableView.estimatedRowHeight = 0;
        _myTableView.estimatedSectionHeaderHeight = 0;
        _myTableView.estimatedSectionFooterHeight = 0;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    WeakSelf(weakSelf);
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getData];
    }];
    [_myTableView.mj_header beginRefreshing];
}
- (void)selectedFousButtonWithCell:(UIButton *)btn
{
    
    AllCircleListTwoCell *cell = (AllCircleListTwoCell *)[[btn superview] superview];
    NSIndexPath *indexPath = [_myTableView indexPathForCell:cell];

    ListModel *model = _notmissDataArr[indexPath.row];
    [self requestFousCirleWithCirleID:model.id];

    [_listDataArr addObject:_notmissDataArr[indexPath.row]];
    NSIndexPath *indx = [NSIndexPath indexPathForRow:_listDataArr.count - 1 inSection:0];
    [_myTableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:indx, nil] withRowAnimation:UITableViewRowAnimationLeft];

    [_notmissDataArr removeObjectAtIndex:indexPath.row];
    [_myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];

 
}
#pragma mark -- tableViewDelegate  &&  tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _listDataArr.count;
    }else{
        return _notmissDataArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.section == 0 ){
//        return 160;
//    }
    return [_myTableView cellHeightForIndexPath:indexPath cellContentViewWidth:kScreenW tableView:_myTableView];
    //    return [_myTableView cellHeightForIndexPath:indexPath cellClass:[HomeOnePictureCell class] cellContentViewWidth:kScreenW cellDataSetting:nil];
    //
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"HomePageListTableViewCell";
    static NSString *cellINullDID = @"CardNullTableViewCell";
    static NSString *homeBannerCellIdentifier = @"homeBannerCellIdentifier";
    
    if (indexPath.section == 1){
        if (_listDataArr.count  == 0) {
            CardNullTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellINullDID];
            if (cell == nil) {
                cell = [[CardNullTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellINullDID];
            }
            cell.nameLabel.text = @"空空如也~";
            cell.myImageView.image = [UIImage imageNamed:@"Group 5"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }else{
            AllCircleListTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[AllCircleListTwoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.indexPath = indexPath;
            cell.delegate = self;
            cell.model = _notmissDataArr[indexPath.row];
            return cell;
        }
    }else{
        AllCircleListCell *cell = [tableView dequeueReusableCellWithIdentifier:homeBannerCellIdentifier];
        if (cell == nil) {
            cell = [[AllCircleListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeBannerCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _listDataArr[indexPath.row];
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CircleDetailTwoViewController *vc = [[CircleDetailTwoViewController alloc]init];
    if (indexPath.section == 0) {
        vc.circleID = ((ListModel *)_listDataArr[indexPath.row]).id;
    }else{
        vc.circleID = ((ListModel *)_notmissDataArr[indexPath.row]).id;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HomeCirleHeaderInSectionView *view = [[HomeCirleHeaderInSectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 34)];
    if(section == 0){
        view.titleLabel.text = @"我的圈子";
        view.moreBtn.hidden = YES;
    }
    if(section == 1 && _notmissDataArr.count != 0){
        view.titleLabel.text = @"不可错过的热门圈子";
        view.moreBtn.hidden = NO;
    }
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 34)];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, kScreenW-30, 1)];
    lineView.backgroundColor = [MyTool colorWithString:@"E5E5E5"];
    [bgView addSubview:lineView];
    return bgView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1 && _notmissDataArr.count == 0 ) {
        return .01;
    }else{
        return 34;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1 && _notmissDataArr.count == 0 ) {
        return .01;
    }
    if (section == 0 && _listDataArr.count == 0 ) {
        return .01;
    }else{
        return 1;
    }
}

-(void)getData
{
    NSString *urlStr = [NetRequest HomeCircle];
    NSDictionary *paramsDic = @{};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        self.model = [CircleModel yy_modelWithJSON:JSON];
        _listDataArr = [NSMutableArray array];
        _notmissDataArr = [NSMutableArray array];
        if ([self.model.error integerValue] == 0) {
            _listDataArr = self.model.data.list.mutableCopy;
            _notmissDataArr = self.model.data.notmiss.mutableCopy;
            [_myTableView reloadData];
            [_myTableView.mj_header endRefreshing];
            
        }
    } failure:^(NSError *error) {
        [_myTableView.mj_header endRefreshing];
    }];
}
-(void)requestFousCirleWithCirleID:(NSString *)cirleID
{
    NSString *urlStr = [NetRequest FollowCircle];
    NSDictionary *paramsDic = @{@"id":cirleID,@"follow":@"1"};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        CircleModel *model = [CircleModel yy_modelWithJSON:JSON];
        if ([model.error integerValue] == 0) {
           
          
            
        }
        [MyTool showHUDWithStr:model.msg];
    } failure:^(NSError *error) {
    }];
}
@end
