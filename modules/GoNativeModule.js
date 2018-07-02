'use strict';

import { NativeModules } from 'react-native';



/**
 * goUserDetail 
 * 参数: 用户id 
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
 * 参数：圈子id 圈子名 封面图url
 * 跳转圈子详情页
 * 
 * goActivityOrder
 * 参数：活动id
 * 跳转购票页
 * 
 * shareActivity
 * 参数：活动id
 * 活动分享
 */
export default NativeModules.GoNativeModule;