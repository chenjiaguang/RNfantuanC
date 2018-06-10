//
//  LQYDropMenuView.m
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/29.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "LQYDropMenuView.h"
#import "DropMenuOneTableViewCell.h"
#import "DropMenuTwoTableViewCell.h"
#import "DropMenuRightTableViewCell.h"

#define Main_Screen_Height [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width [[UIScreen mainScreen] bounds].size.width
#define KBgMaxHeight  Main_Screen_Height
#define KTableViewMaxHeight 300

#define KTopButtonHeight 44

@implementation LQYIndexPath

+ (instancetype)twIndexPathWithColumn:(NSInteger)column
                                  row:(NSInteger)row
                                 item:(NSInteger)item
                                 rank:(NSInteger)rank{
    
    LQYIndexPath *indexPath = [[self alloc] initWithColumn:column row:row item:item rank:rank];
    
    return indexPath;
}


- (instancetype)initWithColumn:(NSInteger )column
                           row:(NSInteger )row
                          item:(NSInteger )item
                          rank:(NSInteger )rank{
    
    if (self = [super init]) {
        
        self.column = column;
        self.row = row;
        self.item = item;
        self.rank = rank;
        
    }
    
    return self;
}

@end

@interface LQYDropMenuView ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _currSelectColumn;
    NSInteger _currSelectRow;
    NSInteger _currSelectItem;
    NSInteger _currSelectRank;
    
    CGFloat _otherHeight;
    
    CGFloat _rightHeight;
    BOOL _isRightOpen;
    BOOL _isLeftOpen;
    BOOL _isOtherOpen;
    
}

@property (nonatomic,strong) UITableView *otherTableView;

@property (nonatomic,strong) UITableView *leftTableView;
@property (nonatomic,strong) UITableView *leftTableView_1;
@property (nonatomic,strong) UITableView *leftTableView_2;

@property (nonatomic,strong) UITableView *rightTableView;

@property (nonatomic,strong) UIButton *bgButton; //背景

@end


@implementation LQYDropMenuView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
        
        [self _setButton];
        [self _initialize];
        [self _setSubViews];
    }
    return self;
}


- (void)_initialize{
    
    _currSelectColumn = 0;
    _currSelectItem = WSNoFound;
    _currSelectRank = WSNoFound;
    _currSelectRow = WSNoFound;
    _isLeftOpen = NO;
    _isRightOpen = NO;
    _isOtherOpen = NO;
}


- (void)_setButton{
    
    self.otherButton = [MoreButton buttonWithType:UIButtonTypeCustom];
    self.otherButton.frame = CGRectMake(0, 0, Main_Screen_Width/3, KTopButtonHeight);
    [self.otherButton setTitleColor:[MyTool colorWithString:@"666666"] forState:UIControlStateNormal];
    [self.otherButton setImage:[UIImage imageNamed:@"菜单下拉灰"] forState:UIControlStateNormal];
    self.otherButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.otherButton.titleLabel.lineBreakMode = 0;
    self.otherButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.otherButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 16)];
    [self.otherButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.otherButton];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.otherButton.frame), 12, 1, 20)];
    line.backgroundColor = [MyTool colorWithString:@"e5e5e5"];
    [self addSubview:line];
    
    self.leftButton = [MoreButton buttonWithType:UIButtonTypeCustom];
    self.leftButton.frame = CGRectMake(CGRectGetMaxX(self.otherButton .frame)+1, 0, Main_Screen_Width/3, KTopButtonHeight);
    [self.leftButton setTitle:OtherButtonTitle forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[MyTool colorWithString:@"666666"] forState:UIControlStateNormal];
    [self.leftButton setImage:[UIImage imageNamed:@"菜单下拉灰"] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.leftButton.titleLabel.lineBreakMode = 0;
    self.leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.leftButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 16)];
    [self.leftButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftButton];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.leftButton.frame), 12, 1, 20)];
    line1.backgroundColor = [MyTool colorWithString:@"e5e5e5"];
    [self addSubview:line1];
    
    self.rightButton = [MoreButton buttonWithType:UIButtonTypeCustom];
    self.rightButton .frame = CGRectMake(CGRectGetMaxX(self.leftButton .frame)+1, 0, Main_Screen_Width/3, KTopButtonHeight);
    [self.rightButton  setTitle:RightButtonTitle forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"菜单下拉灰"] forState:UIControlStateNormal];
    [self.rightButton  addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitleColor:[MyTool colorWithString:@"666666"]  forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.rightButton.titleLabel.lineBreakMode = 0;
    self.rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.rightButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 16)];
    [self addSubview:self.rightButton ];
}

- (void)_setSubViews{
    
    [self addSubview:self.bgButton];
    [self.bgButton addSubview:self.leftTableView];
    [self.bgButton addSubview:self.leftTableView_1];
    [self.bgButton addSubview:self.otherTableView];
    [self.bgButton addSubview:self.rightTableView];
    
}


#pragma mark -- public fun --
- (void)reloadOtherTableView{
    [self.otherTableView reloadData];
}

- (void)reloadLeftTableView{
    [self.leftTableView reloadData];
}

- (void)reloadRightTableView{
    [self.rightTableView reloadData];
}

- (void)reloadLeft1TabelView{
    [self.leftTableView_1 reloadData];
}

#pragma mark -- getter --
- (UITableView *)otherTableView{
    
    if (!_otherTableView) {
        
        _otherTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _otherTableView.delegate = self;
        _otherTableView.dataSource = self;
        _otherTableView.frame = CGRectMake(0, 0 , self.bgButton.frame.size.width, 0);
        _otherTableView.tableFooterView = [[UIView alloc]init];
        _otherTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _otherTableView;
}

- (UITableView *)leftTableView{
    
    if (!_leftTableView) {
        
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.frame = CGRectMake(0, 0, 120, 0);
        _leftTableView.backgroundColor = [MyTool colorWithString:@"f5f5f5"];
        _leftTableView.tableFooterView = [[UIView alloc]init];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _leftTableView;
}

- (UITableView *)leftTableView_1{
    
    if (!_leftTableView_1) {
        
        _leftTableView_1 = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView_1.delegate = self;
        _leftTableView_1.dataSource = self;
        _leftTableView_1.frame = CGRectMake(120, 0 , kScreenW - 120, 0);
        _leftTableView_1.backgroundColor = [UIColor whiteColor];
        _leftTableView_1.tableFooterView = [[UIView alloc]init];
        _leftTableView_1.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _leftTableView_1;
    
}

- (UITableView *)rightTableView{
    
    if (!_rightTableView) {
        
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.frame = CGRectMake(0, 0 , self.bgButton.frame.size.width, 0);
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return _rightTableView;
    
    
}

- (UIButton *)bgButton{
    
    if (!_bgButton) {
        
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgButton.backgroundColor = [UIColor clearColor];
        _bgButton.frame = CGRectMake(0, KTopButtonHeight, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - KTopButtonHeight);
        [_bgButton addTarget:self action:@selector(bgAction:) forControlEvents:UIControlEventTouchUpInside];
        _bgButton.clipsToBounds = YES;
        
    }
    
    return _bgButton;
}


#pragma mark -- tableViews Change
- (void)_hiddenOtherTableViews{
    [self.otherButton setTitleColor:[MyTool colorWithString:@"666666"] forState:UIControlStateNormal];
    [self.otherButton setImage:[UIImage imageNamed:@"菜单下拉灰"] forState:UIControlStateNormal];
    
    self.otherTableView.frame = CGRectMake(self.otherTableView.frame.origin.x, self.otherTableView.frame.origin.y, self.otherTableView.frame.size.width, 0);
}

- (void)_showOtherTableViews{
    [self.otherButton setTitleColor:[MyTool colorWithString:@"ff3f53"] forState:UIControlStateNormal];
    [self.otherButton setImage:[UIImage imageNamed:@"菜单下拉红"] forState:UIControlStateNormal];
    
    CGFloat height = MIN(_otherHeight, KTableViewMaxHeight);
    
    self.otherTableView.frame = CGRectMake(self.otherTableView.frame.origin.x, self.otherTableView.frame.origin.y, self.otherTableView.frame.size.width, height);
}

- (void)_hiddenLeftTableViews{
    [self.leftButton setTitleColor:[MyTool colorWithString:@"666666"] forState:UIControlStateNormal];
    [self.leftButton setImage:[UIImage imageNamed:@"菜单下拉灰"] forState:UIControlStateNormal];
    
    self.leftTableView.frame = CGRectMake(self.leftTableView.frame.origin.x, self.leftTableView.frame.origin.y, self.leftTableView.frame.size.width, 0);
    self.leftTableView_1.frame = CGRectMake(self.leftTableView_1.frame.origin.x, self.leftTableView_1.frame.origin.y, self.leftTableView_1.frame.size.width, 0);
}

- (void)_showLeftTableViews{
    
    [self.leftButton setTitleColor:[MyTool colorWithString:@"ff3f53"] forState:UIControlStateNormal];
    [self.leftButton setImage:[UIImage imageNamed:@"菜单下拉红"] forState:UIControlStateNormal];
    
    self.leftTableView.frame = CGRectMake(self.leftTableView.frame.origin.x, self.leftTableView.frame.origin.y, self.leftTableView.frame.size.width, KTableViewMaxHeight);
    self.leftTableView_1.frame = CGRectMake(self.leftTableView_1.frame.origin.x, self.leftTableView_1.frame.origin.y, self.leftTableView_1.frame.size.width, KTableViewMaxHeight);
}

- (void)_HiddenRightTableView{
    
    [self.rightButton setTitleColor:[MyTool colorWithString:@"666666"] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"菜单下拉灰"] forState:UIControlStateNormal];
    
    self.rightTableView.frame = CGRectMake(self.rightTableView.frame.origin.x, self.rightTableView.frame.origin.y, self.rightTableView.frame.size.width, 0);
}

- (void)_showRightTableView{
    
    [self.rightButton setTitleColor:[MyTool colorWithString:@"ff3f53"] forState:UIControlStateNormal];
    [self.rightButton setImage:[UIImage imageNamed:@"菜单下拉红"] forState:UIControlStateNormal];
    
    CGFloat height = MIN(_rightHeight, KTableViewMaxHeight);
    
    self.rightTableView.frame = CGRectMake(self.rightTableView.frame.origin.x, self.rightTableView.frame.origin.y, self.rightTableView.frame.size.width, height);
}

- (void)_changeTopButton:(NSString *)string{
    
    if (_currSelectColumn == 2) {
        
        [self.otherButton setTitle:string forState:UIControlStateNormal];
    }
    if (_currSelectColumn == 0) {
        
        [self.leftButton setTitle:string forState:UIControlStateNormal];
    }
    if (_currSelectColumn == 1) {
        
        [self.rightButton setTitle:string forState:UIControlStateNormal];
    }
    
}

#pragma mark -- 点击按钮
- (void)buttonAction:(UIButton *)sender{
    
    if (self.otherButton == sender) {
        if (_isOtherOpen) {
            _isOtherOpen = !_isOtherOpen;
            [self bgAction:nil];
            return ;
        }
        _currSelectColumn = 2;
        _isOtherOpen = YES;
        _isLeftOpen = NO;
        _isRightOpen = NO;
        [self _hiddenLeftTableViews];
        [self _HiddenRightTableView];
    }
    
    if (self.leftButton == sender) {
        if (_isLeftOpen) {
            _isLeftOpen = !_isLeftOpen;
            [self bgAction:nil];
            return ;
        }
        _currSelectColumn = 0;
        _isOtherOpen = NO;
        _isLeftOpen = YES;
        _isRightOpen = NO;
        [self _hiddenOtherTableViews];
        [self _HiddenRightTableView];
        
    }
    if (self.rightButton == sender) {
        
        if (_isRightOpen) {
            _isRightOpen = !_isRightOpen;
            [self bgAction:nil];
            return ;
        }
        _currSelectColumn = 1;
        _isOtherOpen = NO;
        _isLeftOpen = NO;
        _isRightOpen = YES;
        [self _hiddenLeftTableViews];
        [self _hiddenOtherTableViews];
        
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, Main_Screen_Width, Main_Screen_Height);
    self.bgButton.frame = CGRectMake(self.bgButton.frame.origin.x, self.bgButton.frame.origin.y, self.bounds.size.width, self.bounds.size.height - KTopButtonHeight);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.bgButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        if (_currSelectColumn == 2) {
            [self _showOtherTableViews];
        }
        if (_currSelectColumn == 0) {
            [self _showLeftTableViews];
        }
        if (_currSelectColumn == 1) {
            [self _showRightTableView];
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)bgAction:(UIButton *)sender{
    
    _isOtherOpen = NO;
    _isRightOpen = NO;
    _isLeftOpen = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.bgButton.backgroundColor = [UIColor clearColor];
        [self _hiddenOtherTableViews];
        [self _hiddenLeftTableViews];
        [self _HiddenRightTableView];
        
    } completion:^(BOOL finished) {
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, Main_Screen_Width, KTopButtonHeight);
        self.bgButton.frame = CGRectMake(self.bgButton.frame.origin.x, self.bgButton.frame.origin.y, self.bounds.size.width, 0);
    }];
    
}


#pragma mark -- DataSource -
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    LQYIndexPath *twIndexPath =[self _getTwIndexPathForNumWithtableView:tableView];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(dropMenuView:numberWithIndexPath:)]) {
        
        NSInteger count =  [self.dataSource dropMenuView:self numberWithIndexPath:twIndexPath];
        if (twIndexPath.column == 1) {
            _rightHeight = count * 44.0;
        } else if (twIndexPath.column == 2) {
            _otherHeight = count * 44.0;
        }
        
        return count;
    }else{
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    LQYIndexPath *twIndexPath = [self _getTwIndexPathForCellWithTableView:tableView indexPath:indexPath];
    if (tableView == self.leftTableView_1) {
        static NSString *cellIdentifier = @"DropMenuTwoTableViewCell";
        DropMenuTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[DropMenuTwoTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor =  [UIColor whiteColor];
        
        if ([_categoryArr[twIndexPath.row][@"subcates"][indexPath.row][@"id"] isEqualToString:_left1RowStr]) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(dropMenuView:titleWithIndexPath:)]) {
            
            [cell setNameLabelText:[self.dataSource dropMenuView:self titleWithIndexPath:twIndexPath][@"name"] numLabelText:[NSString stringWithFormat:@"(%@)", [self.dataSource dropMenuView:self titleWithIndexPath:twIndexPath][@"num"]]];
        }
        
        return cell;
        
    } else if (tableView == self.rightTableView || tableView == self.otherTableView) {
        static NSString *cellIdentifier = @"DropMenuRightTableViewCell";
        DropMenuRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[DropMenuRightTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor =  [UIColor whiteColor];
        
        if (tableView == self.rightTableView) {
            if ([_sortArr[indexPath.row][@"sort"] isEqualToString:_rightRowStr]) {
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        } else if (tableView == self.otherTableView) {
            if ([_floorArr[indexPath.row][@"id"] isEqualToString:_otherRowStr]) {
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }
        
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(dropMenuView:titleWithIndexPath:)]) {
            
            cell.nameLabel.text =  [self.dataSource dropMenuView:self titleWithIndexPath:twIndexPath][@"name"];
        }
        
        return cell;
        
    } else {
        static NSString *cellIdentifier = @"DropMenuOneTableViewCell";
        DropMenuOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[DropMenuOneTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor =  [UIColor whiteColor];
        
        if ([_categoryArr[indexPath.row][@"id"] isEqualToString:_leftRowStr] && tableView == self.leftTableView) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(dropMenuView:titleWithIndexPath:)]) {
            
            cell.nameLabel.text =  [self.dataSource dropMenuView:self titleWithIndexPath:twIndexPath][@"name"];
        }
        
        cell.backgroundColor = [MyTool colorWithString:@"f5f5f5"];
        
        return cell;
    }
    
}


#pragma mark - tableView delegate -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LQYIndexPath *twIndexPath = [self _getTwIndexPathForCellWithTableView:tableView indexPath:indexPath];
    
    if (tableView == self.otherTableView) {
        _otherRowStr = _floorArr[indexPath.row][@"id"];
        
        [self _changeTopButton:_floorArr[indexPath.row][@"name"]];
        [self bgAction:nil];
        [self createDelegateWithIndexPath:twIndexPath];
    }
    
    
    
    if (tableView == self.leftTableView) {
        _currSelectRow = indexPath.row;
        _currSelectItem = WSNoFound;
        _leftRowStr = _categoryArr[indexPath.row][@"id"];
        
        [self.leftTableView_1 reloadData];
        
        if (_currSelectRow == 0) {
            _left1RowStr = _categoryArr[indexPath.row][@"id"];
            [self _changeTopButton:_categoryArr[indexPath.row][@"name"]];
            [self bgAction:nil];
            [self createDelegateWithIndexPath:twIndexPath];
        }
    }
    if (tableView == self.leftTableView_1) {
        _left1RowStr = _categoryArr[twIndexPath.row][@"subcates"][twIndexPath.item][@"id"];
        if (indexPath.row == 0) {
            [self _changeTopButton:_categoryArr[twIndexPath.row][@"name"]];
        } else {
            [self _changeTopButton:_categoryArr[twIndexPath.row][@"subcates"][twIndexPath.item][@"name"]];
        }
        [self bgAction:nil];
        [self createDelegateWithIndexPath:twIndexPath];
    }
    
    
    
    if (self.rightTableView == tableView) {
        _rightRowStr = _sortArr[indexPath.row][@"sort"];
        
        [self _changeTopButton:_sortArr[indexPath.row][@"name"]];
        [self bgAction:nil];
        [self createDelegateWithIndexPath:twIndexPath];
    }
    
    
    
}
- (void)createDelegateWithIndexPath:(LQYIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dropMenuView:didSelectWithIndexPath:)]) {
        
        [self.delegate dropMenuView:self didSelectWithIndexPath:indexPath];
    }
}



- (LQYIndexPath *)_getTwIndexPathForNumWithtableView:(UITableView *)tableView{
    
    if (tableView == self.otherTableView) {
        
        return  [LQYIndexPath twIndexPathWithColumn:2 row:WSNoFound item:WSNoFound rank:WSNoFound];
        
    }
    
    
    if (tableView == self.leftTableView) {
        
        return  [LQYIndexPath twIndexPathWithColumn:0 row:WSNoFound item:WSNoFound rank:WSNoFound];
        
    }
    
    if (tableView == self.leftTableView_1 && _currSelectRow != WSNoFound) {
        
        for (NSInteger i = 0; i < _categoryArr.count; i++) {
            if ([_leftRowStr isEqualToString:_categoryArr[i][@"id"]]) {
                _currSelectRow = i;
            }
        }
        
        return [LQYIndexPath twIndexPathWithColumn:0 row:_currSelectRow item:WSNoFound rank:WSNoFound];
    }
    
    
    
    if (tableView == self.rightTableView) {
        
        return [LQYIndexPath twIndexPathWithColumn:1 row:WSNoFound item:WSNoFound  rank:WSNoFound];
    }
    
    
    return  0;
}

- (LQYIndexPath *)_getTwIndexPathForCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == self.otherTableView) {
        
        return  [LQYIndexPath twIndexPathWithColumn:2 row:indexPath.row item:WSNoFound rank:WSNoFound];
        
    }
    
    
    if (tableView == self.leftTableView) {
        
        return  [LQYIndexPath twIndexPathWithColumn:0 row:indexPath.row item:WSNoFound rank:WSNoFound];
        
    }
    
    if (tableView == self.leftTableView_1) {
        
        return [LQYIndexPath twIndexPathWithColumn:0 row:_currSelectRow item:indexPath.row rank:WSNoFound];
    }
    
    
    if (tableView == self.rightTableView) {
        
        return [LQYIndexPath twIndexPathWithColumn:1 row:indexPath.row item:WSNoFound  rank:WSNoFound];
    }
    
    
    return  [LQYIndexPath twIndexPathWithColumn:2 row:indexPath.row item:WSNoFound rank:WSNoFound];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
