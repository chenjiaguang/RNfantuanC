//
//  ShareAlertAleView.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/1/12.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "ShareAlertView.h"
#import "ShareAlertCollectionViewCell.h"

#define animationsTime 0.3

@implementation ShareAlertView
{
    NSMutableArray *_listArr;
    
    UIView *_bgView;
    UICollectionView *_myCollecionView;
}

- (instancetype)initWithFrame:(CGRect)frame listArr:(NSMutableArray *)listArr
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUIWithListArr:listArr];
    }
    return self;
}

- (void)createUIWithListArr:(NSMutableArray *)listArr
{
    _listArr = listArr;
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 198)];
    _bgView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.94f];
    [self addSubview:_bgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, kScreenW - 30, 14)];
    label.text = @"分享到";
    label.textColor = [MyTool colorWithString:@"333333"];
    label.font = [UIFont systemFontOfSize:14];
    [_bgView addSubview:label];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(kScreenW / 4.6, 122);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _myCollecionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), kScreenW, 122) collectionViewLayout:flowLayout];
    _myCollecionView.backgroundColor = [UIColor clearColor];
    _myCollecionView.delegate = self;
    _myCollecionView.dataSource = self;
    _myCollecionView.showsHorizontalScrollIndicator = NO;
    [_bgView addSubview:_myCollecionView];
    
    
    [_myCollecionView registerClass:[ShareAlertCollectionViewCell class] forCellWithReuseIdentifier:@"ShareAlertCollectionViewCell"];
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, _bgView.frame.size.height - 45, kScreenW, 45);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[MyTool colorWithString:@"333333"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:cancelBtn];
    
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_myCollecionView.frame), kScreenW - 30, 1)];
    line.backgroundColor = [MyTool colorWithString:@"e1e1e1"];
    [_bgView addSubview:line];
    
    
    [UIView animateWithDuration:animationsTime animations:^{
        _bgView.frame = CGRectMake(0, kScreenH - 198, kScreenW, 198);
    }];
}

#pragma mark -- collectionViewDelegate  &&  collectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _listArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShareAlertCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShareAlertCollectionViewCell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    cell.myImageV.image = [UIImage imageNamed:_listArr[indexPath.row]];
    cell.nameLabel.text = _listArr[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self hiddenAlertView];
    self.SelectItem(indexPath);
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self hiddenAlertView];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint touchPoint = [touch locationInView:self];
    return !CGRectContainsPoint(_bgView.frame, touchPoint);
}

- (void)hiddenAlertView
{
    [UIView animateWithDuration:animationsTime animations:^{
        _bgView.frame = CGRectMake(0, kScreenH, kScreenW, 198);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationsTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
