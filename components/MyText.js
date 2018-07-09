import React, {Component} from 'react';
import {Text} from 'react-native';

class MyText extends Component {
  render() {
    return <Text adjustsFontSizeToFit={true} allowFontScaling={false} {...this.props} />;
  }
};

export default MyText;