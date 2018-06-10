//
//  ScanCodeViewController.h
//  FanTuanSJ
//
//  Created by 冫柒Yun on 2017/9/14.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "ChildBaseViewController.h"

@class ScanCodeViewController;

@protocol QRScanDelegate <NSObject>

- (void)qrScanResult:(NSString *)result viewController:(ScanCodeViewController *)qrScanVC;

@end

@interface ScanCodeViewController : ChildBaseViewController

@property (nonatomic, weak) id <QRScanDelegate> delegate;

@end
