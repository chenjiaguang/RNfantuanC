import React, { Component } from 'react'
import { View, StyleSheet, Image, ListView, Animated, Easing } from 'react-native'
import Text from './MyText'
import Toast from './Toast'
import px2dp from '../lib/px2dp';
import LoadingView from '../components/LoadingView';
const refreshIcon = require('../static/image/rn_refresh_icon.png')
const refreshingIcon = require('../static/image/rn_refreshing_icon.png')
var ds = new ListView.DataSource({rowHasChanged: (r1, r2) => r1 !== r2}) // assumes immutable objects

import {PullListView, PullFlatList} from 'react-native-rk-pull-to-refresh'

class CustomFlatList extends Component {
  constructor(props) {
    super(props)
    this.state = {
      refreshing: false,
      dataList: [],
      rotate: new Animated.Value(0)
    }
  }

  componentDidMount() {
    this.pull && this.pull.startRefresh()
  }

  onPullRelease = () => {
    let {refreshing} = this.state
    if (refreshing) {
      return false
    }
    let rData = {
      token: 'lcaKiq5GIC_FHqubOBcI6FUKaL8N171U',
      pn: 1
    }
    this.setState({
      refreshing: true
    })
    this.ref_refresh_icon && this.ref_refresh_icon.setNativeProps({opacity: 0})
    this.ref_refreshing_icon && this.ref_refreshing_icon.setNativeProps({opacity: 1})
    let time = new Date().getTime()
    _FetchData(_Api + '/jv/qz/v21/activity/myjoined', rData).then(res => {
      let leftTime = 1000 - (new Date().getTime() - time)
      if (leftTime > 0) { // 如果1秒内返回结果，则继续显示加载图标，直到满1秒后才隐藏加载图标，否则立即隐藏加载图标
        this.timer = setTimeout(() => {
          this.setState({
            refreshing: false
          })
          this.ref_refresh_icon && this.ref_refresh_icon.setNativeProps({opacity: 1})
          this.ref_refreshing_icon && this.ref_refreshing_icon.setNativeProps({opacity: 0})
          this.pull.finishRefresh()
        }, leftTime)
      } else {
        this.setState({
          refreshing: false
        })
        this.ref_refresh_icon && this.ref_refresh_icon.setNativeProps({opacity: 1})
        this.ref_refreshing_icon && this.ref_refreshing_icon.setNativeProps({opacity: 0})
        this.pull.finishRefresh()
      }
      if (res && res.msg) {
        Toast.show(res.msg)
      }
      if (res && res.data) {
        this.setState({
          dataList: res.data.list
        })
      }
    }).catch(err => {
      this.setState({
        refreshing: false
      })
      this.ref_refresh_icon && this.ref_refresh_icon.setNativeProps({opacity: 1})
      this.ref_refreshing_icon && this.ref_refreshing_icon.setNativeProps({opacity: 0})
      this.pull.finishRefresh()
    })
  }

  renderItem = ({item}) => {
    return <View>
      <Text>{item.title}</Text>
    </View>
  }

  onPullStateChangeHeight = (pullState, moveHeight) => {
    if (pullState == 'pullrelease') { // 仅在放手且距离超过刷新距离时显示loading
      this.ref_refresh_icon && this.ref_refresh_icon.setNativeProps({opacity: 0})
      this.ref_refreshing_icon && this.ref_refreshing_icon.setNativeProps({opacity: 1})
    } else {
      this.ref_refresh_icon && this.ref_refresh_icon.setNativeProps({opacity: 1})
      this.ref_refreshing_icon && this.ref_refreshing_icon.setNativeProps({opacity: 0})
    }
  }

  topIndicatorRender = () => {
    return <View style={{height: px2dp(100)}}>
      <Image ref={e => this.ref_refresh_icon = e} source={refreshIcon} style={{width: px2dp(44), height: px2dp(44), position: 'absolute', left: (px2dp(750) - px2dp(44)) / 2, bottom: px2dp(26)}} />
      <Animated.Image ref={e => this.ref_refreshing_icon = e} onLoad={this.startAnimation} source={refreshingIcon} style={{width: px2dp(44), height: px2dp(44), position: 'absolute', left: (px2dp(750) - px2dp(44)) / 2, bottom: px2dp(26), transform: [{rotate: this.state.rotate.interpolate({inputRange: [0, 1], outputRange: ['0deg', '360deg']})}]}} />
    </View>
  }

  startAnimation = () => {
    let {rotate} = this.state
    rotate.setValue(0)
    Animated.timing(rotate, {
        toValue: 1,
        duration: 500,
        easing: Easing.linear
    }).start(() => this.startAnimation());
  }

  onPushing = () => {
    console.log('onPushing')
  }

  render() {
    let {dataList, refreshing, rotate} = this.state
    return (
      <View style={styles.container}>
       <PullFlatList
        data={dataList}
        ref={(c) => this.pull = c}
        isContentScroll={true}
        style={{flex: 1, width: px2dp(750)}}
        onPullRelease={this.onPullRelease}
        topIndicatorRender={this.topIndicatorRender}
        // onPullStateChangeHeight={this.onPullStateChangeHeight}
        topIndicatorHeight={px2dp(100)}
        renderItem={this.renderItem}
        keyExtractor={(item, index) => index.toString()}/>
      </View>
    )
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1
  },
  title: {
    fontSize: 18,
    height: 84,
    textAlign: 'center'
  }
})

export default CustomFlatList