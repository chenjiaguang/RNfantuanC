//
//  MMRichImageCell.m
//  RichTextEditDemo
//
//  Created by aron on 2017/7/19.
//  Copyright © 2017年 aron. All rights reserved.
//

#import "MMRichImageCell.h"
#import <Masonry.h>
#import "UtilMacro.h"
#import "MMRichImageModel.h"
#import "MMRichTextConfig.h"
#import "MMTextView.h"

@interface MMRichImageCell () <MMTextViewDelegate, UITextViewDelegate, MMRichImageUploadDelegate>
@property (nonatomic, strong) MMTextView* textView;
@property (nonatomic, strong) UIImageView* imageContentView;
@property (nonatomic, strong) CAShapeLayer *border;
@property (nonatomic, strong) UIButton *describeBtn;
@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, strong) MMRichImageModel* imageModel;
@end


@implementation MMRichImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.textView];
    [self.contentView addSubview:self.imageContentView];
    [self.contentView addSubview:self.reloadButton];
    [self.contentView addSubview:self.describeBtn];
    [_imageContentView.layer addSublayer:self.border];
    
    _textView.textAlignment = NSTextAlignmentCenter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)updateWithData:(id)data {
    if ([data isKindOfClass:[MMRichImageModel class]]) {
        MMRichImageModel* imageModel = (MMRichImageModel*)data;
        // 设置旧的数据delegate为nil
        _imageModel.uploadDelegate = nil;
        _imageModel = imageModel;
        // 设置新的数据delegate
        _imageModel.uploadDelegate = self;
        
        self.imageContentView.image = _imageModel.image;
        
        _imageContentView.sd_layout
        .topSpaceToView(self.contentView, 10)
        .leftSpaceToView(self.contentView, 15)
        .rightSpaceToView(self.contentView, 15)
        .heightIs(_isSort?80:_imageModel.imageFrame.size.height);
        
        // 重新设置TextView的约束
        _textView.sd_layout
        .topSpaceToView(_imageContentView, 0)
        .leftSpaceToView(self.contentView, 15)
        .rightSpaceToView(self.contentView, 15)
        .heightIs(_imageModel.textContentHeight);
        
        if (_isSort) {
            _imageContentView.sd_layout
            .leftSpaceToView(self.contentView, 15 - 38)
            .rightSpaceToView(self.contentView, 15 - 38);
            _border.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kScreenW-32, 80)].CGPath;
            _border.frame = CGRectMake(0, 0, kScreenW-32, 80);
            _border.hidden = NO;
        } else {
            _border.hidden = YES;
        }
        
        _reloadButton.sd_layout
        .yIs(imageModel.imageContentHeight - 40)
        .rightSpaceToView(self.contentView, 25)
        .widthIs(25)
        .heightEqualToWidth();
        
        
        _describeBtn.sd_layout
        .widthIs(72)
        .heightIs(20)
        .yIs(imageModel.imageContentHeight - 40)
        .leftSpaceToView(self.contentView, 25);
        
        
        self.reloadButton.hidden = _isSort;
        self.describeBtn.hidden = _isSort?YES:[_imageModel.textContent isEqualToString:@""]?NO:YES;
        self.textView.hidden = _isSort?YES:[_imageModel.textContent isEqualToString:@""]?YES:NO;
    }
}

- (void)mm_beginEditing {
    [self.textView becomeFirstResponder];
}

- (void)mm_endEditing {
    [self.textView resignFirstResponder];
}

- (void)getPreFlag:(BOOL*)isPre postFlag:(BOOL*)isPost {
    NSRange selRange = self.textView.selectedRange;
    
    // 设置标记值
    if (isPre) {
        if (selRange.location == 0) {
            *isPre = YES;
        } else {
            *isPre = NO;
        }
    }
    
    if (isPost) {
        if (selRange.location+selRange.length == _textView.text.length) {
            *isPost = YES;
        } else {
            *isPost = NO;
        }
    }
}


#pragma mark - ......::::::: lazy load :::::::......

- (MMTextView *)textView {
    if (!_textView) {
        _textView = [MMTextView new];
        _textView.scrollEnabled = NO;
        _textView.font = [UIFont systemFontOfSize:12];
        _textView.placeHolderAlignment = NSTextAlignmentCenter;
        _textView.placeHolder = @"请输入描述";
        _textView.placeHolderFrame = CGRectMake(0, 0, kScreenW - 30, 30);
        _textView.placeHolderColor = [MyTool colorWithString:@"999999"];
        _textView.maxInputs = 50;
        _textView.textAlignment = NSTextAlignmentCenter;
        _textView.backgroundColor = [MyTool colorWithString:@"f3f3f3"];
        _textView.delegate = self;
        _textView.mm_delegate = self;
    }
    return _textView;
}

- (UIImageView *)imageContentView {
    if (!_imageContentView) {
        _imageContentView = [UIImageView new];
        _imageContentView.contentMode = UIViewContentModeScaleAspectFill;
        _imageContentView.clipsToBounds = YES;
    }
    return _imageContentView;
}

- (CAShapeLayer *)border {
    if (!_border) {
        CAShapeLayer *border = [CAShapeLayer layer];
        //虚线的颜色
        border.strokeColor = [MyTool colorWithString:@"ff3f53"].CGColor;
        //填充的颜色
        border.fillColor = [UIColor clearColor].CGColor;
        //设置路径
        border.path = [UIBezierPath bezierPathWithRect:CGRectZero].CGPath;
        border.frame = CGRectZero;
        //虚线的宽度
        border.lineWidth = .5f;
        //虚线的间隔
        border.lineDashPattern = @[@2, @2];
        border.hidden = YES;
        _border = border;
    }
    return _border;
}

- (UIButton *)describeBtn
{
    if (!_describeBtn) {
        _describeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_describeBtn setImage:[UIImage imageNamed:@"编辑描述"] forState:UIControlStateNormal];
        [_describeBtn addTarget:self action:@selector(onDescribeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _describeBtn;
}

- (UIButton *)reloadButton {
    if (!_reloadButton) {
        _reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reloadButton setImage:[UIImage imageNamed:@"长文章图片删除"] forState:UIControlStateNormal];
        [_reloadButton addTarget:self action:@selector(onReloadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reloadButton;
}

- (void)onDescribeBtnClick:(UIButton *)btn
{
    [self mm_beginEditing];
    _imageModel.textContentHeight = 30;
    _imageModel.textContent = @"范团长文章NULL";
    UITableView* tableView = [self containerTableView];
    [tableView beginUpdates];
    // 重新设置TextView的约束
    _textView.sd_layout
    .topSpaceToView(_imageContentView, 0)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(_imageModel.textContentHeight);
    [tableView endUpdates];
    [self scrollToCursorForTextView:_textView];
    _describeBtn.hidden = YES;
    self.textView.hidden = [_imageModel.textContent isEqualToString:@""];
    _imageModel.textContent = @"";
}

- (void)onReloadBtnClick:(UIButton*)sender {
    if ([self.delegate respondsToSelector:@selector(mm_reloadItemAtIndexPath:)]) {
        [self.delegate mm_reloadItemAtIndexPath:[self curIndexPath]];
    }
}


#pragma mark - ......::::::: UITextViewDelegate :::::::......

- (void)textViewDidChange:(UITextView *)textView {
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    
    // 更新模型数据
    _imageModel.textContentHeight = size.height;
    _imageModel.textContent = textView.text;
    
    if (ABS(_textView.frame.size.height - size.height) > 5) {
        
        UITableView* tableView = [self containerTableView];
        [tableView beginUpdates];
        // 重新设置TextView的约束
        _textView.sd_layout
        .topSpaceToView(_imageContentView, 0)
        .leftSpaceToView(self.contentView, 15)
        .rightSpaceToView(self.contentView, 15)
        .heightIs(_imageModel.textContentHeight);
        [tableView endUpdates];
        
        [self scrollToCursorForTextView:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // 处理删除，防止输入的字数为最大值的时候删除无效
    if ([text isEqualToString:@""]) {
        return YES;
    }
    // 中间位置不能插入更多导致超过最大值
    // 结尾位置支持插入更多   && range.location < textView.text.length
    if (textView.text.length + text.length > 50) {
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    // textView.inputAccessoryView = [self.delegate mm_inputAccessoryView];
    if ([self.delegate respondsToSelector:@selector(mm_shouldShowAccessoryView:)]) {
        [self.delegate mm_shouldShowAccessoryView:YES];
    }
    if ([self.delegate respondsToSelector:@selector(mm_updateActiveIndexPath:)]) {
        [self.delegate mm_updateActiveIndexPath:[self curIndexPath]];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    textView.inputAccessoryView = nil;
    return YES;
}


#pragma mark - ......::::::: MMRichImageUploadDelegate :::::::......

// 上传进度回调
- (void)uploadProgress:(float)progress {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.reloadButton.hidden = YES;
    });
}

// 上传失败回调
- (void)uploadFail {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.reloadButton.hidden = NO;
        
        if ([self.delegate respondsToSelector:@selector(mm_uploadFailedAtIndexPath:)]) {
            [self.delegate mm_uploadFailedAtIndexPath:[self curIndexPath]];
        }
    });
}

// 上传完成回调
- (void)uploadDone {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.reloadButton.hidden = YES;
        
        if ([self.delegate respondsToSelector:@selector(mm_uploadDonedAtIndexPath:)]) {
            [self.delegate mm_uploadDonedAtIndexPath:[self curIndexPath]];
        }
    });
}

- (void)scrollToCursorForTextView:(UITextView*)textView {
    CGRect cursorRect = [textView caretRectForPosition:textView.selectedTextRange.start];
    cursorRect = [self.containerTableView convertRect:cursorRect fromView:textView];
    if (![self rectVisible:cursorRect]) {
        cursorRect.size.height += 8; // To add some space underneath the cursor
        [self.containerTableView scrollRectToVisible:cursorRect animated:YES];
    }
}

- (BOOL)rectVisible:(CGRect)rect {
    CGRect visibleRect;
    visibleRect.origin = self.containerTableView.contentOffset;
    visibleRect.origin.y += self.containerTableView.contentInset.top;
    visibleRect.size = self.containerTableView.bounds.size;
    visibleRect.size.height -= self.containerTableView.contentInset.top + self.containerTableView.contentInset.bottom;
    return CGRectContainsRect(visibleRect, rect);
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing: editing animated: YES];

    if (editing) {
        for (UIView * view in self.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString: @"Reorder"].location != NSNotFound) {
                for (UIView * subview in view.subviews) {
                    if ([subview isKindOfClass: [UIImageView class]]) {
                        ((UIImageView *)subview).image = [UIImage imageNamed: @"移动"];
                        [((UIImageView *)subview) mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.height.width.equalTo(@(convertLength(30)));
                            make.centerY.equalTo(self);
                            make.right.equalTo(self).with.offset(-30);
                        }];
                    }
                }
            }
        }
    }
}

@end
