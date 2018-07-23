import React, {Component} from 'react';
import {Animated} from 'react-native';
// smooth: 是否平滑显示，true/false[true]

class SmoothImage extends Component {
  constructor (props) {
    super(props)
    this.state = {
      imageOpacity: new Animated.Value(0)
    }
  }
  load = () => {
    let {onLoad} = this.props
    let {imageOpacity} = this.state
    if (onLoad) {
      onLoad()
    }
    Animated.timing(
      imageOpacity,
      {
        toValue: 1,
        duration: 300
      }
    ).start()
  }
  render() {
    let {imageOpacity} = this.state
    let {onLoad, style, smooth, ...other} = this.props
    return <Animated.Image style={[{opacity: smooth === false ? 1 : imageOpacity}, style]} onLoad={this.load} {...other} />;
  }
};

export default SmoothImage;