//
//  NewsFeatureCell.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/4/16.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "NewsFeatureCell.h"
#import "NewsPicDetailViewController.h"

@implementation NewsFeatureCell
{
    UIImageView *_coverImageView;
    UILabel *_titleLabel;
    UIView *_titleBgView;
    UILabel *_contenLabel1;
    UILabel *_contenLabel2;
    UILabel *_contenLabel3;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
    }
    return self;
}
-(void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
//    _titleLabel.text  = _dataDic[@"special"][@"name"];
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"special"][@"covers"][0][@"url"]]];
    _contenLabel1.text = _dataDic[@"lastest"][@"name"];
    _contenLabel2.text = _dataDic[@"hottest"][@"name"];
    _contenLabel3.text = _dataDic[@"focused"][@"name"];
    
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", _dataDic[@"special"][@"name"]]];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    attch.image = [UIImage imageNamed:@"专题"];
    attch.bounds = CGRectMake(0, -2.5, 30, 17);
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    _titleLabel.attributedText = attri;
    
    [_titleBgView updateLayout];
    _titleBgView.sd_layout
    .heightIs(_titleLabel.size.height + 20);
    
}
- (void)createSubviews
{
    UIImageView *coverImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    coverImageView.clipsToBounds = YES;
    coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    _coverImageView = coverImageView;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.textColor = [MyTool colorWithString:@"FFFFFF"];
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
    _titleLabel = titleLabel;
    
    UIView *titleBgView = [[UIView alloc] initWithFrame:CGRectZero];
    titleBgView.backgroundColor = [[MyTool colorWithString:@"000000"] colorWithAlphaComponent:0.5];
    _titleBgView = titleBgView;
    
    UILabel *subtitleLabel1 = [[UILabel alloc]initWithFrame:CGRectZero];
    subtitleLabel1.text = @"最新";
    subtitleLabel1.font = [UIFont boldSystemFontOfSize:18];
    subtitleLabel1.textColor = [MyTool ColorWithColorStr:@"000000"];
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectZero];
    lineView1.backgroundColor = [MyTool colorWithString:@"E5E5E5"];
    UILabel *contenLabel1 = [[UILabel alloc]initWithFrame:CGRectZero];
    contenLabel1.font = [UIFont systemFontOfSize:16];
    contenLabel1.textColor = [MyTool ColorWithColorStr:@"666666"];
    contenLabel1.userInteractionEnabled = YES;
    _contenLabel1 = contenLabel1;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1Action:)];
    [_contenLabel1 addGestureRecognizer:tap1];
    
    UILabel *subtitleLabel2 = [[UILabel alloc]initWithFrame:CGRectZero];
    subtitleLabel2.text = @"热点";
    subtitleLabel2.font = [UIFont boldSystemFontOfSize:18];
    subtitleLabel2.textColor = [MyTool ColorWithColorStr:@"000000"];
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectZero];
    lineView2.backgroundColor = [MyTool colorWithString:@"E5E5E5"];
    UILabel *contenLabel2 = [[UILabel alloc]initWithFrame:CGRectZero];
    contenLabel2.font = [UIFont systemFontOfSize:16];
    contenLabel2.textColor = [MyTool ColorWithColorStr:@"666666"];
    contenLabel2.userInteractionEnabled = YES;
    _contenLabel2 = contenLabel2;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2Action:)];
    [_contenLabel2 addGestureRecognizer:tap2];

    UILabel *subtitleLabel3 = [[UILabel alloc]initWithFrame:CGRectZero];
    subtitleLabel3.text = @"聚焦";
    subtitleLabel3.font = [UIFont boldSystemFontOfSize:18];
    subtitleLabel3.textColor = [MyTool ColorWithColorStr:@"000000"];
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectZero];
    lineView3.backgroundColor = [MyTool colorWithString:@"E5E5E5"];
    UILabel *contenLabel3 = [[UILabel alloc]initWithFrame:CGRectZero];
    contenLabel3.font = [UIFont systemFontOfSize:16];
    contenLabel3.textColor = [MyTool ColorWithColorStr:@"666666"];
    contenLabel3.userInteractionEnabled = YES;
    _contenLabel3 = contenLabel3;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap3Action:)];
    [_contenLabel3 addGestureRecognizer:tap3];
    
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectZero];
    lineView4.backgroundColor = [MyTool ColorWithColorStr:@"e5e5e5"];
    [self.contentView sd_addSubviews:@[coverImageView,titleBgView,titleLabel,subtitleLabel1,lineView1,contenLabel1,subtitleLabel2,lineView2,contenLabel2,subtitleLabel3,lineView3,contenLabel3,lineView4]];
    
    
    coverImageView.sd_layout
    .topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(kScreenW*0.562);
    
    subtitleLabel1.sd_layout
    .topSpaceToView(coverImageView, 30)
    .leftSpaceToView(self.contentView, 15)
    .heightIs(18)
    .widthIs(38);
    
    titleLabel.sd_layout
    .rightSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, 15)
    .bottomSpaceToView(subtitleLabel1, 39)
    .autoHeightRatio(0);
    [titleLabel setMaxNumberOfLinesToShow:2];
    
    titleBgView.sd_layout
    .bottomEqualToView(coverImageView)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0);
    
    lineView1.sd_layout
    .centerYEqualToView(subtitleLabel1)
    .leftSpaceToView(subtitleLabel1, 10)
    .heightIs(18)
    .widthIs(0.5);
    
    contenLabel1.sd_layout
    .centerYEqualToView(subtitleLabel1)
    .leftSpaceToView(lineView1, 9)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    
    
    subtitleLabel2.sd_layout
    .topSpaceToView(subtitleLabel1, 40)
    .leftSpaceToView(self.contentView, 15)
    .heightIs(18)
    .widthIs(38);
    
    lineView2.sd_layout
    .centerYEqualToView(subtitleLabel2)
    .leftSpaceToView(subtitleLabel2, 10)
    .heightIs(18)
    .widthIs(0.5);
    
    contenLabel2.sd_layout
    .centerYEqualToView(subtitleLabel2)
    .leftSpaceToView(lineView2, 9)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    
    subtitleLabel3.sd_layout
    .topSpaceToView(subtitleLabel2, 40)
    .leftSpaceToView(self.contentView, 15)
    .heightIs(18)
    .widthIs(38);
    
    lineView3.sd_layout
    .centerYEqualToView(subtitleLabel3)
    .leftSpaceToView(subtitleLabel3, 10)
    .heightIs(18)
    .widthIs(0.5);
    
    contenLabel3.sd_layout
    .centerYEqualToView(subtitleLabel3)
    .leftSpaceToView(lineView3, 9)
    .rightSpaceToView(self.contentView, 15)
    .autoHeightRatio(0);
    
    lineView4.sd_layout
    .topSpaceToView(contenLabel3, 15)
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .heightIs(0.5);
    
    [self setupAutoHeightWithBottomView:lineView4 bottomMargin:0.5];
}

- (void)tap1Action:(UITapGestureRecognizer *)tap
{
    if ([_dataDic[@"lastest"][@"contentType"] isEqualToString:@"1"]) {
        NewsPicDetailViewController *newsPicDetailVC = [[NewsPicDetailViewController alloc] init];
        newsPicDetailVC.article_id = _dataDic[@"lastest"][@"id"];
        [[MyTool topViewController].navigationController pushViewController:newsPicDetailVC animated:YES];
    } else {
        MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
        myWebVC.urlStr = _dataDic[@"lastest"][@"article_url"];
        myWebVC.isNewsDetail = YES;
        myWebVC.title = _dataDic[@"lastest"][@"author"];
        myWebVC.hidesBottomBarWhenPushed = YES;
        [[MyTool topViewController].navigationController pushViewController:myWebVC animated:YES];
    }
}
- (void)tap2Action:(UITapGestureRecognizer *)tap
{
    if ([_dataDic[@"hottest"][@"contentType"] isEqualToString:@"1"]) {
        NewsPicDetailViewController *newsPicDetailVC = [[NewsPicDetailViewController alloc] init];
        newsPicDetailVC.article_id = _dataDic[@"hottest"][@"id"];
        [[MyTool topViewController].navigationController pushViewController:newsPicDetailVC animated:YES];
    } else {
        MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
        myWebVC.urlStr = _dataDic[@"hottest"][@"article_url"];
        myWebVC.isNewsDetail = YES;
        myWebVC.title = _dataDic[@"hottest"][@"author"];
        myWebVC.hidesBottomBarWhenPushed = YES;
        [[MyTool topViewController].navigationController pushViewController:myWebVC animated:YES];
    }
}
- (void)tap3Action:(UITapGestureRecognizer *)tap
{
    if ([_dataDic[@"focused"][@"contentType"] isEqualToString:@"1"]) {
        NewsPicDetailViewController *newsPicDetailVC = [[NewsPicDetailViewController alloc] init];
        newsPicDetailVC.article_id = _dataDic[@"focused"][@"id"];
        [[MyTool topViewController].navigationController pushViewController:newsPicDetailVC animated:YES];
    } else {
        MyWebViewController *myWebVC = [[MyWebViewController alloc] init];
        myWebVC.urlStr = _dataDic[@"focused"][@"article_url"];
        myWebVC.isNewsDetail = YES;
        myWebVC.title = _dataDic[@"focused"][@"author"];
        myWebVC.hidesBottomBarWhenPushed = YES;
        [[MyTool topViewController].navigationController pushViewController:myWebVC animated:YES];
    }
}

@end
