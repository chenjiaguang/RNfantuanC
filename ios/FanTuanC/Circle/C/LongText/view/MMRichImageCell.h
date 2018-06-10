//
//  MMRichImageCell.h
//  RichTextEditDemo
//
//  Created by aron on 2017/7/19.
//  Copyright © 2017年 aron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMBaseRichContentCell.h"
#import "LongTextEditViewController.h"


@interface MMRichImageCell : MMBaseRichContentCell

@property (nonatomic, weak) id<RichTextEditDelegate> delegate;

@property (nonatomic, assign) BOOL isSort;

- (void)updateWithData:(id)data;
- (void)mm_beginEditing;
- (void)mm_endEditing;

- (void)getPreFlag:(BOOL*)isPre postFlag:(BOOL*)isPost;

@end
