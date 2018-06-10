//
//  HomeFousTwoController.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/5/2.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "HomeFousTwoController.h"
#import "CardNullTableViewCell.h"
#import "HomeOnePictureCell.h"
#import "HomeFourPictureCell.h"
#import "HomeScratchableLatexCell.h"
#import "HomeRecommendCell.h"
#import "HomeBannerCell.h"
#import "CircleDetailTwoViewController.h"
#import "HomeTextCell.h"
#import "LongAtricleDetailsTwoController.h"
#import "DynamicDetailsViewController.h"
#import "DynamicDetailsTwoController.h"
#import "HomeLongArticlesCell.h"
#import <React/RCTRootView.h>

@interface HomeFousTwoController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *tableDataArr; //数据数组
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL beingLoaded; //正在加载更多
@property (nonatomic, assign) BOOL more; //还有更多数据
@end

@implementation HomeFousTwoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
}

- (void)createUI
{
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
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
        weakSelf.page = 1;
        [weakSelf getDataIsDown:YES];
    }];
    [_myTableView.mj_header beginRefreshing];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:nil];
    [footer setTitle:@"已经到底了~" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = [MyTool colorWithString:@"999999"];
    self.myTableView.mj_footer = footer;
}
-(void)getDataIsDown:(BOOL)down
{
    NSString *urlStr = [NetRequest HomeFous];
    NSDictionary *paramsDic = @{ @"limit": @"20", @"pn":[NSString stringWithFormat:@"%ld",_page]};
    if (!down) {
        _beingLoaded = YES;
    }
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        
        CircleModel *model = [CircleModel yy_modelWithJSON:JSON];
        
        if (_page == 1) {
            _tableDataArr = [NSMutableArray array];
        }
        
        if ([model.error integerValue] == 0) {
            model.data.paging.is_end == NO? _more = YES:NO;
            if (down) {
                _tableDataArr = model.data.list.mutableCopy;
            }else{
                _beingLoaded = NO;
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
//请求点赞、取消点赞
-(void)requestPraiseDynamic:(BOOL)isLiske indexPath:(NSIndexPath *)indexPath model:(ListModel *)model praiseButton:(UIButton *)praiseButton
{
    NSString *urlStr = [NetRequest DynamicPraise];
    NSDictionary *paramsDic = @{@"type":@"0",@"id":model.id,@"like":[NSString stringWithFormat:@"%d",!isLiske]};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        CircleModel *model = [CircleModel yy_modelWithJSON:JSON];
        if ([model.error integerValue] == 0) {
            ((ListModel *)_tableDataArr[indexPath.row]).has_like = !((ListModel *)_tableDataArr[indexPath.row]).has_like;
            
            if (praiseButton.selected) {
                if ([praiseButton.titleLabel.text intValue] == 1) {
                    [praiseButton setTitle:@"点赞" forState:UIControlStateNormal];
                }else{
                    [praiseButton setTitle:[NSString stringWithFormat:@"%d",[praiseButton.titleLabel.text intValue] - 1] forState:UIControlStateNormal];
                }
            }else{
                [praiseButton setTitle:[NSString stringWithFormat:@"%d",[praiseButton.titleLabel.text intValue] + 1] forState:UIControlStateSelected];
            }
            praiseButton.selected = !praiseButton.selected;
        }else{
            [MyTool showHUDWithStr:model.msg];
        }
    } failure:^(NSError *error) {
    }];
}
#pragma mark -- tableViewDelegate  &&  tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListModel *model = _tableDataArr[indexPath.row];

    if ([model.type isEqualToString:@"18"]) {
        return [self.myTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HomeLongArticlesCell class] contentViewWidth:kScreenW];
    }else{
          return [tableView cellHeightForIndexPath:indexPath cellContentViewWidth:kScreenW tableView:_myTableView];
    }
//    if (model.covers.count == 0) {
//        return [self.myTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HomeTextCell class] contentViewWidth:kScreenW];
//        
//    }else if (model.covers.count == 1){
//        return [self.myTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HomeOnePictureCell class] contentViewWidth:kScreenW];
//        
//    }else if (model.covers.count == 4){
//        return [self.myTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HomeFourPictureCell class] contentViewWidth:kScreenW];
//    }else{
//        return [self.myTableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[HomeScratchableLatexCell class] contentViewWidth:kScreenW];
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *onePictureCellIdentifier = @"onePictureCellIdentifier";
    static NSString *cellINullDID = @"CardNullTableViewCell";
    static NSString *homeTextCellIdentifier = @"homeTextCellIdentifier";
    static NSString *homeFourPictureCellIdentifier = @"homeFourPictureCellIdentifier";
    static NSString *homeScratchableLatexCellIdentifier = @"homeScratchableLatexCellIdentifier";
    static NSString *homeLongArticlesCellIdentifier = @"homeLongArticlesCellIdentifier";
    WeakSelf(weakSelf)

    if (_tableDataArr.count ==0) {
        CardNullTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellINullDID];
        if (cell == nil) {
            cell = [[CardNullTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellINullDID];
        }
        cell.nameLabel.text = @"空空如也~";
        cell.myImageView.image = [UIImage imageNamed:@"Group 5"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        ListModel *model = _tableDataArr[indexPath.row];
        if ([model.type isEqualToString:@"18"]) {
            HomeLongArticlesCell *cell = [tableView dequeueReusableCellWithIdentifier:homeLongArticlesCellIdentifier];
            if (cell == nil) {
                cell = [[HomeLongArticlesCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeLongArticlesCellIdentifier];
            }
            cell.model = model;
            cell.praiseButtonClickedBlock = ^(UIButton *praiseButton) {
                [weakSelf requestPraiseDynamic:praiseButton.selected indexPath:indexPath model:model praiseButton:praiseButton];
            };
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            if (model.covers.count == 0) {
                //无图
                HomeTextCell *cell = [tableView dequeueReusableCellWithIdentifier:homeTextCellIdentifier];
                if (cell == nil) {
                    cell = [[HomeTextCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeTextCellIdentifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.model = model;
                cell.praiseButtonClickedBlock = ^(UIButton *praiseButton) {
                    [weakSelf requestPraiseDynamic:praiseButton.selected indexPath:indexPath model:model praiseButton:praiseButton];
                };
                return cell;
            }else if(model.covers.count == 1){
                //单图
                HomeOnePictureCell *cell = [tableView dequeueReusableCellWithIdentifier:onePictureCellIdentifier];
                if (cell == nil) {
                    cell = [[HomeOnePictureCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:onePictureCellIdentifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.model = model;
                cell.praiseButtonClickedBlock = ^(UIButton *praiseButton) {
                    [weakSelf requestPraiseDynamic:praiseButton.selected indexPath:indexPath model:model praiseButton:praiseButton];
                };
                return cell;
            }else if(model.covers.count == 4){
                //四图
                HomeFourPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:homeFourPictureCellIdentifier];
                if (cell == nil) {
                    cell = [[HomeFourPictureCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeFourPictureCellIdentifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.model = model;
                cell.praiseButtonClickedBlock = ^(UIButton *praiseButton) {
                    [weakSelf requestPraiseDynamic:praiseButton.selected indexPath:indexPath model:model praiseButton:praiseButton];
                };
                return cell;
                
            }else{
                //九宫格
                HomeScratchableLatexCell *cell = [tableView dequeueReusableCellWithIdentifier:homeScratchableLatexCellIdentifier];
                if (cell == nil) {
                    cell = [[HomeScratchableLatexCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeScratchableLatexCellIdentifier];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.model = model;
                cell.praiseButtonClickedBlock = ^(UIButton *praiseButton) {
                    [weakSelf requestPraiseDynamic:praiseButton.selected indexPath:indexPath model:model praiseButton:praiseButton];
                };
                return cell;
            }
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ListModel *listModel = _tableDataArr[indexPath.row];
//
//    if ([listModel.type isEqualToString:@"18"]) {
//        LongAtricleDetailsTwoController *vc = [[LongAtricleDetailsTwoController alloc]init];
//        vc.articleId = listModel.id;
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }else{
//        DynamicDetailsTwoController *vc = [[DynamicDetailsTwoController alloc]init];
//        //        vc.hidesBottomBarWhenPushed = YES;
//        vc.model = listModel;
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }
    [self test];

}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //首先判断是否还有可以刷新的数据
    
    if (indexPath.row==(_tableDataArr.count-5) && !_beingLoaded &&_more &&_tableDataArr.count >=20) {  //如果当用户滑动到倒数第五个的时候，而且当前请求已经结束的时候，去加载更多的数据。
        self.page +=1;
        [self getDataIsDown:NO];
    }
    
}
-(void)test
{
    NSURL *jsCodeLocation = [NSURL
                             URLWithString:@"http://localhost:8081/index.bundle?platform=ios"];
    RCTRootView *rootView =
    [[RCTRootView alloc] initWithBundleURL : jsCodeLocation
                         moduleName        : @"RNfantuanC"
                         initialProperties :
     @{
       @"scores" : @[
               @{
                   @"name" : @"Alex",
                   @"value": @"42"
                   },
               @{
                   @"name" : @"Joel",
                   @"value": @"10"
                   }
               ]
       }
                          launchOptions    : nil];
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view = rootView;
    [self presentViewController:vc animated:YES completion:nil];
}
@end
