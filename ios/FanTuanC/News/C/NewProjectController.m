//
//  NewProjectController.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/4/11.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "NewProjectController.h"
#import "MainTouchTableTableView.h"
#import "ParentClassScrollViewController.h"
#import "CircleTableViewController.h"
#import "CircleDataController.h"
#import "ReleaseDynamicViewController.h"
#import "DynamicDetailsViewController.h"
#import "NewsProjectTableViewController.h"
#import "ShareAlertView.h"
#import "NewsSegmentTitleView.h"
#import "NewsScrollContentView.h"
#import "UINavigationBar+Awesome.h"
//static CGFloat const headViewHeight = 230;

#define NAVBAR_CHANGE_POINT 50

@interface NewProjectController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,scrollDelegate,LXSegmentTitleViewDelegate,LXScrollContentViewDelegate>
{
    CGFloat headViewHeight;
    NSMutableArray *_shareArr;
}

@property(nonatomic ,strong)MainTouchTableTableView * mainTableView;
@property(nonatomic,strong) UIScrollView * parentScrollView;
@property(nonatomic,strong)UIView *headView;//头部图片
@property(nonatomic,strong)UIImageView * avatarImage;
@property(nonatomic,strong)UILabel *countentLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)CircleModel *model;
@property(nonatomic,strong)NSMutableArray *buttonList;
@property (nonatomic, strong) NewsSegmentTitleView *titleView;
@property (nonatomic, strong) NewsScrollContentView *contentView;
@property(nonatomic,weak)CALayer *LGLayer;
@end

@implementation NewProjectController
@synthesize mainTableView;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    UIButton *rButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rButton setImage:[UIImage imageNamed:@"circleDot"] forState:UIControlStateNormal];
//    [rButton setBackgroundImage:[UIImage imageNamed:@"circleDot"] forState:UIControlStateNormal];
    rButton.frame = CGRectMake(0, 0, 30, 30);
    [rButton addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rButton];
//    [self createBackButton];
    
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.mainTableView];
    
    [self.mainTableView addSubview:self.headView];
    
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

- (void)segmentTitleView:(NewsSegmentTitleView *)segmentView selectedIndex:(NSInteger)selectedIndex lastSelectedIndex:(NSInteger)lastSelectedIndex{
    self.contentView.currentIndex = selectedIndex;
}

- (void)contentViewDidScroll:(NewsScrollContentView *)contentView fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(float)progress{
    
}

- (void)contentViewDidEndDecelerating:(NewsScrollContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    self.titleView.selectedIndex = endIndex;
}


-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
  
    headViewHeight = 150 +  15 + [MyTool heightOfLabel:_dataDic[@"special"][@"intro"] forFont:[UIFont systemFontOfSize:14] labelLength:kScreenW-30] + [MyTool heightOfLabel:_dataDic[@"special"][@"name"] forFont:[UIFont systemFontOfSize:18] labelLength:kScreenW-30] + 30;
}
#pragma scrollDelegate
-(void)scrollViewLeaveAtTheTop:(UIScrollView *)scrollView
{
    self.parentScrollView = scrollView;
    //离开顶部 主View 可以滑动
    
    self.parentScrollView.scrollEnabled = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //获取滚动视图y值的偏移量
    CGFloat tabOffsetY = [mainTableView rectForSection:0].origin.y;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY>=tabOffsetY) {
        self.navigationItem.title = _dataDic[@"special"][@"name"];
        scrollView.contentOffset = CGPointMake(0, tabOffsetY);
        self.parentScrollView.scrollEnabled = YES;
    }else if(offsetY <= -headViewHeight){
        //关闭回弹 -133是表头高度
        self.navigationItem.title = @"";
        scrollView.contentOffset = CGPointMake(0, -headViewHeight);
        self.parentScrollView.scrollEnabled = YES;
    }else{
        self.navigationItem.title = @"";
    }
    
    /**
     * 处理头部视图
     */
    CGFloat yOffset  = scrollView.contentOffset.y;
    if(yOffset < -headViewHeight) {
        
        CGRect f = self.headView.frame;
        f.origin.y= yOffset ;
        f.size.height=  -yOffset;
        f.origin.y= yOffset;
        //改变头部视图的fram
        self.headView.frame= f;
        
        
        
    }
    
    CGFloat ap = 1 - fabs(offsetY)/133;
    UIColor * color = [UIColor whiteColor];
    if (offsetY + headViewHeight > NAVBAR_CHANGE_POINT) {
//        CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:ap]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

#pragma mark --tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kScreenH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /* 添加pageView
     * 这里可以任意替换你喜欢的pageView
     *作者这里使用一款github较多人使用的 WMPageController 地址https://github.com/wangmchn/WMPageController
     */
    //    [cell.contentView addSubview:self.setPageViewControllers];
    
    //    [self buttonList];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:_dataDic[@"elements"]];
    NSMutableArray *titleArr = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        [titleArr addObject:dic[@"name"]];
    }
    //初始化
    self.titleView = [[NewsSegmentTitleView alloc] initWithFrame:CGRectZero];
    self.titleView.itemMinMargin = 30.f;
    self.titleView.indicatorHeight = 3.f;
    self.titleView.indicatorExtraW = 3.f;
    self.titleView.titleFont = [UIFont systemFontOfSize:17.f];
    self.titleView.titleNormalColor = [MyTool colorWithString:@"333333"];
    self.titleView.titleSelectedColor = [MyTool colorWithString:@"333333"];
    self.titleView.indicatorColor = [MyTool colorWithString:@"1EB0FD"];
    self.titleView.delegate = self;
    self.titleView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:self.titleView];
    
    self.contentView = [[NewsScrollContentView alloc] initWithFrame:CGRectZero];
    self.contentView.delegate = self;
    [cell.contentView addSubview:self.contentView];
    
    self.titleView.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    self.contentView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
    
    NSMutableArray *arr1 = [NSMutableArray arrayWithArray:_dataDic[@"elements"]];
    self.titleView.segmentTitles = arr1;
    NSMutableArray *vcs = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < arr1.count; i++) {
        NewsProjectTableViewController *newsProjectTVC = [[NewsProjectTableViewController alloc] init];
        newsProjectTVC.ID = arr[i][@"id"];
        [vcs addObject:newsProjectTVC];
    }
    [self.contentView reloadViewWithChildVcs:vcs parentVC:self];
    self.titleView.selectedIndex = 0;
    self.contentView.currentIndex = 0;
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, _titleView.frame.size.height - 0.5, kScreenW, 0.5)];
    line.backgroundColor = [MyTool colorWithString:@"E5E5E5"];
    [cell.contentView addSubview:line];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSMutableArray *)buttonList
{
    if (!_buttonList)
    {
        _buttonList = [NSMutableArray array];
    }
    return _buttonList;
}



-(UIView *)headView
{
    if (_headView == nil)
    {
        _headView= [[UIView alloc]init];
        _headView.frame=CGRectMake(0, -headViewHeight, kScreenW, 0);
        _headView.userInteractionEnabled = YES;
        
        _avatarImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatarImage.userInteractionEnabled = YES;
        _avatarImage.clipsToBounds = YES;
        _avatarImage.contentMode = UIViewContentModeScaleAspectFill;
        [_avatarImage sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"special"][@"covers"][0][@"url"]]];
        [_headView addSubview:_avatarImage];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _titleLabel.textColor = [MyTool colorWithString:@"333333"];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.text = _dataDic[@"special"][@"name"];
        [_headView addSubview:_titleLabel];
        
        _countentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _countentLabel.font = [UIFont systemFontOfSize:12];
        _countentLabel.textColor = [MyTool colorWithString:@"999999"];
        _countentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _countentLabel.text = _dataDic[@"special"][@"intro"];
        [_headView addSubview:_countentLabel];
        
        
        _avatarImage.sd_layout
        .topSpaceToView(_headView, 0)
        .leftSpaceToView(_headView, 0)
        .rightSpaceToView(_headView, 0)
        .heightIs(150);
        
        _titleLabel.sd_layout
        .topSpaceToView(_avatarImage, 15)
        .leftSpaceToView(_headView, 15)
        .rightSpaceToView(_headView, 15)
        .autoHeightRatio(0);
        
        _countentLabel.sd_layout
        .topSpaceToView(_titleLabel, 15)
        .leftSpaceToView(_headView, 15)
        .rightSpaceToView(_headView, 15)
        .autoHeightRatio(0);
        

        [_headView setupAutoHeightWithBottomView:_countentLabel bottomMargin:15];
        
    }
    
    return _headView;
}



-(MainTouchTableTableView *)mainTableView
{
    if (mainTableView == nil)
    {
        mainTableView= [[MainTouchTableTableView alloc]initWithFrame:CGRectMake(0,0,kScreenW,kScreenH)];
        mainTableView.delegate=self;
        mainTableView.dataSource=self;
        mainTableView.showsVerticalScrollIndicator = NO;
        mainTableView.contentInset = UIEdgeInsetsMake(headViewHeight,0, 0, 0);
        mainTableView.backgroundColor = [UIColor clearColor];
    }
    return mainTableView;
}

- (void)shareBtnAction:(UIButton *)btn
{
    _shareArr = [NSMutableArray array];
    if ([WXApi isWXAppInstalled]) {
        [_shareArr addObjectsFromArray:@[@"微信好友", @"微信朋友圈"]];
    }
    if ([WeiboSDK isWeiboAppInstalled]) {
        [_shareArr addObjectsFromArray:@[@"微博"]];
    }
    if ([TencentOAuth iphoneQQInstalled]) {
        [_shareArr addObjectsFromArray:@[@"QQ好友", @"QQ空间"]];
    }
    [_shareArr addObject:@"复制链接"];
    
    [self shareViewWithShareTitle:_dataDic[@"special"][@"name"] ShareDescription:_dataDic[@"special"][@"intro"]];
}

// 分享界面
- (void)shareViewWithShareTitle:(NSString *)shareTitle ShareDescription:(NSString *)shareDescription
{
    ShareAlertView *shareAlertV = [[ShareAlertView alloc] initWithFrame:[[UIScreen mainScreen] bounds] listArr:_shareArr];
    [ApplicationDelegate.window addSubview:shareAlertV];
    
    shareAlertV.SelectItem = ^(NSIndexPath *indexPath) {
        if ([_shareArr[indexPath.row] isEqualToString:@"复制链接"]) {
            [self copyUrl];
        } else if ([_shareArr[indexPath.row] isEqualToString:@"微信好友"]) {
            [self WXshareWtihShareTitle:shareTitle ShareDescription:shareDescription Scene:WXSceneSession];
        } else if ([_shareArr[indexPath.row] isEqualToString:@"微信朋友圈"]) {
            [self WXshareWtihShareTitle:shareTitle ShareDescription:shareDescription Scene:WXSceneTimeline];
        } else if ([_shareArr[indexPath.row] isEqualToString:@"QQ好友"]) {
            [self QQshareWtihShareTitle:shareTitle ShareDescription:shareDescription Scene:1];
        } else if ([_shareArr[indexPath.row] isEqualToString:@"QQ空间"]) {
            [self QQshareWtihShareTitle:shareTitle ShareDescription:shareDescription Scene:2];
        } else if ([_shareArr[indexPath.row] isEqualToString:@"微博"]) {
            [self WBshareWtihShareTitle:shareTitle ShareDescription:shareDescription];
        }
    };
}

- (void)WBshareWtihShareTitle:(NSString *)shareTitle ShareDescription:(NSString *)shareDescription
{
    WBMessageObject *message = [WBMessageObject message];
    message.text = [NSString stringWithFormat:@"分享来自范团APP的《%@》 %@", shareTitle, _dataDic[@"special"][@"article_url"]];
    
    WBImageObject *imageObject = [WBImageObject object];
    imageObject.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_dataDic[@"special"][@"coverStr"]]];
    message.imageObject = imageObject;
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    [WeiboSDK sendRequest:request];
}

- (void)QQshareWtihShareTitle:(NSString *)shareTitle ShareDescription:(NSString *)shareDescription Scene:(int)scene
{
    QQApiURLObject *urlObject = [QQApiURLObject objectWithURL:[NSURL URLWithString:_dataDic[@"special"][@"article_url"]] title:shareTitle description:shareDescription previewImageURL:[NSURL URLWithString:_dataDic[@"special"][@"coverStr"]] targetContentType:QQApiURLTargetTypeNews];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:urlObject];
    if (scene == 1) {
        // 分享给好友
        [QQApiInterface sendReq:req];
    } else {
        //分享QQ空间
        [QQApiInterface SendReqToQZone:req];
    }
}


// 分享微信相关
- (void)WXshareWtihShareTitle:(NSString *)shareTitle ShareDescription:(NSString *)shareDescription Scene:(int)scene
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = shareTitle;
    message.description = shareDescription;
    
    WXWebpageObject *webPageObject = [WXWebpageObject object];
    webPageObject.webpageUrl = _dataDic[@"special"][@"article_url"];
    message.mediaObject = webPageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"special"][@"coverStr"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        message.thumbData = [MyTool compressOriginalImage:imageV.image toMaxDataSizeKBytes:32*1000];
        [WXApi sendReq:req];
    }];
}
// 复制链接
- (void)copyUrl
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _dataDic[@"special"][@"article_url"];
    [MyTool showHUDWithStr:@"复制成功"];
}

@end
