import React from "react";
import {
  ScrollView,
  View,
  Image,
  StyleSheet,
  TouchableOpacity,
  TouchableWithoutFeedback
} from 'react-native';
import px2dp from '../../lib/px2dp'
import { ifIphoneX } from 'react-native-iphone-x-helper'
import MyTextInput from '../../components/MyTextInput' // 自己封装的输入框，解决ios中文输入问题
import CodeInput from '../../components/CodeInput' // 自己封装的获取验证码输入框，自带获取验证码处理逻辑
import Button from 'apsl-react-native-button' // 第三方button库，RN官方的库会根据平台不同区别，这里统一
import Iconfont from "../../components/cxicon/CXIcon"; // 自定义iconfont字体文字，基于"react-native-vector-icons"
import Toast from  '../../components/Toast'
import commonStyle from "../../static/commonStyle";
import SwipBackModule from '../../modules/SwipBackModule'
import Text from '../../components/MyText'
import Progress from '../../components/Progress'

export default class GrowthCenter extends React.Component {  // 什么参数都不传，则默认是绑定手机都页面，传入isRebind为true时表示新绑手机，界面稍有差异
  constructor (props) {
    super(props)
    this.state = {
      userAvatar: 'http://img.besoo.com/file/201705/16/0940318745908.jpg',
      userLevel: 2,
      userName: '曾半仙仙仙儿啊曾半仙',
      joneDays: 99,
      levelPercent: 0.6
    }
  }
  static navigationOptions = {
    title: '成长中心'
  }
  render() {
    let {userAvatar, userLevel, userName, joneDays} = this.state
    return <ScrollView style={styles.scrollView}>
    <View style={styles.header}>
      <Image style={styles.avatar} source={{uri: userAvatar}} />
      <Image style={styles.level} source={levelImage['lv' + userLevel]} />
      <View style={styles.name} numberOfLines={1}>{userName}
        <Text numberOfLines={1} style={{fontSize: px2dp(34), color: '#333'}}>{userName}</Text>
      </View>
      <View style={styles.joinDays}>
        <Text numberOfLines={1} style={{fontSize: px2dp(20), color: '#666'}}>今天是你加入范团的第{joneDays}天哦</Text>
      </View>
      <Progress width={px2dp(600)} height={px2dp(10)} colors={['#40D8FF', '#1EB0FD']} style={{marginTop: px2dp(30)}} />
      <TouchableWithoutFeedback>
        <View style={styles.knowMore}>
          <Text style={styles.knowMoreText}>了解更多</Text>
          <Iconfont name="help" color="#1EB0FD" size={px2dp(25)} />
        </View>
      </TouchableWithoutFeedback>
    </View>
      
    </ScrollView>
  }
}

const levelImage = {
  lv1: require('../../static/image/level1.png'),
  lv2: require('../../static/image/level2.png'),
  lv3: require('../../static/image/level3.png'),
  lv4: require('../../static/image/level4.png'),
  lv5: require('../../static/image/level5.png'),
  lv6: require('../../static/image/level6.png'),
  lv7: require('../../static/image/level7.png'),
  lv8: require('../../static/image/level8.png'),
  lv9: require('../../static/image/level9.png'),
  lv10: require('../../static/image/level10.png')
}

const styles = StyleSheet.create({
  scrollView: {
    flex: 1,
    backgroundColor: '#fff'
  },
  header: {
    height: px2dp(430),
    justifyContent: 'flex-start',
    alignItems: 'center'
  },
  avatar: {
    width: px2dp(120),
    height: px2dp(120),
    marginTop: px2dp(40),
    borderRadius: px2dp(60)
  },
  level: {
    width:px2dp(53),
    height: px2dp(26),
    marginTop: px2dp(20)
  },
  name: {
    height: px2dp(54),
    justifyContent: 'center',
    marginTop: px2dp(10)
  },
  joinDays: {
    height: px2dp(40),
    justifyContent: 'center'
  },
  knowMore: {
    position: 'absolute',
    top: px2dp(40),
    right: px2dp(30),
    flexDirection: 'row',
    justifyContent: 'flex-end',
    alignItems: 'center'
  },
  knowMoreText: {
    color: '#333',
    fontSize: px2dp(24),
    marginRight: px2dp(9)
  }
})
