import React from "react";
import {
  View,
  StyleSheet,
  Animated
} from 'react-native';
import px2dp from '../../lib/px2dp'
import Text from '../../components/MyText'
import Iconfont from "../../components/cxicon/CXIcon"; // 自定义iconfont字体文字，基于"react-native-vector-icons"

// notice[Array], 通知的文字

export default class NoticeSwiper extends React.Component {  // 什么参数都不传，则默认是绑定手机都页面，传入isRebind为true时表示新绑手机，界面稍有差异
  constructor (props) {
    super(props)
    let notice = []
    if (props.notice.length > 1) {
      notice = props.notice.concat(props.notice[0])
    } else {
      notice = props.notice
    }
    this.state = {
      notice: notice,
      animationY: new Animated.Value(0)
    }
  }
  componentWillReceiveProps (nextProps) {
    if (this.props.notice !== nextProps.notice) {
      let notice = []
      if (nextProps.notice.length > 1) {
        notice = nextProps.notice.concat(nextProps.notice[0])
      } else {
        notice = nextProps.notice
      }
      this.setState({
        notice: notice
      })
    }
  }
  startAnimation = (event) => {
    let {notice} = this.state
    if (notice.length < 2) {
      return false
    }
    let scrollHeight = event.nativeEvent.layout.height
    let {animationY} = this.state
    let minY = -((notice.length - 1) / notice.length) * scrollHeight
    let step = -(1 / notice.length) * scrollHeight
    const timeFunc = () => {
      if (this.timer) {
        clearTimeout(this.timer)
      }
      if (animationY._value <= minY) {
        animationY.setValue(0)
      }
      let positionY = animationY._value + step
      Animated.timing(
        animationY,
        {
          toValue: positionY,
          duration: 300
        }
      ).start(() => {
        let {animationY} = this.state
        if (animationY._value <= minY) {
          animationY.setValue(0)
        }
        setTimeout(timeFunc, 3000)
      })
    }
    this.timer = setTimeout(timeFunc, 3000)
  }
  componentWillUnmount () {
    if (this.timer) {
      clearTimeout(this.timer)
    }
  }
  render() {
    let {notice, animationY} = this.state
    return notice && notice.length > 0 ? <View style={[styles.noticeWrapper, {height: px2dp(100)}]}>
      <Iconfont name="notice" color="#333" size={px2dp(30)} style={{marginRight: px2dp(15)}} />
      <Animated.View onLayout={this.startAnimation} ref={(e) => this.scroller = e} style={[styles.noticeBody, {transform: [{translateY: animationY}]}]}>
        {notice.map((item, idx) => <View style={[styles.noticeItem, {height: px2dp(100)}]} key={idx}>
          <Text style={styles.noticeText}>{item}</Text>
        </View>)}
      </Animated.View>
    </View> : null
  }
}

const styles = StyleSheet.create({
  noticeWrapper: {
    flexDirection: 'row',
    borderBottomWidth: px2dp(1),
    borderBottomColor: '#E5E5E5',
    marginLeft: px2dp(30),
    marginRight: px2dp(30),
    paddingLeft: px2dp(5),
    alignItems: 'center',
    overflow: 'hidden'
  },
  noticeBody: {
    position: 'absolute',
    top: 0,
    left: px2dp(50)
  },
  noticeItem: {
    flexDirection: 'row',
    alignItems: 'center'
  },
  noticeText: {
    fontSize: px2dp(24),
    color: '#333'
  }
})
