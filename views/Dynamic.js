import React from "react";
import {
  ScrollView,
  TouchableOpacity,
  View,
  Image,
  Text,
  StyleSheet,
  FlatList,
  findNodeHandle,
  Platform
} from 'react-native';
import { BlurView } from 'react-native-blur';
import Iconfont from "../components/cxicon/CXIcon";
import commonStyle from "../static/commonStyle";
import px2dp from '../lib/px2dp'
import { ifIphoneX, getStatusBarHeight } from 'react-native-iphone-x-helper'
import Button from 'apsl-react-native-button' // 第三方button库，RN官方的库会根据平台不同区别，这里统一
// 动态

export default class Dynamic extends React.Component {
  constructor (props) {
    super(props)
    this.state = {
      data: [
        {
          id: 1,
          avatar: 'http://www.qqzhi.com/uploadpic/2014-09-04/190201863.jpg',
          name: '深井冰的日常',
          time: '8分钟前',
          userType: 1, // 1管理员
          content: '珍惜所有的不期而遇，看淡所有的不辞而别。',
          images: [
            'http://img4.imgtn.bdimg.com/it/u=2634486665,3327935877&fm=27&gp=0.jpg'
          ],
          like: 2320,
          comment: 998
        },
        {
          id: 2,
          avatar: 'http://www.qqzhi.com/uploadpic/2014-09-04/190201863.jpg',
          name: '深井冰的日常',
          time: '8分钟前',
          userType: 1, // 1管理员
          content: '珍惜所有的不期而遇，看淡所有的不辞而别。',
          images: [
            'http://img4.imgtn.bdimg.com/it/u=2634486665,3327935877&fm=27&gp=0.jpg'
          ],
          like: 2320,
          comment: 998
        },
        {
          id: 3,
          avatar: 'http://www.qqzhi.com/uploadpic/2014-09-04/190201863.jpg',
          name: '深井冰的日常',
          time: '8分钟前',
          userType: 1, // 1管理员
          content: '珍惜所有的不期而遇，看淡所有的不辞而别。',
          images: [
            'http://img4.imgtn.bdimg.com/it/u=2634486665,3327935877&fm=27&gp=0.jpg'
          ],
          like: 2320,
          comment: 998
        },
        {
          id: 4,
          avatar: 'http://www.qqzhi.com/uploadpic/2014-09-04/190201863.jpg',
          name: '深井冰的日常',
          time: '8分钟前',
          userType: 1, // 1管理员
          content: '珍惜所有的不期而遇，看淡所有的不辞而别。',
          images: [
            'http://img4.imgtn.bdimg.com/it/u=2634486665,3327935877&fm=27&gp=0.jpg'
          ],
          like: 2320,
          comment: 998
        },
        {
          id: 5,
          avatar: 'http://www.qqzhi.com/uploadpic/2014-09-04/190201863.jpg',
          name: '深井冰的日常',
          time: '8分钟前',
          userType: 1, // 1管理员
          content: '珍惜所有的不期而遇，看淡所有的不辞而别。',
          images: [
            'http://img4.imgtn.bdimg.com/it/u=2634486665,3327935877&fm=27&gp=0.jpg'
          ],
          like: 2320,
          comment: 998
        }
      ],
      extraData: {
        header: {
          avatar: 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1527844130387&di=ce3ec3e2e234aa0df0c081c855351e4c&imgtype=0&src=http%3A%2F%2Fp.3761.com%2Fpic%2F43801422060860.jpg',
          name: '无问西东',
          intro: '海南有趣、有料、有温度的生活圈，分分吃遍海南大街小巷的美食，不错过任何一味，快来加入吧~：）',
          fans: 128,
          dynamic: 78
        }
      },
      viewRef: null,
      refreshing: false
    }
  }
  static navigationOptions = (navigation) => {
    let _headerStyle = Object.assign({}, navigation.navigationOptions.headerStyle,{
      position: 'absolute',
      left: 0,
      top: 0,
      backgroundColor: 'transparent'
    })
    return{
      title: '',
      headerStyle: _headerStyle
    }
  };
  imageLoaded() {
    this.setState({ viewRef: findNodeHandle(this.backgroundImage) });
  }
  renderHeader = () => {
    let {header} = this.state.extraData
    return <View style={style.blurBg}>
      <Image
        ref={(img) => { this.backgroundImage = img; }}
        source={{uri: header.avatar}}
        style={style.absoluteBlur}
        resizeMode="cover"
        onLoadEnd={this.imageLoaded.bind(this)}
      />
      <BlurView
        style={style.absoluteBlur}
        viewRef={this.state.viewRef}
        blurType="light"
        blurAmount={10}
      />
      <View style={style.circleShortcut}>
        <Image source={{uri: header.avatar}} style={style.circleAvatar}/>
        <View style={{flex: 1}}>
          <Text style={style.circleName} numberOfLines={1}>{header.name}</Text>
          <Text style={style.circleIntro}>{header.intro}</Text>
        </View>
      </View>
      <View style={style.circleSum}>
        <Button style={style.followBtn} textStyle={style.followBtnText} activeOpacity={1}>关注</Button>
        <Text style={style.followNum}>{header.fans}人关注</Text>
        <Text style={style.dynamicNum}>{header.dynamic}条动态</Text>
      </View>
    </View>
  }
  render() {
    console.log('getStatusBarHeight', getStatusBarHeight(true))
    let {data, refreshing} = this.state
    return <FlatList onRefresh={(e) => {
      console.log('refreshing', e);
      this.setState({
        refreshing: true
      })
      setTimeout(() => {
        this.setState({
          refreshing: false
        })
      }, 3000)
    }} refreshing={refreshing} ListHeaderComponent={this.renderHeader()} style={style.flatList} data={data} renderItem={({item}) => <Text style={{lineHeight: px2dp(400)}}>{item.id}</Text>} keyExtractor={item => item.id.toString()}/>
  }
}

const style = StyleSheet.create({
  flatList: {
    flex: 1,
    backgroundColor: '#fff'
  },
  blurBg: {
    paddingLeft: px2dp(40),
    paddingRight: px2dp(40),
    paddingTop: px2dp(90) + (Platform.OS === 'ios' ? getStatusBarHeight(true) : 0)
  },
  absoluteBlur: {
    position: "absolute",
    top: 0, left: 0, bottom: 0, right: 0
  },
  circleShortcut: {
    flexDirection: 'row'
  },
  circleAvatar: {
    width: px2dp(150),
    height: px2dp(150),
    borderRadius: px2dp(10),
    marginRight: px2dp(30),
    marginTop: px2dp(10)
  },
  circleName: {
    fontSize: px2dp(36),
    lineHeight: px2dp(56),
    paddingBottom: px2dp(15),
    color: '#fff'
  },
  circleIntro: {
    fontSize: px2dp(24),
    lineHeight: px2dp(34),
    color: '#fff'
  },
  circleSum: {
    height: px2dp(108),
    flexDirection: 'row',
    alignItems: 'center',
    overflow: 'hidden'
  },
  followBtn: {
    width: px2dp(109),
    height: px2dp(48),
    backgroundColor: commonStyle.color.btn_primary.bg,
    borderRadius: px2dp(6),
    borderWidth: 0,
    marginLeft: px2dp(20),
    alignSelf: 'center',
    marginBottom: 0
  },
  followBtnText: {
    fontSize: px2dp(24),
    color: '#fff'
  },
  followNum: {
    fontSize: px2dp(24),
    color: '#fff',
    marginLeft: px2dp(50)
  },
  dynamicNum: {
    fontSize: px2dp(24),
    color: '#fff',
    marginLeft: px2dp(30)
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
