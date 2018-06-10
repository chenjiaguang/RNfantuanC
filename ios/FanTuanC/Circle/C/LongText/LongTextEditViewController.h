//
//  LongTextEditViewController.h
//  FanTuanC
//
//  Created by 梁其运 on 2018/4/12.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "ChildBaseViewController.h"
#import "MMRichEditAccessoryView.h"

#define kPostContentNotification            @"PostContentNotification"
#define kPostContentDispatchNotification    @"PostContentDispatchNotification"
#define kPostContentID                      @"PostContentID"
#define kPostContentPubID                   @"PostContentPubID"

@protocol RichTextEditDelegate <NSObject>

- (void)mm_shouldShowAccessoryView:(BOOL)shouldShow;
- (BOOL)mm_shouldCellShowPlaceholder;

- (void)mm_preInsertTextLineAtIndexPath:(NSIndexPath*)actionIndexPath textContent:(NSString*)textContent;
- (void)mm_postInsertTextLineAtIndexPath:(NSIndexPath*)actionIndexPath textContent:(NSString*)textContent;
- (void)mm_preDeleteItemAtIndexPath:(NSIndexPath*)actionIndexPath;
- (void)mm_PostDeleteItemAtIndexPath:(NSIndexPath*)actionIndexPath;
- (void)mm_updateActiveIndexPath:(NSIndexPath*)activeIndexPath;
- (void)mm_reloadItemAtIndexPath:(NSIndexPath*)actionIndexPath;
- (void)mm_uploadFailedAtIndexPath:(NSIndexPath*)actionIndexPath;
- (void)mm_uploadDonedAtIndexPath:(NSIndexPath*)actionIndexPath;

@end



@protocol RichContentPostDelegate <NSObject>

- (void)mm_richContentDidPost:(NSInteger)postID;

@end


@interface LongTextEditViewController : ChildBaseViewController

@property (nonatomic, strong) NSString *circle_id;
@property (nonatomic, strong) NSString *formText;

@property (nonatomic, strong) void(^ProgressBlock)(CGFloat progress);
@property (nonatomic, strong) void(^uploadCompleteBlock)(void);

@property (nonatomic, weak) id<RichContentPostDelegate> contentPostDelegate;

@end
