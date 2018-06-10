//
//  LongTextEditViewController.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/4/12.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "LongTextEditViewController.h"
#import <ZLPhotoManager.h>
#import <ZLPhotoConfiguration.h>
#import <ZLPhotoActionSheet.h>
#import "MMDraftUtil.h"
#import "MMRichContentUtil.h"
#import "MMRichTextConfig.h"

#import "MMRichTextModel.h"
#import "MMRichImageModel.h"

#import "MMRichTextCell.h"
#import "MMRichImageCell.h"


@interface LongTextEditViewController () <UITableViewDelegate, UITableViewDataSource, RichTextEditDelegate, MMRichEditAccessoryViewDelegate, UITextFieldDelegate>
{
    BOOL _isSort;
    NSMutableArray *_selectedAssets;
    ListModel *_listModel;
    NSString *_rangeStr;
}

@property (nonatomic, strong) UIView *headerBgView;
@property (nonatomic, strong) UITextField *headerTextF;
@property (nonatomic, strong) MMRichEditAccessoryView *contentInputAccessoryView;

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSMutableArray *contentArr;
@property (nonatomic, strong) NSIndexPath *activeIndexPath;

@property (copy, nonatomic) NSString *maxCount;
@property (nonatomic,assign) BOOL keyBoardlsVisible;
@property (nonatomic, strong) NSString *lastStr;

@end

@implementation LongTextEditViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
    _activeIndexPath.row==_datas.count-1?[_myTableView scrollToRowAtIndexPath:_activeIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES]:nil;
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    _rangeStr = @"0";
    _activeIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _maxCount = @"100";
    _isSort = NO;
    _selectedAssets = [NSMutableArray array];
    _datas = [NSMutableArray array];
    _imageArr = [NSMutableArray array];
    _contentArr = [NSMutableArray array];
    [_datas addObject:[MMRichTextModel new]];
    
    [self createBackButton];
    [self createRightBarButton];
    [self.view addSubview:self.myTableView];
    _myTableView.sd_layout
    .topEqualToView(self.view)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 100);
    
    _myTableView.tableHeaderView = self.headerBgView;
    [_headerTextF becomeFirstResponder];
    _headerBgView.sd_layout
    .topEqualToView(self.view)
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .heightIs(47);
    
    [self.view addSubview:self.contentInputAccessoryView];
    
    [self.myTableView registerClass:MMRichTextCell.class forCellReuseIdentifier:NSStringFromClass(MMRichTextCell.class)];
    [self.myTableView registerClass:MMRichImageCell.class forCellReuseIdentifier:NSStringFromClass(MMRichImageCell.class)];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)createBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 60, 44);
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}

- (void)backBtnAction:(UIButton *)btn
{
    [self.view endEditing:YES];
    if (_headerTextF.text.length != 0 || [self mm_shouldCellShowPlaceholder]==NO) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"退出此次编辑？"      preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];

        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [[MyTool topViewController] presentViewController:alert animated:YES completion:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)createRightBarButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [btn setTitleColor:[MyTool colorWithString:@"05a4be"] forState:UIControlStateNormal];
    [btn setTitle:@"排序" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 50, 40);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn addTarget:self action:@selector(sortBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnBarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [btn2 setTitleColor:[MyTool colorWithString:@"05a4be"] forState:UIControlStateNormal];
    [btn2 setTitle:@"发布" forState:UIControlStateNormal];
    btn2.frame = CGRectMake(0, 0, 50, 44);
    btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn2 addTarget:self action:@selector(onUpload) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn2BarBtnItem = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    
    self.navigationItem.rightBarButtonItems = @[btn2BarBtnItem,btnBarBtnItem];
}

#pragma mark - 发布
- (void)onUpload
{
    [self.view endEditing:YES];
    if (_headerTextF.text.length == 0) {
        [MyTool showHUDWithStr:@"请输入标题"];
    } else if ([self mm_shouldCellShowPlaceholder]==YES) {
        [MyTool showHUDWithStr:@"请输入正文内容"];
    } else {
        NSLog(@"发布");
        for (NSInteger i = 0; i < _datas.count; i++) {
            id dataModel = _datas[i];
            if ([dataModel isKindOfClass:[MMRichImageModel class]]) {
                MMRichImageModel *imageModel = (MMRichImageModel*)dataModel;
                [_imageArr addObject:imageModel];
            }
        }
        [self getImageUpload];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - 排序
- (void)sortBtnAction
{
    [self.view endEditing:YES];
    [_myTableView sd_resetLayout];
    _myTableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    self.navigationItem.leftBarButtonItem = nil;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    [button setTitleColor:[MyTool colorWithString:@"05a4be"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(okBtnAction) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 50, 44);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setTitle:@"确定" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:button]];
    
    _isSort = YES;
    [_myTableView setEditing:YES animated:YES];
    _contentInputAccessoryView.hidden = YES;
    [self filterNullText];
    [_myTableView reloadData];
    
    if (_datas.count!=0) {
        NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
        [_myTableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [_myTableView setContentOffset:CGPointMake(0,0) animated:NO];
    }
}

- (void)okBtnAction
{
    [_myTableView sd_resetLayout];
    _myTableView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, 100, 0));
    [self createRightBarButton];
    [self createBackButton];
    _isSort = NO;
    [_myTableView setEditing:NO animated:YES];
    _contentInputAccessoryView.hidden = NO;
    [self compleNullText];
    [_myTableView reloadData];
    NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
    [_myTableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

// 编辑状态过滤数据为空的textcell
- (void)filterNullText
{
    for (NSInteger i = 0; i < _datas.count; i++) {
        id dataModel = _datas[i];
        if ([dataModel isKindOfClass:[MMRichTextModel class]]) {
            MMRichTextModel *textModel = (MMRichTextModel*)dataModel;
            [textModel.textContent isEqualToString:@""] ? [_datas removeObjectAtIndex:i] : nil;
        }
    }
}

// 编辑完成补全空白textcell
 - (void)compleNullText
{
    if (_datas.count==0) {
        [_datas addObject:[MMRichTextModel new]];
        return;
    }
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_datas];
    NSMutableArray *indexArr = [NSMutableArray array];
    for (NSInteger i = 0; i < arr.count-1; i++) {
        id dataModel = arr[i];
        id nextModel = arr[i+1];
        if ([dataModel isKindOfClass:[MMRichImageModel class]] && [nextModel isKindOfClass:[MMRichImageModel class]]) {
            [indexArr addObject:[NSString stringWithFormat:@"%ld", i+1]];
        }
    }
    
    for (NSInteger i = indexArr.count-1; i >= 0; i--) {
        [_datas insertObject:[MMRichTextModel new] atIndex:[indexArr[i] integerValue]];
    }
    
    if ([_datas.firstObject isKindOfClass:[MMRichImageModel class]]) {
        [_datas insertObject:[MMRichTextModel new] atIndex:0];
    }
    if ([_datas.lastObject isKindOfClass:[MMRichImageModel class]]) {
        [_datas addObject:[MMRichTextModel new]];
    }
}

#pragma mark - ......::::::: RichTextEditDelegate :::::::......

- (void)mm_preInsertTextLineAtIndexPath:(NSIndexPath*)actionIndexPath textContent:(NSString*)textContent {
    
    UITableViewCell* cell = [self.myTableView cellForRowAtIndexPath:actionIndexPath];
    if ([cell isKindOfClass:[MMRichTextCell class]]) {
        // 不处理
    } else if ([cell isKindOfClass:[MMRichImageCell class]]) {
        NSIndexPath* preIndexPath = nil;
        if (actionIndexPath.row > 0) {
            preIndexPath = [NSIndexPath indexPathForRow:actionIndexPath.row - 1 inSection:actionIndexPath.section];
            
            id preData = _datas[preIndexPath.row];
            if ([preData isKindOfClass:[MMRichTextModel class]]) {
                // Image节点-前面：上面是text，光标移动到上面一行，并且在最后添加一个换行，定位光标在最后将
                [self.myTableView scrollToRowAtIndexPath:preIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
                // 设置为编辑模式
                UITableViewCell* cell = [self.myTableView cellForRowAtIndexPath:preIndexPath];
                if ([cell isKindOfClass:[MMRichTextCell class]]) {
                    [((MMRichTextCell*)cell) mm_beginEditing];
                } else if ([cell isKindOfClass:[MMRichImageCell class]]) {
                    [((MMRichImageCell*)cell) mm_beginEditing];
                }
            } else if ([preData isKindOfClass:[MMRichImageModel class]]) {
                // Image节点-前面：上面是图片或者空，在上面添加一个Text节点，光标移动到上面一行，
                [self addTextNodeAtIndexPath:actionIndexPath textContent:textContent];
            }
            
        } else {
            // 上面为空，添加一个新的单元格
            [self addTextNodeAtIndexPath:actionIndexPath textContent:textContent];
        }
    }
}

- (void)mm_postInsertTextLineAtIndexPath:(NSIndexPath*)actionIndexPath textContent:(NSString *)textContent {
    
    UITableViewCell* cell = [self.myTableView cellForRowAtIndexPath:actionIndexPath];
    if ([cell isKindOfClass:[MMRichTextCell class]]) {
        // 不处理
    } else if ([cell isKindOfClass:[MMRichImageCell class]]) {
        NSIndexPath* nextIndexPath = nil;
        nextIndexPath = [NSIndexPath indexPathForRow:actionIndexPath.row + 1 inSection:actionIndexPath.section];
        if (actionIndexPath.row < _datas.count-1) {
            
            id nextData = _datas[nextIndexPath.row];
            if ([nextData isKindOfClass:[MMRichTextModel class]]) {
                // Image节点-后面：下面是text，光标移动到下面一行，并且在最前面添加一个换行，定位光标在最前面
                [self.myTableView scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
                // 添加文字到下一行
                MMRichTextModel* textModel = ((MMRichTextModel*)nextData);
                textModel.textContent = [NSString stringWithFormat:@"%@%@", textContent, textModel.textContent];
                textModel.textContentHeight = [MMRichContentUtil computeHeightInTextVIewWithContent:textModel.textContent];
                if ([textContent isEqualToString:@"\n"]) {
                    textModel.selectedRange = NSMakeRange(0, 0);
                } else {
                    textModel.selectedRange = NSMakeRange(textContent.length, 0);
                }
                textModel.shouldUpdateSelectedRange = YES;
                
                // 设置为编辑模式
                UITableViewCell* cell = [self.myTableView cellForRowAtIndexPath:nextIndexPath];
                if ([cell isKindOfClass:[MMRichTextCell class]]) {
                    [((MMRichTextCell*)cell) mm_beginEditing];
                } else if ([cell isKindOfClass:[MMRichImageCell class]]) {
                    [((MMRichImageCell*)cell) mm_beginEditing];
                }
            } else if ([nextData isKindOfClass:[MMRichImageModel class]]) {
                // Image节点-后面：下面是图片或者空，在下面添加一个Text节点，光标移动到下面一行
                [self addTextNodeAtIndexPath:nextIndexPath textContent:textContent];
            }
            
        } else {
            // Image节点-后面：下面是图片或者空，在下面添加一个Text节点，光标移动到下面一行
            [self addTextNodeAtIndexPath:nextIndexPath textContent:textContent];
        }
    }
}

- (void)mm_preDeleteItemAtIndexPath:(NSIndexPath*)actionIndexPath {
    UITableViewCell* cell = [self.myTableView cellForRowAtIndexPath:actionIndexPath];
    if ([cell isKindOfClass:[MMRichTextCell class]]) {
        // 处理Text节点
        if (actionIndexPath.row < _datas.count) {
            
            if (actionIndexPath.row <= 0) {
                MMRichTextModel* textModel = (MMRichTextModel*)_datas[actionIndexPath.row];
                if (_datas.count == 1) {
                    // Text节点-当前的Text为空-前面-没有其他元素-：不处理
                    // Text节点-当前的Text不为空-前面-没有其他元素-：不处理
                } else {
                    if (textModel.textContent.length == 0) {
                        // Text节点-当前的Text为空-前面-有其他元素-：删除这一行，定位光标到下面图片的最后
                        if (actionIndexPath.row != 0) {
                            [self positionToNextItemAtIndexPath:actionIndexPath];
                            [self deleteItemAtIndexPath:actionIndexPath shouldPositionPrevious:NO];
                        }
                    } else {
                        // Text节点-当前的Text不为空-前面-有其他元素-：不处理
                    }
                }
            } else {
                MMRichTextModel* textModel = (MMRichTextModel*)_datas[actionIndexPath.row];
                if (textModel.textContent.length == 0) {
                    // Text节点-当前的Text为空-前面-有图片则不删除text
                    id obj = _datas[actionIndexPath.row-1];
                    if (![obj isKindOfClass:[MMRichImageModel class]]) {
                        [self deleteItemAtIndexPath:actionIndexPath shouldPositionPrevious:YES];
                    }
                    
                } else {
                    // 当前节点不为空
                    // Text节点-当前的Text不为空-前面-：上面是图片，定位光标到上面图片的最后
                    // Text节点不存在相邻的情况，所以直接定位上上一个元素即可
                    id obj = _datas[actionIndexPath.row-1];
                    if ([obj isKindOfClass:[MMRichTextModel class]]) {
                        MMRichTextModel* newTextModel = (MMRichTextModel*)obj;
                        textModel.textContent = [NSString stringWithFormat:@"%@%@", newTextModel.textContent, textModel.textContent];
                        [_datas removeObjectAtIndex:actionIndexPath.row-1];
                        [_myTableView reloadData];
                    }
                    [self positionToPreItemAtIndexPath:actionIndexPath];
                }
            }
        }
    } else if ([cell isKindOfClass:[MMRichImageCell class]]) {
        // 处理Image节点
        if (actionIndexPath.row < _datas.count) {
            if (actionIndexPath.row <= 0) {
                // Image节点-前面-上面为空：不处理
                // 第一行不处理
            } else {
                NSIndexPath* preIndexPath = [NSIndexPath indexPathForRow:actionIndexPath.row - 1 inSection:actionIndexPath.section];
                if (preIndexPath.row < _datas.count) {
                    id preData = _datas[preIndexPath.row];
                    if ([preData isKindOfClass:[MMRichTextModel class]]) {
                        if (((MMRichTextModel*)preData).textContent.length == 0) {
                            // mage节点-前面-上面为Text（为空）：删除上面Text节点
                            [self deleteItemAtIndexPath:preIndexPath shouldPositionPrevious:NO];
                        } else {
                            [self positionToPreItemAtIndexPath:actionIndexPath];
                        }
                    } else if ([preData isKindOfClass:[MMRichImageModel class]]) {
                        [self positionToPreItemAtIndexPath:actionIndexPath];
                    }
                }
            }
        }
    }
}

- (void)mm_PostDeleteItemAtIndexPath:(NSIndexPath*)actionIndexPath {
    
    UITableViewCell* cell = [self.myTableView cellForRowAtIndexPath:actionIndexPath];
    if ([cell isKindOfClass:[MMRichTextCell class]]) {
        // 不处理
        // Text节点-当前的Text不为空-后面-：正常删除
        // Text节点-当前的Text为空-后面-：正常删除，和第三种情况：为空的情况处理一样
    } else if ([cell isKindOfClass:[MMRichImageCell class]]) {
        // 处理Image节点
        if (actionIndexPath.row < _datas.count) {
            // 处理第一个节点
            if (actionIndexPath.row <= 0) {
                if (_datas.count > 1) {
                    // Image节点-后面-上面为空-列表多于一个元素：删除当前节点，光标放在后面元素之前
                    [self positionToNextItemAtIndexPath:actionIndexPath];
                    [self deleteItemAtIndexPath:actionIndexPath shouldPositionPrevious:NO];
                } else {
                    // Image节点-后面-上面为空-列表只有一个元素：添加一个Text节点，删除当前Image节点，光标放在添加的Text节点上
                    [self deleteItemAtIndexPath:actionIndexPath shouldPositionPrevious:NO];
                    [self addTextNodeAtIndexPath:actionIndexPath textContent:nil];
                }
            } else {
                // 处理非第一个节点
                NSIndexPath* preIndexPath = nil;
                if (actionIndexPath.row > 0) {
                    preIndexPath = [NSIndexPath indexPathForRow:actionIndexPath.row - 1 inSection:actionIndexPath.section];
                    id preData = _datas[preIndexPath.row];
                    if ([preData isKindOfClass:[MMRichTextModel class]]) {
                        NSIndexPath* nextIndexPath = nil;
                        if (actionIndexPath.row < _datas.count - 1) {
                            nextIndexPath = [NSIndexPath indexPathForRow:actionIndexPath.row + 1 inSection:actionIndexPath.section];
                        }
                        if (nextIndexPath) {
                            id nextData = _datas[nextIndexPath.row];
                            if ([nextData isKindOfClass:[MMRichTextModel class]]) {
                                // Image节点-后面-上面为Text-下面为Text：删除Image节点，合并下面的Text到上面，删除下面Text节点，定位到上面元素的后面
                                ((MMRichTextModel*)preData).textContent = [NSString stringWithFormat:@"%@\n%@", ((MMRichTextModel*)preData).textContent, ((MMRichTextModel*)nextData).textContent];
                                ((MMRichTextModel*)preData).textContentHeight = [MMRichContentUtil computeHeightInTextVIewWithContent:((MMRichTextModel*)preData).textContent];
                                ((MMRichTextModel*)preData).selectedRange = NSMakeRange(((MMRichTextModel*)preData).textContent.length, 0);
                                ((MMRichTextModel*)preData).shouldUpdateSelectedRange = YES;
                                
                                [self deleteItemAtIndexPathes:@[actionIndexPath, nextIndexPath] shouldPositionPrevious:YES];
                            } else {
                                // Image节点-后面-上面为Text-下面为图片或者空：删除Image节点，定位到上面元素的后面
                                [self deleteItemAtIndexPath:actionIndexPath shouldPositionPrevious:YES];
                            }
                        } else {
                            // Image节点-后面-上面为Text-下面为图片或者空：删除Image节点，定位到上面元素的后面
                            [self deleteItemAtIndexPath:actionIndexPath shouldPositionPrevious:YES];
                        }
                        
                    } else if ([preData isKindOfClass:[MMRichImageModel class]]) {
                        // Image节点-后面-上面为图片：删除Image节点，定位到上面元素的后面
                        [self deleteItemAtIndexPath:actionIndexPath shouldPositionPrevious:YES];
                    }
                }
            }
        }
    }
}

// 更新ActionIndexpath
- (void)mm_updateActiveIndexPath:(NSIndexPath*)activeIndexPath {
    _activeIndexPath = activeIndexPath;
    NSLog(@"mm_updateActiveIndexPath ===== %@", activeIndexPath);
}

#pragma mark - 删除图片
- (void)mm_reloadItemAtIndexPath:(NSIndexPath*)actionIndexPath {
    [self handleReloadItemAdIndexPath:actionIndexPath];
}

- (void)mm_uploadFailedAtIndexPath:(NSIndexPath *)actionIndexPath {
}

- (void)mm_uploadDonedAtIndexPath:(NSIndexPath *)actionIndexPath {
}

- (void)mm_shouldShowAccessoryView:(BOOL)shouldShow {
}

- (BOOL)mm_shouldCellShowPlaceholder {
    return [MMRichContentUtil shouldShowPlaceHolderFromRichContents:_datas];
}

// 处理删除
- (void)handleReloadItemAdIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row == 0 && _datas.count == 1) {
        // 第一行，并且只有一个元素：添加Text
        [self deleteItemAtIndexPath:indexPath shouldPositionPrevious:NO];
        [self addTextNodeAtIndexPath:indexPath textContent:nil];
    } else {
        [self deleteItemAtIndexPath:indexPath shouldPositionPrevious:YES];
    }
    _maxCount = [NSString stringWithFormat:@"%ld", _maxCount.integerValue+1];
}

#pragma mark - ......::::::: MMRichEditAccessoryViewDelegate :::::::......

- (void)mm_didKeyboardTapInaccessoryView:(MMRichEditAccessoryView *)accessoryView {
    if (!_keyBoardlsVisible) {
        if (_activeIndexPath.row > _datas.count-1) {
            _activeIndexPath = [NSIndexPath indexPathForRow:_datas.count - 1 inSection:0];
        }
        [_myTableView scrollToRowAtIndexPath:_activeIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
        UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath:_activeIndexPath];
        if ([cell isKindOfClass:[MMRichTextCell class]]) {
            [((MMRichTextCell*)cell) mm_beginEditingShowKB];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                id data = _datas[_activeIndexPath.row];
                if ([data isKindOfClass:[MMRichTextCell class]]) {
                    MMRichTextCell *cell = [self.myTableView cellForRowAtIndexPath:_activeIndexPath];
                    [cell mm_beginEditingShowKB];
                } else {
                    MMRichImageCell *cell = [self.myTableView cellForRowAtIndexPath:_activeIndexPath];
                    [cell mm_beginEditing];
                }
            });
        }
    } else {
        [self.view endEditing:YES];
    }
}

- (void)mm_didImageTapInaccessoryView:(MMRichEditAccessoryView *)accessoryView {
    [self handleSelectPics];
}

- (void)handleSelectPics {
    
    if (self.maxCount.integerValue <= 0) {
        [MyTool showHUDWithStr:@"最多选择100张图片"];
        return;
    }
    
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    
#pragma mark - 参数配置 optional，可直接使用 defaultPhotoConfiguration
    
    //以下参数为自定义参数，均可不设置，有默认值
    actionSheet.configuration.sortAscending = NO;
    actionSheet.configuration.allowSelectImage = YES;
    actionSheet.configuration.allowSelectGif = NO;
    actionSheet.configuration.allowSelectVideo = NO;
    actionSheet.configuration.allowSelectLivePhoto = NO;
    actionSheet.configuration.allowForceTouch = YES;
    actionSheet.configuration.allowEditImage = NO;
    actionSheet.configuration.allowEditVideo = NO;
    actionSheet.configuration.allowSlideSelect = YES;
    actionSheet.configuration.allowMixSelect = NO;
    actionSheet.configuration.allowDragSelect = NO;
    actionSheet.configuration.allowSelectOriginal = NO;
    //设置相册内部显示拍照按钮
    actionSheet.configuration.allowTakePhotoInLibrary = YES;
    //设置在内部拍照按钮上实时显示相机俘获画面
    actionSheet.configuration.showCaptureImageOnTakePhotoBtn = NO;
    //设置照片最大选择数
    actionSheet.configuration.maxSelectCount = self.maxCount.integerValue;
    //设置照片cell弧度
    //单选模式是否显示选择按钮
    actionSheet.configuration.showSelectBtn = YES;
    //是否在选择图片后直接进入编辑界面
    actionSheet.configuration.editAfterSelectThumbnailImage = NO;
    //是否保存编辑后的图片
    //    actionSheet.configuration.saveNewImageAfterEdit = NO;
    //设置编辑比例
    //    actionSheet.configuration.clipRatios = @[GetClipRatio(7, 1)];
    //是否在已选择照片上显示遮罩层
    actionSheet.configuration.showSelectedMask = NO;
    //颜色，状态栏样式
    //    actionSheet.configuration.selectedMaskColor = [UIColor purpleColor];
    actionSheet.configuration.navBarColor = [UIColor whiteColor];
    actionSheet.configuration.navTitleColor = [UIColor blackColor];
    //    actionSheet.configuration.bottomBtnsNormalTitleColor = kRGB(80, 160, 100);
    //    actionSheet.configuration.bottomBtnsDisableBgColor = kRGB(190, 30, 90);
    actionSheet.configuration.bottomViewBgColor = [UIColor colorWithWhite:0 alpha:0.8];
    actionSheet.configuration.statusBarStyle = UIStatusBarStyleDefault;
    actionSheet.configuration.customImageNames = @[@"btn_circle", @"btn_selected", @"btn_unselected", @"takePhoto", @"navBackBtn"];
    //是否允许框架解析图片
    actionSheet.configuration.shouldAnialysisAsset = YES;
    //自定义多语言
    //    actionSheet.configuration.customLanguageKeyValue = @{@"ZLPhotoBrowserCameraText": @"没错，我就是一个相机"};
    
    //是否使用系统相机
    actionSheet.configuration.useSystemCamera = YES;
    actionSheet.configuration.sessionPreset = ZLCaptureSessionPreset1920x1080;
    actionSheet.configuration.exportVideoType = ZLExportVideoTypeMp4;
    actionSheet.configuration.allowRecordVideo = NO;
    
#pragma mark - required
    //如果调用的方法没有传sender，则该属性必须提前赋值
    actionSheet.sender = self;
    //记录上次选择的图片
    actionSheet.arrSelectedAssets = nil;
    
    zl_weakify(self);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        zl_strongify(weakSelf);
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
        strongSelf.lastStr = @"";
        for (NSInteger i = 0; i < images.count; i++) {
            [self handleInsertImage:images[i]];
        }
        if (![_lastStr isEqualToString:@""]) {
            [self addTextNodeAtIndexPath:[NSIndexPath indexPathForRow:_activeIndexPath.row + 2 inSection:_activeIndexPath.section] textContent:_lastStr];
        }
        strongSelf.maxCount = [NSString stringWithFormat:@"%ld", strongSelf.maxCount.integerValue - images.count];
    }];
    
    [actionSheet showPhotoLibrary];
}

- (void)handleInsertImage:(UIImage*)image {
    
    UITableViewCell *cell = [_myTableView cellForRowAtIndexPath:_activeIndexPath];
    if ([cell isKindOfClass:[MMRichTextCell class]]) {
        // 处理文本节点
        // 根据光标拆分文本节点
        BOOL isPre = NO;
        BOOL isPost = NO;
        NSArray *splitedTexts = [((MMRichTextCell*)cell) splitedTextArrWithPreFlag:&isPre postFlag:&isPost];
        if (splitedTexts.count==2) {
            // 替换当前节点，添加Text/image/Text，光标移动到图片节点上
            NSInteger tmpActiveIndexRow = _activeIndexPath.row;
            NSInteger tmpActiveIndexSection = _activeIndexPath.section;
            // 处理删除
            [_datas removeObjectAtIndex:tmpActiveIndexRow];
            [self.myTableView beginUpdates];
            [self.myTableView deleteRowsAtIndexPaths:@[_activeIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.myTableView endUpdates];
            // 第一段文字
            [self addTextNodeAtIndexPath:_activeIndexPath textContent:[splitedTexts.firstObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            // 图片
            [self addImageNodeAtIndexPath:[NSIndexPath indexPathForRow:tmpActiveIndexRow + 1 inSection:tmpActiveIndexSection] image:image];
            // 第二段文字
            _lastStr = [splitedTexts.lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        } else {
            NSIndexPath* nextIndexPath = [NSIndexPath indexPathForRow:_activeIndexPath.row + 1 inSection:_activeIndexPath.section];
            [self addImageNodeAtIndexPath:nextIndexPath image:image];
            [self postHandleAddImageNode:nextIndexPath];
        }
    } else if ([cell isKindOfClass:[MMRichImageCell class]]) {
        NSIndexPath* nextIndexPath = [NSIndexPath indexPathForRow:_activeIndexPath.row + 2 inSection:_activeIndexPath.section];
        [self addImageNodeAtIndexPath:nextIndexPath image:image];
        [self postHandleAddImageNode:nextIndexPath];
    } else {
        NSIndexPath* nextIndexPath = [NSIndexPath indexPathForRow:_activeIndexPath.row + 1 inSection:_activeIndexPath.section];
        [self addImageNodeAtIndexPath:nextIndexPath image:image];
        [self postHandleAddImageNode:nextIndexPath];
    }
}

#pragma mark - Node Handler

- (void)addImageNodeAtIndexPath:(NSIndexPath*)indexPath image:(UIImage*)image {
    
    NSLog(@"addImageNodeAtIndexPath ===== %@", indexPath);
    
    UIImage* scaledImage = [MMRichContentUtil scaleImage:image];
    NSString* scaledImageStoreName= [MMRichContentUtil saveImageToLocal:scaledImage];
    if (scaledImageStoreName == nil || scaledImageStoreName.length <= 0) {
        // 提示出错
        return;
    }
    MMRichImageModel* imageModel =  [MMRichImageModel new];
    imageModel.image = scaledImage;
    imageModel.localImageName = scaledImageStoreName;
    CGFloat width = [MMRichTextConfig sharedInstance].editAreaWidth;
    NSAttributedString* imgAttrStr = [imageModel attrStringWithContainerWidth:width];
    imageModel.imageContentHeight = [MMRichContentUtil computeHeightInTextVIewWithContent:imgAttrStr minHeight:MMEditConfig.minImageContentCellHeight];
    
    // 添加到上传队列中
    [[MMFileUploadUtil sharedInstance] addUploadItem:imageModel];
    
    [self.myTableView beginUpdates];
    [_datas insertObject:imageModel atIndex:indexPath.row];
    [self.myTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.myTableView endUpdates];
    [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

- (void)postHandleAddImageNode:(NSIndexPath*)indexPath {
    if (indexPath.row < _datas.count - 1) {
        NSIndexPath* nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        id nextData = _datas[nextIndexPath.row];
        if ([nextData isKindOfClass:[MMRichTextModel class]]) {
            // Image节点-后面：下面是text，光标移动到下面一行，并且在最前面添加一个换行，定位光标在最前面
            [self.myTableView scrollToRowAtIndexPath:nextIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            MMRichTextModel* textModel = ((MMRichTextModel*)nextData);
            textModel.selectedRange = NSMakeRange(0, 0);
            textModel.shouldUpdateSelectedRange = YES;
            [self positionAtIndex:nextIndexPath];
            
        } else if ([nextData isKindOfClass:[MMRichImageModel class]]) {
            // 添加文字到下一行
            [self addTextNodeAtIndexPath:nextIndexPath textContent:@""];
        }
    } else {
        // 添加文字到下一行
        NSIndexPath* nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        [self addTextNodeAtIndexPath:nextIndexPath textContent:@""];
    }
}

- (void)addTextNodeAtIndexPath:(NSIndexPath*)indexPath textContent:(NSString*)textContent {
    MMRichTextModel* textModel = [MMRichTextModel new];
    textModel.textContent = [textContent isEqualToString:@"\n"] ? @"" : textContent == nil ? @"" : textContent;
    textModel.textContentHeight = [MMRichContentUtil computeHeightInTextVIewWithContent:textModel.textContent];
    
    [self.myTableView beginUpdates];
    [_datas insertObject:textModel atIndex:indexPath.row];
    [self.myTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.myTableView endUpdates];
    [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    
    // 定位到新增的元素
    [self positionAtIndex:indexPath];
}

- (void)deleteItemAtIndexPathes:(NSArray<NSIndexPath*>*)actionIndexPathes shouldPositionPrevious:(BOOL)shouldPositionPrevious {
    if (actionIndexPathes.count > 0) {
        // 处理删除
        for (NSInteger i = actionIndexPathes.count - 1; i >= 0; i--) {
            NSIndexPath* actionIndexPath = actionIndexPathes[i];
            id obj = _datas[actionIndexPath.row];
            if ([obj isKindOfClass:[MMRichImageModel class]]) {
                [MMDraftUtil deleteImageContent:(MMRichImageModel*)obj];
            }
            [_datas removeObjectAtIndex:actionIndexPath.row];
        }
        [self.myTableView beginUpdates];
        [self.myTableView deleteRowsAtIndexPaths:actionIndexPathes withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.myTableView endUpdates];
        
        //  定位动到上一行
        if (shouldPositionPrevious) {
            [self positionToPreItemAtIndexPath:actionIndexPathes.firstObject];
        }
    }
}

- (void)deleteItemAtIndexPath:(NSIndexPath*)actionIndexPath shouldPositionPrevious:(BOOL)shouldPositionPrevious {
    //  定位动到上一行
    if (shouldPositionPrevious) {
        [self positionToPreItemAtIndexPath:actionIndexPath];
    }
    
    MMRichTextModel *obj = _datas[actionIndexPath.row+1];
    
    // 处理光标的位置
    if (_activeIndexPath.row == actionIndexPath.row) {
        _activeIndexPath = [NSIndexPath indexPathForRow:_activeIndexPath.row-1 inSection:_activeIndexPath.section];
    } else if (_activeIndexPath.row == _datas.count-1) {
        if ([obj.textContent isEqualToString:@""]) {
            _activeIndexPath = [NSIndexPath indexPathForRow:_activeIndexPath.row-2 inSection:_activeIndexPath.section];
        } else {
            _activeIndexPath = [NSIndexPath indexPathForRow:_activeIndexPath.row-1 inSection:_activeIndexPath.section];
        }
    }
    
    
    if ([obj.textContent isEqualToString:@""]) {
        [_datas removeObjectAtIndex:actionIndexPath.row+1];
        [self.myTableView beginUpdates];
        [self.myTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:actionIndexPath.row+1 inSection:actionIndexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
        [self.myTableView endUpdates];
    }
    
    // 处理删除
    [_datas removeObjectAtIndex:actionIndexPath.row];
    [self.myTableView beginUpdates];
    [self.myTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:actionIndexPath.row inSection:actionIndexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
    [self.myTableView endUpdates];
}

/**
 定位到指定的元素
 */
- (void)positionAtIndex:(NSIndexPath*)indexPath {
    UITableViewCell* cell = [self.myTableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[MMRichTextCell class]]) {
        [((MMRichTextCell*)cell) mm_beginEditing];
    } else if ([cell isKindOfClass:[MMRichImageCell class]]) {
        [((MMRichImageCell*)cell) mm_beginEditing];
    }
}

// 定位动到上一行
- (void)positionToPreItemAtIndexPath:(NSIndexPath*)actionIndexPath {
    NSIndexPath* preIndexPath = [NSIndexPath indexPathForRow:actionIndexPath.row - 1 inSection:actionIndexPath.section];
    [self positionAtIndex:preIndexPath];
}

// 定位动到下一行
- (void)positionToNextItemAtIndexPath:(NSIndexPath*)actionIndexPath {
    NSIndexPath* preIndexPath = [NSIndexPath indexPathForRow:actionIndexPath.row + 1 inSection:actionIndexPath.section];
    [self positionAtIndex:preIndexPath];
}

- (UITableView *)myTableView{
    if (!_myTableView) {
        UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        if (@available(iOS 11.0, *)) {
            _myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTableViewTap)]];
        _myTableView = tableView;
    }
    return _myTableView;
}

- (UIView *)headerBgView
{
    if (!_headerBgView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [view addSubview:self.headerTextF];
        _headerBgView = view;
    }
    return _headerBgView;
}
- (UITextField *)headerTextF
{
    if (!_headerTextF) {
        UITextField *textF = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, kScreenW - 30, 47)];
        textF.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:17];
        textF.textColor = [MyTool colorWithString:@"333333"];
        textF.placeholder = @"标题（1-30字之间）";
        [textF setValue:[MyTool colorWithString:@"999999"] forKeyPath:@"_placeholderLabel.textColor"];
        [textF setValue:[UIFont fontWithName:@"PingFangSC-Semibold" size:17] forKeyPath:@"_placeholderLabel.font"];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 46.5, kScreenW - 30, 0.5)];
        line.backgroundColor = [MyTool colorWithString:@"e1e1e1"];
        [textF addSubview:line];
        textF.delegate = self;
        [textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _headerTextF = textF;
    }
    return _headerTextF;
}

- (MMRichEditAccessoryView *)contentInputAccessoryView {
    if (!_contentInputAccessoryView) {
        _contentInputAccessoryView = [[MMRichEditAccessoryView alloc] init];
        _contentInputAccessoryView.backgroundColor = [UIColor whiteColor];
        _contentInputAccessoryView.delegate = self;
        _contentInputAccessoryView.circleName = _formText;
        _contentInputAccessoryView.SelectedButtonBlock = ^(NSInteger selectIndex) {
            _rangeStr = [NSString stringWithFormat:@"%ld", selectIndex];
        };
        _contentInputAccessoryView.addressBlock = ^(ListModel *model) {
            _listModel = model;
        };
    }
    return _contentInputAccessoryView;
}

- (void)onTableViewTap {
    NSIndexPath* lastIndexPath = [NSIndexPath indexPathForRow:_datas.count - 1 inSection:0];
    UITableViewCell* cell = [_myTableView cellForRowAtIndexPath:lastIndexPath];
    if ([cell isKindOfClass:[MMRichTextCell class]]) {
        [((MMRichTextCell*)cell) mm_beginEditingShowKB];
    } else if ([cell isKindOfClass:[MMRichImageCell class]]) {
        [((MMRichImageCell*)cell) mm_beginEditing];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.headerTextF) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.headerTextF.text.length >= 30) {
            self.headerTextF.text = [textField.text substringToIndex:30];
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    CGFloat maxLength = 30;
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position || !selectedRange)
    {
        if (toBeString.length > maxLength)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:maxLength];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

#pragma mark - ......::::::: UITableView Handler :::::::......

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isSort) {
        return 90;
    }
    id obj = _datas[indexPath.row];
    if ([obj isKindOfClass:[MMRichTextModel class]]) {
        MMRichTextModel* textModel = (MMRichTextModel*)obj;
        return textModel.textContentHeight + 10;
    } else if ([obj isKindOfClass:[MMRichImageModel class]]) {
        MMRichImageModel* imageModel = (MMRichImageModel*)obj;
        if ([imageModel.textContent isEqualToString:@""]) {
            imageModel.textContentHeight = 0;
        }
        return imageModel.imageContentHeight + imageModel.textContentHeight;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Content
    id obj = _datas[indexPath.row];
    if ([obj isKindOfClass:[MMRichTextModel class]]) {
        MMRichTextCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MMRichTextCell.class)];
        cell.delegate = self;
        cell.isSort = _isSort;
        [cell updateWithData:obj indexPath:indexPath];
        return cell;
    }
    if ([obj isKindOfClass:[MMRichImageModel class]]) {
        MMRichImageCell* cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MMRichImageCell.class)];
        cell.delegate = self;
        cell.isSort = _isSort;
        [cell updateWithData:obj];
        return cell;
    }
    
    static NSString* cellID = @"cellId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    id obj = _datas[indexPath.row];
    if ([obj isKindOfClass:[MMRichTextModel class]]) {
        return NO;
    } else if ([obj isKindOfClass:[MMRichImageModel class]]) {
        return YES;
    }
    return YES;
}

//对数据源进行重新排序
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    [_datas exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
//    [_myTableView reloadData];
}

#pragma mark - ......::::::: Notification :::::::......

- (void)keyboardWillShow:(NSNotification*)noti {
    
    _keyBoardlsVisible = YES;
    
    CGRect keyboardFrame = [noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    NSTimeInterval keyboardAnimTime = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    CGFloat keyboardH = kScreenH - keyboardFrame.origin.y;
    // 处理显示AccessorityView
    [UIView animateWithDuration:keyboardAnimTime animations:^{
        _myTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardH, 0);
        _contentInputAccessoryView.kbImageIcon.image = [UIImage imageNamed:@"回收键盘"];
        [_contentInputAccessoryView sd_resetLayout];
        _contentInputAccessoryView.sd_layout
        .leftEqualToView(self.view)
        .rightEqualToView(self.view)
        .bottomSpaceToView(self.view, keyboardH)
        .heightIs(100);
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    
    _keyBoardlsVisible = NO;
    
    NSTimeInterval keyboardAnimTime = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
        // 处理隐藏AccessorityView
        [UIView animateWithDuration:keyboardAnimTime animations:^{
            _myTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            _contentInputAccessoryView.kbImageIcon.image = [UIImage imageNamed:@"弹出键盘"];
            [_contentInputAccessoryView sd_resetLayout];
            _contentInputAccessoryView.sd_layout
            .bottomEqualToView(self.view)
            .leftEqualToView(self.view)
            .rightEqualToView(self.view)
            .heightIs(100);
        }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - 上传图片接口
- (void)getImageUpload
{
    NSString * url = [NetRequest ImageUpload];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken]};
    [manager POST:url parameters:paramsDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSInteger i = 0; i < _imageArr.count; i++) {
            MMRichImageModel *imageModel = (MMRichImageModel*)_imageArr[i];
            UIImage *originalImage = imageModel.image;
            originalImage = [MyTool fixOrientation:originalImage];
            NSData *picData = UIImageJPEGRepresentation(originalImage, 0.5);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *fileName = [NSString stringWithFormat:@"%@%ld.png", [formatter stringFromDate:[NSDate date]], i];
            [formData appendPartWithFileData:picData name:[NSString stringWithFormat:@"image%ld", i] fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat progerss = 100 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        self.ProgressBlock(progerss);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 处理图片的URL、宽高放入contentArr里面传给后台
        NSDictionary *dic = responseObject;
        NSMutableArray *imageUrlArr = [dic[@"data"][@"url"] mutableCopy];
        NSInteger imageIndex = 0;
        [_contentArr removeAllObjects];
        for (NSInteger i = 0; i < _datas.count; i++) {
            NSDictionary *dic = [NSDictionary dictionary];
            id dataModel = _datas[i];
            if ([dataModel isKindOfClass:[MMRichImageModel class]]) {
                MMRichImageModel *imageModel = (MMRichImageModel*)dataModel;
                dic = @{@"content": @"", @"des":[imageModel.textContent stringByReplacingOccurrencesOfString:@"\n" withString:@" "], @"imageUrl":imageUrlArr[imageIndex], @"width":[NSString stringWithFormat:@"%f", imageModel.imageFrame.size.width], @"height":[NSString stringWithFormat:@"%f", imageModel.imageFrame.size.height], @"type":@"2"};
                imageIndex++;
            } else {
                MMRichTextModel *textModel = (MMRichTextModel*)dataModel;
                dic = @{@"content": textModel.textContent, @"des":@"", @"imageUrl":@"", @"width":@"", @"height":@"", @"type":@"1"};
            }
            self.uploadCompleteBlock();
            [_contentArr addObject:[MyTool dictionaryToJson:[dic mutableCopy]]];
        }
        NSArray *imageIdArr = dic[@"data"][@"id"];
        imageIdArr.count>3?imageIdArr=[imageIdArr subarrayWithRange:NSMakeRange(0, 3)]:NULL;
        [self getPublishDynamiCarticleWithImageID:[imageIdArr componentsJoinedByString:@","]];
        NSLog(@"上传成功== %@", dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"错误信息=====%@", error.description);
    }];
}

- (void)getPublishDynamiCarticleWithImageID:(NSString *)ImageID
{
    NSString *urlStr = [NetRequest PublishDynamiCarticle];
    NSDictionary *paramsDic = @{@"circle_id": _circle_id, @"image_ids": ImageID?ImageID:@"", @"title": _headerTextF.text, @"content": [MyTool objArrayToJSON:_contentArr],@"lng":_listModel?_listModel.lng:@"",@"lat":_listModel?_listModel.lat:@"",@"location":_listModel?_listModel.title:@"", @"range": _rangeStr};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [MyTool showHUDWithStr:JSON[@"msg"]];
    } failure:^(NSError *error) {
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
