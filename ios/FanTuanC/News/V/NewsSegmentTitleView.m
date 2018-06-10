//
//  NewsSegmentTitleView.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/4/24.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "NewsSegmentTitleView.h"

@interface NewsSegmentTitleView()

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray<UIButton *> *itemButtons;

@property (nonatomic, weak) UIView *indicatorView;

@end

@implementation NewsSegmentTitleView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initData];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initData];
    }
    return self;
}

- (void)initData{
    self.titleNormalColor = [UIColor blackColor];
    self.titleSelectedColor = [UIColor redColor];
    self.selectedIndex = 0;
    self.titleFont = [UIFont systemFontOfSize:14.f];
    self.indicatorColor = [UIColor redColor];
    self.indicatorHeight = 2.f;
    self.indicatorExtraW = 5.f;
    self.indicatorBottomMargin = 0;
    self.itemMinMargin = 25.f;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(0, 0, kScreenW, self.frame.size.height);
//    self.extraBtn.frame = CGRectMake(kScreenW - 64, 0, 64, self.frame.size.height);
    if (self.itemButtons.count == 0) {
        return;
    }
    CGFloat totalBtnW = 0;
    for (UIButton *btn in self.itemButtons) {
        [btn sizeToFit];
        totalBtnW += btn.frame.size.width;
    }
    
    CGFloat itemMarginW = (self.scrollView.frame.size.width - totalBtnW) / (self.itemButtons.count + 1);
    if (itemMarginW < self.itemMinMargin) {
        itemMarginW = self.itemMinMargin;
    }
    
    CGFloat lastX = itemMarginW;
    for (UIButton *btn in self.itemButtons) {
        [btn sizeToFit];
        btn.frame = CGRectMake(lastX, 0, btn.frame.size.width, self.scrollView.frame.size.height);
        lastX += btn.frame.size.width + itemMarginW;
    }
    self.scrollView.contentSize = CGSizeMake(lastX, self.scrollView.frame.size.height);
    [self setSelectedIndicatorFrame:NO];
}

- (void)setSelectedIndicatorFrame:(BOOL)animated{
    UIButton *selectedBtn = self.itemButtons[self.selectedIndex];
    [UIView animateWithDuration:(animated? 0.1 : 0) delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.indicatorView.frame = CGRectMake(selectedBtn.centerX - 10, self.scrollView.frame.size.height - self.indicatorHeight - self.indicatorBottomMargin, 20, self.indicatorHeight);
        self.indicatorView.layer.masksToBounds = YES;
        self.indicatorView.layer.cornerRadius = self.indicatorHeight / 2;
    } completion:^(BOOL finished) {
        [self scrollRectToVisibleCenterAnimated:animated];
    }];
}

- (void)scrollRectToVisibleCenterAnimated:(BOOL)animated {
    UIButton *selectedBtn = self.itemButtons[self.selectedIndex];
    CGRect centeredRect = CGRectMake(selectedBtn.center.x - self.scrollView.frame.size.width / 2, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView scrollRectToVisible:centeredRect animated:animated];
}

#pragma mark - getter

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        scrollView.scrollsToTop = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIButton *)extraBtn
{
    if (!_extraBtn) {
        UIButton *btn = [UIButton new];
        NSString *imageName = @"频道添加";
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
        // 设置边缘的阴影效果
        //        btn.layer.shadowColor = [UIColor whiteColor].CGColor;
        //        btn.layer.shadowOffset = CGSizeMake(-10, 0);
        //        btn.layer.shadowOpacity = 1;
        [self addSubview:btn];
        _extraBtn = btn;
    }
    return _extraBtn;
}



- (UIView *)indicatorView{
    if (!_indicatorView) {
        UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.scrollView addSubview:indicatorView];
        _indicatorView = indicatorView;
    }
    return _indicatorView;
}

- (NSMutableArray<UIButton *> *)itemButtons{
    if (!_itemButtons) {
        _itemButtons = [[NSMutableArray alloc] init];
    }
    return _itemButtons;
}


#pragma mark - setter

- (void)setSegmentTitles:(NSArray<NSString *> *)segmentTitles{
    [self.itemButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.itemButtons = nil;
    for (NSDictionary *dic in segmentTitles) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.selectedIndex == self.itemButtons.count) {
            btn.selected = YES;
        }
        btn.tag = 888 + self.itemButtons.count;
        [btn setTitle:dic[@"name"] forState:UIControlStateNormal];
        [btn setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = self.titleFont;
        [self.scrollView addSubview:btn];
        [self.itemButtons addObject:btn];
        
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}


- (void)setSelectedIndex:(NSInteger)selectedIndex{
    //    if (selectedIndex == 0) {
    //        UIButton *selectedBtn = [self.scrollView viewWithTag:_selectedIndex + 888];
    //        selectedBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:17];
    //    }
    if (_selectedIndex == selectedIndex || selectedIndex < 0 || selectedIndex > self.itemButtons.count - 1 || self.itemButtons.count <= 0) {
        return;
    }
    UIButton *btn = [self.scrollView viewWithTag:_selectedIndex + 888];
    btn.selected = NO;
    btn.titleLabel.font = self.titleFont;
    _selectedIndex = selectedIndex;
    UIButton *selectedBtn = [self.scrollView viewWithTag:_selectedIndex + 888];
    selectedBtn.selected = YES;
    //    selectedBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:17];
    [self setSelectedIndicatorFrame:YES];
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor{
    _titleNormalColor = titleNormalColor;
    for (UIButton *btn in self.itemButtons) {
        [btn setTitleColor:titleNormalColor forState:UIControlStateNormal];
    }
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor{
    _titleSelectedColor = titleSelectedColor;
    for (UIButton *btn in self.itemButtons) {
        [btn setTitleColor:titleSelectedColor forState:UIControlStateSelected];
    }
}

- (void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    for (UIButton *btn in self.itemButtons) {
        btn.titleLabel.font = titleFont;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setIndicatorColor:(UIColor *)indicatorColor{
    _indicatorColor = indicatorColor;
    self.indicatorView.backgroundColor = indicatorColor;
}

- (void)setIndicatorHeight:(CGFloat)indicatorHeight{
    _indicatorHeight = indicatorHeight;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setIndicatorExtraW:(CGFloat)indicatorExtraW{
    _indicatorExtraW = indicatorExtraW;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setItemMinMargin:(CGFloat)itemMinMargin{
    _itemMinMargin = itemMinMargin;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setIndicatorBottomMargin:(CGFloat)indicatorBottomMargin{
    _indicatorBottomMargin = indicatorBottomMargin;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - EventResponse
- (void)btnClick:(UIButton *)btn{
    NSInteger btnIndex = btn.tag - 888;
    if (btnIndex == self.selectedIndex) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentTitleView:selectedIndex:lastSelectedIndex:)]) {
        [self.delegate segmentTitleView:self selectedIndex:btnIndex lastSelectedIndex:self.selectedIndex];
    }
    self.selectedIndex = btnIndex;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
