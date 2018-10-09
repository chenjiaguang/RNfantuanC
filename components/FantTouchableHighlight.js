import React, { Component } from 'react';
import { Text,Platform, TouchableHighlight,TouchableNativeFeedback } from 'react-native';
class FantTouchableHighlight extends Component {
  render() {
    return Platform.OS === 'android' ?
    <TouchableNativeFeedback {...this.props}>
    </TouchableNativeFeedback>:
    <TouchableHighlight {...this.props}
      delayPressIn={0}
      delayPressOut={300}
      underlayColor={'#f1f1f1'} >
      </TouchableHighlight>;
  }
};

export default FantTouchableHighlight;