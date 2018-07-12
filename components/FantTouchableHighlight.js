import React, { Component } from 'react';
import { Text, TouchableHighlight } from 'react-native';
class FantTouchableHighlight extends Component {
  render() {
    return <TouchableHighlight {...this.props}
      delayPressIn={0}
      delayPressOut={300}
      underlayColor={'#f1f1f1'} >
      </TouchableHighlight>;
  }
};

export default FantTouchableHighlight;