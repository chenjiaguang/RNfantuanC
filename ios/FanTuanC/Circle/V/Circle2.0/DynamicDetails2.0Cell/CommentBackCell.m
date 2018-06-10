//
//  CommentBackCell.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/5/11.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "CommentBackCell.h"
#import <UILabel+YBAttributeTextTapAction.h>

@interface CommentBackCell ()
{
    
    UILabel *_contentLabel;         //内容

}
@end
@implementation CommentBackCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)setModel:(ListModel *)model
{
    _model = model;
//    _contentLabel.text = [NSString stringWithFormat:@"%@:%@",_model.username, _model.content];
    _contentLabel.attributedText =  [self editorAttributedStringWithUserName:model.username toUserID:model.uid content:model.content];
    WeakSelf(weakSelf);
    [_contentLabel yb_addAttributeTapActionWithStrings:@[model.username,model.pusername] tapClicked:^(NSString *string, NSRange range,NSInteger index) {
//        点击了回复的用户名 跳转个人名片
//        MyCardViewController *vc = [[MyCardViewController alloc]init];
//        vc.navigationItem.title = weakSelf.model.to_username;
//        vc.type = 1;
//        vc.uid = weakSelf.model.to_uid;
//        vc.isNews = weakSelf.model.is_news;
//        [weakSelf.navVC pushViewController:vc animated:YES];
    }];
}
-(NSAttributedString *)editorAttributedStringWithUserName:(NSString *)userName toUserID:(NSString *)userId content:(NSString *)content
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@":%@",content]];
    
    NSRange range = NSMakeRange(0, attrStr.length);
    [attrStr addAttribute:NSForegroundColorAttributeName value:[MyTool colorWithString:@"333333"] range:range];

    if (_model.pusername.length > 0) {
        NSString *str = [NSString stringWithFormat:@"回复%@",_model.pusername];
        NSRange pusernameRange = NSMakeRange(2, _model.pusername.length);
        NSMutableAttributedString *pusernameAttrStr = [[NSMutableAttributedString alloc]initWithString:str];
        [attrStr insertAttributedString:pusernameAttrStr atIndex:range.location];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[MyTool colorWithString:@"255A96"] range:pusernameRange];
    }
    NSString *str = [NSString stringWithFormat:@"%@",userName];
    NSRange range2 = NSMakeRange(0, userName.length);
    NSMutableAttributedString *nameAttrStr = [[NSMutableAttributedString alloc]initWithString:str];
    [attrStr insertAttributedString:nameAttrStr atIndex:range.location];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[MyTool colorWithString:@"255A96"] range:range2];
    

    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, attrStr.length)];
    return attrStr;
}
-(void)createUI
{
  
    UILabel *contenLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    contenLabel.font = [UIFont systemFontOfSize:13];
    contenLabel.textColor = [MyTool colorWithString:@"333333"];
//    contenLabel.backgroundColor = [MyTool colorWithString:@"F1F1F1"];
//    contenLabel.userInteractionEnabled = YES;
    _contentLabel = contenLabel;
    
    [self.contentView sd_addSubviews:@[contenLabel]];
    
    contenLabel.sd_layout
    .autoHeightRatio(0)
    .leftSpaceToView(self.contentView, 12 )
    .topSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 12);
    contenLabel.isAttributedContent = YES;

    
    [self setupAutoHeightWithBottomView:contenLabel bottomMargin:2.5];
    
}
@end
