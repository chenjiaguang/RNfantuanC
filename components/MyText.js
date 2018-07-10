import React, {Component} from 'react';
import {Text} from 'react-native';

class MyText extends Component {
  render() {
    return <Text adjustsFontSizeToFit={false} allowFontScaling={false} {...this.props} />;
  }
};

export default MyText;