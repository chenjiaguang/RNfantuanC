//
//  CircleCommentsCell.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/3/1.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "CircleCommentsCell.h"
#import <UILabel+YBAttributeTextTapAction.h>
#import "MyCardViewController.h"
@interface CircleCommentsCell ()
{
    UIImageView *_avatarImageView;
    UILabel *_contenLabel;
    UILabel *_nameLabel;
    UILabel *_timerLabel;
    UIButton *_deleteCommentsBtn;

}
@end
@implementation CircleCommentsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
    }
    return self;
}
-(void)setIs_delete:(BOOL)is_delete
{
    _is_delete = is_delete;
    _deleteCommentsBtn.hidden = !_is_delete;
}
-(void)deleteBtnAction:(UIButton *)btn
{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    WeakSelf(weakSelf)
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf alerViewWithTitle:@"确定删除该评论？" ];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVc addAction:deleteAction];
    [alertVc addAction:cancelAction];
    
    [[MyTool topViewController] presentViewController:alertVc animated:YES completion:^{
        
        
    }];
    
}
-(void)alerViewWithTitle:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定删除",nil];
    [alert show];
}
#pragma marks -- UIAlertViewDelegate --
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    [self.delegate selectedDeleteButtonWithCell:self.indexPath];
}
-(void)createSubviews
{
    UIImageView *avatarImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//    avatarImageView.backgroundColor = [UIColor yellowColor];
    avatarImageView.userInteractionEnabled = YES;
    _avatarImageView = avatarImageView;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pusCard)];
    [avatarImageView addGestureRecognizer:singleTap];

    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];;
    nameLabel.textColor = [MyTool colorWithString:@"05a4be"];
    nameLabel.text = @"这里是账号昵称";
    nameLabel.font = [UIFont systemFontOfSize:16];
    nameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *labelTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pusCard)];
    [nameLabel addGestureRecognizer:labelTap];
    _nameLabel = nameLabel;
    
    UIButton *deleteCommentsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteCommentsBtn setImage:[UIImage imageNamed:@"评论下拉箭头"] forState:UIControlStateNormal];
    [deleteCommentsBtn addTarget:self action:@selector(deleteBtnAction:) forControlEvents:UIControlEventTouchDown];
    _deleteCommentsBtn = deleteCommentsBtn;
    
    UILabel *contenLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    contenLabel.font = [UIFont systemFontOfSize:15];
    contenLabel.text = @"海口的粉店大概就跟兰州满大街的拉面店那海口的粉店大概就跟兰州满大街的拉面店那海口的粉店大概就跟兰州满大街的拉面店那";
    contenLabel.textColor = [MyTool colorWithString:@"999999"];
    _contenLabel = contenLabel;
    
    UILabel *timerLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    timerLabel.textColor = [MyTool colorWithString:@"999999"];
    timerLabel.font = [UIFont systemFontOfSize:12];
    _timerLabel = timerLabel;
    
    [self.contentView sd_addSubviews:@[avatarImageView,nameLabel,deleteCommentsBtn,contenLabel,timerLabel]];
    avatarImageView.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(30)
    .heightEqualToWidth();
    avatarImageView.sd_cornerRadiusFromWidthRatio = @(0.5);

    [nameLabel setSingleLineAutoResizeWithMaxWidth:kScreenW-75];
    nameLabel.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(avatarImageView, 15)
    .autoHeightRatio(0);
    
    
    deleteCommentsBtn.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .centerYEqualToView(nameLabel)
    .heightIs(30)
    .widthEqualToHeight();
    
    deleteCommentsBtn.imageView.sd_layout
    .centerYEqualToView(deleteCommentsBtn)
    .heightIs(7)
    .widthIs(11);
    
    contenLabel.sd_layout.autoHeightRatio(0);
    contenLabel.sd_layout
    .leftSpaceToView(avatarImageView, 15)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(nameLabel, 10);
    
//    timerLabel.sd_layout.autoHeightRatio(0);
    timerLabel.sd_layout
    .leftSpaceToView(avatarImageView, 15)
    .topSpaceToView(contenLabel, 10)
    .heightIs(12);
    
    [self setupAutoHeightWithBottomView:timerLabel bottomMargin:10];

}
-(void)setModel:(ListModel *)model
{
    if (!model) {
        return;
    }
    _model = model;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_model.avatar]];
    _nameLabel.text = _model.username;
    _contenLabel.attributedText =  [self editorAttributedStringWithUserName:model.to_username toUserID:model.to_uid content:model.content];
    WeakSelf(weakSelf);
    [_contenLabel yb_addAttributeTapActionWithStrings:@[model.to_username] tapClicked:^(NSString *string, NSRange range,NSInteger index) {
        //点击了回复的用户名 跳转个人名片
        MyCardViewController *vc = [[MyCardViewController alloc]init];
        vc.navigationItem.title = weakSelf.model.to_username;
        vc.type = 1;
        vc.uid = weakSelf.model.to_uid;
        vc.isNews = weakSelf.model.is_news;
        [weakSelf.navVC pushViewController:vc animated:YES];
    }];
    _timerLabel.text = _model.time;

    
}
-(void)pusCard
{
    MyCardViewController *vc = [[MyCardViewController alloc]init];
    vc.navigationItem.title = _model.username;
    vc.type = 1;
    vc.uid = _model.uid;
    vc.isNews = _model.is_news;
    [self.navVC pushViewController:vc animated:YES];
}
-(NSAttributedString *)editorAttributedStringWithUserName:(NSString *)userName toUserID:(NSString *)userId content:(NSString *)content
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:content];
    NSRange range = NSMakeRange(0, attrStr.length);
    [attrStr addAttribute:NSForegroundColorAttributeName value:[MyTool colorWithString:@"333333"] range:range];
    if(userName.length> 0){
        NSString *str = [NSString stringWithFormat:@"回复%@:",userName];
        NSRange range2 = NSMakeRange(2, userName.length);
        NSMutableAttributedString *nameAttrStr = [[NSMutableAttributedString alloc]initWithString:str];
        [attrStr insertAttributedString:nameAttrStr atIndex:range.location];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[MyTool colorWithString:@"05a4be"] range:range2];

    }
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, attrStr.length)];
    return attrStr;
}
@end
