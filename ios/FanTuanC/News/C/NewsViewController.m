//
//  NewsViewController.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/1/26.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "NewsViewController.h"
#import "LXScrollContentView.h"
#import "LXSegmentTitleView.h"
#import "XLChannelControl.h"
#import "NewsTableViewController.h"
#import "NewProjectController.h"
@interface NewsViewController ()<LXSegmentTitleViewDelegate,LXScrollContentViewDelegate>

@property (nonatomic, strong) NSMutableArray *inUseTitles;
@property (nonatomic, strong) NSMutableArray *unUseTitles;

@property (nonatomic, strong) LXSegmentTitleView *titleView;
@property (nonatomic, strong) LXScrollContentView *contentView;

@property (nonatomic, strong) NSMutableArray *vcs;
@property (nonatomic, assign) NSInteger index;

@end

@implementation NewsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    self.jz_navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.jz_navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _index = 1;
    [self createTitleView];
    [self reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNewsViewData:) name:reloadNewsViewData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNewsTitleList:) name:reloadNewsTitleList object:nil];
    
    
}

- (void)reloadNewsViewData:(NSNotification *)notification
{
    if ([[notification object] integerValue] == 1) {
        NewsTableViewController *newsTableVC = _vcs[_index];
        [newsTableVC reloadNewsData];
    }
}

- (void)reloadNewsTitleList:(NSNotification *)notification
{
    _index = 0;
    [self reloadData];
}

- (void)createTitleView
{
    UIView *naView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, iPhoneX?88:64)];
    naView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:naView];
    
    
    self.titleView = [[LXSegmentTitleView alloc] initWithFrame:CGRectZero];
    self.titleView.itemMinMargin = 20.f;
    self.titleView.indicatorHeight = 3.f;
    self.titleView.indicatorExtraW = 3.f;
    self.titleView.titleFont = [UIFont systemFontOfSize:17.f];
    self.titleView.titleNormalColor = [MyTool colorWithString:@"666666"];
    self.titleView.titleSelectedColor = [MyTool colorWithString:@"333333"];
    self.titleView.indicatorColor = [MyTool colorWithString:@"1EB0FD"];
    self.titleView.delegate = self;
    self.titleView.backgroundColor = [UIColor whiteColor];
    [self.titleView.extraBtn addTarget:self action:@selector(showChannel) forControlEvents:UIControlEventTouchUpInside];
    [naView addSubview:self.titleView];
    
    self.contentView = [[LXScrollContentView alloc] initWithFrame:CGRectZero];
    self.contentView.delegate = self;
    [self.view addSubview:self.contentView];
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, iPhoneX?88:64, kScreenW, 0.5)];
    line.backgroundColor = [MyTool colorWithString:@"e5e5e5"];
    [self.view addSubview:line];
}

- (void)segmentTitleView:(LXSegmentTitleView *)segmentView selectedIndex:(NSInteger)selectedIndex lastSelectedIndex:(NSInteger)lastSelectedIndex{
    self.contentView.currentIndex = selectedIndex;
    _index = selectedIndex;
}

- (void)contentViewDidScroll:(LXScrollContentView *)contentView fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(float)progress{
    
}

- (void)contentViewDidEndDecelerating:(LXScrollContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    self.titleView.selectedIndex = endIndex;
    _index = endIndex;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.titleView.frame = CGRectMake(0, iPhoneX?44:20, kScreenW, 44);
    self.contentView.frame = CGRectMake(0, iPhoneX?88:64, kScreenW, iPhoneX?kScreenH - 88 - 44:kScreenH - 64 - 44);
}

- (void)reloadData
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:KNewsDataDic] == NULL) {
        _inUseTitles = [NSMutableArray arrayWithArray:@[@{@"name": @"关注", @"id": @"-1"}, @{@"name": @"推荐", @"id": @"0"}, @{@"name": @"海口", @"id": @"3"}]];
        _unUseTitles = [NSMutableArray array];
        
        [self loadingWithText:@"加载中"];
        [self getNewsCategoryLoad];
        return;
    } else {
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] == YES) {
            _inUseTitles = [NSMutableArray arrayWithArray:@[@{@"name": @"关注", @"id": @"-1"}, @{@"name": @"推荐", @"id": @"0"}, @{@"name": @"海口", @"id": @"3"}]];
            _unUseTitles = [NSMutableArray array];
            
            [self loadingWithText:@"加载中"];
            [self getNewsCategoryLoad];
            return;
        }
        NSMutableDictionary *newsDataDic = [[[NSUserDefaults standardUserDefaults] objectForKey:KNewsDataDic] mutableCopy];
        _inUseTitles = [newsDataDic[@"inUseTitles"] mutableCopy];
        _unUseTitles = [newsDataDic[@"unUseTitles"] mutableCopy];
        
        
        self.titleView.segmentTitles = _inUseTitles;
        _vcs = [[NSMutableArray alloc] init];
        for (NSDictionary *titleDic in _inUseTitles) {
            NewsTableViewController *vc = [[NewsTableViewController alloc] init];
            vc.ID = titleDic[@"id"];
            [_vcs addObject:vc];
        }
        [self.contentView reloadViewWithChildVcs:_vcs parentVC:self];
        self.titleView.selectedIndex = 1;
        self.contentView.currentIndex = 1;
    }
}

-(void)showChannel
{
    NSDictionary *titleDic = _inUseTitles[_index];
    [_inUseTitles removeObjectsInRange:NSMakeRange(0, 3)];
    NSMutableArray *removiewArr = [[_vcs objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]] mutableCopy];
    [_vcs removeObjectsInRange:NSMakeRange(0, 3)];
    [[XLChannelControl shareControl] showChannelViewWithInUseTitles:_inUseTitles unUseTitles:_unUseTitles finish:^(NSArray *inUseTitles, NSArray *unUseTitles) {
//        NSLog(@"inUseTitles = %@",inUseTitles);
//        NSLog(@"unUseTitles = %@",unUseTitles);
        
        NSMutableArray *arr = [NSMutableArray array];
        
        if (inUseTitles.count == 0) {
            self.titleView.selectedIndex = 1;
            self.contentView.currentIndex = 1;
        }
        
        for (NSInteger i = 0; i < inUseTitles.count; i++) {
            if (_inUseTitles.count == 0) {
                NewsTableViewController *vc = [[NewsTableViewController alloc] init];
                vc.ID = inUseTitles[i][@"id"];
                [arr addObject:vc];
            } else {
                for (NSInteger j = 0; j < _inUseTitles.count; j++) {
                    if ([inUseTitles[i][@"name"] isEqualToString:_inUseTitles[j][@"name"]]) {
                        [arr addObject:_vcs[j]];
                        break;
                    } else if (![_inUseTitles containsObject:inUseTitles[i]]) {
                        NewsTableViewController *vc = [[NewsTableViewController alloc] init];
                        vc.ID = inUseTitles[i][@"id"];
                        [arr addObject:vc];
                        break;
                    }
                }
            }
            
            
            if ([inUseTitles[i] isEqual:titleDic]) {
                _index = i + 3;
                self.titleView.selectedIndex = i + 3;
                self.contentView.currentIndex = i + 3;
            } else if (![inUseTitles containsObject:titleDic]) {
                _index = 1;
                self.titleView.selectedIndex = 1;
                self.contentView.currentIndex = 1;
            }
        }
        
        _unUseTitles = [unUseTitles mutableCopy];
        _inUseTitles = [inUseTitles mutableCopy];
        [_inUseTitles insertObjects:@[@{@"name": @"关注", @"id": @"-1"}, @{@"name": @"推荐", @"id": @"0"}, @{@"name": @"海口", @"id": @"3"}] atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
        _vcs = arr;
        [_vcs insertObjects:removiewArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)]];
        self.titleView.segmentTitles = _inUseTitles;
        [self.contentView reloadViewWithChildVcs:_vcs parentVC:self];
        
        [self saveData];
    }];
}

- (void)saveData
{
    NSDictionary *newsDataDic = @{@"inUseTitles": _inUseTitles, @"unUseTitles": _unUseTitles};
    [[NSUserDefaults standardUserDefaults] setObject:newsDataDic forKey:KNewsDataDic];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self getNewsCategorySave];
}

- (void)getNewsCategoryLoad
{
    NSString *urlStr = [NetRequest NewsCategoryLoad];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] == YES ? [[NSUserDefaults standardUserDefaults] objectForKey:kToken] : @""};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        if ([JSON[@"error"] integerValue] == 0) {
            [_inUseTitles addObjectsFromArray:[JSON[@"data"][@"user_news_category"] mutableCopy]];
            NSArray *arr = JSON[@"data"][@"all_news_category"];
            NSArray *arr2 = JSON[@"data"][@"user_news_category"];
            // 如果服务器为空，直接取本地数据并上传服务器
            if (arr2.count == 0) {
                NSMutableDictionary *newsDataDic = [[[NSUserDefaults standardUserDefaults] objectForKey:KNewsDataDic] mutableCopy];
                _inUseTitles = [newsDataDic[@"inUseTitles"] mutableCopy];
                _unUseTitles = [newsDataDic[@"unUseTitles"] mutableCopy];
                [self getNewsCategorySave];
            } else {
                for (NSInteger i = 0; i < arr.count; i++) {
                    if (![arr2 containsObject:arr[i]]) {
                        [_unUseTitles addObject:arr[i]];
                    }
                }
            }
            
            
            self.titleView.segmentTitles = _inUseTitles;
            _vcs = [[NSMutableArray alloc] init];
            for (NSDictionary *titleDic in _inUseTitles) {
                NewsTableViewController *vc = [[NewsTableViewController alloc] init];
                vc.ID = titleDic[@"id"];
                [_vcs addObject:vc];
            }
            [self.contentView reloadViewWithChildVcs:_vcs parentVC:self];
            self.titleView.selectedIndex = 1;
            self.contentView.currentIndex = 1;
            
            
            [self saveData];
            [self endLoading];
        }
    } failure:^(NSError *error) {
        [self endLoading];
    }];
}

- (void)getNewsCategorySave
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] == YES) {    
        NSArray *arr = [_inUseTitles subarrayWithRange:NSMakeRange(3, _inUseTitles.count - 3)];
        NSString *urlStr = [NetRequest NewsCategorySave];
        NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"news_category": arr};
        [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        } failure:^(NSError *error) {
        }];
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:reloadNewsViewData object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:reloadNewsTitleList object:nil];
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
