import React from "react";
import {
  StyleSheet,
  WebView
} from 'react-native';
import px2dp from '../lib/px2dp'
import { ifIphoneX } from 'react-native-iphone-x-helper'
// 申请头条首页

export default class WebPage extends React.Component {
  constructor (props) {
    super(props)
    this.state = {
      uri: this.props.navigation.state.params.url
    }
  }
  static navigationOptions = ({ navigation }) => {
    return {
      title: navigation.getParam && navigation.getParam('title') || ''
    }
  };
  onShouldStartLoadWithRequest = (event) => {
    // Implement any custom loading logic here, don't forget to return!
    return true;
  };
  onNavigationStateChange = (navState) => {
    this.setState({
      backButtonEnabled: navState.canGoBack,
      forwardButtonEnabled: navState.canGoForward,
      url: navState.url,
      status: navState.title,
      loading: navState.loading,
      scalesPageToFit: true
    });
  };
  render() {
    let {uri} = this.state
    return <WebView
      ref={el => this.webView = el}
      automaticallyAdjustContentInsets={false}
      style={style.webView}
      source={{uri: uri}}
      javaScriptEnabled={true}
      decelerationRate="normal"
      startInLoadingState={false}
      contentInset={{...ifIphoneX({
        bottom: px2dp(44)
      }, {
        bottom: 0
      })}}
    />
  }
}

const style = StyleSheet.create({
  webView: {
    width: px2dp(750),
    flex: 1,
    backgroundColor: '#fff',
    overflow: 'visible'
  }
})
