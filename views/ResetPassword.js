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

export default class ResetPassword extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      password: '',
      hide: false,
      submitting: false
    }
  }
  static navigationOptions = {
    title: '修改登录密码'
  };
  confirm = () => {
    let { password, oldPassword, submitting } = this.state
    if (!oldPassword || oldPassword.length < 6 || oldPassword.length > 24) {
      Toast.show('请输入6-24个字符的原密码')
      return false
    }
    if (!password || password.length < 6 || password.length > 24) {
      Toast.show('请输入6-24个字符的新密码')
      return false
    }
    if (oldPassword && password && oldPassword === password) {
      Toast.show('原密码与新密码不能一致')
      return false
    }
    if (submitting) {
      Toast.show('正在提交，请稍后...')
      return false
    }
    let rData = {
      password: password,
      oldPassword: oldPassword
    }
    this.setState({
      submitting: true
    })
    _FetchData(_Api + '/jv/user/password/change', rData).then(res => {
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
      console.log('修改密码出错', err)
      this.setState({
        submitting: false
      })
    })
  }
  confirmComplete = () => {
    // 完成验证，修改密码成功，跳转原生登录界面,关闭rn页面
    if (Platform.OS === 'ios') { // ios
      GoNativeModule && GoNativeModule.goReLogin()
      SwipBackModule && SwipBackModule.exit()
    } else { // android
      GoNativeModule && GoNativeModule.goReLogin()
    }
  }
  forgetPassword = () => {
    // 跳转修改重置密码页面（通过手机短信验证）
    if (Platform.OS === 'ios') { // ios
      GoNativeModule && GoNativeModule.goForgetPassWord('')
    } else { // android
      GoNativeModule && GoNativeModule.goForgetPassWord()
    }
  }
  showHidePassword = () => {
    this.setState({
      hide: !this.state.hide
    })
  }
  render() {
    let { password, oldPassword, hide } = this.state
    return <ScrollView style={styles.scrollView}>
      <View style={styles.contentWrapper}>
        <View style={styles.passwordBox}>
          <MyTextInput secureTextEntry={hide} autoCorrect={false} value={oldPassword} autoCapitalize="none" placeholder="原密码" placeholderTextColor={commonStyle.color.text.para_thirdly} onChangeText={(value) => this.setState({ oldPassword: value })} keyboardType={'default'} style={{ flex: 1, height: px2dp(90), color: commonStyle.color.text.para_primary, fontSize: px2dp(30), padding: 0 }} underlineColorAndroid="transparent" />
        </View>
        <View style={styles.confirmPasswordBox}>
          <MyTextInput secureTextEntry={hide} autoCorrect={false} value={password} autoCapitalize="none" placeholder="新密码" placeholderTextColor={commonStyle.color.text.para_thirdly} onChangeText={(value) => this.setState({ password: value })} keyboardType={'default'} style={{ flex: 1, height: px2dp(90), color: commonStyle.color.text.para_primary, fontSize: px2dp(30), padding: 0 }} underlineColorAndroid="transparent" />
          <Iconfont name={hide ? 'password-hidden' : 'password-visible'} size={px2dp(42)} color="#C4C5CA" onPress={this.showHidePassword} />
        </View>
        <Text style={styles.passwordTip}>密码长度至少6个字符，最多24个字符</Text>
        <Button style={styles.confirmButton} textStyle={styles.confirmButtonText} activeOpacity={0.8} onPress={this.confirm}>确定</Button>
        <Button style={styles.forgetButton} textStyle={styles.forgetButtonText} activeOpacity={0.8} onPress={this.forgetPassword}>忘记原密码</Button>
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
  confirmPasswordBox: {
    flexDirection: 'row',
    alignItems: 'center',
    borderBottomWidth: px2dp(1),
    borderBottomColor: '#bbb',
    paddingLeft: px2dp(20),
    paddingRight: px2dp(20),
    marginTop: px2dp(38)
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
    marginTop: px2dp(60),
    marginBottom: 0
  },
  confirmButtonText: {
    fontSize: px2dp(34),
    color: '#fff'
  },
  forgetButton: {
    alignSelf: 'center',
    borderWidth: 0,
    borderRadius: 0,
    height: px2dp(64),
    lineHeight: px2dp(64),
    color: '#1EB0FD',
    marginTop: px2dp(40)
  },
  forgetButtonText: {
    fontSize: px2dp(24),
    color: '#1EB0FD'
  }
})
