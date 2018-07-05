import React from "react";
import {
  ScrollView,
  View,
  Text,
  Image,
  StyleSheet,
  Linking,
  Animated,
  Platform,
  StatusBar,
  TouchableWithoutFeedback,
  TouchableOpacity
} from 'react-native';
import px2dp from '../lib/px2dp'
import { ifIphoneX, getStatusBarHeight, isIphoneX } from 'react-native-iphone-x-helper'
import Iconfont from '../components/cxicon/CXIcon';
import ActionSheet from 'react-native-actionsheet' // RN官方提供ios的ActionSheet，此处引入双平台的ActionSheet(ios/android)
import Button from 'apsl-react-native-button' // 第三方button库，RN官方的库会根据平台不同区别，这里统一
import Toast from '../components/Toast'
import GoNativeModule from '../modules/GoNativeModule'
import SwipBackModule from '../modules/SwipBackModule';
import LoadingView from '../components/LoadingView' // _todo ios未封装loadingView
import HeadNav from '../components/HeadNav'
import RoundBorderView from '../components/RoundBorderView'
import UtilsModule from '../modules/UtilsModule'



export default class ActivityDetail extends React.Component {  // 什么参数都不传，则默认是绑定手机都页面，传入isRebind为true时表示新绑手机，界面稍有差异
  constructor(props) {
    super(props)
    this.lastY = 0
    this.state = {
      isOpen: false,
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
        circle: null,
        latitude: '',
        longitude: '',
        address_text: '',
        joinedTotal: '',
        shareUrl: '',
        share_content: ''
      }
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
      }
    }
  }
  onJumpPublishArticleDynamic = (id, name, actid) => {
    GoNativeModule && GoNativeModule.goPublishArticleDynamic(id, name, actid)
  }
  onJumpPublishDynamic = (id, name, actid) => {
    GoNativeModule && GoNativeModule.goPublishDynamic(id, name, actid)
  }
  onJumpActivityMap = (destName, longtitude, latitude) => {
    GoNativeModule && GoNativeModule.goActivityMap(destName, longtitude, latitude)
  }
  onJumpActivityShow = (id, name, actid) => {
    GoNativeModule && GoNativeModule.goActivityShow(id, name, actid)
  }
  onJumpActivityOrder = (id) => {
    GoNativeModule && GoNativeModule.goActivityOrder(id)
  }
  onJumpCircleDetail = (id, name, coverUrl, hasActivity) => {
    GoNativeModule && GoNativeModule.goCircleDetail(id, name, coverUrl, hasActivity ? "1" : "0")
  }
  onJumpActivityJoiners = (id) => {
    StatusBar.setBarStyle('dark-content')
    this.props.navigation.navigate('ActivityJoiners', { id: id })
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
        StatusBar.setBarStyle('dark-content')
      } else {
        StatusBar.setBarStyle('light-content')
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
  introBoxLayout = (event) => {
    let { initialHeight, maxHeight, animationHeight, iconRotate } = this.state
    if (initialHeight && maxHeight && animationHeight && iconRotate) {
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
  publish = async () => {
    let { status } = this.state.activity
    if (status.toString() !== '1') { // 活动未上线
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
    _FetchData(_Api + '/jv/qz/v21/activity', rData).then(res => {
      let _tags = []
      if (!res.data.refund) {
        _tags.push('不可退票')
      }
      if (res.data.insurance) {
        _tags.push('费用中包含保险')
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
        content: res.data.content.filter(item => item.type.toString() !== '0').map(item => {
          return {
            type: item.type,
            content: item.type.toString() === '1' ? item.content : {
              image: item.imageUrl,
              description: item.des
            },
            width: item.width,
            height: item.height
          }
        }),
        circle: res.data.circle,
        status: res.data.status
      }
      this.setState({
        activity: _obj
      })
      this.props.navigation.setParams({ 'activity': _obj })
      StatusBar.setBarStyle('light-content')
      if (Platform.OS === 'android') {
        StatusBar.setTranslucent(true)
      }
    }).catch(err => {
      console.log('获取活动数据失败', err)
    })
  }
  componentDidMount() {
    this.fetchActivity()
  }
  componentWillUnmount() {
    StatusBar.setBarStyle('dark-content')
    if (Platform.OS === 'android') {
      StatusBar.setTranslucent(true)
    }
  }
  share = () => {
    let activity = this.props.navigation.state.params.activity
    let { status } = this.state.activity
    if (!status) { // 未拉取到数据时操作无效
      return false
    }
    if (status.toString() !== '1') { // 活动未上线
      Toast.show('活动未上线，还不能操作哦~')
      return false
    }
    GoNativeModule && GoNativeModule.shareActivity(activity.bannerUrl,
      activity.title,
      activity.share_content,
      activity.shareUrl)
  }
  render() {
    let { id, bannerUrl, title, joinedTotal, from, sponsorName, sponsorPhone, address, location, date, cost, deadline_text, tags, join, activityImages, activityImageLength, statusText, content, circle } = this.state.activity
    let { initialHeight, maxHeight, animationHeight, iconRotate } = this.state
    return <View style={styles.page}>
      {
        this.state.activity.id == '' ?
          <LoadingView style={{ height: px2dp(500), marginTop: Platform.OS === 'android' ? px2dp(90) + 25 : px2dp(90) }} /> :
          <View style={styles.page}>
            <HeadNav
              ref={(component) => this._headNav = component}
              navigation={this.props.navigation}
              title={'活动详情'}
              headerRight={(rgb) => {
                return <TouchableWithoutFeedback disabled={false} onPress={() => { this.share() }}>
                  <View style={{ height: px2dp(90), paddingLeft: px2dp(20), paddingRight: px2dp(30), justifyContent: 'center' }}>
                    <Iconfont name="share" size={px2dp(36)} color={rgb} />
                  </View>
                </TouchableWithoutFeedback>
              }}
            />
            <ScrollView style={styles.scrollView} onScroll={this.handleScroll} bounces={false} scrollEventThrottle={15}>
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
                      <Text style={[styles.infoRight, { color: '#FF3F53' }]} numberOfLines={1}>{cost.toString() === '0' ? '免费' : '¥' + cost}</Text>
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
                  {(content && content.length > 0) ? <Animated.View ref={el => this.animateElement = el} style={[styles.introBox, { height: animationHeight ? animationHeight : 'auto' }]} onLayout={this.introBoxLayout}>
                    <Text style={styles.introHeader}>活动介绍</Text>
                    {content.map((item, idx) => {
                      if (item.type.toString() === '1') { // 文本
                        return <Text key={idx} style={styles.introText}>{item.content}</Text>
                      } else if (item.type.toString() === '2') { // 图片
                        return <Image key={idx} source={{ uri: item.content.image }} style={[styles.introImage, { height: px2dp((item.height / item.width) * 690 || 388) }]} resizeMode={'cover'} />
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
                        {join.map((item, idx) => <Image key={idx} source={{ uri: item.avatar }} style={{ width: px2dp(42), height: px2dp(42), marginLeft: idx === 0 ? 0 : px2dp(30) }} />)}
                      </View>
                    </TouchableOpacity>
                  </View> : null}
                  <View style={styles.dynamicBox}>
                    <View style={styles.dynamicBoxHeader}>
                      <Text style={{ fontSize: px2dp(32), color: '#333', fontWeight: '600' }}>大家都在晒</Text>
                      {activityImageLength ?
                        <TouchableOpacity onPress={() => this.onJumpActivityShow(circle.id, circle.name, id)} activeOpacity={0.8}>
                          <View style={{ height: px2dp(112), flexDirection: 'row', alignItems: 'center' }}>
                            <Text style={{ color: '#333', fontSize: px2dp(28) }}>更多</Text>
                            <Iconfont name="next" size={px2dp(18)} color="#666666" style={{ marginLeft: px2dp(4) }} />
                          </View>
                        </TouchableOpacity> : null
                      }
                    </View>
                    {activityImageLength ? <View style={styles.dynamicBoxImages}>
                      {activityImages.slice(0, 3).map((item, idx) =>
                        <TouchableOpacity onPress={() => this.onJumpActivityShow(circle.id, circle.name, id)} activeOpacity={0.8}>
                          <Image key={idx} source={{ uri: item.compress }} style={{ width: px2dp(155), height: px2dp(155), marginRight: px2dp(20) }} />
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
                    <Button style={styles.circleButton} textStyle={styles.circleButtonText} onPress={() => this.onJumpCircleDetail(circle.id, circle.name, circle.cover.compress, circle.circle_has_activity)} activeOpacity={1}>进入圈子参与该活动讨论</Button>
                  </View> : null}
                </View>
              </View>
            </ScrollView>
            <View style={styles.fixedButtons}>
              <Button style={{ flex: 1, height: px2dp(100), borderRadius: 0, borderWidth: px2dp(1), borderColor: '#E5E5E5', backgroundColor: '#fff' }} textStyle={{ fontSize: px2dp(30), color: '#333' }} activeOpacity={0.8} onPress={this.publish}>晒图</Button>
              <Button style={{ flex: 1, height: px2dp(100), borderRadius: 0, borderWidth: px2dp(1), borderColor: statusText === '购票' ? '#FF3F53' : '#BBBBBB', backgroundColor: '#FF3F53' }} disabledStyle={{ backgroundColor: '#BBBBBB' }} textStyle={{ fontSize: px2dp(30), color: '#fff', fontWeight: '600' }} activeOpacity={0.8} isDisabled={statusText !== '购票'}
                onPress={() => this.onJumpActivityOrder(id)} >{statusText}</Button>
            </View>
          </View>

      }
      <ActionSheet
        ref={el => this.ActionSheet = el}
        options={[<Text style={{ color: '#333333', fontSize: px2dp(34) }}>动态</Text>,
        <Text style={{ color: '#333333', fontSize: px2dp(34) }}>长文</Text>,
        <Text style={{ color: '#333333', fontSize: px2dp(34) }}>取消</Text>]}
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
              this.onJumpPublishDynamic(this.state.activity.circle.id, this.state.activity.circle.name, this.state.activity.id)
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
    flexDirection: 'row',
    height: px2dp(44)
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
    borderColor: '#1EB0FD',
    borderRadius: px2dp(6),
    marginTop: px2dp(53),
    alignSelf: 'center'
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
