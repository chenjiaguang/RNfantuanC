//
//  HomeRecommendCell.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/5/3.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "HomeRecommendCell.h"
#import "HomeCircleCollectionCell.h"
#import "CircleDetailTwoViewController.h"
@interface HomeRecommendCell ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *_myCollecionView;
}
@end
@implementation HomeRecommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createUI];
        
    }
    return self;
}
-(void)setCircles:(NSArray<CirclesModel *> *)circles
{
    _circles = circles;
    
}
-(void)createUI
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(kScreenW * 131/375, kScreenH * 162/667);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(5 ,15, 5, 15);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *myCollecionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    myCollecionView.backgroundColor = [UIColor whiteColor];
    myCollecionView.delegate = self;
    myCollecionView.dataSource = self;
    myCollecionView.showsVerticalScrollIndicator = NO;
    myCollecionView.showsHorizontalScrollIndicator = NO;
    [myCollecionView registerClass:[HomeCircleCollectionCell class] forCellWithReuseIdentifier:@"HomeCircleCollectionCell"];
    [self addSubview:myCollecionView];
    _myCollecionView = myCollecionView;
    
    myCollecionView.sd_layout
    .heightIs(kScreenH * 162/667 + 30)
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    [self setupAutoHeightWithBottomView:myCollecionView bottomMargin:5];

}
#pragma mark -- collectionViewDelegate  &&  collectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _circles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCircleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCircleCollectionCell" forIndexPath:indexPath];
    cell.model = _circles[indexPath.row];
    //    cell.myImageV.backgroundColor = [UIColor yellowColor];
  
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CircleDetailTwoViewController *vc = [[CircleDetailTwoViewController alloc]init];
    vc.circleID = ((CirclesModel *)_circles[indexPath.row]).id;
    [[MyTool topViewController].navigationController pushViewController:vc animated:YES];

    
}
@end
