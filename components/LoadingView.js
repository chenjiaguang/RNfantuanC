

import { requireNativeComponent, View, Text, Platform } from 'react-native';
import React, { Component } from "react";
import PropTypes from 'prop-types';
import px2dp from '../lib/px2dp';

var iface = {
  name: 'RCTLoadingView',
  propTypes: {
    ...View.propTypes // 包含默认的View的属性
  },
};
class LoadingView extends Component {
  constructor(props) {
      super(props)
  }
  render() {
      return <View style={{height: px2dp(500), justifyContent: 'center', alignItems: 'center'}}>
        <Text style={{fontSize: px2dp(30)}}>加载中...</Text>
      </View >;
  }
};



module.exports = Platform.OS === 'android' ? requireNativeComponent('RCTLoadingView', iface) : LoadingView;