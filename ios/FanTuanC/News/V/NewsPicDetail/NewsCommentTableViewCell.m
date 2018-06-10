//
//  NewsCommentTableViewCell.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/3/29.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "NewsCommentTableViewCell.h"
#import "MyCardViewController.h"
#import "NewsCommentDetailViewController.h"

@implementation NewsCommentTableViewCell
{
    UIButton *_headImageV;
    UIButton *_nameLabel;
    UILabel *_contentLabel;
    UILabel *_timeLabel;
    UIButton *_replyNumBtn;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    _headImageV = [UIButton buttonWithType:UIButtonTypeCustom];
    _headImageV.clipsToBounds = YES;
    _headImageV.contentMode = UIViewContentModeScaleAspectFill;
    [_headImageV addTarget:self action:@selector(tapUserAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_headImageV];
    
    
    _nameLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nameLabel setTitleColor:[MyTool colorWithString:@"225894"] forState:UIControlStateNormal];
    _nameLabel.titleLabel.font = [UIFont systemFontOfSize:14];
    [_nameLabel addTarget:self action:@selector(tapUserAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_nameLabel];
    
    
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _likeBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
    [self.contentView addSubview:_likeBtn];
    
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentLabel.textColor = [MyTool colorWithString:@"333333"];
    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _timeLabel.textColor = [MyTool colorWithString:@"999999"];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_timeLabel];
    
    
    _replyNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _replyNumBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_replyNumBtn setTitleColor:[MyTool colorWithString:@"333333"] forState:UIControlStateNormal];
    [_replyNumBtn setBackgroundColor:[MyTool colorWithString:@"f5f5f5"]];
    _replyNumBtn.layer.masksToBounds = YES;
    _replyNumBtn.layer.cornerRadius = 9;
    [_replyNumBtn addTarget:self action:@selector(replyNumBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_replyNumBtn];
    
    
    _headImageV.sd_cornerRadiusFromWidthRatio = @0.5;
    _headImageV.sd_layout
    .topSpaceToView(self.contentView, 25)
    .leftSpaceToView(self.contentView, 15)
    .widthIs(30)
    .heightEqualToWidth();
    
    _nameLabel.sd_layout
    .topSpaceToView(self.contentView, 25)
    .leftSpaceToView(_headImageV, 10)
    .heightIs(15);
    [_nameLabel setupAutoSizeWithHorizontalPadding:0 buttonHeight:15];
    
    _likeBtn.imageView.sd_layout
    .heightIs(21)
    .widthIs(21);
    
    _likeBtn.sd_layout
    .topSpaceToView(self.contentView, 20)
    .rightSpaceToView(self.contentView, 15 - 21)
    .heightIs(21);
    [_likeBtn setupAutoSizeWithHorizontalPadding:21 buttonHeight:21];
    
    _contentLabel.sd_layout
    .topSpaceToView(_nameLabel, 10)
    .leftEqualToView(_nameLabel)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    
    _timeLabel.sd_layout
    .topSpaceToView(_contentLabel, 10)
    .leftEqualToView(_nameLabel)
    .heightIs(12);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _replyNumBtn.sd_layout
    .centerYEqualToView(_timeLabel)
    .leftSpaceToView(_timeLabel, 15)
    .heightIs(18);
    [_replyNumBtn setupAutoSizeWithHorizontalPadding:8 buttonHeight:18];
    
    
    [self setupAutoHeightWithBottomView:_replyNumBtn bottomMargin:0];
}

- (void)setDataDic:(NSMutableDictionary *)dataDic
{
    _dataDic = dataDic;
    [_headImageV sd_setBackgroundImageWithURL:[NSURL URLWithString:dataDic[@"user"][@"avatar"]] forState:UIControlStateNormal];
    [_nameLabel setTitle:[dataDic[@"is_author"]boolValue]?@"我":dataDic[@"user"][@"username"] forState:UIControlStateNormal];
    [_likeBtn setTitle:dataDic[@"like_num"] forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage imageNamed:[dataDic[@"is_like"] boolValue]?@"praiseIconOn":@"praiseIconOff"] forState:UIControlStateNormal];
    [_likeBtn setTitleColor:[MyTool colorWithString:[dataDic[@"is_like"] boolValue]?@"ff3f53":@"666666"] forState:UIControlStateNormal];
    _contentLabel.text = dataDic[@"content"];
    _timeLabel.text = dataDic[@"time"];
    [_replyNumBtn setTitle:[dataDic[@"reply_num"] integerValue] <= 0?@"回复":[NSString stringWithFormat:@"%@条回复", dataDic[@"reply_num"]] forState:UIControlStateNormal];
    [_replyNumBtn setBackgroundColor:[dataDic[@"reply_num"] integerValue] <= 0?[UIColor clearColor]:[MyTool colorWithString:@"f5f5f5"]];
}

- (void)tapUserAction:(UIButton *)btn
{
    MyCardViewController *myCardVC = [[MyCardViewController alloc] init];
    myCardVC.hidesBottomBarWhenPushed = YES;
    myCardVC.title = _dataDic[@"user"][@"username"];
    myCardVC.uid = _dataDic[@"user"][@"id"];
    myCardVC.type = 1;
    myCardVC.isNews = _dataDic[@"is_news"];
    [[MyTool topViewController].navigationController pushViewController:myCardVC animated:YES];
}

- (void)replyNumBtnAction:(UIButton *)btn
{
    NewsCommentDetailViewController * newsCommentDetailVC = [[NewsCommentDetailViewController alloc] init];
    newsCommentDetailVC.comment_id = _dataDic[@"id"];
    [[MyTool topViewController].navigationController pushViewController:newsCommentDetailVC animated:YES];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
