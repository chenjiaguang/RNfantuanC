//
//  ReleaseReviewViewController.h
//  FanTuanC
//
//  Created by 冫柒Yun on 2017/11/28.
//  Copyright © 2017年 冫柒Yun. All rights reserved.
//

#import "ChildBaseViewController.h"
#import "TZImagePickerController.h"
#import "TapStarRateView.h"
#import <AFNetworking.h>

@interface ReleaseReviewViewController : ChildBaseViewController <TapStarRateViewDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, TZImagePickerControllerDelegate>

@property (nonatomic, strong) NSString *order_id;

@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSMutableArray *imageViewArr;

@end
