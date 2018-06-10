//
//  ClassifyViewController.m
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/3.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "ClassifyViewController.h"

@interface ClassifyViewController ()
@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation ClassifyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _allDic = [NSMutableDictionary dictionary];
    _detailArr = [NSMutableArray array];
    _allCassifyArr = [NSMutableArray array];
    _row = 0;
    [self createNavigationBar];
    [self createTableView];
    [self createCollecionView];
    
    [self loadingWithText:@"加载中"];
    [self getClassifyData];
}

- (void)createNavigationBar
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 100, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    _titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _titleBtn.frame = CGRectMake(0, 7, kScreenW - 60, 30);
    _titleBtn.backgroundColor = [MyTool colorWithString:@"f5f5f5"];
    _titleBtn.layer.cornerRadius = 15;
    [_titleBtn setImage:[UIImage imageNamed:@"首页搜索"] forState:UIControlStateNormal];
    [_titleBtn setTitleColor:[MyTool colorWithString:@"999999"] forState:UIControlStateNormal];
    [_titleBtn setTitle:@"可搜索商家、购物中心" forState:UIControlStateNormal];
    _titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_titleBtn addTarget:self action:@selector(titleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _titleBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    _titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 18, 0, 0);
    _titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [titleView addSubview:_titleBtn];
    self.navigationItem.titleView = titleView;
}

#pragma mark - 搜索
- (void)titleBtnAction:(UIButton *)btn
{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.latitude = [[NSUserDefaults standardUserDefaults] objectForKey:KLatitude];
    searchVC.longitude = [[NSUserDefaults standardUserDefaults] objectForKey:KLongitude];
    UINavigationController *searchNaVC = [[UINavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:searchNaVC animated:NO completion:nil];
}

- (void)createTableView
{
    _listTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 90, kScreenH - 64) style:UITableViewStylePlain];
    if (iPhoneX) {
        _listTabelView.frame = CGRectMake(0, 0, 90, kScreenH - 88);
    }
    _listTabelView.delegate = self;
    _listTabelView.dataSource = self;
    _listTabelView.backgroundColor = [MyTool colorWithString:@"f5f5f5"];
    _listTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listTabelView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_listTabelView];
}

- (void)createCollecionView
{
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置item的大小 小方块的大小
    _flowLayout.itemSize = CGSizeMake((kScreenW - _listTabelView.frame.size.width - 45) / 3, (kScreenW - _listTabelView.frame.size.width - 45) / 3 + 45);
    // 最小行间距
    _flowLayout.minimumLineSpacing = 0;
    // 最小列间距
    _flowLayout.minimumInteritemSpacing = 10;
    // 设置item 上左下右的边距大小
    _flowLayout.sectionInset = UIEdgeInsetsMake(0 , 10, 0, 10);
    
    _flowLayout.headerReferenceSize = CGSizeMake(130, 130);
    
    _detailCollecionView = [[UICollectionView alloc] initWithFrame:CGRectMake(_listTabelView.frame.size.width, 0, kScreenW - _listTabelView.frame.size.width - 5, kScreenH - 64) collectionViewLayout:_flowLayout];
    if (iPhoneX) {
        _detailCollecionView.frame = CGRectMake(_listTabelView.frame.size.width, 0, kScreenW - _listTabelView.frame.size.width - 5, kScreenH - 88);
    }
    _detailCollecionView.backgroundColor = [UIColor whiteColor];
    _detailCollecionView.delegate = self;
    _detailCollecionView.dataSource = self;
    [self.view addSubview:_detailCollecionView];
    
    
    [_detailCollecionView registerClass:[ClassifyCollectionViewCell class] forCellWithReuseIdentifier:@"ClassifyCollectionViewCell"];
    [_detailCollecionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ClassifyHeaderView"];
}

#pragma mark -- tableViewDelegate  &&  tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allCassifyArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ClassifyTableViewCell";
    ClassifyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ClassifyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 54.5, cell.frame.size.width, 0.5)];
    lineView.backgroundColor = [UIColor clearColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 54.5)];
    view.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:view];
    [bgView addSubview:lineView];
    cell.selectedBackgroundView = bgView;
    
    if (indexPath.row == _row) {
        [_listTabelView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        cell.titleLabel.textColor = [MyTool colorWithString:@"ff3f53"];
        cell.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    } else {
        cell.titleLabel.textColor = [MyTool colorWithString:@"333333"];
        cell.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    cell.backgroundColor = [MyTool colorWithString:@"f5f5f5"];
    cell.titleLabel.text = _allCassifyArr[indexPath.row][@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _row = indexPath.row;
    _detailArr = [_allCassifyArr[_row][@"subcates"] mutableCopy];
    
    if (_row == 0) {
        _flowLayout.headerReferenceSize = CGSizeMake(130, 130);
    } else {
        _flowLayout.headerReferenceSize = CGSizeMake(45, 45);
    }
    [_detailCollecionView reloadData];
    [_listTabelView reloadData];
}


#pragma mark -- collectionViewDelegate  &&  collectionViewDataSource
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"ClassifyHeaderView" forIndexPath:indexPath];
        
        for (UIView *view in reusableView.subviews) {
            [view removeFromSuperview];
        }
        
        
        UIView *bgVeiew = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 90 - 15, 45)];
        bgVeiew.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, bgVeiew.frame.size.width - 10, 45)];
        if (_allCassifyArr.count != 0) {
            label.text = _allCassifyArr[_row][@"name"];
        }
        label.textColor = [MyTool colorWithString:@"333333"];
        label.font = [UIFont systemFontOfSize:14];
        label.backgroundColor = [UIColor clearColor];
        [bgVeiew addSubview:label];
        [reusableView addSubview:bgVeiew];
        
        if (_row == 0) {
            bgVeiew.frame = CGRectMake(0, 0, kScreenW - 90 - 15, 60 + 70 * Swidth);
            label.frame = CGRectMake(10, 60 + 70 * Swidth - 45, bgVeiew.frame.size.width - 25, 45);
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kScreenW - 90 - 25, 70 * Swidth)];
            imageView.backgroundColor = [UIColor clearColor];
            imageView.contentMode = UIViewContentModeScaleToFill;
            imageView.layer.masksToBounds = YES;
            if (_allCassifyArr.count != 0) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:_allDic[@"banner"]]];
            }
            [bgVeiew addSubview:imageView];
            
        }
        
        return reusableView;
    }
    return nil;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _detailArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassifyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClassifyCollectionViewCell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    [cell.myImageV sd_setImageWithURL:[NSURL URLWithString:_detailArr[indexPath.row][@"image_url"]]];
    cell.nameLabel.text = _detailArr[indexPath.row][@"name"];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
    myWebVC.hidesBottomBarWhenPushed = YES;
    myWebVC.urlStr = _detailArr[indexPath.row][@"url"];
    [self.navigationController pushViewController:myWebVC animated:YES];
}


- (void)getClassifyData
{
    NSString *urlStr = [NetRequest Category];
    [[NetTool shareInstance] getWithURL:urlStr success:^(id JSON) {
        
        if ([[JSON objectForKeyNotNull:@"error"] integerValue] == 0){
            _allDic = JSON[@"data"];
            _allCassifyArr = [JSON[@"data"][@"all_category"] mutableCopy];
            _detailArr = [_allCassifyArr[_row][@"subcates"] mutableCopy];
            
            [_listTabelView reloadData];
            [_detailCollecionView reloadData];
        }
        [self endLoading];
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
