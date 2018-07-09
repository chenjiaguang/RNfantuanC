import { View, Dimensions, CameraRoll, Platform, Animated } from 'react-native';
import React, { Component } from "react";
import px2dp from '../lib/px2dp';
import ImageViewer from 'react-native-image-zoom-viewer';
import Iconfont from '../components/cxicon/CXIcon';
import ActionSheet from 'react-native-actionsheet' // RN官方提供ios的ActionSheet，此处引入双平台的ActionSheet(ios/android)
import Toast from '../components/Toast'
import SwipBackModule from '../modules/SwipBackModule';
import Text from '../components/MyText'

export default class ImageBrowser extends React.Component {
  constructor(props) {
      super(props)
      this.state = {
        ActionSheetOptions: Platform.OS === 'android' ? [<Text style={{ color: '#333333', fontSize: px2dp(34) }}>保存图片</Text>,
        <Text style={{ color: '#333333', fontSize: px2dp(34) }}>取消</Text>] : ['保存图片', '取消'],
        index: this.props.index || 0,
        show: false,
        scaleX: new Animated.Value(0.8),
        scaleY: new Animated.Value(0.8)
      }
  }
  show = (idx) => {
    this.setState({
        index: idx || 0,
        show: true
    }, () => {
        let {scaleX, scaleY, page} = this.state
        Animated.parallel([
            Animated.timing(scaleX, {
                toValue: 1,
                duration: 300
            }),
            Animated.timing(scaleY, {
                toValue: 1,
                duration: 300
            })
        ]).start();
        if (page) {
            page.props.navigation.setParams({gesturesEnabled: false, stopBack: true})
        }
    })
  }
  hide = () => {
    this.setState({
        show: false
    }, () => {
        if (page) {
            page.props.navigation.setParams({gesturesEnabled: false, stopBack: true})
        }
        let {scaleX, scaleY, page} = this.state
        Animated.parallel([
            Animated.timing(scaleX, {
                toValue: 0.8,
                duration: 0
            }),
            Animated.timing(scaleY, {
                toValue: 0.8,
                duration: 0
            })
        ]).start()
    })
  }
  componentWillUnmount () {
    let {page} = this.props;
    if (page) {
        page.props.navigation.setParams({gesturesEnabled: true, stopBack: false})
    }
  }
  showActionSheet = (image) => {
    this.setState({
        saveUrl: image.url
    }, () => {
        this.ActionSheetInstance.show()
    })
  }
  renderIndicator = (current, total) => {
    return <View style={{flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', position: 'absolute', left: 0, top: px2dp(54), width: px2dp(750), height: px2dp(60)}}>
      <Iconfont onPress={this.hide} name="close" size={px2dp(30)} style={{marginLeft: px2dp(40), paddingLeft: px2dp(15), paddingTop: px2dp(15), paddingRight: px2dp(15), paddingBottom: px2dp(15)}} color="#fff" />
      <Text style={{color: '#fff', fontSize: px2dp(34)}}>{current + '/' + total}</Text>
      <View style={{width: px2dp(60), height: px2dp(60), marginRight: px2dp(40)}}></View>
    </View>
  }
  render() {
      let {images} = this.props
      let {index, show, scaleX, scaleY} = this.state
      return show ? <Animated.View style={{transform: [{scaleX: scaleX}, {scaleY: scaleY}], position: 'absolute', width: Dimensions.get('window').width, height: Dimensions.get('window').height, left: 0, top: 0, zIndex: 99999}}>
      <ImageViewer onLongPress={this.showActionSheet} saveToLocalByLongPress={false} renderIndicator={this.renderIndicator} index={index} imageUrls={images} enableSwipeDown={true} onSwipeDown={this.hide} />
      <ActionSheet
        ref={el => this.ActionSheetInstance = el}
        options={this.state.ActionSheetOptions}
        cancelButtonIndex={1}
        styles={{
          color: '#333333',
          titleText: {
            color: '#333333'
          }
        }}
        onPress={(index) => {
          switch (index) {
            case 0: // 保存图片
              let Promise = CameraRoll.saveToCameraRoll(this.state.saveUrl)
              Promise.then(res => {
                Toast.show('已保存到手机相册')
              }).catch(err => {
                Toast.show('保存图片失败')
              })
              break;
            default:
            // do nothing
          }
        }}
      />
    </Animated.View> : null
  }
}