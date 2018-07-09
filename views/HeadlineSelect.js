import React from "react";
import {
  ScrollView,
  TouchableOpacity,
  View,
  Image,
  StyleSheet,
  StatusBar
} from 'react-native';
import Iconfont from "../components/cxicon/CXIcon";
import commonStyle from '../static/commonStyle'
import { ifIphoneX } from 'react-native-iphone-x-helper'
import px2dp from '../lib/px2dp'
import Text from '../components/MyText'
// 申请头条选择类型
const personIcon = require('../static/image/rn_person_icon.png')
const organizationIcon = require('../static/image/rn_organization_icon.png')
export default class HeadlineSelect extends React.Component {
  constructor (props) {
    super(props)
    this.state = {}
  }
  static navigationOptions = {
    title: '注册头条号'
  };
  goNext = (type) => {
    let {navigate} = this.props.navigation
    navigate('HeadlineForm', {type: type})
  }
  render() {
    return <ScrollView style={style.scrollView}>
      <View style={style.contentWrapper}>
        <TouchableOpacity style={style.selectItem} activeOpacity={0.8} onPress={() => this.goNext(1)}>
          <View>
            <View style={style.icon}>
              <Image style={{width: px2dp(168), height: px2dp(168)}} source={personIcon}/>
            </View>
            <Text style={style.itemText}>个人用户</Text>
          </View>
        </TouchableOpacity>
        <TouchableOpacity style={style.selectItem} activeOpacity={0.8} onPress={() => this.goNext(2)}>
          <View>
            <View style={style.icon}>
              <Image style={{width: px2dp(168), height: px2dp(168)}} source={organizationIcon}/>
            </View>
            <Text style={style.itemText}>组织机构</Text>
          </View>
        </TouchableOpacity>
      </View>
    </ScrollView>
  }
}

const style = StyleSheet.create({
  scrollView: {
    flex: 1,
    backgroundColor: commonStyle.color.bg.secondary
  },
  contentWrapper: {
    ...ifIphoneX({
      paddingBottom: px2dp(124)
    }, {
      paddingBottom: px2dp(80)
    })
  },
  selectItem: {
    height:px2dp(350),
    backgroundColor: '#fff',
    justifyContent: 'center',
    alignItems: 'center',
    marginLeft: commonStyle.page.left,
    marginRight: commonStyle.page.right,
    marginTop: px2dp(30),
    borderRadius: px2dp(8)
  },
  icon: {
    borderRadius: px2dp(84)
  },
  itemText: {
    fontSize: px2dp(32),
    lineHeight: px2dp(36),
    marginTop: px2dp(28),
    textAlign: 'center',
    color: commonStyle.color.text.para_primary
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
