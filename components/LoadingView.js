

import { requireNativeComponent, View, Platform, Image, Text, StyleSheet, Animated } from 'react-native';
import React, { Component } from "react";
import PropTypes from 'prop-types';
import px2dp from '../lib/px2dp';
// import Text from '../components/MyText'

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
    console.log('render', this.state.rotate)
    return <View {...this.props}
      style={[this.props.style, { paddingTop: px2dp(32), justifyContent: 'center', flexDirection: 'row' }]}>
      <Image
        style={[styles.image, {transform: [{ rotateZ: rotate + 'deg' }]}]}
        source={require('../static/image/rn_loading_01.png')} />
      <Text style={styles.text}>正在加载...</Text>
    </View>;
  }
};


const styles = StyleSheet.create({
  image: Platform.OS == 'ios' ? {
    width: px2dp(32),
    height: px2dp(32),
    marginRight: px2dp(10)
  } :
    {
      width: 16,
      height: 16,
      marginRight: 5
    },
  text: Platform.OS == 'ios' ? {
    fontSize: px2dp(24)
  } : {
      fontSize: 12
    },
})

module.exports = LoadingView;