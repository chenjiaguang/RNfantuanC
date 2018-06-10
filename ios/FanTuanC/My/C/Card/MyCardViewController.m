//
//  MyCardViewController.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/3/2.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "MyCardViewController.h"
#import "CardHeaderTableViewCell.h"
#import "NewsOnePicTableViewCell.h"
#import "NewsThreePicTableViewCell.h"
#import "NewsPicTableViewCell.h"
#import "CardLongArticleCellCell.h"
#import "CardNullTableViewCell.h"
#import "CardOnePicTableViewCell.h"
#import "CardFourPicTableViewCell.h"
#import "CardOtherPicTableViewCell.h"
#import "CardTextTableViewCell.h"
#import "MyAddCardTableViewCell.h"
#import "DynamicDetailsTwoController.h"
#import "VPImageCropperViewController.h"
#import "NewsPicDetailViewController.h"
#import "LongArticleDetailsController.h"
#import "UINavigationBar+Awesome.h"
#import "QYPiecewiseView.h"
#import "ReleaseDynamicViewController.h"
#import "LongTextEditViewController.h"
#import "RootNavigationController.h"

static NSString *cardHeaderIdentifier = @"cardHeaderIdentifier";
static NSString *newsOnePicIdentifier = @"newsOnePicIdentifier";
static NSString *newsThreePicIdentifier = @"newsThreePicIdentifier";
static NSString *newsPicCellIdentifier = @"newsPicCellIdentifier";
static NSString *cardOnePicIdentifier = @"cardOnePicIdentifier";
static NSString *cardFourPicIdentifier = @"cardFourPicIdentifier";
static NSString *cardOtherPicIdentifier = @"cardOtherPicIdentifier";
static NSString *cardTextIdentifier = @"cardTextIdentifier";
static NSString *longArticleCellIdentifier = @"CardLongArticleCellCell";
static NSString *addCardIdentifier = @"addCardIdentifier";
static NSString *cardNullIdentifier = @"cardNullIdentifier";

@interface MyCardViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, VPImageCropperDelegate>
{
    CGFloat _alpha;
    
    UIButton *_rightBtn;
    UIButton *_backBtn;
    
    UITableView *_myTableView;
    UIButton *_followBtn;
    
    NSMutableArray *_listArr;
    NSMutableDictionary *_userDataDic;
    
    BOOL _isFollow;
    BOOL _isOwner;
    BOOL _has_articles;
    NSString *_lastYear;
}

@property (nonatomic, strong) NSURLSessionDataTask *tesk;

@end

@implementation MyCardViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:_alpha==1?UIStatusBarStyleDefault:UIStatusBarStyleLightContent animated:YES];
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:_alpha]];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar lt_reset];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    _lastYear = @"";
    _isFollow = NO;
    _isOwner = NO;
    _isChangeType = NO;
    _has_articles = NO;
    _pageNum = 1;
    _listArr = [NSMutableArray array];
    _userDataDic = [NSMutableDictionary dictionary];
    
    [self createBackButton];
    [self createTableView];
    
    [self loadingWithText:@"加载中"];
    [self getData];
    [self addMyCardFooter];
}

- (void)createBackButton
{
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, 0, 44, 60);
    [_backBtn setImage:[UIImage imageNamed:_alpha == 1?@"返回":@"导航栏白色返回"] forState:UIControlStateNormal];
    _backBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_backBtn];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = [UIColor whiteColor];
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > kScreenW-140) {
        _alpha = MIN(1, 1 - ((kScreenW-140 + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:_alpha]];
        self.navigationItem.title = _titleStr;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        [_rightBtn setImage:[UIImage imageNamed:@"circleDot"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    } else {
        _alpha = 0;
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
        self.navigationItem.title = @"";
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [_rightBtn setImage:[UIImage imageNamed:@"DotWhite"] forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:@"导航栏白色返回"] forState:UIControlStateNormal];
    }
}

#pragma mark - 点击头部背景图片
- (void)tapBgImageViewAction:(UITapGestureRecognizer *)tap
{
    if (_isOwner) {
        UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [action showInView:self.view];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if (actionSheet.tag == 1000) {
            [self releaseTheDynamic];
        } else {
            [self getImageFromIpcWithCamera:YES];
        }
    } else if (buttonIndex == 1) {
        if (actionSheet.tag == 1000) {
            [self releaseLongText];
        } else {
            [self getImageFromIpcWithCamera:NO];
        }
    }
}

- (void)createTableView
{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -kScreenW/4, kScreenW, kScreenH+kScreenW/4-50) style:UITableViewStyleGrouped];
    _myTableView.backgroundColor = [UIColor whiteColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myTableView];
    
    if (@available(iOS 11.0, *)) {
        _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    // 添加关注按钮
    _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _followBtn.frame = CGRectMake(0, CGRectGetMaxY(_myTableView.frame), kScreenW, 50);
    _followBtn.userInteractionEnabled = YES;
    _followBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _followBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.5)];
    line.backgroundColor = [MyTool colorWithString:@"e5e5e5"];
    [_followBtn addSubview:line];
    [_followBtn addTarget:self action:@selector(followBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_followBtn];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(0, 0, 44, 60);
    [_rightBtn setImage:[UIImage imageNamed:@"DotWhite"] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(moreCircle) forControlEvents:UIControlEventTouchUpInside];
    _rightBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)moreCircle
{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    WeakSelf(weakSelf);
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf selectDeleteWithTitle:@"选择举报原因"];

    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVc addAction:deleteAction];
    [alertVc addAction:cancelAction];
    
    [self presentViewController:alertVc animated:YES completion:^{
        
        
    }];
    
}
-(void)selectDeleteWithTitle:(NSString *)title
{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];//UIAlertControllerStyleActionSheet
    
    WeakSelf(weakSelf);
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"账号昵称含有害信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf requestToReportWithType:@"0" Type_id:_uid Content:@"账号昵称含有害信息"];
        
    }];
    UIAlertAction *sureAction1 = [UIAlertAction actionWithTitle:@"发布淫秽色情等有害信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf requestToReportWithType:@"0" Type_id:_uid Content:@"发布淫秽色情等有害信息"];

        
    }];
    UIAlertAction *sureAction2 = [UIAlertAction actionWithTitle:@"头像图片有问题" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf requestToReportWithType:@"0" Type_id:_uid Content:@"头像图片有问题"];

        
    }];
    UIAlertAction *sureAction3 = [UIAlertAction actionWithTitle:@"存在侵权信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf requestToReportWithType:@"0" Type_id:_uid Content:@"账存在侵权信息"];

        
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVc addAction:sureAction];
    [alertVc addAction:sureAction1];
    [alertVc addAction:sureAction2];
    [alertVc addAction:sureAction3];
    [alertVc addAction:cancelAction];
    [self presentViewController:alertVc animated:YES completion:^{
        
        
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
#pragma mark - 关注按钮点击事件
- (void)followBtnAction:(UIButton *)btn
{
    [self getFollowData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0?1:_listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || _has_articles == NO) {
        return 0;
    }
    return 84;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 84)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    QYPiecewiseView *piecewiseView = [[QYPiecewiseView alloc] initWithFrame:CGRectMake(15, 40, kScreenW - 30, 44) tittleArr:@[@"动态", @"头条"].mutableCopy font:[UIFont systemFontOfSize:18] defaultIndex:_type-1];
    piecewiseView.selectedButtonBlock = ^(NSString *buttonTag) {
        _isChangeType = YES;
        _pageNum = 1;
        _type = [buttonTag isEqualToString:@"头条"]?2:1;
        [self getData];
    };
    [bgView addSubview:piecewiseView];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 83.5, kScreenW, 0.5)];
    bottomLine.backgroundColor = [MyTool colorWithString:@"E5E5E5"];
    [bgView addSubview:bottomLine];
    
    return _has_articles?bgView:[UIView new];
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
    if (indexPath.section == 0) {
        return [tableView cellHeightForIndexPath:indexPath model:_userDataDic keyPath:@"dataDic" cellClass:[CardHeaderTableViewCell class] contentViewWidth:kScreenW];
    }
    // cell的高度计算
    if ([_listArr[indexPath.row][@"type"] isEqualToString:@"1"]) {
        return [tableView cellHeightForIndexPath:indexPath model:_listArr[indexPath.row] keyPath:@"dataDic" cellClass:[NewsOnePicTableViewCell class] contentViewWidth:kScreenW];
    } else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"3"]){
        return [tableView cellHeightForIndexPath:indexPath model:_listArr[indexPath.row] keyPath:@"dataDic" cellClass:[NewsThreePicTableViewCell class] contentViewWidth:kScreenW];
    } else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"2"]){
        return [tableView cellHeightForIndexPath:indexPath model:_listArr[indexPath.row] keyPath:@"dataDic" cellClass:[NewsPicTableViewCell class] contentViewWidth:kScreenW];
    } else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"19"]) {
        return [tableView cellHeightForIndexPath:indexPath model:_listArr[indexPath.row] keyPath:@"dataDic" cellClass:[CardOtherPicTableViewCell class] contentViewWidth:kScreenW];
    } else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"10"]) {
        return [tableView cellHeightForIndexPath:indexPath model:_listArr[indexPath.row] keyPath:@"dataDic" cellClass:[CardTextTableViewCell class] contentViewWidth:kScreenW];
    } else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"18"]){
        return [tableView cellHeightForIndexPath:indexPath model:_listArr[indexPath.row] keyPath:@"dataDic" cellClass:[CardLongArticleCellCell class] contentViewWidth:kScreenW];
    } else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"14"]) {
        return [tableView cellHeightForIndexPath:indexPath model:_listArr[indexPath.row] keyPath:@"dataDic" cellClass:[CardFourPicTableViewCell class] contentViewWidth:kScreenW];
    } else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"11"]) {
        return [tableView cellHeightForIndexPath:indexPath model:_listArr[indexPath.row] keyPath:@"dataDic" cellClass:[CardOnePicTableViewCell class] contentViewWidth:kScreenW];
    } else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"000"]) {
        // 自己的名片页面添加加号
        return 117;
    }
    // 空界面样式
    return 275;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CardHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cardHeaderIdentifier];
        if (cell == nil) {
            cell = [[CardHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cardHeaderIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.dataDic = _userDataDic;
        return cell;
    }
    if ([_listArr[indexPath.row][@"type"] isEqualToString:@"1"]) {
        NewsOnePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newsOnePicIdentifier];
        if (cell == nil) {
            cell = [[NewsOnePicTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:newsOnePicIdentifier];
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
    } else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"3"]) {
        NewsThreePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:newsThreePicIdentifier];
        if (cell == nil) {
            cell = [[NewsThreePicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newsThreePicIdentifier];
        }
        
        cell.dataDic = _listArr[indexPath.row];
        return cell;
    } else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"19"]) {
        CardOtherPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cardOtherPicIdentifier];
        if (cell == nil) {
            cell = [[CardOtherPicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cardOtherPicIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.dataDic = _listArr[indexPath.row];
        cell.praiseBtn.tag = 3000+indexPath.row;
        [cell.praiseBtn addTarget:self action:@selector(praiseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }  else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"10"]) {
        CardTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cardTextIdentifier];
        if (cell == nil) {
            cell = [[CardTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cardTextIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.dataDic = _listArr[indexPath.row];
        cell.praiseBtn.tag = 3000+indexPath.row;
        [cell.praiseBtn addTarget:self action:@selector(praiseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"18"]) {
        CardLongArticleCellCell *cell = [tableView dequeueReusableCellWithIdentifier:longArticleCellIdentifier];
        if (cell == nil) {
            cell = [[CardLongArticleCellCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:longArticleCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.dataDic = _listArr[indexPath.row];
        cell.praiseBtn.tag = 3000+indexPath.row;
        [cell.praiseBtn addTarget:self action:@selector(praiseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"14"]) {
        CardFourPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cardFourPicIdentifier];
        if (cell == nil) {
            cell = [[CardFourPicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cardFourPicIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.dataDic = _listArr[indexPath.row];
        cell.praiseBtn.tag = 3000+indexPath.row;
        [cell.praiseBtn addTarget:self action:@selector(praiseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"11"]) {
        CardOnePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cardOnePicIdentifier];
        if (cell == nil) {
            cell = [[CardOnePicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cardOnePicIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.dataDic = _listArr[indexPath.row];
        cell.praiseBtn.tag = 3000+indexPath.row;
        [cell.praiseBtn addTarget:self action:@selector(praiseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"000"]) {
        MyAddCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addCardIdentifier];
        if (cell == nil) {
            cell = [[MyAddCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addCardIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.myBtn addTarget:self action:@selector(myBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell.myBtn setImage:[UIImage imageNamed:_listArr[indexPath.row][@"image"]] forState:UIControlStateNormal];
        
        return cell;
    }  else if ([_listArr[indexPath.row][@"type"] isEqualToString:@"null"]) {
        CardNullTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addCardIdentifier];
        if (cell == nil) {
            cell = [[CardNullTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addCardIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.myImageView.image = [UIImage imageNamed:@"社交名片动态Null"];
        cell.nameLabel.text = _listArr[indexPath.row][@"image"];
        
        return cell;
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"tableViewCell"];
        }
        
        return cell;
    }
}

#pragma mark - 点击添加
- (void)myBtnAction:(UIButton *)btn
{
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"动态",@"长文", nil];
    action.tag = 1000;
    [action showInView:self.view];
}

- (void)releaseTheDynamic
{
    ReleaseDynamicViewController *reDynamicVC = [[ReleaseDynamicViewController alloc] init];
    reDynamicVC.circle_id = @"";
    reDynamicVC.ProgressBlock = ^(CGFloat progress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (progress==100) {
                [UpdataSingleton sharedInstance].isUploading = NO;
            } else {
                [UpdataSingleton sharedInstance].isUploading = YES;
            }
        });
    };
    RootNavigationController *naVC = [[RootNavigationController alloc] initWithRootViewController:reDynamicVC];
    [self presentViewController:naVC animated:YES completion:nil];
}

- (void)releaseLongText
{
    LongTextEditViewController *longTextEditVC = [[LongTextEditViewController alloc] init];
    longTextEditVC.circle_id = @"";
    longTextEditVC.formText = @"";
    longTextEditVC.ProgressBlock = ^(CGFloat progress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (progress==100) {
                [UpdataSingleton sharedInstance].isUploading = NO;
            } else {
                [UpdataSingleton sharedInstance].isUploading = YES;
            }
        });
    };
    longTextEditVC.uploadCompleteBlock = ^{
    };
    RootNavigationController *naVC = [[RootNavigationController alloc] initWithRootViewController:longTextEditVC];
    [self presentViewController:naVC animated:YES completion:nil];
}

#pragma mark - 点击点赞按钮
- (void)praiseBtnAction:(UIButton *)btn
{
    NSInteger index = btn.tag - 3000;
    BOOL has_like = ![_listArr[index][@"has_like"] boolValue];
    NSMutableDictionary *dic = [_listArr[index] mutableCopy];
    [dic setObject:[NSString stringWithFormat:@"%d", has_like] forKey:@"has_like"];
    [dic setObject:[NSString stringWithFormat:@"%ld", has_like ? [dic[@"like_num"] integerValue] + 1 : [dic[@"like_num"] integerValue] - 1] forKey:@"like_num"];
    [_listArr replaceObjectAtIndex:index withObject:dic];

    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
    [_myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self getLikeDataWithIndex:index];
}

#pragma mark - 点击cell的店铺
- (void)shopBtnAction:(UIButton *)btn
{
    BusinessDetailsViewController *businessDetailsVC = [[BusinessDetailsViewController alloc] init];
    businessDetailsVC.mid = _listArr[btn.tag - 1000][@"mid"];
    businessDetailsVC.nameStr = _listArr[btn.tag - 1000][@"name"];
    [self.navigationController pushViewController:businessDetailsVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 || [_listArr[indexPath.row][@"type"] isEqualToString:@"000"] || [_listArr[indexPath.row][@"type"] isEqualToString:@"null"]) {
        return;
    }
    
    if (_type == 1) {
        if ([_listArr[indexPath.row][@"type"] isEqualToString:@"18"]) {
            LongArticleDetailsController *vc = [[LongArticleDetailsController alloc]init];
            vc.articleId = _listArr[indexPath.row][@"id"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            DynamicDetailsTwoController *vc = [[DynamicDetailsTwoController alloc]init];
            vc.model = [ListModel yy_modelWithJSON:_listArr[indexPath.row]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (_type == 2) {
        if ([_listArr[indexPath.row][@"type"] isEqualToString:@"2"]) {
            NewsPicDetailViewController *newsPicDetailVC = [[NewsPicDetailViewController alloc] init];
            newsPicDetailVC.article_id = _listArr[indexPath.row][@"id"];
            newsPicDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newsPicDetailVC animated:YES];
        } else {
            MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
            myWebVC.urlStr = _listArr[indexPath.row][@"article_url"];
            myWebVC.isNewsDetail = YES;
            myWebVC.title = _listArr[indexPath.row][@"news_name"];
            myWebVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:myWebVC animated:YES];
        }
    }
}

- (void)getData
{
    NSString *urlStr = [NetRequest Social];
    NSDictionary *paramsDic = @{@"id": _uid, @"type": [NSString stringWithFormat:@"%ld", _type], @"pn": [NSString stringWithFormat:@"%ld", _pageNum], @"limit":@"20", @"lastYear":_lastYear};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] == YES ? [[NSUserDefaults standardUserDefaults] objectForKey:kToken] : @"" forHTTPHeaderField:@"token"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain",nil];
    [_tesk cancel];
    _tesk = [manager POST:urlStr parameters:paramsDic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self endLoading];
        NSDictionary *JSON = responseObject;
        if ([[JSON objectForKeyNotNull:@"error"] integerValue] == 0) {
            
            _lastYear = JSON[@"data"][@"lastYear"];
            
            if (_pageNum == 1) {
                _userDataDic = [JSON[@"data"][@"user"] mutableCopy];
                _has_articles = [_userDataDic[@"has_articles"] boolValue];
            }
            
            // 关注按钮
            _isFollow = [JSON[@"data"][@"user"][@"is_follow"] boolValue];
            if (_isFollow) {
                [_followBtn setTitle:@"已关注" forState:UIControlStateNormal];
                [_followBtn setTitleColor:[MyTool colorWithString:@"999999"] forState:UIControlStateNormal];
            } else {
                [_followBtn setTitle:@"加关注" forState:UIControlStateNormal];
                [_followBtn setTitleColor:[MyTool colorWithString:@"333333"] forState:UIControlStateNormal];
            }
            [_followBtn setImage:[UIImage imageNamed:_followBtn.titleLabel.text] forState:UIControlStateNormal];
            
            if (_isChangeType == YES) {
                [_listArr removeAllObjects];
                _isChangeType = NO;
            }
            
            // 判断是不是本人
            _isOwner = [JSON[@"data"][@"user"][@"is_owner"] boolValue];
            if (_isOwner) {
                _followBtn.hidden = YES;
                _rightBtn.hidden = YES;
                _myTableView.frame = CGRectMake(0, -kScreenW/4, kScreenW, kScreenH+kScreenW/4);
                if (_type == 1) {
                    [_listArr addObject:@{@"type": @"000", @"image": @"社交名片添加"}];
                }
            }
            
            [_listArr addObjectsFromArray:[JSON[@"data"][@"list"] mutableCopy]];
            
            _listArr.count == 0 ? [_listArr addObject:@{@"type": @"null", @"image": @"暂无动态"}]:NULL;
            
            _isChangeType?[_myTableView reloadSections:[[NSIndexSet alloc] initWithIndex:1] withRowAnimation:UITableViewRowAnimationNone]:[_myTableView reloadData];
            [_myTableView.mj_footer endRefreshing];
            if ([JSON[@"data"][@"paging"][@"is_end"] boolValue] == YES) {
                [_myTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self endLoading];
    }];
}

- (void)getLikeDataWithIndex:(NSInteger)index
{
    NSString *urlStr = [NetRequest DynamicPraise];
    NSDictionary *paramsDic = @{@"type": @"0", @"like": [NSString stringWithFormat:@"%d", [_listArr[index][@"has_like"] boolValue]], @"id": _listArr[index][@"id"]};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
    } failure:^(NSError *error) {
    }];
}

- (void)getFollowData
{
    NSString *urlStr = [NetRequest UserFollow];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"following_id": _uid, @"follow": [NSString stringWithFormat:@"%d", !_isFollow]};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [MyTool showHUDWithStr:JSON[@"msg"]];
        if ([JSON[@"error"] boolValue] == 0) {
            if (!_isFollow) {
                [_followBtn setTitle:@"已关注" forState:UIControlStateNormal];
                [_followBtn setTitleColor:[MyTool colorWithString:@"999999"] forState:UIControlStateNormal];
            } else {
                [_followBtn setTitle:@"加关注" forState:UIControlStateNormal];
                [_followBtn setTitleColor:[MyTool colorWithString:@"333333"] forState:UIControlStateNormal];
            }
            [_followBtn setImage:[UIImage imageNamed:_followBtn.titleLabel.text] forState:UIControlStateNormal];
            
            _isFollow = !_isFollow;
        }
    } failure:^(NSError *error) {
    }];
}

- (void)addMyCardFooter
{
    __block MyCardViewController *myCardVC = self;
    
    MJRefreshAutoNormalFooter *footer  = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        myCardVC.pageNum++;
        
        [self getData];
    }];
    
    [footer setTitle:@"已经到底了~" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.textColor = [MyTool colorWithString:@"999999"];
    _myTableView.mj_footer = footer;
}

// 获取系统相册图片
- (void)getImageFromIpcWithCamera:(BOOL)isCamera
{
    // 1.判断相册是否可以打开
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    // 2. 创建图片选择控制器
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    /**
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
     UIImagePickerControllerSourceTypePhotoLibrary, // 相册
     UIImagePickerControllerSourceTypeCamera, // 用相机拍摄获取
     UIImagePickerControllerSourceTypeSavedPhotosAlbum // 相簿
     }
     */
    // 3. 设置打开照片相册类型(显示所有相簿)
    if (isCamera) {
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    // ipc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    // 照相机
    // ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 4.设置代理
    ipc.delegate = self;
    // 5.modal出这个控制器
    [self presentViewController:ipc animated:YES completion:nil];
}

#pragma mark -- <UIImagePickerControllerDelegate>--
// 获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 销毁控制器
    [picker dismissViewControllerAnimated:NO completion:^{
        
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:info[UIImagePickerControllerOriginalImage] cropFrame:CGRectMake(0, (kScreenH - 282 * Swidth) / 2, kScreenW, 282 * Swidth) limitScaleRatio:kScreenW / 282 * Swidth];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:nil];
    }];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    // 设置图片
//    _cardHeaderV.BgImgV.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
    [self uploadImage:editedImage];
}
- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 上传图片
- (void)uploadImage:(UIImage *)image
{
    [self loadingWithText:@"上传图片中"];
    NSString *urlStr = [NetRequest ImageUpload];
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //2.上传文件
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken]};
    [manager POST:urlStr parameters:paramsDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // UIImagePNGRepresentation(image)
        NSData *imageData = UIImageJPEGRepresentation(image, 0.01);
        [formData appendPartWithFileData:imageData name:@"images" fileName:@"images.png" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKeyNotNull:@"error"] integerValue] == 0) {
            [self getImageUpdateWithcoverID:responseObject[@"data"][@"id"][0]];
        } else {
            [self endLoading];
            [MyTool showHUDWithStr:responseObject[@"msg"]];
        }
        NSLog(@"请求成功：%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self endLoading];
        NSLog(@"请求失败：%@",error);
    }];
}

- (void)getImageUpdateWithcoverID:(NSString *)coverID
{
    NSString *urlStr = [NetRequest UserProfileUpdateCover];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"cover": coverID};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [self endLoading];
        [MyTool showHUDWithStr:@"上传成功"];
    } failure:^(NSError *error) {
        [self endLoading];
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
