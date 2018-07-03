import React from "react";
import {
  ScrollView,
  View,
  Text,
  StyleSheet
} from 'react-native';
import Iconfont from "../components/cxicon/CXIcon";
import px2dp from '../lib/px2dp'
import { ifIphoneX } from 'react-native-iphone-x-helper'
import Button from 'apsl-react-native-button'
import commonStyle from "../static/commonStyle"; // 第三方button库，RN官方的库会根据平台不同区别，这里统一
import SwipBackModule from '../modules/SwipBackModule'
// 提交头条申请成功页面

export default class HeadlineSubmitted extends React.Component {
  constructor (props) {
    super(props)
    this.state = {}
  }
  static navigationOptions = {
    headerLeft: <View></View>,
    title: '申请成功'
  };
  complete = () => {
    // 点击完成需要的操作,关闭rn页面,回到原生
    SwipBackModule && SwipBackModule.exit()
  }
  render() {
    return <ScrollView style={style.scrollView}>
      <View style={style.contentWrapper}>
        <Iconfont name='success' size={px2dp(190)} color='#2DCC70' style={style.icon}></Iconfont>
        <Text style={style.successHead}>申请成功！</Text>
        <Text style={style.tip}>您可以在电脑上进入（http://toutiao.fantuanlife.com），用此账号登录范团头条作者后台即可。</Text>
        <Button style={style.button} textStyle={style.buttonText} onPress={this.complete} activeOpacity={0.8}>完成</Button>
      </View>
    </ScrollView>
  }
}

const style = StyleSheet.create({
  scrollView: {
    flex: 1,
    backgroundColor: '#fff'
  },
  contentWrapper: {
    alignItems: 'center',
    ...ifIphoneX({
      paddingBottom: px2dp(124)
    }, {
      paddingBottom: px2dp(80)
    })
  },
  icon: {
    marginTop:px2dp(120),
  },
  successHead: {
    fontSize: px2dp(36),
    lineHeight: px2dp(50),
    color: commonStyle.color.text.para_primary,
    marginTop: px2dp(40)
  },
  tip: {
    fontSize: px2dp(28),
    lineHeight: px2dp(40),
    color: commonStyle.color.text.para_primary,
    marginTop: px2dp(50),
    marginLeft: commonStyle.page.left,
    marginRight: commonStyle.page.right
  },
  button: {
    width:px2dp(690),
    height:px2dp(90),
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#1EB0FD',
    marginTop: px2dp(130),
    alignSelf: 'center',
    borderRadius: px2dp(6),
    borderWidth: 0
  },
  buttonText: {
    fontSize: px2dp(34),
    color: '#fff'
  }
})
