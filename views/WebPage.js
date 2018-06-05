import React from "react";
import {
  ScrollView,
  TouchableOpacity,
  View,
  Image,
  Text,
  StyleSheet,
  WebView
} from 'react-native';
import Iconfont from "../components/cxicon/CXIcon";
import px2dp from '../lib/px2dp'
import { ifIphoneX } from 'react-native-iphone-x-helper'
import AutoHeightWebView from 'react-native-autoheight-webview'
const bg = require('../static/image/apply_banner.png')
// 申请头条首页

export default class HeadlineIndex extends React.Component {
  constructor (props) {
    super(props)
    this.state = {}
  }
  static navigationOptions = ({ navigation }) => {
    return {
      title: navigation.getParam && navigation.getParam('title') || ''
    }
  };
  componentWillMount () {
    let {params} = this.props.navigation.state
    this.setState({
      uri: params.url
    })
  }
  render() {
    let {uri} = this.state
    return uri && <WebView
      ref="webView"
      automaticallyAdjustContentInsets={false}
      style={style.webView}
      source={{uri: uri}}
      javaScriptEnabled={true}
      domStorageEnabled={true}
      decelerationRate="normal"
      startInLoadingState={true}
      // onNavigationStateChange={this.onNavigationStateChange}
      // onShouldStartLoadWithRequest={this.onShouldStartLoadWithRequest}
      // scalesPageToFit={this.state.scalesPageToFit}
    />
  }
}

const style = StyleSheet.create({
  webView: {
    width: px2dp(750),
    flex: 1,
    backgroundColor: '#fff',
    ...ifIphoneX({
      marginBottom: px2dp(68)
    }, {
      marginBottom: 0
    }),
    overflow: 'visible'
  },
  bg: {
    width:px2dp(750),
    height:px2dp(540),
    position: 'absolute',
    left:0,
    top:0
  },
  contentWrapper: {
    ...ifIphoneX({
      paddingBottom: px2dp(124)
    }, {
      paddingBottom: px2dp(80)
    })
  },
  articleBody: {
    width:px2dp(690),
    paddingTop: px2dp(35),
    alignSelf: 'center',
    marginTop: px2dp(255),
    backgroundColor: '#fff',
    borderRadius: px2dp(11),
    shadowColor: '#646464',
    shadowOffset: {width: 0, height: px2dp(2)},
    shadowOpacity: 0.36,
    shadowRadius: px2dp(30),
    elevation: px2dp(3), // android上的阴影,此值为阴影的偏移
  },
  paragraph: {
    marginLeft:px2dp(30),
    marginRight:px2dp(30),
    flexDirection:'row',
  },
  icon: {
    marginRight:px2dp(20),
  },
  textWrapper: {
    flex:1
  },
  header: {
    fontSize: px2dp(34),
    lineHeight: px2dp(44),
    color: '#333',
    paddingBottom: px2dp(10),
    fontWeight: '600'
  },
  content: {
    fontSize: px2dp(28),
    lineHeight: px2dp(38),
    color: '#666',
    paddingBottom: px2dp(35)
  },
  button: {
    width:px2dp(690),
    height:px2dp(90),
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#1EB0FD',
    marginTop: px2dp(40),
    alignSelf: 'center',
    borderRadius: px2dp(6),
  },
  buttonText: {
    fontSize: px2dp(34),
    color: '#fff'
  }
})
