//
//  MMRichEditAccessoryView.m
//  RichTextEditDemo
//
//  Created by aron on 2017/7/21.
//  Copyright © 2017年 aron. All rights reserved.
//

#import "MMRichEditAccessoryView.h"
#import "UtilMacro.h"
#import "AddressSelectedController.h"
#import "SelectRangeViewController.h"

@interface MMRichEditAccessoryView ()
@property (nonatomic, strong) UIView *bottomBGview;
@property (nonatomic, strong) UIImageView *picImageIcon;
@property (nonatomic, strong) UIButton *addressBtn;
@property (nonatomic, strong) UIButton *deleteBtn;
@end


@implementation MMRichEditAccessoryView

- (instancetype)init {
    if (self = [super init]) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.bottomBGview];
    [_bottomBGview addSubview:self.picImageIcon];
    [_bottomBGview addSubview:self.kbImageIcon];
    [self addSubview:self.addressBtn];
    [self addSubview:self.deleteBtn];
    [self addSubview:self.nameBtn];
    
    
    _bottomBGview.sd_layout
    .bottomEqualToView(self)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(47);
    
    
    _picImageIcon.sd_layout
    .centerYEqualToView(_bottomBGview)
    .leftSpaceToView(_bottomBGview, 25)
    .widthIs(25)
    .heightIs(20);
    
    
    _kbImageIcon.sd_layout
    .centerYEqualToView(_bottomBGview)
    .rightSpaceToView(_bottomBGview, 25)
    .widthIs(24)
    .heightIs(23);
    
    
    _addressBtn.imageView.sd_layout
    .leftSpaceToView(_addressBtn, 7)
    .centerYEqualToView(_addressBtn)
    .heightIs(12)
    .widthIs(10);
    
    [_addressBtn setupAutoSizeWithHorizontalPadding:8 buttonHeight:23];
    _addressBtn.sd_cornerRadius = @3;
    _addressBtn.sd_layout
    .leftSpaceToView(self, 15)
    .topSpaceToView(self, 15)
    .heightIs(23);
    
    _addressBtn.titleLabel.sd_layout
    .leftSpaceToView(_addressBtn.imageView, 7);
    
    
    _deleteBtn.sd_layout
    .leftSpaceToView(_addressBtn, 4)
    .centerYEqualToView(_addressBtn)
    .heightIs(23)
    .widthEqualToHeight();
    
    
    _nameBtn.imageView.sd_layout
    .leftSpaceToView(_nameBtn, 4)
    .centerYEqualToView(_nameBtn)
    .heightIs(16)
    .widthIs(16);
    
    [_nameBtn setupAutoSizeWithHorizontalPadding:8 buttonHeight:23];
    _nameBtn.sd_cornerRadius = @3;
    _nameBtn.sd_layout
    .rightSpaceToView(self, 15)
    .topSpaceToView(self, 15)
    .heightIs(23);
    
    _nameBtn.titleLabel.sd_layout
    .leftSpaceToView(_nameBtn.imageView, 5);
}

- (UIView *)bottomBGview
{
    if (!_bottomBGview) {
        _bottomBGview = [UIView new];
        _bottomBGview.backgroundColor = [MyTool colorWithString:@"f9f9f9"];
    }
    return _bottomBGview;
}

- (UIImageView *)kbImageIcon {
    if (!_kbImageIcon) {
        _kbImageIcon = [UIImageView new];
        _kbImageIcon.contentMode = UIViewContentModeScaleAspectFit;
        _kbImageIcon.image = [UIImage imageNamed:@"回收键盘"];
        _kbImageIcon.userInteractionEnabled = YES;
        [_kbImageIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onKbImageIconTap:)]];
    }
    return _kbImageIcon;
}

- (UIImageView *)picImageIcon {
    if (!_picImageIcon) {
        _picImageIcon = [UIImageView new];
        _picImageIcon.contentMode = UIViewContentModeScaleAspectFit;
        _picImageIcon.image = [UIImage imageNamed:@"长文章选择图片"];
        _picImageIcon.userInteractionEnabled = YES;
        [_picImageIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPicImageIconTap:)]];
    }
    return _picImageIcon;
}

- (UIButton *)addressBtn
{
    if (!_addressBtn) {
        UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addressBtn.backgroundColor = [MyTool colorWithString:@"f2f2f2"];
        [addressBtn setImage:[UIImage imageNamed:@"icon_位置"] forState:UIControlStateNormal];
        [addressBtn setTitle:@"你在哪里?" forState:UIControlStateNormal];
        [addressBtn setTitleColor:[MyTool colorWithString:@"999999"] forState:UIControlStateNormal];
        addressBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [addressBtn setImage:[UIImage imageNamed:@"icon_位置"] forState:UIControlStateSelected];
        [addressBtn setTitleColor:[MyTool colorWithString:@"05a4be"] forState:UIControlStateSelected];
        [addressBtn addTarget:self action:@selector(addressBtnAction:) forControlEvents:UIControlEventTouchDown];
        _addressBtn = addressBtn;
    }
    return _addressBtn;
}

- (UIButton *)deleteBtn
{
    if (!_delegate) {
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.backgroundColor = [MyTool colorWithString:@"f2f2f2"];
        [deleteBtn setImage:[UIImage imageNamed:@"deleteAddress"] forState:UIControlStateNormal];
        deleteBtn.hidden = YES;
        [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchDown];
        _deleteBtn = deleteBtn;
    }
    return _deleteBtn;
}

- (UIButton *)nameBtn
{
    if (!_nameBtn) {
        UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nameBtn.backgroundColor = [MyTool colorWithString:@"f2f2f2"];
        [nameBtn setTitleColor:[MyTool colorWithString:@"333333"] forState:UIControlStateNormal];
        [nameBtn setTitle:@"公开" forState:UIControlStateNormal];
        [nameBtn setImage:[UIImage imageNamed:@"发布_公开"] forState:UIControlStateNormal];
        nameBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [nameBtn addTarget:self action:@selector(nameBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _nameBtn = nameBtn;
    }
    return _nameBtn;
}

- (void)setCircleName:(NSString *)circleName
{
    _circleName = circleName.length > 6 ? [NSString stringWithFormat:@"%@...", [circleName substringToIndex:6]]:circleName;
    if (![circleName isEqualToString:@""]) {
        [_nameBtn setTitle:_circleName forState:UIControlStateNormal];
        [_nameBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_nameBtn setTitleColor:[MyTool colorWithString:@"1EB0FD"] forState:UIControlStateNormal];
        
        [_nameBtn setupAutoSizeWithHorizontalPadding:8 buttonHeight:23];
        [_nameBtn.imageView sd_resetLayout];
        [_nameBtn.titleLabel sd_resetLayout];
        
        _nameBtn.userInteractionEnabled = NO;
    } else {
        _nameBtn.userInteractionEnabled = YES;
    }
}


#pragma mark - ......::::::: ui action :::::::......

- (void)onKbImageIconTap:(UITapGestureRecognizer*)gesture {
    if ([self.delegate respondsToSelector:@selector(mm_didKeyboardTapInaccessoryView:)]) {
        [self.delegate mm_didKeyboardTapInaccessoryView:self];
    }
}

- (void)onPicImageIconTap:(UITapGestureRecognizer*)gesture {
    if ([self.delegate respondsToSelector:@selector(mm_didImageTapInaccessoryView:)]) {
        [self.delegate mm_didImageTapInaccessoryView:self];
    }
}

- (void)addressBtnAction:(UIButton *)btn
{
    AddressSelectedController *vc = [[AddressSelectedController alloc]init];
    WeakSelf(weakSelf);
    vc.selectedAddressBlock = ^(ListModel *model) {
        if (model) {
            [_addressBtn setTitle:model.title forState:UIControlStateSelected];
            _addressBtn.selected = YES;
            _deleteBtn.hidden = NO;
        }else{
            _addressBtn.selected = NO;
            _deleteBtn.hidden = YES;
        }
        
        if (weakSelf.addressBlock != nil) {
            weakSelf.addressBlock(model);
        }
    };
    [[MyTool topViewController].navigationController pushViewController:vc animated:YES];
}

- (void)deleteBtnAction:(UIButton *)btn
{
    btn.hidden = YES;
    _addressBtn.selected = NO;
}

- (void)nameBtnAction:(UIButton *)btn
{
    SelectRangeViewController *selectRangeVC = [[SelectRangeViewController alloc] init];
    selectRangeVC.selectIndex = _rangeIndex;
    WeakSelf(weakSelf);
    selectRangeVC.SelectRangeBlock = ^(NSInteger selectIndex) {
        if (selectIndex == 0) {
            [_nameBtn setTitle:@"公开" forState:UIControlStateNormal];
            [_nameBtn setImage:[UIImage imageNamed:@"发布_公开"] forState:UIControlStateNormal];
        } else if (selectIndex == 1) {
            [_nameBtn setTitle:@"仅好友可见" forState:UIControlStateNormal];
            [_nameBtn setImage:[UIImage imageNamed:@"发布_好友可见"] forState:UIControlStateNormal];
        } else {
            [_nameBtn setTitle:@"仅自己可见" forState:UIControlStateNormal];
            [_nameBtn setImage:[UIImage imageNamed:@"发布_自己可见"] forState:UIControlStateNormal];
        }
        weakSelf.rangeIndex = selectIndex;
        self.SelectedButtonBlock(selectIndex);
    };
    [[MyTool topViewController].navigationController pushViewController:selectRangeVC animated:YES];
}

@end
