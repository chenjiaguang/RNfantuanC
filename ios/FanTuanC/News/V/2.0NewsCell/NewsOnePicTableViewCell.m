//
//  NewsOnePicTableViewCell.m
//  FanTuanC
//
//  Created by 梁其运 on 2018/5/3.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "NewsOnePicTableViewCell.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"

@implementation NewsOnePicTableViewCell

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
    _headerImageV = [[FLAnimatedImageView alloc] initWithFrame:CGRectZero];
    _headerImageV.layer.masksToBounds = YES;
    _headerImageV.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_headerImageV];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textColor = [MyTool colorWithString:@"333333"];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_titleLabel];
    
    _authorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _authorLabel.textColor = [MyTool colorWithString:@"999999"];
    _authorLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_authorLabel];
    
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _numLabel.textColor = [MyTool colorWithString:@"999999"];
    _numLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:_numLabel];
    
    
    _line = [[UIView alloc] initWithFrame:CGRectZero];
    _line.backgroundColor = [MyTool colorWithString:@"e5e5e5"];
    [self.contentView addSubview:_line];
    
    
    CGFloat imageViewW = (kScreenW - 36) / 3;
    _headerImageV.sd_layout
    .widthIs(imageViewW)
    .heightIs(imageViewW * 0.75)
    .rightSpaceToView(self.contentView, 15)
    .topSpaceToView(self.contentView, 18);
    
    _titleLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(_headerImageV, 15)
    .topSpaceToView(self.contentView, 18);
    _titleLabel.isAttributedContent = YES;
    
    _line.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .rightSpaceToView(self.contentView, 15)
    .bottomEqualToView(self.contentView)
    .heightIs(0.5);
    
    _authorLabel.sd_layout
    .leftSpaceToView(self.contentView, 15)
    .bottomSpaceToView(_line, 18)
    .heightIs(12);
    [_authorLabel setSingleLineAutoResizeWithMaxWidth:kScreenW/2-15];
    
    _numLabel.sd_layout
    .leftSpaceToView(_authorLabel, 15)
    .bottomSpaceToView(_line, 18)
    .heightIs(12)
    .widthIs(120);
    
    [self setupAutoHeightWithBottomView:_headerImageV bottomMargin:18];
}

- (void)setDataDic:(NSMutableDictionary *)dataDic
{
    _dataDic = dataDic;
    
    [_headerImageV sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"covers"][0][@"url"]] placeholderImage:[UIImage imageNamed:@"新闻图片占位图"]];
    
    _titleLabel.textColor = [MyTool colorWithString:[_dataDic[@"is_readed"] boolValue]?@"999999":@"333333"];
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距设置为30
    [paragraphStyle setLineSpacing:4];
    NSString *testString = _dataDic[@"name"];
    NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:testString];
    [setString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [testString length])];
    [_titleLabel setAttributedText:setString];
    
    CGSize labelSz = [_titleLabel szieAdaptiveWithText:_dataDic[@"name"] andTextFont:[UIFont systemFontOfSize:16] andTextMaxSzie:CGSizeMake(kScreenW - 45 - (kScreenW - 36) / 3 , 10000) andLineSpacing:4 andTextAlignment:NSTextAlignmentLeft numberOfLines:kScreenW == 320?2:3];
    _titleLabel.sd_layout.heightIs(labelSz.height);
    _titleLabel.numberOfLines = kScreenW == 320?2:3;
    
    _authorLabel.text = _dataDic[@"news_name"];
    _numLabel.text = _dataDic[@"read_num"];
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
