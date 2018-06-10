//
//  HomeCircleCollectionCell.m
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/5/3.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import "HomeCircleCollectionCell.h"
@interface HomeCircleCollectionCell ()
{
    UIImageView *_circleCoverImageView; //用户头像
    UILabel *_nameLabel;         //用户名称
    UILabel *_fousNumLabel;
}
@end
@implementation HomeCircleCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubviews];
    }
    return self;
}
-(void)setModel:(CirclesModel *)model
{
    _model = model;
    [_circleCoverImageView sd_setImageWithURL:[NSURL URLWithString:_model.cover.url]];
    _nameLabel.text = _model.name;
    _fousNumLabel.text = [NSString stringWithFormat:@"%@人关注",_model.num];
}
-(void)fousBtnAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self requestFousCirleWithCirleID:_model.id Follow:@"1"];
        btn.layer.borderColor=[MyTool ColorWithColorStr:@"DDDDDD"].CGColor;
    }else{
        [self requestFousCirleWithCirleID:_model.id Follow:@"0"];
        btn.layer.borderColor=[MyTool ColorWithColorStr:@"1EB0FD"].CGColor;
    }

}
-(void)requestFousCirleWithCirleID:(NSString *)cirleID Follow:(NSString *)follow
{
    NSString *urlStr = [NetRequest FollowCircle];
    NSDictionary *paramsDic = @{@"id":cirleID,@"follow":follow};
    [[NetToolExtend shareInstance] postWithURL:urlStr params:paramsDic success:^(id JSON) {
        CircleModel *model = [CircleModel yy_modelWithJSON:JSON];
        if ([model.error integerValue] == 0) {
            
    
        }
        [MyTool showHUDWithStr:model.msg];
    } failure:^(NSError *error) {
    }];
}
- (void)addSubviews
{
    UIImageView * circleCoverImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    circleCoverImageView.backgroundColor = [MyTool colorWithString:@"EEEEEE"];
    circleCoverImageView.contentMode = UIViewContentModeScaleAspectFill;
    circleCoverImageView.layer.masksToBounds = YES;
    _circleCoverImageView = circleCoverImageView;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    nameLabel.textColor = [MyTool colorWithString:@"333333"];
    nameLabel.font = [UIFont systemFontOfSize:14];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = @"这里圈子名这里圈子名";
    _nameLabel = nameLabel;
    
    UILabel *fousNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    fousNumLabel.textColor = [MyTool colorWithString:@"999999"];
    fousNumLabel.font = [UIFont systemFontOfSize:12];
    fousNumLabel.textAlignment = NSTextAlignmentCenter;
    fousNumLabel.text = @"1234人关注";
    _fousNumLabel = fousNumLabel;
    
    UIButton *fousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fousBtn.titleLabel.font =[UIFont systemFontOfSize:12 ];
    [fousBtn setTitle:@"关注" forState:UIControlStateNormal];
    [fousBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [fousBtn setTitleColor:[MyTool ColorWithColorStr:@"1EB0FD"] forState:UIControlStateNormal];
    [fousBtn setTitleColor:[MyTool ColorWithColorStr:@"999999"] forState:UIControlStateSelected];
    [fousBtn addTarget: self action:@selector(fousBtnAction:) forControlEvents:UIControlEventTouchDown];
    [fousBtn.layer setBorderWidth:0.5];
    fousBtn.layer.borderColor=[MyTool ColorWithColorStr:@"1EB0FD"].CGColor;
    
    self.contentView.layer.cornerRadius = 4;
    self.contentView.layer.masksToBounds = YES;
    [self.contentView.layer setBorderWidth:0.5];
    self.contentView.layer.borderColor=[MyTool ColorWithColorStr:@"CCCCCC"].CGColor;
    
    [self.contentView sd_addSubviews:@[circleCoverImageView,nameLabel,fousBtn,fousNumLabel]];
    
   

    circleCoverImageView.sd_layout
    .topSpaceToView(self.contentView, 10)
    .centerXEqualToView(self.contentView)
    .widthIs(self.bounds.size.width * 41/131)
    .heightEqualToWidth();
    circleCoverImageView.sd_cornerRadius = @(4);
    
    nameLabel.sd_layout
    .topSpaceToView(circleCoverImageView, 10)
    .leftSpaceToView(self.contentView, 23)
    .rightSpaceToView(self.contentView, 23)
    .centerXEqualToView(self.contentView)
    .autoHeightRatio(0);
    //设置约束 最多5行
    [nameLabel setMaxNumberOfLinesToShow:2];
    
    
    fousBtn.sd_layout
    .bottomSpaceToView(self.contentView, 10)
    .centerXEqualToView(self.contentView)
    .heightIs(24)
    .widthIs(self.bounds.size.width * 73/131);
    fousBtn.sd_cornerRadius = @(4);

    fousNumLabel.sd_layout
    .bottomSpaceToView(fousBtn, 12)
    .centerXEqualToView(self.contentView)
    .heightIs(12);
    [fousNumLabel setSingleLineAutoResizeWithMaxWidth:self.bounds.size.width -30];
}
@end
