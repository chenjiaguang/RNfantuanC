//
//  NewsDetailLikeTableViewCell.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/5/21.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "NewsDetailLikeTableViewCell.h"

@implementation NewsDetailLikeTableViewCell
{
    UILabel *_likeNumLabel;
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
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_likeBtn];
    
    _likeNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _likeNumLabel.font = [UIFont systemFontOfSize:15];
    _likeNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_likeNumLabel];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"分享到";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [MyTool colorWithString:@"666666"];
    label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label];
    
    UIButton *wxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wxBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    wxBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [wxBtn setTitleColor:[MyTool colorWithString:@"666666"] forState:UIControlStateNormal];
    [wxBtn setTitle:@"微信" forState:UIControlStateNormal];
    [wxBtn setImage:[UIImage imageNamed:@"微信好友"] forState:UIControlStateNormal];
    [wxBtn addTarget:self action:@selector(wxBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:wxBtn];
    
    UIButton *pyqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pyqBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    pyqBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [pyqBtn setTitleColor:[MyTool colorWithString:@"666666"] forState:UIControlStateNormal];
    [pyqBtn setTitle:@"朋友圈" forState:UIControlStateNormal];
    [pyqBtn setImage:[UIImage imageNamed:@"微信朋友圈"] forState:UIControlStateNormal];
    [pyqBtn addTarget:self action:@selector(pyqBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:pyqBtn];
    
    UIButton *fzljBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fzljBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    fzljBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [fzljBtn setTitleColor:[MyTool colorWithString:@"666666"] forState:UIControlStateNormal];
    [fzljBtn setTitle:@"复制链接" forState:UIControlStateNormal];
    [fzljBtn setImage:[UIImage imageNamed:@"复制链接"] forState:UIControlStateNormal];
    [fzljBtn addTarget:self action:@selector(fzljBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:fzljBtn];
    
    
    _likeBtn.sd_layout
    .topSpaceToView(self.contentView, 40)
    .centerXEqualToView(self.contentView)
    .widthIs(50)
    .heightEqualToWidth();
    
    _likeNumLabel.sd_layout
    .topSpaceToView(_likeBtn, 10)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(15);
    
    label.sd_layout
    .topSpaceToView(_likeNumLabel, 30)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(17);
    
    wxBtn.sd_layout
    .topSpaceToView(label, 20)
    .leftSpaceToView(self.contentView, 58 * Swidth)
    .bottomEqualToView(self.contentView)
    .widthIs(50);
    
    wxBtn.imageView.sd_layout
    .topSpaceToView(wxBtn, 0)
    .centerXEqualToView(wxBtn)
    .widthIs(40)
    .heightEqualToWidth();
    
    wxBtn.titleLabel.sd_layout
    .topSpaceToView(wxBtn.imageView, 5)
    .leftSpaceToView(wxBtn, 0)
    .widthIs(50);
    
    
    pyqBtn.sd_layout
    .topSpaceToView(label, 20)
    .centerXEqualToView(self.contentView)
    .bottomEqualToView(self.contentView)
    .widthIs(50);
    
    pyqBtn.imageView.sd_layout
    .topSpaceToView(pyqBtn, 0)
    .centerXEqualToView(pyqBtn)
    .widthIs(40)
    .heightEqualToWidth();
    
    pyqBtn.titleLabel.sd_layout
    .topSpaceToView(pyqBtn.imageView, 5)
    .leftSpaceToView(pyqBtn, 0)
    .widthIs(50);
    
    
    fzljBtn.sd_layout
    .topSpaceToView(label, 20)
    .rightSpaceToView(self.contentView, 58 * Swidth)
    .bottomEqualToView(self.contentView)
    .widthIs(50);
    
    fzljBtn.imageView.sd_layout
    .topSpaceToView(fzljBtn, 0)
    .centerXEqualToView(fzljBtn)
    .widthIs(40)
    .heightEqualToWidth();
    
    fzljBtn.titleLabel.sd_layout
    .topSpaceToView(fzljBtn.imageView, 5)
    .leftSpaceToView(fzljBtn, 0)
    .widthIs(50);
    
}

- (void)setDataDic:(NSMutableDictionary *)dataDic
{
    _dataDic = dataDic;
    
    [_likeBtn setImage:[UIImage imageNamed:[_dataDic[@"is_like"] boolValue]?@"新闻详情已点赞":@"新闻详情点赞"] forState:UIControlStateNormal];
    _likeNumLabel.text = [_dataDic[@"like_num"] integerValue]==0?@"":_dataDic[@"like_num"];
    _likeNumLabel.textColor = [MyTool colorWithString:[_dataDic[@"is_like"] boolValue]?@"FF3F53":@"666666"];
    
}

- (void)wxBtnAction:(UIButton *)btn
{
    [self WXshareWtihShareTitle:_dataDic[@"name"] ShareDescription:_dataDic[@"content"] Scene:WXSceneSession imageUrl:_dataDic[@"covers"][0][@"compress"]];
}

- (void)pyqBtnAction:(UIButton *)btn
{
    [self WXshareWtihShareTitle:_dataDic[@"name"] ShareDescription:_dataDic[@"content"] Scene:WXSceneTimeline imageUrl:_dataDic[@"covers"][0][@"compress"]];
}

- (void)fzljBtnAction:(UIButton *)btn
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _dataDic[@"share_url"];
    [MyTool showHUDWithStr:@"复制成功"];
}


// 分享微信相关
- (void)WXshareWtihShareTitle:(NSString *)shareTitle ShareDescription:(NSString *)shareDescription Scene:(int)scene imageUrl:(NSString *)imageUrl
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = shareTitle;
    message.description = shareDescription;
    
    WXWebpageObject *webPageObject = [WXWebpageObject object];
    webPageObject.webpageUrl = _dataDic[@"share_url"];
    message.mediaObject = webPageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        message.thumbData = [MyTool compressOriginalImage:imageV.image toMaxDataSizeKBytes:32*1000];
        [WXApi sendReq:req];
    }];
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
