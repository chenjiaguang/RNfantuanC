import React from "react";
import {
  ScrollView,
  View,
  Image,
  StyleSheet,
  Linking,
  Animated,
  Platform,
  StatusBar,
  Alert,
  TouchableWithoutFeedback,
  TouchableOpacity,
  WebView
} from 'react-native';
import px2dp from '../lib/px2dp'
import { ifIphoneX, getStatusBarHeight, isIphoneX } from 'react-native-iphone-x-helper'
import Iconfont from '../components/cxicon/CXIcon';
import ActionSheet from 'react-native-actionsheet' // RN官方提供ios的ActionSheet，此处引入双平台的ActionSheet(ios/android)
import Button from 'apsl-react-native-button' // 第三方button库，RN官方的库会根据平台不同区别，这里统一
import Toast from '../components/Toast'
import GoNativeModule from '../modules/GoNativeModule'
import SwipBackModule from '../modules/SwipBackModule';
import LoadingView from '../components/LoadingView'
import HeadNav from '../components/HeadNav'
import RoundBorderView from '../components/RoundBorderView'
import UtilsModule from '../modules/UtilsModule'
import ImageBrowser from '../components/ImageBrowser'
import Text from '../components/MyText'
import NoNetwork from '../components/NoNetwork'
import Util from '../lib/Util'
import commonStyle from '../static/commonStyle'



export default class ActivityDetail extends React.Component {  // 什么参数都不传，则默认是绑定手机都页面，传入isRebind为true时表示新绑手机，界面稍有差异
  constructor(props) {
    super(props)
    this.lastY = 0
    this.state = {
      defWebViewHeight: 0,
      circleApplying: false,
      isOpen: false,
      browserIndex: 0,
      actionSheetOptions: Platform.OS === 'android' ? [<Text style={{ color: '#333333', fontSize: px2dp(34) }}>动态</Text>,
      <Text style={{ color: '#333333', fontSize: px2dp(34) }}>长文</Text>,
      <Text style={{ color: '#333333', fontSize: px2dp(34) }}>取消</Text>] : ['动态', '长文', '取消'],
      activity: {
        id: '',
        bannerUrl: '',
        title: '',
        from: '',
        sponsorName: '',
        sponsorPhone: '',
        address: '',
        location: {
          lng: '',
          lat: ''
        },
        date: '',
        cost: '',
        deadline: '',
        tags: [],
        join: [],
        activityImages: [],
        activityImageLength: 0,
        status: '',
        statusText: '',
        content: [],
        htmlContent: null,
        circle: null,
        latitude: '',
        longitude: '',
        address_text: '',
        joinedTotal: '',
        shareUrl: '',
        share_content: '',
        contentImages: [],
        submitting: false
      },
      netError: false
    }
  }
  static navigationOptions = ({ navigation, screenProps }) => {
    return {
      title: '',
      headerLeft: null,
      headerRight: null,
      headerStyle: {
        width: px2dp(750),
        height: 0,
        backgroundColor: 'rgba(250,250,250,' + 0 + ')',
        position: 'absolute',
        borderBottomWidth: 0,
        elevation: 0
      },
      gesturesEnabled: navigation.state.params.gesturesEnabled
    }
  }
  onNetReload = () => {
    this.setState({
      netError: false,
    })
    setTimeout(this.fetchActivity, 0)
  }
  onNetError = (err) => {
    // this.state.activity.id = ''
    this.setState({
      netError: true,
    })
  }
  setBarStyle(barStyle) {
    if (barStyle == 'dark-content' || barStyle == 'light-content') {
      if (this.lastBarStyle != barStyle) {
        if (Platform.OS === 'android') {
          UtilsModule.setBarStyle(barStyle)
        } else {
          StatusBar.setBarStyle(barStyle)
        }
        this.lastBarStyle = barStyle
      }
    }
  }
  onJumpPublishArticleDynamic = (id, name, actid) => {
    GoNativeModule && GoNativeModule.goPublishArticleDynamic(id, name, actid)
  }
  onJumpPublishDynamic = (id, name, actid, actname) => {
    GoNativeModule && GoNativeModule.goPublishDynamic(id, name, actid, actname)
  }
  onJumpActivityMap = (destName, longtitude, latitude) => {
    GoNativeModule && GoNativeModule.goActivityMap(destName, longtitude, latitude)
  }
  onJumpActivityShow = (id, name, actid, actname) => {
    GoNativeModule && GoNativeModule.goActivityShow(id, name, actid, actname)
  }
  onJumpActivityOrder = (id) => {
    GoNativeModule && GoNativeModule.goActivityOrder(id)
  }
  onJumpActivityConfirmOrder = (id) => {
    GoNativeModule && GoNativeModule.goFirmOrder(id)
  }
  onJumpCircleDetail = (id, name, coverUrl, hasActivity) => {
    GoNativeModule && GoNativeModule.goCircleDetail(id, name, coverUrl, hasActivity ? "1" : "0")
  }
  onJumpActivityJoiners = (id) => {
    this.setBarStyle('dark-content')
    this.props.navigation.navigate('ActivityJoiners', { id: id })
  }
  onJumpApplyCircle = (circleid, circleName, circleCover) => {
    GoNativeModule && GoNativeModule.goCircleApply(circleid, circleName, circleCover)
  }
  scanCode = (id) => {
    GoNativeModule && GoNativeModule.goActivityCodeScan(id)
  }
  handleScroll = (event) => {
    let newY = event.nativeEvent.contentOffset.y
    let range = (px2dp(332) - getStatusBarHeight(true))
    let value = newY / range
    value = value > 1 ? 1 : value
    if (newY < range + 100) {
      if (value >= 1) {
        this.setBarStyle('dark-content')
      } else {
        this.setBarStyle('light-content')
      }
      this._headNav.setState({ value: value })
    }
    this.lastY = newY
  }
  callPhone = () => {
    let { sponsorPhone } = this.state.activity
    if (!sponsorPhone) {
      return false
    }
    let url = 'tel:' + sponsorPhone
    Linking.canOpenURL(url).then(supported => {
      if (!supported) {
      } else {
        return Linking.openURL(url);
      }
    }).catch(err => console.error('An error occurred', err));
  }
  animate = () => {
    let { initialHeight, maxHeight, animationHeight, iconRotate } = this.state
    if (animationHeight._value < initialHeight) {
      animationHeight.setValue(initialHeight)
      iconRotate.setValue(1)
      this.setState({ isOpen: true })
      // Animated.parallel([
      //   Animated.timing(
      //     animationHeight,
      //     {
      //       toValue: initialHeight,
      //       duration: 300
      //     }
      //   ),
      //   Animated.timing(
      //     iconRotate,
      //     {
      //       toValue: 1,
      //       duration: 300
      //     }
      //   )
      // ]).start()

    } else {
      animationHeight.setValue(maxHeight)
      iconRotate.setValue(0)
      this.setState({ isOpen: false })
      // Animated.parallel([
      //   Animated.timing(
      //     animationHeight,
      //     {
      //       toValue: maxHeight,
      //       duration: 300
      //     }
      //   ),
      //   Animated.timing(
      //     iconRotate,
      //     {
      //       toValue: 0,
      //       duration: 300
      //     }
      //   )
      // ]).start()
    }
  }
  introBoxLayout = (event, forceUpdate) => {
    let { initialHeight, maxHeight, animationHeight, iconRotate } = this.state
    if (initialHeight && maxHeight && animationHeight && iconRotate && !forceUpdate) {
      return false
    }
    let height = 0
    let _initialHeight = 0
    if (event.nativeEvent.layout.height > px2dp(700)) {
      height = px2dp(700)
      _initialHeight = event.nativeEvent.layout.height + px2dp(84)
    } else {
      height = event.nativeEvent.layout.height + px2dp(40)
      _initialHeight = event.nativeEvent.layout.height + px2dp(40)
    }
    let animation = new Animated.Value(height)
    this.setState({
      initialHeight: _initialHeight,
      maxHeight: px2dp(700),
      animationHeight: animation,
      iconRotate: new Animated.Value(0)
    })
  }
  checkAccess = () => {
    let { id, name, cover, followed, need_audit } = this.state.activity.circle
    let flat = false
    if (!followed) { // 需加入群组才能晒图
      Alert.alert(
        '',
        '加入群组才能进行更多操作哦~',
        [
          {
            text: '我再想想',
            onPress: () => { },
            style: { color: '#0076FF' }
          },
          {
            text: need_audit ? '申请加入' : '立即加入',
            onPress: () => {
              if (need_audit) { // 跳转申请加入
                this.onJumpApplyCircle(id, name, cover.compress)
              } else { // 直接申请
                if (this.state.circleApplying) { // 正在申请
                  Toast.show('正在提交申请，请稍后~')
                  return false
                }
                let rData = {
                  id: id,
                  follow: 1
                }
                this.setState({
                  circleApplying: true
                })
                _FetchData(_Api + '/jv/qz/following', rData).then(res => {
                  let _activity = Object.assign({}, this.state.activity)
                  if (res && !res.error) { // 申请成功
                    _activity.circle.followed = true
                    this.setState({
                      activity: _activity,
                      circleApplying: false
                    })
                    Toast.show('加入成功')
                  } else if (res.error && res.msg) {
                    this.setState({
                      circleApplying: false
                    })
                    Toast.show(res.msg)
                  } else {
                    this.setState({
                      circleApplying: false
                    })
                  }
                }).catch(err => {
                  console.log('加入群组出错', err)
                  this.setState({
                    circleApplying: false
                  })
                })
              }
            },
            style: { color: '#0076FF', fontWeight: 'bold' }
          }
        ],
        { cancelable: false }
      )
      flat = false
    } else {
      flat = true
    }
    return flat
  }
  checkOrder = () => {
    let rData = {
      aid: this.state.activity.id
    }
    this.setState({
      submitting: true
    })
    _FetchData(_Api + '/jv/qz/v25/order/unpaid', rData, { dontToast: true }).then(res => {
      this.setState({
        submitting: false
      })
      if (res && res.data && res.data.checkcode && !res.error) { // 有未支付订单
        if (res.data.leftTime && parseInt(res.data.leftTime) > 0) { // 剩余时间大于0
          this.onJumpActivityConfirmOrder(this.state.activity.id)
        } else { // 剩余时间不足
          this.onJumpActivityOrder(this.state.activity.id)
        }
      } else { // 无未支付订单
        this.onJumpActivityOrder(this.state.activity.id)
      }
    }).catch(err => {
      this.setState({
        submitting: false
      })
      if (err && err.status && err.status.toString() === '200') {
        this.onJumpActivityOrder(this.state.activity.id)
      }
    })
  }
  goOrder = () => {
    if (!this.checkAccess()) { // 需加入群组才能购票
      return false
    }
    this.checkOrder()
  }
  publish = async () => {
    let { status } = this.state.activity
    let { id, name, cover, followed, need_audit } = this.state.activity.circle
    if (!this.checkAccess()) { // 需加入群组才能晒图
      return false
    }
    if (status.toString() === '0' || status.toString() === '2') { // 活动未上线
      Toast.show('活动未上线，还不能操作哦~')
      return false
    }
    if (UtilsModule) {
      try {
        await UtilsModule.canCreateDynamic()
        this.ActionSheet.show()
      } catch (error) {
      }
    } else {
      this.ActionSheet.show()
    }
  }
  fetchActivity = () => {
    let rData = {
      id: this.props.navigation.state.params.id
    }
    _FetchData(_Api + '/jv/qz/v21/activity', rData, { onNetError: (err) => this.onNetError(err) }).then(res => {
      let _tags = []
      if (!res.data.refund) {
        _tags.push('不可退票')
      }
      if (res.data.insurance) {
        _tags.push('费用中包含保险')
      }
      if (res.data.max_ticket && res.data.max_ticket > 0) {
        _tags.push('限购' + res.data.max_ticket + '张')
      }
      let _obj = {
        id: res.data.id,
        bannerUrl: res.data.covers[0].compress,
        title: res.data.title,
        from: res.data.circle.name,
        sponsorName: res.data.oid,
        sponsorPhone: res.data.phone,
        address: res.data.address_text,
        location: {
          lng: res.data.longitude,
          lat: res.data.latitude,
          name: res.data.address_text
        },
        date: res.data.time_text,
        cost: res.data.money,
        deadline: res.data.deadline,
        deadline_text: res.data.deadline_text,
        tags: _tags,
        join: res.data.joined_users,
        activityImages: res.data.activity_images.filter((item, idx) => idx < 3),
        activityImageLength: res.data.activity_images.length,
        statusText: res.data.status_text,
        joinedTotal: res.data.joined_total,
        shareUrl: res.data.share_url,
        share_content: res.data.share_content,
        hasDynamic: res.data.activity_has_dynamic,
        content: res.data.rendering_type.toString() === '0' ? res.data.content.filter(item => item.type.toString() !== '0').map((item, idx) => {
          return {
            type: item.type,
            content: item.type.toString() === '1' ? item.content : {
              image: item.imageUrl,
              description: item.des
            },
            idx: idx,
            des: item.des,
            width: item.width,
            height: item.height
          }
        }) : [],
        htmlContent: res.data.rendering_type.toString() === '1' ? ('<!DOCTYPE html><html style="padding:0;margin:0;"><head><meta http-equiv="content-type" content="text/html" /><meta http-equiv="Pragma" content="no-cache" /><meta name="viewport" content="initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no,width=device-width" /><meta name="app-mobile-web-app-capable" content="yes" /></head><body style="padding:0;margin:0;"><div style="overflow-x:auto;">' + res.data.content + '</div></body></html>') : null,
        circle: res.data.circle,
        status: res.data.status,
      }
      if (_obj.content && _obj.content.length) {
        let images = _obj.content.filter(item => item.type.toString() === '2')
        let contentImages = images.map(item => {
          return {
            idx: item.idx,
            url: item.content.image
          }
        })
        _obj.contentImages = contentImages
      }
      this.setState({
        activity: _obj,
        netError: false
      })
      this.props.navigation.setParams({ 'activity': _obj })
      this.setBarStyle('light-content')
    }).catch(err => {
      console.log('获取活动数据失败', err)
      // this.setState({
      //   initial: false
      // })
    })
  }
  componentDidMount() {
    this.fetchActivity()
  }
  componentWillUnmount() {
    this.setBarStyle('dark-content')
  }
  share = () => {
    let activity = this.props.navigation.state.params.activity
    let { status } = this.state.activity
    if (status === '') { // 未拉取到数据时操作无效
      return false
    }
    if (status.toString() === '0' || status.toString() === '2') { // 活动未上线,0审核中，2不通过
      Toast.show('活动未上线，还不能操作哦~')
      return false
    }
    GoNativeModule && GoNativeModule.shareActivity(activity.bannerUrl,
      activity.title,
      activity.share_content,
      activity.shareUrl)
  }
  viewImages = (index) => {
    let _idx = ''
    let { contentImages } = this.state.activity
    contentImages.map((item, idx) => {
      if (item.idx === index) {
        _idx = idx
      }
    })
    this.ImageBrowser.show(_idx)
  }
  patchPostMessageFunction = function() {
    var originalPostMessage = window.postMessage
    var patchedPostMessage = function(message, targetOrigin, transfer) { 
      originalPostMessage(message, targetOrigin, transfer)
    }
    patchedPostMessage.toString = function() { 
      return String(Object.hasOwnProperty).replace('hasOwnProperty', 'postMessage')
    }
    window.postMessage = patchedPostMessage
  }

  _onLoadEnd = () => {
    const script = `window.postMessage(document.body.scrollHeight)`
    this.webview && this.webview.injectJavaScript(script)
  }
  _onMessage = (e) => {
    if (!e.nativeEvent.data) {
      return false
    }
    let valToInt= parseInt(e.nativeEvent.data)
    let defWebViewHeight = px2dp(valToInt)
    if (defWebViewHeight != this.state.defWebViewHeight) {
      this.setState({defWebViewHeight})
      this.introBoxLayout({ // 强制重新设置内容高度
        nativeEvent: {
          layout: {
            height: valToInt
          }
        }
      }, true)
    }
  }
  render() {
    let { id, bannerUrl, title, joinedTotal, from, sponsorName, sponsorPhone, address, location, date, cost, deadline_text, tags, join, activityImages, activityImageLength, statusText, content, htmlContent, circle, contentImages, hasDynamic } = this.state.activity
    let { defWebViewHeight, initialHeight, maxHeight, animationHeight, iconRotate, browserIndex } = this.state
    return <View style={styles.page}>
      <HeadNav
        ref={(component) => this._headNav = component}
        fetching={!id}
        navigation={this.props.navigation}
        title={'活动详情'}
        headerRight={(rgb) => {
          return <TouchableWithoutFeedback disabled={false} onPress={() => { this.share() }}>
            <View style={{ height: px2dp(90), paddingLeft: px2dp(20), paddingRight: px2dp(26), justifyContent: 'center' }}>
              <Iconfont name="dot" size={px2dp(36)} color={rgb} />
            </View>
          </TouchableWithoutFeedback>
        }}
      />
      {this.state.netError ? <NoNetwork reload={this.onNetReload} style={{ marginTop: commonStyle.value.navHeightWithStatusBar }} /> :
        this.state.activity.id == '' ? <LoadingView style={{ marginTop: Platform.OS === 'android' ? px2dp(212) + 25 : px2dp(212) }} /> : null
      }

      <ImageBrowser ref={el => this.ImageBrowser = el} index={browserIndex} images={contentImages} page={this} />
      {this.state.activity.id == '' ? null : <ScrollView style={styles.scrollView} onScroll={this.handleScroll} bounces={false} scrollEventThrottle={15}>
        <View style={styles.pageWrapper}>
          <Image source={{ uri: bannerUrl }} style={styles.header} resizeMode="cover" />
          <View style={styles.contentWrapper}>
            <Text style={styles.title}>{title}</Text>
            <Text style={styles.from}>来自"{from}"的活动</Text>
            <View style={styles.infoBox}>
              <View style={styles.infoItem}>
                <Text style={styles.infoLeft}>主办方</Text>
                <Text style={[styles.infoRight, { fontWeight: '600' }]} numberOfLines={1}>{sponsorName}</Text>
                {sponsorPhone ? <Iconfont onPress={this.callPhone} name='phone' size={px2dp(33)} color='#1EB0FD' style={{ width: px2dp(60), paddingTop: px2dp(15), paddingBottom: px2dp(15), textAlign: 'right' }} /> : null}
              </View>
              <View style={styles.infoItem}>
                <Text style={styles.infoLeft}>地点</Text>
                <Text style={styles.infoRight} numberOfLines={1}>{address}</Text>
                {(address && location && location.lng && location.lat) ? <Iconfont name='location' onPress={() => this.onJumpActivityMap(location.name, location.lng, location.lat)} size={px2dp(24)} color='#1EB0FD' style={{ width: px2dp(60), textAlign: 'right', paddingTop: px2dp(20), paddingBottom: px2dp(20) }} /> : null}
              </View>
              <View style={styles.infoItem}>
                <Text style={styles.infoLeft}>时间</Text>
                <Text style={styles.infoRight} numberOfLines={1}>{date}</Text>
              </View>
              <View style={styles.infoItem}>
                <Text style={styles.infoLeft}>费用</Text>
                <Text style={[styles.infoRight, { color: '#FF3A30' }]} numberOfLines={1}>{cost.toString() === '0' ? '免费' : '¥' + cost}</Text>
              </View>
              <View style={styles.infoItem}>
                <Text style={styles.infoLeft}>报名截止时间</Text>
                <Text style={styles.infoRight} numberOfLines={1}>{deadline_text}</Text>
              </View>
              <View style={styles.tags}>
                {tags.map((item, idx) =>
                  <RoundBorderView
                    key={idx}
                    style={styles.tagItem}>
                    <Text style={{ fontSize: px2dp(24), color: '#666' }}>{item}</Text>
                  </RoundBorderView>
                )}
              </View>
            </View>
            {((content && content.length > 0) || htmlContent) ? <Animated.View ref={el => this.animateElement = el} style={[styles.introBox, { height: animationHeight ? animationHeight : 'auto' }]} onLayout={this.introBoxLayout}>
              <Text style={styles.introHeader}>活动介绍</Text>
              {htmlContent ? <WebView ref={ele => this.webview = ele} source={{html: htmlContent, baseUrl: ''}} scrollEnabled={false} bounces={false} style={{width: px2dp(690), height: defWebViewHeight, backgroundColor:'clearColor', opaque:'no'}} onLoadEnd={this._onLoadEnd} onMessage={this._onMessage} injectedJavaScript={'(' + String(this.patchPostMessageFunction) + ')()'}></WebView> : null}
              {content.map((item, idx) => {
                if (item.type.toString() === '1') { // 文本
                  return <Text key={idx} style={styles.introText}>{item.content}</Text>
                } else if (item.type.toString() === '2') { // 图片
                  return <View key={idx}>
                    <TouchableWithoutFeedback
                      onPress={() => this.viewImages(item.idx)}>
                      <Image source={{ uri: item.content.image }}
                        style={[styles.introImage, { height: px2dp((item.height / item.width) * 690 || 388) }]}
                        resizeMode={'cover'} />
                    </TouchableWithoutFeedback>
                    {item.des ? <Text style={styles.imgDesc}>{item.des}</Text> : null}
                  </View>
                }
              })}
              {(initialHeight && animationHeight && maxHeight && initialHeight > px2dp(700)) ? <TouchableWithoutFeedback onPress={this.animate}>
                <View style={styles.showHideBtn}>
                  <Text style={{ fontSize: px2dp(24), color: '#333' }}>{this.state.isOpen ?
                    '收起' :
                    '查看更多图文详情'}</Text>
                  <Animated.View style={{
                    marginLeft: px2dp(17), transform: [
                      {
                        rotateZ: iconRotate.interpolate({
                          inputRange: [0, 1],
                          outputRange: ['0deg', '180deg'],
                        })
                      }
                    ]
                  }}><Iconfont name='pull_down' size={px2dp(18)} color='#666666' /></Animated.View>
                </View>
              </TouchableWithoutFeedback> : null}
            </Animated.View> : null}
          </View>
          <View style={styles.otherBox}>
            <View style={{ height: px2dp(16), backgroundColor: '#F3F3F3' }}></View>
            {(join && join.length > 0) ? <View style={styles.joinBox}>
              <View style={styles.joinBoxHeader}><Text style={{ fontSize: px2dp(32), color: '#333', fontWeight: '600' }}>已报名的小伙伴({joinedTotal})</Text></View>
              <TouchableOpacity onPress={() => this.onJumpActivityJoiners(id)} activeOpacity={0.8}>
                <View style={styles.joinBoxContent}>
                  {join.map((item, idx) => <View key={idx} style={{ width: px2dp(42), height: (item.num && parseInt(item.num) > 1) ? px2dp(52) : px2dp(42), marginLeft: idx === 0 ? 0 : px2dp(30) }}>
                      <Image source={{ uri: item.avatar }} style={{ width: px2dp(42), height: px2dp(42) }} />
                      {(item.num && parseInt(item.num) > 1) ? <Text style={{position: 'absolute', backgroundColor: '#fff', overflow: 'hidden', paddingLeft: px2dp(2), paddingRight: px2dp(2), right: 0, bottom: 0, borderRadius: px2dp(10), borderWidth: px2dp(1), borderColor: '#FE5F5F', fontSize: px2dp(14), color: '#FE5F5F', lineHeight: px2dp(18) }}>x{parseInt(item.num) > 99 ? '99+' : item.num}</Text> : null}
                    </View>)}
                </View>
              </TouchableOpacity>
            </View> : null}
            <View style={styles.dynamicBox}>
              <View style={styles.dynamicBoxHeader}>
                <Text style={{ fontSize: px2dp(32), color: '#333', fontWeight: '600' }}>大家都在晒</Text>
                {hasDynamic ?
                  <TouchableOpacity onPress={() => this.onJumpActivityShow(circle.id, circle.name, id, title)} activeOpacity={0.8}>
                    <View style={{ height: px2dp(112), flexDirection: 'row', alignItems: 'center' }}>
                      <Text style={{ color: '#333', fontSize: px2dp(28) }}>更多</Text>
                      <Iconfont name="next" size={px2dp(18)} color="#666666" style={{ marginLeft: px2dp(4) }} />
                    </View>
                  </TouchableOpacity> : null
                }
              </View>
              {hasDynamic ? <View style={styles.dynamicBoxImages}>
                {activityImages.slice(0, 3).map((item, idx) =>
                  <TouchableOpacity key={idx} onPress={() => this.onJumpActivityShow(circle.id, circle.name, id, title)} activeOpacity={0.8}>
                    <Image source={{ uri: item.compress }} style={{ width: px2dp(155), height: px2dp(155), marginRight: px2dp(20) }} />
                  </TouchableOpacity>
                )}
                <TouchableOpacity onPress={this.publish} activeOpacity={0.8}>
                  <View style={{ width: px2dp(155), height: px2dp(155), justifyContent: 'center', alignItems: 'center', backgroundColor: '#F4F4F4' }}>
                    <Iconfont name="camera" size={px2dp(48)} color="#BBBBBB" />
                    <Text style={{ fontSize: px2dp(20), color: '#999' }}>晒美照</Text>
                  </View>
                </TouchableOpacity>
              </View> : <View style={[styles.dynamicBoxImages, { height: px2dp(195), paddingRight: px2dp(5), flexDirection: 'column', justifyContent: 'center', alignItems: 'center' }]}>
                  <TouchableOpacity onPress={this.publish} style={{ justifyContent: 'center', alignItems: 'center' }} activeOpacity={0.8}>
                    <View style={{ justifyContent: 'center', alignItems: 'center' }}>
                      <Image source={require('../static/image/rn_camera.png')} style={{ width: px2dp(88), height: px2dp(67) }} />
                      <Text style={{ fontSize: px2dp(24), color: '#999', marginTop: px2dp(24) }}>成为第一个晒照的小可爱</Text>
                    </View>
                  </TouchableOpacity>
                </View>}
            </View>
            {circle ? <View style={styles.circleBox}>
              <View style={styles.circleInfo}>
                <Button onPress={() => this.onJumpCircleDetail(circle.id, circle.name, circle.cover.compress, circle.circle_has_activity)} style={styles.circleAvatar} activeOpacity={0.8}><Image source={{ uri: circle.cover.url }} style={{ flex: 1 }} /></Button>
                <View style={styles.circleText}>
                  <Text style={{ fontSize: px2dp(30), color: '#333', lineHeight: px2dp(64) }}>{circle.name}</Text>
                  <Text style={{ fontSize: px2dp(24), color: '#999', lineHeight: px2dp(38), minHeight: px2dp(76) }} numberOfLines={2}>{circle.intro}</Text>
                </View>
              </View>
              <TouchableWithoutFeedback onPress={() => this.onJumpCircleDetail(circle.id, circle.name, circle.cover.compress, circle.circle_has_activity)}>
                <View style={styles.circleButton}>
                  <Text style={styles.circleButtonText}>进入群组参与该活动讨论</Text>
                </View>
              </TouchableWithoutFeedback>
            </View> : null}
          </View>
        </View>
      </ScrollView>}
      {this.state.activity.id == '' ? null : <View style={styles.fixedButtons}>
        <TouchableWithoutFeedback onPress={this.callPhone}>
          <View
            style={{ flexDirection: 'column', justifyContent: 'center', alignItems: 'center', width: px2dp(200), height: px2dp(100), borderRadius: 0, borderWidth: px2dp(1), borderColor: '#E5E5E5', backgroundColor: '#fff' }}
          >
            <Iconfont name="phone-w" size={px2dp(33)} />
            <Text style={{ fontSize: px2dp(24) }}>电话咨询</Text>
          </View>
        </TouchableWithoutFeedback>

        <TouchableWithoutFeedback onPress={this.publish}>
          <View
            style={{ flexDirection: 'column', justifyContent: 'center', alignItems: 'center', width: px2dp(200), height: px2dp(100), borderRadius: 0, borderWidth: px2dp(1), borderColor: '#E5E5E5', backgroundColor: '#fff' }}
          >
            <Iconfont name="camera-w" size={px2dp(33)} />
            <Text style={{ fontSize: px2dp(24) }}>晒图</Text>
          </View>
        </TouchableWithoutFeedback>

        <Button style={{ flex: 1, height: px2dp(100), borderRadius: 0, borderWidth: px2dp(1), borderColor: statusText === '购票' ? '#FF3A30' : '#BBBBBB', backgroundColor: '#FF3A30' }} disabledStyle={{ backgroundColor: '#BBBBBB' }} textStyle={{ fontSize: px2dp(30), color: '#fff', fontWeight: '600' }} activeOpacity={0.8} isDisabled={statusText !== '购票'}
          onPress={this.goOrder} >{statusText}</Button>
      </View>}
      <ActionSheet
        ref={el => this.ActionSheet = el}
        options={this.state.actionSheetOptions}
        cancelButtonIndex={2}
        styles={{
          color: '#333333',
          titleText: {
            color: '#333333'
          }
        }}
        onPress={(index) => {
          switch (index) {
            case 0: // 选择照片
              this.onJumpPublishDynamic(this.state.activity.circle.id, this.state.activity.circle.name, this.state.activity.id, this.state.activity.title)
              break;
            case 1:
              this.onJumpPublishArticleDynamic(this.state.activity.circle.id, this.state.activity.circle.name, this.state.activity.id)
              break;
            default:
            // do nothing
          }
        }}
      />
    </View>
  }
}

const styles = StyleSheet.create({
  page: {
    flex: 1,
    backgroundColor: '#fff'
  },
  scrollView: {
    backgroundColor: '#fff',
    flex: 1
  },
  pageWrapper: {
    alignItems: 'stretch',
    ...ifIphoneX({
      paddingBottom: px2dp(204)
    }, {
        paddingBottom: px2dp(160)
      })
  },
  contentWrapper: {
    paddingLeft: px2dp(30),
    paddingRight: px2dp(30),
    alignItems: 'stretch'
  },
  header: {
    height: px2dp(422)
  },
  title: {
    fontSize: px2dp(32),
    lineHeight: px2dp(46),
    paddingTop: px2dp(27),
    color: '#333'
  },
  from: {
    fontSize: px2dp(24),
    lineHeight: px2dp(56),
    color: '#666'
  },
  infoBox: {
    paddingTop: px2dp(20)
  },
  infoItem: {
    height: px2dp(76),
    flexDirection: 'row',
    alignItems: 'center',
    borderBottomWidth: px2dp(1),
    borderBottomColor: '#E5E5E5'
  },
  infoLeft: {
    width: px2dp(198),
    fontSize: px2dp(28),
    color: '#666',
    flex: 0
  },
  infoRight: {
    fontSize: px2dp(28),
    color: '#333',
    flex: 1
  },
  tags: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    paddingTop: px2dp(24),
    paddingBottom: px2dp(24)
  },
  tagItem: {
    height: px2dp(40),
    paddingLeft: px2dp(14),
    paddingRight: px2dp(14),
    marginTop: px2dp(6),
    marginRight: px2dp(12),
    marginBottom: px2dp(6),
    borderWidth: px2dp(1),
    borderRadius: px2dp(6),
    borderColor: '#BBB',
    justifyContent: 'center'
  },
  introBox: {
    height: 'auto',
    overflow: 'hidden'
  },
  introHeader: {
    color: '#333',
    fontSize: px2dp(32),
    lineHeight: px2dp(92),
    fontWeight: '600'
  },
  introText: {
    fontSize: px2dp(28),
    lineHeight: px2dp(46),
    color: '#333'
  },
  introImage: {
    alignSelf: 'stretch',
    marginTop: px2dp(20),
    marginBottom: px2dp(20),
  },
  imgDesc: {
    flex: 1,
    fontSize: px2dp(24),
    color: '#999999',
    lineHeight: px2dp(34),
    marginTop: px2dp(-7),
    textAlign: 'center',
    marginBottom: px2dp(20),
  },
  showHideBtn: {
    width: px2dp(690),
    height: px2dp(84),
    position: 'absolute',
    left: 0,
    bottom: 0,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    borderTopWidth: px2dp(1),
    borderTopColor: '#E5E5E5',
    backgroundColor: '#fff'
  },
  otherBox: {
    alignItems: 'stretch'
  },
  joinBox: {
    paddingTop: px2dp(20),
    paddingLeft: px2dp(30),
    paddingRight: px2dp(30)
  },
  joinBoxHeader: {
    height: px2dp(112),
    justifyContent: 'center'
  },
  joinBoxContent: {
    flexDirection: 'row'
  },
  dynamicBox: {
    paddingTop: px2dp(20),
    paddingLeft: px2dp(30),
    paddingRight: px2dp(30)
  },
  dynamicBoxHeader: {
    height: px2dp(112),
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    borderBottomWidth: px2dp(1),
    borderBottomColor: '#E5E5E5'
  },
  dynamicBoxImages: {
    flexDirection: 'row',
    paddingLeft: px2dp(5),
    paddingTop: px2dp(20),
    paddingBottom: px2dp(20),
    borderBottomWidth: px2dp(1),
    borderColor: '#E5E5E5',
  },
  circleBox: {
    paddingTop: px2dp(43),
    paddingRight: px2dp(30),
    paddingLeft: px2dp(30)
  },
  circleInfo: {
    flexDirection: 'row'
  },
  circleAvatar: {
    width: px2dp(116),
    height: px2dp(116),
    marginTop: px2dp(17),
    marginRight: px2dp(30),
    alignItems: 'stretch',
    borderRadius: 0,
    borderWidth: 0
  },
  circleText: {
    flex: 1
  },
  circleButton: {
    width: px2dp(360),
    height: px2dp(68),
    borderWidth: px2dp(1),
    borderColor: '#1EB0FD',
    borderRadius: px2dp(6),
    marginTop: px2dp(53),
    alignSelf: 'center',
    justifyContent: 'center',
    alignItems: 'center'
  },
  circleButtonText: {
    fontSize: px2dp(28),
    color: '#1EB0FD'
  },
  fixedButtons: {
    width: px2dp(750),
    ...ifIphoneX(
      {
        height: px2dp(144)
      },
      {
        height: px2dp(100)
      }
    ),
    backgroundColor: '#fff',
    flexDirection: 'row',
    position: 'absolute',
    left: 0,
    bottom: 0
  }
})
