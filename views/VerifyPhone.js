import React from "react";
import {
  ScrollView,
  View,
  Text,
  StyleSheet,
  Alert
} from 'react-native';
import px2dp from '../lib/px2dp'
import { ifIphoneX } from 'react-native-iphone-x-helper'
import CodeInput from '../components/CodeInput' // 自己封装的获取验证码输入框，自带获取验证码处理逻辑
import Button from 'apsl-react-native-button'
import Toast from  '../components/Toast'
import commonStyle from "../static/commonStyle"; // 第三方button库，RN官方的库会根据平台不同区别，这里统一
// 提交头条申请成功页面  需要参数:phone: xxx, verifySuccess: function (验证通过后执行的方法，比如跳转其他页面),例：
// 其他页面调用：this.props.navigation.navigate('VerifyPhone', {phone: 17508959493, verifySuccess: () => console.log(9999900000)})，验证成功后将log 9999900000

export default class VerifyPhone extends React.Component {
  constructor (props) {
    super(props)
    this.state = {
      showPhone: '',
      code: '',
      submitting: false
    }
  }
  static navigationOptions = {
    title: '安全验证'
  }
  componentWillMount () {
    let {params} = this.props.navigation.state
    if (params && params.phone) {
      this.setState({
        phone: params.phone,
        showPhone: params.phone.toString().substr(0, 3) + ' **** ' + params.phone.toString().substr(-4)
      })
    }
  }
  verify = () => {
    let {phone, code} = this.state
    let {params} = this.props.navigation.state
    if (!code) {
      return false
    }
    let rData = {
      phone: phone,
      code: code
    }
    this.setState({
      submitting: true
    })
    _FetchData(_Api + '/sms/verify', rData).then(res => {
      this.setState({
        submitting: false
      })
      if (res && Boolean(res.error) && res.msg) {
        Toast.show(res.msg)
      } else if (res && !Boolean(res.error)) {
        // 下一步，调用页面传进来的verifySuccess
        params && params.verifySuccess && params.verifySuccess()
      }
    }, err => {
      // 验证出错
      this.setState({
        submitting: false
      })
    }).catch(err => {
      // 验证出错
      this.setState({
        submitting: false
      })
    })
  }
  notGetCode = () => {
    Alert.alert(
      '请联系客服处理',
      '客服电话：400-3663-2552',
      [
        {
          text: '确定'
        }
      ],
      {
        cancelable: false
      }
    )
  }
  render() {
    let {code, showPhone, submitting} = this.state
    return <ScrollView style={style.scrollView} keyboardShouldPersistTaps="handled">
      <View style={style.contentWrapper}>
        <Text style={style.tip}>为保证您的账号安全，需要进行短信验证，验证成功方 可进行下一步操作</Text>
        <Text style={style.phone}>{showPhone}</Text>
        <CodeInput phone={this.props.navigation.state.params && this.props.navigation.state.params.phone || ''} value={code} onChangeText={value => this.setState({code: value})} onClear={() => this.setState({code: ''})} style={style.CodeInput}/>
        <Button style={style.button} textStyle={style.buttonText} onPress={this.verify} activeOpacity={0.8} isDisabled={submitting}>下一步</Button>
        <Text style={style.notGetCode} onPress={this.notGetCode}>收不到验证码？</Text>
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
  tip: {
    fontSize: px2dp(28),
    lineHeight: px2dp(44),
    color: commonStyle.color.text.para_secondary,
    marginTop: px2dp(12),
    marginLeft: commonStyle.page.left,
    marginRight: commonStyle.page.right
  },
  phone: {
    fontSize: px2dp(42),
    lineHeight: px2dp(50),
    color: commonStyle.color.text.para_primary,
    fontWeight: '700',
    marginTop: px2dp(48),
  },
  CodeInput: {
    marginTop: px2dp(90),
    marginLeft: px2dp(60),
    marginRight: px2dp(60)
  },
  button: {
    width:px2dp(690),
    height:px2dp(90),
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#1EB0FD',
    marginTop: px2dp(100),
    marginBottom: 0,
    alignSelf: 'center',
    borderRadius: px2dp(6),
    borderWidth: 0
  },
  buttonText: {
    fontSize: px2dp(34),
    color: '#fff'
  },
  notGetCode: {
    fontSize: px2dp(24),
    lineHeight: px2dp(34),
    marginTop: px2dp(55),
    color: commonStyle.color.text.positive
  }
})
