//
//  ScanCodeViewController.m
//  FanTuanSJ
//
//  Created by 冫柒Yun on 2017/9/14.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "ScanCodeViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>

@interface ScanCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate, CAAnimationDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureSession *_session;//输入输出中间桥梁
    AVCaptureVideoPreviewLayer *_layer;
    UIView *_maskView;
    UIImageView *_scanLineView;
    
    BOOL _isFirstAppear;
    
    //提示将二维码放入框内label
    UILabel *_textLabel;
}

@end

@implementation ScanCodeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_scanLineView) {
        [_scanLineView removeFromSuperview];
        _scanLineView = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!_isFirstAppear) {
        [self initScanLineView];
        [_session startRunning];
        return;
    }
//    [self initScanUI];
//    [self initScan];
    _isFirstAppear = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"扫描二维码";
    self.view.backgroundColor = [UIColor blackColor];
    [self createBackButton];
    
    
    _isFirstAppear = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initScanUI) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self initBaseUI];
    [self initScanUI];
    [self initScan];
    
}

- (void)initBaseUI
{
    CGFloat pathWidth = kScreenW - 130;
    CGFloat orginY = (kScreenH - pathWidth) / 2 - 65 + pathWidth;
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, orginY + 10, pathWidth, 15)];
    _textLabel.text = @"将二维码放入框内，即可自动扫描";
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont systemFontOfSize:12];
    _textLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_textLabel];
}

- (void)initScanUI
{
    _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    _maskView.backgroundColor = [[MyTool colorWithString:@"333333"] colorWithAlphaComponent:.7];
    [self.view addSubview:_maskView];
    [self.view sendSubviewToBack:_maskView];
    
    
    CGFloat pathWidth = kScreenW - 130;
    CGFloat orginY = (kScreenH - pathWidth) / 2 - 65;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"验券扫码框"]];
    imageView.frame = CGRectMake(65, orginY, pathWidth, pathWidth);
    [self.view addSubview:imageView];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.25;
    animation.fromValue = @(0);
    animation.toValue = @(1);
    animation.delegate = self;
    [imageView.layer addAnimation:animation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat pathWidth = kScreenW - 130;
    CGFloat orginY = (kScreenH-pathWidth) / 2 - 65;
    //内部方框path
    CGPathAddRect(path, nil, CGRectMake(65, orginY, pathWidth, pathWidth));
    //外部大框path
    CGPathAddRect(path, nil, _maskView.bounds);
    //两个path取差集，即去除差集部分
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    maskLayer.path = path;
    
    _maskView.layer.mask = maskLayer;
    
    [self initScanLineView];
}

- (void)initScanLineView
{
    CGFloat pathWidth = kScreenW - 130;
    CGFloat orginY = (kScreenH - pathWidth) / 2 - 65;
    
    if (_scanLineView) {
        [_scanLineView removeFromSuperview];
        _scanLineView = nil;
    }
    
    _scanLineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"验券光标"]];
    
    CGRect frame = CGRectMake(70, orginY, pathWidth - 10, 2);
    _scanLineView.frame = frame;
    
    frame.origin.y += pathWidth - 5;
    [UIView animateWithDuration:4.0 delay:0.2 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear animations:^{
        _scanLineView.frame = frame;
    } completion:nil];
    [self.view addSubview:_scanLineView];
}

- (void)btnBack
{
    UIViewController *vc = [self.navigationController popViewControllerAnimated:YES];
    if (!vc) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - scan
- (BOOL)requestAuth
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (status == AVAuthorizationStatusDenied) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请在设置->隐私中允许该软件访问摄像头" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return NO;
    }
    if (status == AVAuthorizationStatusRestricted) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"设备不支持" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return NO;
    }
    
    if (![UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"模拟器不支持该功能" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return NO;
    }
    return YES;
}

- (void)initScan
{
    BOOL canInit = [self requestAuth];
    if (!canInit) {
        return;
    }
    
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    //设置扫描有效区域
    /*
     1、这个CGRect参数和普通的Rect范围不太一样，它的四个值的范围都是0-1，表示比例。
     2、经过测试发现，这个参数里面的x对应的恰恰是距离左上角的垂直距离，y对应的是距离左上角的水平距离。
     3、宽度和高度设置的情况也是类似。
     3、举个例子如果我们想让扫描的处理区域是屏幕的下半部分，我们这样设置
     output.rectOfInterest = CGRectMake(0.5, 0, 0.5, 1);
     */
    
//    output.rectOfInterest = CGRectMake(0.1, 0.2, 0.5, 0.5);
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    
    //设置光感代理输出
    AVCaptureVideoDataOutput *respondOutput = [[AVCaptureVideoDataOutput alloc] init];
    [respondOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    
    //初始化链接对象
    if (_session) {
        [_session stopRunning];
    }
    _session = [[AVCaptureSession alloc] init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if ([_session canAddInput:input]) [_session addInput:input];
    if ([_session canAddOutput:output]) [_session addOutput:output];
    if ([_session canAddOutput:respondOutput]) [_session addOutput:respondOutput];
    
    //设置扫码支持的编码格式
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    _layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _layer.frame = self.view.frame;
    [self.view.layer insertSublayer:_layer atIndex:0];
    //开始捕获
    [_session startRunning];
    
    //设置扫描有效区域
    CGFloat pathWidth = kScreenW - 130;
    CGFloat orginY = (kScreenH - pathWidth) / 2 - 65;
    output.rectOfInterest = [_layer metadataOutputRectOfInterestForRect:CGRectMake(65, orginY, pathWidth, pathWidth)];
}

#pragma mark - 扫描结果回调
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject *metaDataObject = [metadataObjects objectAtIndex:0];
        
        if ([self.delegate respondsToSelector:@selector(qrScanResult:viewController:)]) {
            [self.delegate performSelector:@selector(qrScanResult:viewController:) withObject:metaDataObject.stringValue withObject:self];
        }
    }
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_session stopRunning];
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
