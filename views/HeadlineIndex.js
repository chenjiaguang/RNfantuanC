import React from "react";
import {
  ScrollView,
  TouchableOpacity,
  View,
  Image,
  Text,
  StyleSheet
} from 'react-native';
import Iconfont from "../components/cxicon/CXIcon";
import px2dp from '../lib/px2dp'
import { ifIphoneX } from 'react-native-iphone-x-helper'
const bg = require('../static/image/apply_banner.png')
import Button from 'apsl-react-native-button' // 第三方button库，RN官方的库会根据平台不同区别，这里统一
// 申请头条首页

export default class HeadlineIndex extends React.Component {
  constructor (props) {
    super(props)
    this.state = {
      showPage: false
    }
  }
  static navigationOptions = {
    title: '入驻申请'
  };
  goNext = () => {
    const { navigate } = this.props.navigation;
    navigate('HeadlineSelect')
  }
  componentDidMount () {
    console.log('qwer', this.props)
  }
  render() {
    let {showPage} = this.state
    return showPage ? <ScrollView style={style.scrollView}>
      <Image source={bg} resizeMode="cover" onLoad={() => this.setState({
        showPage: true
      })} style={style.bg}></Image>
      <View style={style.contentWrapper}>
        <View style={style.articleBody}>
          <View style={style.paragraph}>
            <Iconfont name='question' size={px2dp(40)} color='#FF3F53' style={style.icon}></Iconfont>
            <View style={style.textWrapper}>
              <Text style={style.header}>什么是范团头条?</Text>
              <Text style={style.content}>范团头条是海南本土首个内容创作平台，我们鼓励所有人在这里创作内容、分享自己的生活。目前范团头条主要以文章的形式展现，任何兴趣领域的内容都可以在这里发布。</Text>
            </View>
          </View>
          <View style={style.paragraph}>
            <Iconfont name='question' size={px2dp(40)} color='#FF3F53' style={style.icon}></Iconfont>
            <View style={style.textWrapper}>
              <Text style={style.header}>入驻范团头条有什么好处？</Text>
              <Text style={style.content}>你可以在这里获得对你的内容感兴趣的粉丝、志同道合的朋友、棋逢对手的知己，你可以在这里和他们互动、交流、分享。后期我们还会逐步增加作者收益，让你的所写有所得。</Text>
            </View>
          </View>
          <View style={style.paragraph}>
            <Iconfont name='question' size={px2dp(40)} color='#FF3F53' style={style.icon}></Iconfont>
            <View style={style.textWrapper}>
              <Text style={style.header}>如何入驻范团头条？</Text>
              <Text style={style.content}>点击下方“成为头条号作者”的按钮，填写简单的资料后，即可以在电脑上进入 http://toutiao.fantuanlife.com，开始进行创作。</Text>
            </View>
          </View>
        </View>
        <Button style={style.button} textStyle={style.buttonText} onPress={this.goNext} activeOpacity={0.8}>成为头条号作者</Button>
      </View>
    </ScrollView> : <ScrollView style={style.scrollView}>
      <Image source={bg} onLoad={() => {
        console.log('sdkfuwjweuf')
        this.setState({
          showPage: true
        })
      }} style={{width:1, height: 1, opacity: 0}}></Image>
    </ScrollView>
  }
}

const style = StyleSheet.create({
  scrollView: {
    flex: 1,
    backgroundColor: '#fff'
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
    borderWidth: 0
  },
  buttonText: {
    fontSize: px2dp(34),
    color: '#fff'
  }
})
