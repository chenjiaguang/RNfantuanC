//
//  CircleModel.h
//  FanTuanC
//
//  Created by 杨晓铭 on 2018/3/5.
//  Copyright © 2018年 冫柒Yun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListModel.h"
#import "CirclesModel.h"
#import "RootModel.h"


@class Data,Paging,Comment,User,Reply_object,Banner;
@interface CircleModel :RootModel

@property (nonatomic, strong) Data *data;
@property (nonatomic, copy) NSString *error;
@property (nonatomic, copy) NSString *msg;


@end

@interface Data : RootModel
@property (nonatomic, strong) NSArray <CirclesModel *> *circles;
@property (nonatomic, strong) NSArray <ListModel *> *banner;
@property (nonatomic, strong) NSArray <ListModel *> *list;
@property (nonatomic, strong) NSArray <ListModel *> *notmiss;
@property (nonatomic, copy) NSString *cover_url;
@property (nonatomic, copy) NSString *coverStr;
@property (nonatomic, copy) NSString *article_url;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) Paging *paging;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *circle_id;
@property (nonatomic, copy) NSString *circle_name;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSArray <ListModel *> *contents;
@property (nonatomic, strong) Cover *cover;
@property (nonatomic, strong) NSArray <Comment *> *follow_circles;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *read_num;
@property (nonatomic, copy) NSString *is_news;
@property (nonatomic, copy) NSString *like_num;
@property (nonatomic, copy) NSString *comment_num;
@property (nonatomic, copy) NSString *followed_num;
@property (nonatomic, copy) NSString *dynamic_num;
@property (nonatomic, copy) NSString *dynamic_owner;
@property (nonatomic, strong) NSMutableArray <ListModel *> *like_list;
@property (nonatomic, strong) NSArray <ListModel *> *comment_list;
@property (nonatomic, assign) BOOL is_like;
@property (nonatomic, assign) BOOL has_like;
@property (nonatomic, assign) BOOL is_owner;
@property (nonatomic, assign) BOOL is_follow;
@property (nonatomic, assign) BOOL is_delete;
@property (nonatomic, assign) BOOL is_manager;
// 地址列表
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *location;

//回复
@property (nonatomic, strong) Comment *comment;
@property (nonatomic, strong) NSArray <Comment *> *reply;
@end

@interface Paging : RootModel
@property (nonatomic, assign) BOOL is_end;
@property (nonatomic, copy) NSString *limit;
@property (nonatomic, copy) NSString *pn;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *total_page;

@end

@interface Comment : RootModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *like_num;
@property (nonatomic, copy) NSString *cover;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *compress;
@property (nonatomic, assign) BOOL  longCover;


//长文
@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *height;

@property (nonatomic, assign) BOOL is_author;
@property (nonatomic, assign) BOOL is_follow;
@property (nonatomic, assign) BOOL is_news;
@property (nonatomic, assign) BOOL is_like;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Reply_object *reply_object;

@end

@interface User : RootModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *avatar;


@end
@interface Reply_object : RootModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *comment_id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *like_num;
@property (nonatomic, copy) User *user;


@end

@interface Banner : RootModel
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *type_id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *following_num;
@property (nonatomic, copy) Comment *cover;


@end
