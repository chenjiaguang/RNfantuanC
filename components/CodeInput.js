import React, {Component} from 'react';
import {TextInput, View, TouchableOpacity, StyleSheet} from 'react-native';
import px2dp from "../lib/px2dp";
import commonStyle from "../static/commonStyle";
import Toast from './Toast'; // 封装的第三方toast,兼容ios/android
import MyTextInput from './MyTextInput'
import Iconfont from "../components/cxicon/CXIcon"; // 自定义iconfont字体文字，基于"react-native-vector-icons"
import Text from '../components/MyText'

export default class CodeInput extends Component {
  constructor (props) {
    super(props)
    this.state = {
      btnText: '获取验证码',
      disabledBtn: false
    }
    this.countNum = -1
  }
  blur = () => {
    this.refs.input.blur()
  }
  focus = () => {
    this.refs.input.focus()
  }
  startCounting = (callback) => {
    if (this.countNum >= 0) { // 还在显示倒计时
      return false
    }
    this.countNum = 59
    this.timer && clearInterval(this.timer)
    this.timer = setInterval(() => {
      let text = '重新获取(' + (this.countNum > 9 ? this.countNum : '0' + this.countNum) + ')'
      this.setState({
        btnText: text
      })
      this.countNum -= 1
      if (this.countNum < 0) {
        clearInterval(this.timer)
        this.setState({
          btnText: '获取验证码'
        }, () => {
          callback && callback()
        })
      }
    }, 1000)
  }
  sendCode = () => {
    let {phone} = this.props
    if (!/^1[34578][0-9]\d{8}$/.test(phone)) { // 输入的不是手机号
      Toast.show('请输入正确手机号')
      return false
    }
    let rData = {
      phone: phone,
      purpose: 'changePhone'
    }
    this.setState({
      disabledBtn: true
    })
    _FetchData(_Api + '/jv/sms/send', rData).then(res => {
      // 请求成功
      if (res && Boolean(res.error) && res.msg) {
        Toast.show(res.msg)
        this.setState({
          disabledBtn: false
        })
      } else if (res && !Boolean(res.error)) {
        Toast.show('验证码已发送，请注意查收')
        this.startCounting(() => {
          this.setState({
            disabledBtn: false
          })
        })
      }
    }).catch(err => {
      // 获取失败
      this.setState({
        disabledBtn: false
      })
    })
  }
  render() {
    let {btnText, disabledBtn} = this.state
    let {style, onClear, value, ...other} = this.props
    return <View style={[styles.wrapper, style]}>
      <TextInput ref="input" autoCorrect={false} autoCapitalize="none" placeholder="请输入验证码" value={value} placeholderTextColor={commonStyle.color.text.para_thirdly} keyboardType="numeric" style={styles.input} underlineColorAndroid="transparent" {...other}/>
      <TouchableOpacity activeOpacity={1} onPress={onClear}>
        <View style={styles.clear}>
          <Iconfont name="close" size={px2dp(27)} color={commonStyle.color.text.para_thirdly}></Iconfont>
        </View>
      </TouchableOpacity>
      <TouchableOpacity disabled={disabledBtn} activeOpacity={0.8} onPress={this.sendCode}>
        <View style={styles.btnView}>
          <Text style={[styles.btnText, {color: disabledBtn ? commonStyle.color.text.para_thirdly : commonStyle.color.text.positive}]}>{btnText}</Text>
        </View>
      </TouchableOpacity>
    </View>
  }
};

const styles = StyleSheet.create({
  wrapper: {
    borderBottomWidth: px2dp(1),
    borderBottomColor: commonStyle.color.border.default,
    flexDirection: 'row',
    alignItems: 'center'
  },
  input: {
    flex: 1,
    height: px2dp(90),
    fontSize: px2dp(30),
    color: commonStyle.color.text.para_primary,
    paddingLeft: px2dp(20)
  },
  clear: {
    marginRight: px2dp(10),
    paddingRight: px2dp(20),
    paddingLeft: px2dp(20),
    paddingTop: px2dp(20),
    paddingBottom: px2dp(20)
  },
  btnView: {
    width: px2dp(210),
    height: px2dp(40),
    borderLeftWidth: px2dp(1),
    borderLeftColor: commonStyle.color.border.default,
    justifyContent: 'center',
    alignItems: 'flex-start',
    paddingLeft: px2dp(30)
  },
  btnText: {
    fontSize: px2dp(30),
    lineHeight: px2dp(38),
    textAlignVertical: 'center'
  }
})
