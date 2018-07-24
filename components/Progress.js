import React, { Component } from "react";
import {
    View,
    StyleSheet,
    LayoutAnimation,
    Animated
} from 'react-native';
import px2dp from '../lib/px2dp'
import LinearGradient from 'react-native-linear-gradient'
import Toast from  './Toast'


class Progress extends Component {
    constructor(props) {
      super(props)
      this.state = {
        fontGround: 0,
        width: props.width || px2dp(600),
        height: props.height || px2dp(10),
        colors: props.colors || ['#40D8FF', '#1EB0FD'],
        ratioWidth: new Animated.Value(0)
      }
    }
    componentWillReceiveProps (nextProps) {
      if (nextProps.percent !== this.props.percent) {
        LayoutAnimation.easeInEaseOut(); //每次组件更新前，执行LayoutAnimation动画
        let nextWidth = this.state.width * nextProps.percent
        Animated.timing(
          this.state.ratioWidth,
          {
            toValue: nextWidth,
            duration: 500
          }
        ).start()
      }
    }
    render() {
      let {width, height, colors, ratioWidth} = this.state
      let {style, percent} = this.props
      return <View style={[styles.wrapper, {width, height}, style]}>
        <Animated.View style={{width: ratioWidth, height, overflow: 'hidden', flex: 0, backgroundColor: 'transparent'}}>
          <LinearGradient style={{width, height}} start={{x: 0, y: 0.5}} end={{x: 1, y: 0.5}} colors={colors}></LinearGradient>
        </Animated.View>
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