import React, { Component } from "react";
import {
    View,
    StyleSheet,
    Platform,
    TouchableWithoutFeedback
} from 'react-native';
import px2dp from '../lib/px2dp'
import Iconfont from '../components/cxicon/CXIcon';
import { getStatusBarHeight } from 'react-native-iphone-x-helper'
import commonStyle from '../static/commonStyle'
import Text from '../components/MyText'
import LinearGradient from 'react-native-linear-gradient'


class Progress extends Component {
    constructor(props) {
        super(props)
        this.state = {
           percent: 0.5,
           width: props.width || px2dp(600),
           height: props.height || px2dp(10),
           colors: props.colors || ['#40D8FF', '#1EB0FD']
        }
    }
    render() {
      let {percent, width, height, colors} = this.state
      let {style} = this.props
      return <View style={[styles.wrapper, {width, height}, style]}>
        <View style={[{width: width * percent, height, overflow: 'hidden'}]}>
          <LinearGradient style={{width, height}} start={{x: 0, y: 0.5}} end={{x: 1, y: 0.5}} colors={colors}></LinearGradient>
        </View>
      </View>
    }
};


const styles = StyleSheet.create({
  wrapper: {
    borderRadius: px2dp(10),
    backgroundColor: '#EAEDF4',
    overflow: 'hidden'
  }
})

export default Progress;