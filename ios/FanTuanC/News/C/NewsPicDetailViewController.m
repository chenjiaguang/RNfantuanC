//
//  NewsPicDetailViewController.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/3/28.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "NewsPicDetailViewController.h"
#import "DDPhotoScrollView.h"
#import "DDPhotoDescView.h"
#import "NewsPicHeaderView.h"
#import "NewsPicBottomView.h"
#import "JT3DScrollView.h"
#import "NewsCommentViewController.h"

@interface NewsPicDetailViewController () <UIScrollViewDelegate>
{
    NSMutableArray *_photoDataArr;
}

@property (nonatomic, strong) JT3DScrollView *imageScrollView;
@property (nonatomic, strong) DDPhotoDescView *photoDescView;
@property (nonatomic, strong) NewsPicHeaderView *headerView;
@property (nonatomic, strong) NewsPicBottomView *bottomView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIView *textBgView;
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, assign) BOOL isDisappear;

@end

@implementation NewsPicDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.jz_navigationBarHidden = YES;
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.jz_navigationBarHidden = NO;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _photoDataArr = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createWhiteBackButton];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.bottomView];
    [self createTextView];
    
    [self getPicDetailData];
}

- (void)createWhiteBackButton
{
    CGFloat statuBarH = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(0, statuBarH, 50, 49);
    [_backBtn setImage:[UIImage imageNamed:@"白色返回"] forState:UIControlStateNormal];
    _backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
}

- (JT3DScrollView *)imageScrollView
{
    if (_imageScrollView == nil) {
        // 设置大ScrollView  40:适当提高下imageView的高度，否则上面显得太空洞
        _imageScrollView = [[JT3DScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _imageScrollView.contentSize = CGSizeMake(_photoDataArr.count * kScreenW, kScreenH);
        _imageScrollView.showsHorizontalScrollIndicator = NO;
        _imageScrollView.effect = JT3DScrollViewEffectNone; // 切换的动画效果,随机枚举中的1，2，3三种效果。
        _imageScrollView.clipsToBounds = YES;
        _imageScrollView.delegate = self;
        
        // 设置小ScrollView（装载imageView的scrollView）
        for (int i = 0; i < _photoDataArr.count; i++) {
            DDPhotoScrollView *photoScrollView = [[DDPhotoScrollView alloc] initWithFrame:CGRectMake(kScreenW * i, 0, kScreenW, kScreenH) urlString:_photoDataArr[i][@"img_url"]];
            // singleTapBlock回调：让所有UI，除了图片，全部消失
            __weak typeof(self) weakSelf = self;
            photoScrollView.singleTapBlock = ^{
//                NSLog(@"tap~");
                // 如果已经消失，就出现
                if (weakSelf.isDisappear == YES) {
                    [weakSelf.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (![obj isKindOfClass:[JT3DScrollView class]]) {
                            [UIView animateWithDuration:0.3 animations:^{
                                obj.alpha = 1;
                                weakSelf.view.backgroundColor = [UIColor blackColor];
                            } completion:^(BOOL finished) {
                                obj.userInteractionEnabled = YES;
                            }];
                        }
                    }];
                    weakSelf.isDisappear = NO;
                } else { // 消失
                    [weakSelf.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (![obj isKindOfClass:[JT3DScrollView class]]) {
                            [UIView animateWithDuration:0.3 animations:^{
                                obj.alpha = 0;
                                weakSelf.view.backgroundColor = [UIColor blackColor];
                            } completion:^(BOOL finished) {
                                obj.userInteractionEnabled = NO;
                            }];
                        }
                    }];
                    weakSelf.isDisappear = YES;
                }
                
            };
            [_imageScrollView addSubview:photoScrollView];
        }
    }
    return _imageScrollView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self createDescViewWithIndex:_imageScrollView.currentPage];
}

- (void)createDescViewWithIndex:(NSInteger)index
{
    // 如果已经消失了，就不展现描述文本了。
    //    NSLog(@"_isDisappear = %zd", _isDisappear);
    if (_isDisappear == YES || index < 0 || index > _photoDataArr.count-1) {return;}
    
    // 先remove
    [_photoDescView removeFromSuperview];
    // 再加入
    _photoDescView = [[DDPhotoDescView alloc] initWithDesc:_photoDataArr[index][@"content"] index:index totalCount:_photoDataArr.count];
    [self.view insertSubview:_photoDescView belowSubview:self.bottomView];
}

- (NewsPicHeaderView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[NewsPicHeaderView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_backBtn.frame), [[UIApplication sharedApplication] statusBarFrame].size.height, kScreenW - CGRectGetMaxX(_backBtn.frame), 44)];
        _headerView.backgroundColor = [UIColor clearColor];
    }
    return _headerView;
}

- (NewsPicBottomView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[NewsPicBottomView alloc] initWithFrame:CGRectMake(0, kScreenH - 50, kScreenW, 50)];
        _bottomView.backgroundColor = [UIColor blackColor];
        WeakSelf(weakSelf);
        _bottomView.commentBlock = ^{
            if ([[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] != YES) {
                [weakSelf pushLoginVC];
            } else {
                [weakSelf.textView becomeFirstResponder];
            }
        };
    }
    return _bottomView;
}

- (void)createTextView
{
    UIView *maskView = [[UIView alloc]initWithFrame:CGRectZero];
    maskView.backgroundColor = [UIColor clearColor];
    maskView.hidden = YES;
    maskView.tag = 5000;
    [ApplicationDelegate.window addSubview:maskView];
    maskView.userInteractionEnabled = YES;
    UITapGestureRecognizer *maskViewTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskViewTap)];
    [maskView addGestureRecognizer:maskViewTap];
    maskViewTap.delegate = self;
    _maskView = maskView;
    
    UIView *textBgView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, 121)];
    textBgView.backgroundColor = [UIColor whiteColor];
    textBgView.hidden = YES;
    [maskView addSubview:textBgView];
    _textBgView = textBgView;
    UIView *textBgLineView = [[UIView alloc]initWithFrame:CGRectZero];
    textBgLineView.backgroundColor = [MyTool colorWithString:@"e5e5e5"];
    [textBgView addSubview:textBgLineView];
    
    YYTextView *textView = [[YYTextView alloc]initWithFrame:CGRectZero];
    textView.font = [UIFont systemFontOfSize:14];
    textView.backgroundColor = [MyTool colorWithString:@"f1f1f1"];
    textView.placeholderText = [NSString stringWithFormat:@"发表一下高见吧~"];
    textView.placeholderFont = [UIFont systemFontOfSize:14];
    textView.placeholderTextColor = [MyTool colorWithString:@"999999"];
    [textBgView addSubview:textView];
    _textView = textView;
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitleColor:[MyTool colorWithString:@"333333"] forState:UIControlStateNormal];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchDown];
    [textBgView addSubview:sendBtn];
    
    
    maskView.sd_layout
    .topSpaceToView(ApplicationDelegate.window, 0)
    .leftSpaceToView(ApplicationDelegate.window, 0)
    .rightSpaceToView(ApplicationDelegate.window, 0)
    .bottomSpaceToView(ApplicationDelegate.window, 0);
    
    textBgLineView.sd_layout
    .topSpaceToView(textBgView, 0)
    .leftSpaceToView(textBgView, 0)
    .rightSpaceToView(textBgView, 0)
    .heightIs(0.5);
    
    textView.sd_cornerRadius = @(5);
    textView.sd_layout
    .topSpaceToView(textBgView, 10)
    .leftSpaceToView(textBgView, 15)
    .rightSpaceToView(textBgView, 68)
    .bottomSpaceToView(textBgView, 9.9);
    
    sendBtn.sd_layout
    .topSpaceToView(textBgView, 0)
    .leftSpaceToView(textView, 0)
    .rightSpaceToView(textBgView, 0)
    .bottomSpaceToView(textBgView, 0);
}

-(void)maskViewTap
{
    _textBgView.frame = CGRectMake(0, kScreenH , kScreenW, 121);
    _maskView.hidden = YES;
    [_textView resignFirstResponder];
}

-(void)sendAction:(UIButton *)btn
{
    if (_textView.text.length == 0) {
        [MyTool showHUDWithStr:@"评论不能为空哦~"];
        return;
    }
    [self getNewsCommentIssue];
}

- (void)getNewsCommentIssue
{
    [self loadingWithText:@"加载中"];
    NSString *urlStr = [NetRequest NewsCommentIssue];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"article_id": _article_id, @"content": _textView.text};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [self endLoading];
        if ([JSON[@"error"] integerValue] == 0) {
            [self maskViewTap];
            _textView.text = @"";
            NewsCommentViewController *newsCommentVC = [[NewsCommentViewController alloc] init];
            newsCommentVC.article_id = _article_id;
            [self.navigationController pushViewController:newsCommentVC animated:YES];
        }
    } failure:^(NSError *error) {
        [self endLoading];
    }];
}

- (void)getPicDetailData
{
    [self loadingWithText:@"加载中"];
    NSString *urlStr = [NetRequest NewsDetail];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] boolForKey:kUserHasLogin] == YES ? [[NSUserDefaults standardUserDefaults] objectForKey:kToken] : @"", @"article_id": _article_id};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        [self endLoading];
        if ([JSON[@"error"] integerValue] == 0) {
            _photoDataArr = JSON[@"data"][@"atlas_content"];
            
            _headerView.dataDic = JSON[@"data"];
            _bottomView.dataDic = JSON[@"data"];
            
            [self.view insertSubview:self.imageScrollView belowSubview:_backBtn];
            [self createDescViewWithIndex:0];
        }
    } failure:^(NSError *error) {
        [self endLoading];
    }];
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    _maskView.hidden = NO;
    _textBgView.hidden = NO;
    
    _textBgView.frame = CGRectMake(0, kScreenH - height - 121, kScreenW, 121);
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    _textBgView.frame = CGRectMake(0, kScreenH , kScreenW, 121);
    _textBgView.hidden = YES;
    _maskView.hidden = YES;
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
