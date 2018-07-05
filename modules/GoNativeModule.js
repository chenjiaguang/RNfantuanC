'use strict';

import { NativeModules } from 'react-native';



/**
 * 无特殊说明 参数全部用字符串型 bool转string的用(0=false,1=true)
 * 
 * 
 * goUserDetail 
 * 参数: 用户id type=1动态=2文章 是否是头条号(string)
 * 跳转用户详情页
 * 
 * 
 * goActivityCodeScan
 * 参数: 活动id
 * 跳转活动二维码扫描
 * 
 * 
 * goActivityCodeDetail
 * 参数: 券码code
 * 跳转活动券码详情页
 * 
 * 
 * goPublishArticleDynamic
 * 参数: 圈子id 圈子名称 活动id
 * 跳转晒长文
 * 
 * 
 * goPublishDynamic
 * 参数: 圈子id 圈子名称 活动id
 * 跳转晒动态
 * 
 * 
 * goActivityShow
 * 参数: 圈子id 圈子名称 活动id
 * 跳转大家都在晒
 * 
 * 
 * goActivityMap
 * 参数: 地点名称 lng lat
 * 跳转地图页
 * 
 * goCircleDetail
 * 参数：圈子id 圈子名 封面图url 是否有活动(string)
 * 跳转圈子详情页
 * 
 * goActivityOrder
 * 参数：活动id
 * 跳转购票页
 * 
 * goReLogin
 * 跳转登陆页
 * 
 * goForgetPassWord
 * 跳转忘记密码页
 * 
 * shareActivity
 * 参数：图片url 标题 内容 跳转url
 * 活动分享
 * 
 */
export default NativeModules.GoNativeModule;