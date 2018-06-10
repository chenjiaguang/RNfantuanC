//
//  ReleaseReviewViewController.m
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/28.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "ReleaseReviewViewController.h"
#import "UIView+Layout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZPhotoPreviewController.h"

@interface ReleaseReviewViewController ()
{
    NSString *_scoreStr;
    UILabel *_scoreLabel;
    UITextView *_myTextView;
    UILabel *_placeLabel;
    UILabel *_wordNumber;
    UIView *_imageBgView;
    NSString *_is_anonymous;
    UIButton *_nmBtn;
    UILabel *_nmLabel;
    UILabel *_nmLabel1;
    UIButton *_sendBtn;
    
    NSMutableArray *_selectedAssets;
}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;

@end

@implementation ReleaseReviewViewController

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        if (iOS7Later) {
            _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        }
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9.0, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"发表评价";
    
    _is_anonymous = @"0";
    _imageArr = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    _imageViewArr = [NSMutableArray array];
    [self createUI];
    [self createImage];
    
}

- (void)createUI
{
    _myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 64)];
    if (iPhoneX) {
        _myScrollView.frame = CGRectMake(0, 0, kScreenW, kScreenH - 88);
    }
    _myScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_myScrollView];
    
    _myScrollView.contentSize = CGSizeMake(_myScrollView.frame.size.width, _myScrollView.frame.size.height);
    
    
    _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenW, 30)];
    _scoreLabel.backgroundColor = [UIColor clearColor];
    _scoreLabel.textColor = [MyTool colorWithString:@"ff3f53"];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    _scoreLabel.font = [UIFont systemFontOfSize:30];
    _scoreStr = @"5.0";
    _scoreLabel.attributedText = [MyTool labelWithText:[NSString stringWithFormat:@"%@分", _scoreStr] Color:[MyTool colorWithString:@"ff3f53"] Font:[UIFont systemFontOfSize:14] range:NSMakeRange(3, 1)];
    [_myScrollView addSubview:_scoreLabel];
    
    
    TapStarRateView *starRateView = [[TapStarRateView alloc] initWithFrame:CGRectMake((kScreenW - 168) / 2, _scoreLabel.frame.origin.y + 50, 168, 27)];
    starRateView.isAnimation = YES;
    starRateView.rateStyle = WholeStar;
    starRateView.currentScore = 5.0;
    starRateView.delegate = self;
    [_myScrollView addSubview:starRateView];
    
    
    UIView *textViewBG = [[UIView alloc] initWithFrame:CGRectMake(15, 127, kScreenW - 30, 120)];
    textViewBG.backgroundColor = [MyTool colorWithString:@"f5f5f5"];
    textViewBG.layer.cornerRadius = 3.f;
    [_myScrollView addSubview:textViewBG];
    
    _myTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 30, 95)];
    _myTextView.font = [UIFont systemFontOfSize:14];
    _myTextView.textColor = [MyTool colorWithString:@"333333"];
    _myTextView.backgroundColor = [UIColor clearColor];
    _myTextView.delegate = self;
    [textViewBG addSubview:_myTextView];
    
    _placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, _myTextView.frame.size.width - 20, [MyTool heightOfLabel:@"您的建议很重要，来点评一下吧，至少输入8字哦。" forFont:[UIFont systemFontOfSize:14] labelLength:_myTextView.frame.size.width - 20])];
    _placeLabel.text = @"您的建议很重要，来点评一下吧，至少输入8字哦。";
    _placeLabel.font = [UIFont systemFontOfSize:14];
    _placeLabel.numberOfLines = 0;
    _placeLabel.textColor = [MyTool colorWithString:@"999999"];
    [_myTextView addSubview:_placeLabel];
    
    _wordNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, textViewBG.frame.size.height - 25, textViewBG.frame.size.width - 10, 25)];
    _wordNumber.text = @"0/300";
    _wordNumber.textAlignment = NSTextAlignmentRight;
    _wordNumber.font = [UIFont systemFontOfSize:12];
    _wordNumber.textColor = [MyTool colorWithString:@"999999"];
    [textViewBG addSubview:_wordNumber];
    
    
    
    _nmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nmBtn.frame = CGRectMake(15, 360, 20, 20);
    [_nmBtn setBackgroundImage:[UIImage imageNamed:@"匿名评价无勾选"] forState:UIControlStateNormal];
    [_nmBtn addTarget:self action:@selector(nmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_myScrollView addSubview:_nmBtn];
    
    _nmLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nmBtn.frame.origin.x + 20 + 5, _nmBtn.frame.origin.y, 80, 20)];
    _nmLabel.text = @"匿名评价";
    _nmLabel.textColor = [MyTool colorWithString:@"333333"];
    _nmLabel.font = [UIFont systemFontOfSize:15];
    [_myScrollView addSubview:_nmLabel];
    
    _nmLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(_nmLabel.frame.origin.x, _nmLabel.frame.origin.y + 20 + 3, kScreenW - 55, [MyTool heightOfLabel:@"匿名评价不会对外公开您的头像、昵称给其他用户和商家" forFont:[UIFont systemFontOfSize:12] labelLength:kScreenW - 55])];
    _nmLabel1.text = @"匿名评价不会对外公开您的头像、昵称给其他用户和商家";
    _nmLabel1.textColor = [MyTool ColorWithColorStr:@"999999"];
    _nmLabel1.font = [UIFont systemFontOfSize:12];
    _nmLabel1.numberOfLines = 0;
    _nmLabel1.hidden = YES;
    [_myScrollView addSubview:_nmLabel1];
    
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.frame = CGRectMake(15, _nmBtn.frame.origin.y + 20 + 168, kScreenW - 30, 45);
    _sendBtn.backgroundColor = [MyTool colorWithString:@"cccccc"];
    _sendBtn.layer.cornerRadius = 3;
    [_sendBtn setTitle:@"提交评论" forState:UIControlStateNormal];
    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_sendBtn addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_myScrollView addSubview:_sendBtn];
}
-(void)starRateView:(LQYStarRateView *)starRateView currentScore:(CGFloat)currentScore
{
    _scoreStr = [NSString stringWithFormat:@"%.1f", currentScore];
    _scoreLabel.attributedText = [MyTool labelWithText:[NSString stringWithFormat:@"%@分", _scoreStr] Color:[MyTool colorWithString:@"ff3f53"] Font:[UIFont systemFontOfSize:14] range:NSMakeRange(3, 1)];
}

- (void)createImage
{
    [_imageBgView removeFromSuperview];
    _imageBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 247, kScreenW, (_imageArr.count / 4 + 1) * 88  * Swidth)];
    [_myScrollView addSubview:_imageBgView];
    _nmBtn.frame = CGRectMake(15, _imageBgView.frame.size.height + 247 + 20, 20, 20);
    _nmLabel.frame = CGRectMake(_nmBtn.frame.origin.x + 20 + 5, _nmBtn.frame.origin.y, 80, 20);
    _nmLabel1.frame = CGRectMake(_nmLabel.frame.origin.x, _nmLabel.frame.origin.y + 20 + 3, kScreenW - 55, [MyTool heightOfLabel:@"匿名评价不会对外公开您的头像、昵称给其他用户和商家" forFont:[UIFont systemFontOfSize:12] labelLength:kScreenW - 55]);
    _sendBtn.frame = CGRectMake(15, _nmBtn.frame.origin.y + 20 + 168, kScreenW - 30, 45);
    _myScrollView.contentSize = CGSizeMake(kScreenW, _sendBtn.frame.origin.y + 45 + 10);
    
    for (NSInteger i = 0; i < _imageArr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + i % 4 * 88 * Swidth,15 + i / 4 * 88 * Swidth, 78 * Swidth, 78 * Swidth)];
        imageView.tag = 2000 + i;
        imageView.userInteractionEnabled = YES;
        imageView.image = _imageArr[i];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [_imageBgView addSubview:imageView];
        [_imageViewArr addObject:imageView];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(imageView.frame.origin.x + imageView.frame.size.width - 10, imageView.frame.origin.y - 10, 19, 19);
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"图片删除"] forState:UIControlStateNormal];
        deleteBtn.tag = 1000 + i;
        [deleteBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_imageBgView addSubview:deleteBtn];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
        [imageView addGestureRecognizer:tap];
    }
    
    if (_imageArr.count < 9) {
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.frame = CGRectMake(15 + _imageArr.count % 4 * 88 * Swidth, 15 + _imageArr.count / 4 * 88 * Swidth, 78 * Swidth, 78 * Swidth);
        [addBtn setBackgroundImage:[UIImage imageNamed:@"上传图片"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_imageBgView addSubview:addBtn];
    }
}

#pragma mark - 匿名
- (void)nmBtnAction:(UIButton *)btn
{
    if ([_is_anonymous isEqualToString:@"0"]) {
        [_nmBtn setBackgroundImage:[UIImage imageNamed:@"匿名评价勾选"] forState:UIControlStateNormal];
        _is_anonymous = @"1";
        _nmLabel1.hidden = NO;
    } else {
        [_nmBtn setBackgroundImage:[UIImage imageNamed:@"匿名评价无勾选"] forState:UIControlStateNormal];
        _is_anonymous = @"0";
        _nmLabel1.hidden = YES;
    }
}

#pragma mark - 发布
- (void)sendBtnAction:(UIButton *)btn
{
    if (_myTextView.text.length >= 8) {
        [self getImageUpload];
    }
}
- (void)getImageUpload
{
    [self loadingWithText:@"发布中"];
    NSString * url = [NetRequest ImageUpload];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken]};
    [manager POST:url parameters:paramsDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSInteger i = 0; i < _imageArr.count; i++) {
            NSData *picData = UIImageJPEGRepresentation(_imageArr[i], 0.5);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *fileName = [NSString stringWithFormat:@"%@%ld.png", [formatter stringFromDate:[NSDate date]], i];
            [formData appendPartWithFileData:picData name:[NSString stringWithFormat:@"image%ld", i] fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSLog(@"上传== %@", dic);
        [self getPostAddWith:dic[@"data"][@"id"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"错误信息=====%@", error.description);
    }];
}
- (void)getPostAddWith:(NSArray *)imageIDArr
{
    NSString *urlStr = [NetRequest OrderReview];
    NSDictionary *paramsDic = @{@"token": [[NSUserDefaults standardUserDefaults] objectForKey:kToken], @"order_id": _order_id, @"score": _scoreStr, @"is_anonymous": _is_anonymous, @"images": imageIDArr, @"content": _myTextView.text};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        
        [self endLoading];
        [MyTool showHUDWithStr:JSON[@"msg"]];
        if ([[JSON objectForKeyNotNull:@"error"] integerValue] == 0){
            [[NSNotificationCenter defaultCenter] postNotificationName:reloadOrderListViewData object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        [self endLoading];
    }];
    
}

#pragma mark - 删除图片
- (void)deleteBtnAction:(UIButton *)btn
{
    [_imageArr removeObjectAtIndex:btn.tag - 1000];
    [_selectedAssets removeObjectAtIndex:btn.tag - 1000];
    [self createImage];
}

#pragma mark - 点击图片
- (void)imageTapAction:(UITapGestureRecognizer *)tap
{
    NSLog(@"点击%ld", tap.view.tag - 2000);
}

#pragma mark - 添加图片
- (void)addBtnAction:(UIButton *)btn
{
    [_myTextView resignFirstResponder];
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [action showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushTZImagePickerController];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 300) {
        textView.text = [textView.text substringToIndex:300];
        [MyTool showHUDWithStr:@"评论很长了,就这么多吧"];
    }
    
    if (textView.text.length == 0) {
        _placeLabel.text = @"您的建议很重要，来点评一下吧，至少输入8字哦。";
    }else{
        _placeLabel.text = @"";
    }
    _wordNumber.text = [NSString stringWithFormat:@"%ld/300",(textView.text.length)];
    
    
    if (textView.text.length < 8) {
        _sendBtn.backgroundColor = [MyTool colorWithString:@"cccccc"];
    } else {
        _sendBtn.backgroundColor = [MyTool colorWithString:@"ff3f53"];
    }
}

#pragma mark - TZImagePickerController
- (void)pushTZImagePickerController {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    imagePickerVc.naviBgColor = [UIColor whiteColor];
    imagePickerVc.naviTitleColor = [UIColor blackColor];
    imagePickerVc.barItemTextColor = [UIColor blackColor];
    imagePickerVc.navLeftBarButtonSettingBlock = ^(UIButton *leftButton) {
        leftButton.frame = CGRectMake(0, 0, 30, 30);
        [leftButton setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    };
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;
    
    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
    
    // imagePickerVc.photoWidth = 1000;
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    // if (iOS7Later) {
    // imagePickerVc.navigationBar.barTintColor = [UIColor greenColor];
    // }
    // imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    // imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    // imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = NO;
    imagePickerVc.needCircleCrop = NO;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.tz_width - 2 * left;
    NSInteger top = (self.view.tz_height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    // 设置横屏下的裁剪尺寸
    // imagePickerVc.cropRectLandscape = CGRectMake((self.view.tz_height - widthHeight) / 2, left, widthHeight, widthHeight);
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
    // 自定义导航栏上的返回按钮
    /*
     [imagePickerVc setNavLeftBarButtonSettingBlock:^(UIButton *leftButton){
     [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
     [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
     }];
     imagePickerVc.delegate = self;
     */
    
    imagePickerVc.isStatusBarDefault = YES;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - UIImagePickerController
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:NO completion:^(TZAlbumModel *model) {
                    
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_imageArr addObject:image];
    [self createImage];
    
//    if ([asset isKindOfClass:[PHAsset class]]) {
//        PHAsset *phAsset = asset;
//        NSLog(@"location:%@",phAsset.location);
//    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    _imageArr = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    [self createImage];
}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
    _imageArr = [NSMutableArray arrayWithArray:@[animatedImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    [self createImage];
}

// Decide album show or not't
// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(id)result {
    /*
     if ([albumName isEqualToString:@"个人收藏"]) {
     return NO;
     }
     if ([albumName isEqualToString:@"视频"]) {
     return NO;
     }*/
    return YES;
}

// Decide asset show or not't
// 决定asset显示与否
- (BOOL)isAssetCanSelect:(id)asset {
    /*
     if (iOS8Later) {
     PHAsset *phAsset = asset;
     switch (phAsset.mediaType) {
     case PHAssetMediaTypeVideo: {
     // 视频时长
     // NSTimeInterval duration = phAsset.duration;
     return NO;
     } break;
     case PHAssetMediaTypeImage: {
     // 图片尺寸
     if (phAsset.pixelWidth > 3000 || phAsset.pixelHeight > 3000) {
     // return NO;
     }
     return YES;
     } break;
     case PHAssetMediaTypeAudio:
     return NO;
     break;
     case PHAssetMediaTypeUnknown:
     return NO;
     break;
     default: break;
     }
     } else {
     ALAsset *alAsset = asset;
     NSString *alAssetType = [[alAsset valueForProperty:ALAssetPropertyType] stringValue];
     if ([alAssetType isEqualToString:ALAssetTypeVideo]) {
     // 视频时长
     // NSTimeInterval duration = [[alAsset valueForProperty:ALAssetPropertyDuration] doubleValue];
     return NO;
     } else if ([alAssetType isEqualToString:ALAssetTypePhoto]) {
     // 图片尺寸
     CGSize imageSize = alAsset.defaultRepresentation.dimensions;
     if (imageSize.width > 3000) {
     // return NO;
     }
     return YES;
     } else if ([alAssetType isEqualToString:ALAssetTypeUnknown]) {
     return NO;
     }
     }*/
    return YES;
}


// 设置了navLeftBarButtonSettingBlock后，需打开这个方法，让系统的侧滑返回生效
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    navigationController.interactivePopGestureRecognizer.enabled = YES;
    if (viewController != navigationController.viewControllers[0]) {
        navigationController.interactivePopGestureRecognizer.delegate = nil; // 支持侧滑
    }
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
