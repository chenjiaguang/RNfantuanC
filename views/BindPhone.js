import React from "react";
import {
  ScrollView,
  View,
  StyleSheet,
  TouchableOpacity,
  Platform
} from 'react-native';
import px2dp from '../lib/px2dp'
import { ifIphoneX } from 'react-native-iphone-x-helper'
import MyTextInput from '../components/MyTextInput' // 自己封装的输入框，解决ios中文输入问题
import CodeInput from '../components/CodeInput' // 自己封装的获取验证码输入框，自带获取验证码处理逻辑
import Button from 'apsl-react-native-button' // 第三方button库，RN官方的库会根据平台不同区别，这里统一
import Iconfont from "../components/cxicon/CXIcon"; // 自定义iconfont字体文字，基于"react-native-vector-icons"
import Toast from  '../components/Toast'
import commonStyle from "../static/commonStyle";
import SwipBackModule from '../modules/SwipBackModule'
import GoNativeModule from '../modules/GoNativeModule'
import Text from '../components/MyText'

export default class BindPhone extends React.Component {  // 什么参数都不传，则默认是绑定手机都页面，传入isRebind为true时表示新绑手机，界面稍有差异
  constructor (props) {
    super(props)
    this.state = {
      focusPhone: false,
      phone: '',
      code: '',
      submitting: false
    }
  }
  static navigationOptions = ({navigation}) => {
    let _title = (navigation.state.params && navigation.state.params.rebind) ? '新的手机号' : '绑定手机'
    return{
      title: _title
    }
  }
  bindPhone = () => { // 绑定手机
    let {phone, code} = this.state
    let {params} = this.props.navigation.state
    if (!/^1\d{10}$/.test(phone)) {
      Toast.show('请填写正确手机号')
      return false
    }
    if (!code) {
      Toast.show('请输入短信验证码')
      return false
    }
    let rData = (params && params.rebind) ? {
      jwtToken: params.jwtToken,
      phone: phone,
      code: code
    } : {
      phone: phone,
      code: code
    }
    this.setState({
      submitting: true
    })
    let rAddress = (params && params.rebind) ? '/jv/user/phone/change' : '/jv/user/phone/bind'
    _FetchData(_Api + rAddress, rData).then(res => {
      this.setState({
        submitting: false
      })
      if (res && Boolean(res.error) && res.msg) {
        res.msg && Toast.show(res.msg)
        return false
      } else if (res && !Boolean(res.error)) {
        // 绑定成功，退出页面
        if (Platform.OS == 'android') {
          GoNativeModule && GoNativeModule.goAfterWXBindPhone()
        }else{
          GoNativeModule && GoNativeModule.goRootTabBar && GoNativeModule.goRootTabBar()
          SwipBackModule && SwipBackModule.exit()
        }
      }
    }, err => {
      // 绑定出错
      this.setState({
        submitting: false
      })
    }).catch(err => {
      this.setState({
        submitting: false
      })
    })
  }
  inputChange = (key, value) => {
    let _state = Object.assign({}, this.state)
    _state[key] = value
    this.setState(_state)
  }
  focus = () => {
    this.setState({
      focusPhone: true
    })
  }
  blur = () => {
    this.setState({
      focusPhone: false
    })
  }
  clear = () => {
    this.setState({
      phone: ''
    })
  }
  render() {
    let {focusPhone, phone, code, submitting} = this.state
    return <ScrollView style={style.scrollView} keyboardShouldPersistTaps="handled">
      <View style={style.contentWrapper}>
        <View style={style.phoneWrapper}>
          <Text style={style.phonePrefix}>+86</Text>
          <MyTextInput keyboardType="numeric" onFocus={this.focus} onBlur={this.blur} style={style.phone} underlineColorAndroid="transparent" placeholder="请输入手机号" value={phone} onChangeText={(value) => this.inputChange('phone', value)} maxLength={11} placeholderTextColor={commonStyle.color.text.para_thirdly}/>
          {(focusPhone && phone) ? <TouchableOpacity activeOpacity={1} onPress={this.clear}>
            <View style={style.clear}>
              <Iconfont name="close" size={px2dp(27)} color={commonStyle.color.text.para_thirdly}></Iconfont>
            </View>
          </TouchableOpacity> : null}
        </View>
        <CodeInput phone={phone} value={code} onChangeText={value => this.setState({code: value})} onClear={() => this.setState({code: ''})} style={style.CodeInput}/>
        <Button style={[style.button, {backgroundColor: (!phone || !code || submitting) ? commonStyle.color.btn_primary.bgDisabled : commonStyle.color.btn_primary.bg}]} textStyle={style.buttonText} onPress={this.bindPhone} activeOpacity={1} isDisabled={!phone || !code || submitting}>立即绑定</Button>
        {this.props.navigation.state.params && this.props.navigation.state.params.isRebind ? <Text style={style.tip}>一旦绑定新手机号，原手机号不可再用于登录</Text> : null}
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
    fontSize: px2dp(24),
    lineHeight: px2dp(34),
    color: commonStyle.color.text.para_secondary,
    alignSelf: 'flex-start',
    marginTop: px2dp(35),
    marginLeft: px2dp(60)
  },
  phoneWrapper: {
    flexDirection: 'row',
    height: px2dp(90),
    alignItems: 'center',
    marginLeft: px2dp(60),
    marginRight: px2dp(60),
    marginTop: px2dp(80),
    paddingLeft: px2dp(20),
    borderBottomWidth: px2dp(1),
    borderBottomColor: commonStyle.color.border.default
  },
  phonePrefix: {
    fontSize: px2dp(30),
    fontWeight: '700',
    color: commonStyle.color.text.para_primary,
    width:px2dp(97),
    marginRight:px2dp(20),
    borderRightWidth: px2dp(1),
    borderRightColor: commonStyle.color.border.default
  },
  phone: {
    flex: 1,
    fontSize: px2dp(30),
    color: commonStyle.color.text.para_primary,
    padding: 0
  },
  CodeInput: {
    marginTop: px2dp(38),
    marginLeft: px2dp(60),
    marginRight: px2dp(60)
  },
  button: {
    width:px2dp(630),
    height:px2dp(90),
    justifyContent: 'center',
    alignItems: 'center',
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
  clear: {
    paddingRight: px2dp(20),
    paddingLeft: px2dp(20),
    paddingTop: px2dp(20),
    paddingBottom: px2dp(20)
  }
})
