//
//  AllPraiseCell.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/3/1.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "AllPraiseCell.h"
@interface AllPraiseCell()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    UICollectionView *_myCollecionView;
}

@end
@implementation AllPraiseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
    }
    return self;
}
-(void)setList:(NSArray<ListModel *> *)list
{
    _list = list;
    [_myCollecionView reloadData];
    
}
-(void)createSubviews
{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(20, 20);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing =10;
    flowLayout.sectionInset = UIEdgeInsetsMake(0 , 0, 0, 0);
    
    _myCollecionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _myCollecionView.backgroundColor = [UIColor whiteColor];
    _myCollecionView.delegate = self;
    _myCollecionView.dataSource = self;
    [_myCollecionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.contentView addSubview:_myCollecionView];
    
    _myCollecionView.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 15)
    .bottomSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15);
    
    [self setupAutoHeightWithBottomView:_myCollecionView bottomMargin:0];

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    UIImageView *avatarImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//    avatarImageView.backgroundColor = [UIColor yellowColor];
    [cell addSubview:avatarImageView];
    avatarImageView.sd_layout
    .topSpaceToView(cell, 0)
    .leftSpaceToView(cell, 0)
    .bottomSpaceToView(cell, 0)
    .rightSpaceToView(cell, 0);
    avatarImageView.sd_cornerRadiusFromWidthRatio = @(0.5);

    ListModel *model = _list[indexPath.row];
    [avatarImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
