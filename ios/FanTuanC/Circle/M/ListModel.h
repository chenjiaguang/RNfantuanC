//
//  ListModel.h
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/3/5.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RootModel.h"
#import "CircleModel.h"
@class Cover,Replys,List;
@interface ListModel : RootModel

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, strong) Cover *cover;
@property (nonatomic, strong) NSArray <ListModel *> *covers;
@property (nonatomic, strong) Replys *replys;

@property (nonatomic, copy) NSString *circle_id;
@property (nonatomic, copy) NSString *circle_name;
@property (nonatomic, copy) NSString *comment_num;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *b_content;
@property (nonatomic, copy) NSString *dynamic_image;
@property (nonatomic, assign) BOOL has_like;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *like_num;
@property (nonatomic, copy) NSString *read_num;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *compress;
@property (nonatomic, assign) BOOL longCover;
@property (nonatomic, assign) BOOL followed;
@property (nonatomic, assign) BOOL is_circle_manager;
@property (nonatomic, assign) BOOL is_circle_owner;
@property (nonatomic, assign) BOOL circle_owner;
@property (nonatomic, assign) BOOL circle_admin;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *to_uid;
@property (nonatomic, copy) NSString *to_username;
@property (nonatomic, copy) NSString *pusername;
@property (nonatomic, copy) NSString *puid;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *target_id;
@property (nonatomic, copy) NSString *article_id;
@property (nonatomic, copy) NSString *dynamic_id;
@property (nonatomic, copy) NSString *target_type;

@property (nonatomic, assign) BOOL is_news;
@property (nonatomic, assign) BOOL is_owner;
@property (nonatomic, assign) BOOL is_mutual;
@property (nonatomic, assign) BOOL is_delete;
@property (nonatomic, assign) BOOL is_following;
@property (nonatomic, assign) BOOL is_new_one;

// 头条Model
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *news_name;
@property (nonatomic, copy) NSString *article_url;
@property (nonatomic, copy) NSString *atlas_num;

// 地址列表
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *dynamic_title;


@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *following_num;
@property (nonatomic, copy) NSString *today_num;

@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *total_page;
@property (nonatomic, copy) NSString *limit;
@property (nonatomic, copy) NSString *pn;
@property (nonatomic, assign) BOOL is_end;

@end
@interface Replys : RootModel
@property (nonatomic, strong) NSMutableArray <ListModel *> *list;
@property (nonatomic, strong) ListModel *paging;



@end
@interface List : RootModel
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *puid;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *pusername;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL is_owner;
@property (nonatomic, assign) BOOL is_delete;
@property (nonatomic, assign) BOOL is_manager;


@end
@interface Cover : RootModel
@property (nonatomic, copy) NSString *compress;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *longCover;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *width;

@end
