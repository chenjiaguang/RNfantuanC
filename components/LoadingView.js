

import { requireNativeComponent, View, Platform, Image, Text, StyleSheet, Animated } from 'react-native';
import React, { Component } from "react";
import PropTypes from 'prop-types';
import px2dp from '../lib/px2dp';
// import Text from '../components/MyText'
// 可传入text，更改文字部分，可传入textStyle，更改文字样式，可传入iconstyle，更改icon样式

var iface = {
  name: 'RCTLoadingView',
  propTypes: {
    ...View.propTypes // 包含默认的View的属性
  },
};
class LoadingView extends Component {
  constructor(props) {
    super(props)
    this.state = {
      rotate: 0
    }
  }
  componentDidMount() {
    let duration = 1000 / 12
    this.timer = setInterval(() => {
      let rotate = (this.state.rotate + 30) % 360
      this.setState({
        rotate: rotate
      });
    }, duration)
  }
  componentWillUnmount() {
    clearInterval(this.timer)
  }
  render() {
    let {rotate} = this.state
    return <View {...this.props}
      style={[this.props.style, { justifyContent: 'center', flexDirection: 'row' }]}>
      <Image
        style={[styles.image, {transform: [{ rotateZ: rotate + 'deg' }]}, this.props.iconStyle]}
        source={require('../static/image/rn_loading_01.png')} />
      <Text style={[styles.text, this.props.textStyle]}>{this.props.text || '加载中...'}</Text>
    </View>;
  }
};


const styles = StyleSheet.create({
  image: Platform.OS == 'ios' ? {
    width: px2dp(32),
    height: px2dp(32)
  } :
    {
      width: 16,
      height: 16,
      marginRight: 5
    },
  text: Platform.OS == 'ios' ? {
    fontSize: px2dp(24),
    color: '#333',
    marginLeft: px2dp(12)
  } : {
      fontSize: 12,
      color: '#333',
      marginLeft: px2dp(12)
    },
})

module.exports = LoadingView;