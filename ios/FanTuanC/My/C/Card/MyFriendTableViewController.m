//
//  MyFriendTableViewController.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/3/26.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "MyFriendTableViewController.h"
#import "MyFriendCell.h"
#import "CardNullTableViewCell.h"
#import "MyCardViewController.h"
@interface MyFriendTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *tableDataArr;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *type;

@end

@implementation MyFriendTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [_myTableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI{
    CGFloat navH = iPhoneX?88:64;
    UITableView *myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 44 - navH) style:UITableViewStylePlain];
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    self.myTableView = myTableView;
   
    WeakSelf(weakSelf);
    _myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getDataIsDown:YES];
    }];
    _myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page +=1;
        [weakSelf getDataIsDown:NO];
    }];
}
-(void)setTableTyp:(NSString *)tableTyp
{
    _tableTyp = tableTyp;
    if ([_tableTyp isEqualToString:@"好友"]) {
        _type = @"1";
    }
    if ([_tableTyp isEqualToString:@"关注"]) {
        _type = @"2";
    }
    if ([_tableTyp isEqualToString:@"粉丝"]) {
        _type = @"3";
    }
    
}
#pragma mark -- tableViewDelegate  &&  tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableDataArr.count ==0?1:_tableDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _tableDataArr.count ==0?100:80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyFriendCell";
    static NSString *nullCellIdentifier = @"NullAddressCell";

    if (_tableDataArr.count == 0) {
        CardNullTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nullCellIdentifier];
        if (cell == nil) {
            cell = [[CardNullTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nullCellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([_tableTyp isEqualToString:@"好友"]) {
            cell.myImageView.image = [UIImage imageNamed:@"NullFous"];
            cell.nameLabel.text = @"还没有互相关注的好友哦~";
        }
        if ([_tableTyp isEqualToString:@"关注"]) {
            cell.myImageView.image = [UIImage imageNamed:@"AndFocus"];
            cell.nameLabel.text = @"你还没有关注任何人~";
        }
        if ([_tableTyp isEqualToString:@"粉丝"]) {
            cell.myImageView.image = [UIImage imageNamed:@"NullFans"];
            cell.nameLabel.text = @"你还没有粉丝，快去发动态吸粉吧~";
        }
        return cell;
    }else{
        
        MyFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[MyFriendCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        
        ListModel *model = _tableDataArr[indexPath.row];
        cell.model = model;
        
        cell.focusBtn.tag = 1000 + indexPath.row;
        [cell.focusBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        if ([_tableTyp isEqualToString:@"关注"]) {
            if (!model.is_following) {
                [cell.focusBtn setImage:[UIImage imageNamed:@"FousBtn"] forState:UIControlStateNormal];
            } else {
                [cell.focusBtn setImage:[UIImage imageNamed:model.is_mutual?@"EachFous":@"AlreadyFous"] forState:UIControlStateNormal];
            }
        }
        if ([_tableTyp isEqualToString:@"粉丝"]) {
            [cell.focusBtn setImage:[UIImage imageNamed:model.is_following?@"AlreadyFous": @"FousBtn"] forState:UIControlStateNormal];
        }
        if ([_tableTyp isEqualToString:@"好友"]) {
            cell.focusBtn.hidden = YES;
        }
        
        return cell;
    }
}

-(void)buttonAction:(UIButton *)btn
{
    [self fous:btn.selected btn:btn];
}
-(void)fous:(BOOL)selected btn:(UIButton *)btn
{
    ListModel *model = _tableDataArr[btn.tag - 1000];
    NSString *urlStr = [NetRequest UserFollow];
    NSDictionary *paramsDic = @{@"token":  [[NSUserDefaults standardUserDefaults] objectForKey:kToken],@"follow":[NSString stringWithFormat:@"%d",!model.is_following],@"following_id":model.uid};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        CircleModel *circleModel = [CircleModel yy_modelWithJSON:JSON];
        [MyTool showHUDWithStr:circleModel.msg];
        if ([circleModel.error integerValue] == 0) {
            model.is_following = !model.is_following;
            if ([_type isEqualToString:@"2"]) {
                model.is_mutual = !model.is_mutual;
            }
            [_tableDataArr replaceObjectAtIndex:btn.tag - 1000 withObject:model];
            
            NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:btn.tag-1000 inSection:0];
            [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ListModel *model = _tableDataArr[indexPath.row];
    model.is_new_one = NO;
    [_tableDataArr replaceObjectAtIndex:indexPath.row withObject:model];
    NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [_myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    MyCardViewController *myCardVC = [[MyCardViewController alloc] init];
    myCardVC.hidesBottomBarWhenPushed = YES;
    myCardVC.title = model.username;
    myCardVC.uid = model.id;
    myCardVC.type = 1;
    myCardVC.isNews = model.is_news;
    [[MyTool topViewController].navigationController pushViewController:myCardVC animated:YES];
}

-(void)getDataIsDown:(BOOL)down
{
    NSString *urlStr = [NetRequest MyFriendsList];
    NSDictionary *paramsDic = @{@"token":  [[NSUserDefaults standardUserDefaults] objectForKey:kToken],@"pn":[NSString stringWithFormat:@"%ld",_page],@"type":_type};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        CircleModel *model = [CircleModel yy_modelWithJSON:JSON];
        if ([model.error integerValue] == 0) {
            if (down) {
                _tableDataArr = [model.data.list mutableCopy];
            }else{
                _tableDataArr = [[_tableDataArr arrayByAddingObjectsFromArray:model.data.list]mutableCopy];
            }
            [_myTableView reloadData];
            [_myTableView.mj_header endRefreshing];
            model.data.paging.is_end == YES?[_myTableView.mj_footer endRefreshingWithNoMoreData]:[_myTableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSError *error) {
        [_myTableView.mj_header endRefreshing];
        [_myTableView.mj_footer endRefreshing];
    }];
}
@end
