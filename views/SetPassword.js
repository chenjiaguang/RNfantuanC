import React from "react";
import {
  ScrollView,
  TouchableOpacity,
  View,
  Image,
  TextInput,
  StyleSheet,
  Platform
} from 'react-native';
import Iconfont from "../components/cxicon/CXIcon";
import commonStyle from '../static/commonStyle' // 公共样式，方便以后换肤，换主题色
import Toast from '../components/Toast'
import px2dp from '../lib/px2dp'
import { ifIphoneX } from 'react-native-iphone-x-helper'
const bg = require('../static/image/rn_apply_banner.png')
import Button from 'apsl-react-native-button' // 第三方button库，RN官方的库会根据平台不同区别，这里统一
import MyTextInput from '../components/MyTextInput' // 封装RN官方的TextInput以处理中文输入问题（RN官方bug）
import GoNativeModule from '../modules/GoNativeModule'
import SwipBackModule from '../modules/SwipBackModule'
import Text from '../components/MyText'
// 申请头条首页

export default class SetPassword extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      password: '',
      hide: false,
      submitting: false
    }
  }
  static navigationOptions = {
    title: '设置新密码'
  };
  confirm = () => {
    let { password, submitting } = this.state
    if (!password || password.length < 6 || password.length > 24) {
      Toast.show('请输入6-24个字符')
      return false
    }
    if (submitting) {
      Toast.show('正在提交，请稍后...')
      return false
    }
    let rData = {
      password: password
    }
    this.setState({
      submitting: true
    })
    _FetchData(_Api + '/jv/user/password/create', rData).then(res => {
      this.setState({
        submitting: false
      })
      if (res && Boolean(res.error) && res.msg) {
        Toast.show(res.msg)
        return false
      } else if (res && !Boolean(res.error)) {
        this.confirmComplete()
      }
    }).catch(err => {
      console.log('设置密码出错', err)
      this.setState({
        submitting: false
      })
    })
  }
  confirmComplete = () => {
    // 完成验证，设置密码成功，关闭rn页面
    if (Platform.OS === 'ios') { // ios
      GoNativeModule && GoNativeModule.goReLogin()
      SwipBackModule && SwipBackModule.exit()
    } else { // android 
      GoNativeModule && GoNativeModule.goReLogin()
    }
  }
  showHidePassword = () => {
    this.setState({
      hide: !this.state.hide
    })
  }
  render() {
    let { password, hide } = this.state
    return <ScrollView style={styles.scrollView}>
      <View style={styles.contentWrapper}>
        <View style={styles.passwordBox}>
          <TextInput secureTextEntry={hide} autoCorrect={false} value={password} autoCapitalize="none" placeholder="请输入密码" placeholderTextColor={commonStyle.color.text.para_thirdly} onChangeText={(value) => this.setState({ password: value })} keyboardType={'phone-pad'} style={{ flex: 1, height: px2dp(90), color: commonStyle.color.text.para_primary, fontSize: px2dp(30), padding: 0 }} underlineColorAndroid="transparent" />
          <Iconfont name={hide ? 'password-hidden' : 'password-visible'} size={px2dp(42)} color="#C4C5CA" onPress={this.showHidePassword} />
        </View>
        <Text style={styles.passwordTip}>密码长度至少6个字符，最多24个字符</Text>
        <Button style={styles.confirmButton} textStyle={styles.confirmButtonText} activeOpacity={0.8} onPress={this.confirm}>确定</Button>
      </View>
    </ScrollView>
  }
}

const styles = StyleSheet.create({
  scrollView: {
    flex: 1,
    backgroundColor: '#fff'
  },
  contentWrapper: {
    paddingTop: px2dp(88),
    paddingLeft: px2dp(60),
    paddingRight: px2dp(60),
    ...ifIphoneX({
      paddingBottom: px2dp(124)
    }, {
        paddingBottom: px2dp(80)
      })
  },
  passwordBox: {
    flexDirection: 'row',
    alignItems: 'center',
    borderBottomWidth: px2dp(1),
    borderBottomColor: '#bbb',
    paddingLeft: px2dp(20),
    paddingRight: px2dp(20)
  },
  passwordTip: {
    fontSize: px2dp(24),
    lineHeight: px2dp(64),
    color: '#999'
  },
  confirmButton: {
    alignSelf: 'stretch',
    borderWidth: 0,
    borderRadius: px2dp(6),
    height: px2dp(90),
    backgroundColor: '#1EB0FD',
    marginTop: px2dp(60)
  },
  confirmButtonText: {
    fontSize: px2dp(34),
    color: '#fff'
  }
})
