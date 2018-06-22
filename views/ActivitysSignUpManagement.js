import React from "react";
import {
  FlatList,
  Text,
  View,
  Image,
  StyleSheet,
  TouchableWithoutFeedback,
  Alert,
  Linking,
  ActivityIndicator
} from 'react-native';
import px2dp from '../lib/px2dp'
import { PullView } from 'react-native-pull';

class HeaderRight extends React.Component {
  constructor(props) {
    super(props)
    this.state = {}
  }
  onScan = () => {
    Alert.alert(
      '进入扫码'
    )
  }
  render() {
    return <TouchableWithoutFeedback disabled={false} onPress={this.onScan}>
      <View style={{ flexDirection: 'row', alignItems: 'center' }}>
        <Image style={styles.scanImg} source={require('../static/image/rn_ic_scan.png')} />
        <Text style={styles.scanText}>验票</Text>
      </View>
    </TouchableWithoutFeedback>
  }
}
export default class ActivitysSignUpManagement extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      refreshState: 0,
      dataList: this.data,
      dataCount1: "12",
      dataCount2: "￥23"
    }
  }
  activeStatus = [
    '未验票'
  ]
  data = [
    {
      id: '0',
      img: 'http://yanxuan.nosdn.127.net/3011d972cb4c1e72f38b9838dac7e21c.jpg?imageView&thumbnail=78x78&quality=95',
      title: 'A票男生票C区20男生票C区',
      name: '花花（陈晓华）',
      time: '01-30 16:00 开始',
      status: '已验票',
      price: '￥100 x 10',
      idNo: '460009898989899779',
      gender: '男',
      phone: '13337663721',
      uid: '1433'
    },
    {
      id: '1',
      img: 'http://yanxuan.nosdn.127.net/3011d972cb4c1e72f38b9838dac7e21c.jpg?imageView&thumbnail=78x78&quality=95',
      title: 'A票男生票C区20男生票C区',
      name: '花花（陈晓华）',
      time: '01-30 16:00 开始',
      status: '未验票',
      price: '￥100 x 10',
      idNo: '460009898989899779',
      gender: '',
      phone: '13337663721',
      uid: '1433'
    },
    {
      id: '2',
      img: 'http://yanxuan.nosdn.127.net/3011d972cb4c1e72f38b9838dac7e21c.jpg?imageView&thumbnail=78x78&quality=95',
      title: 'A票男生票C区20男生票C区',
      name: '花花（陈晓华）',
      time: '01-30 16:00 开始',
      status: '未验票',
      price: '￥100 x 10',
      idNo: '',
      gender: '男',
      phone: '13337663721',
      uid: '1433'
    },
    {
      id: '3',
      img: 'http://yanxuan.nosdn.127.net/3011d972cb4c1e72f38b9838dac7e21c.jpg?imageView&thumbnail=78x78&quality=95',
      title: 'A票男生票C区20男生票C区',
      name: '花花（陈晓华）',
      time: '01-30 16:00 开始',
      status: '未验票',
      price: '￥100 x 10',
      idNo: '',
      gender: '',
      phone: '13337663721',
      uid: '1433'
    },
    {
      id: '4',
      img: 'http://yanxuan.nosdn.127.net/3011d972cb4c1e72f38b9838dac7e21c.jpg?imageView&thumbnail=78x78&quality=95',
      title: 'A票男生票C区20男生票C区',
      name: '花花（陈晓华）',
      time: '01-30 16:00 开始',
      status: '未验票',
      price: '￥100 x 10',
      idNo: '460009898989899779',
      gender: '男',
      phone: '13337663721',
      uid: '1433'
    },
    {
      id: '5',
      img: 'http://yanxuan.nosdn.127.net/3011d972cb4c1e72f38b9838dac7e21c.jpg?imageView&thumbnail=78x78&quality=95',
      title: 'A票男生票C区20男生票C区',
      name: '花花（陈晓华）',
      time: '01-30 16:00 开始',
      status: '未验票',
      price: '￥100 x 10',
      idNo: '460009898989899779',
      gender: '男',
      phone: '13337663721',
      uid: '1433'
    },
    {
      id: '6',
      img: 'http://yanxuan.nosdn.127.net/3011d972cb4c1e72f38b9838dac7e21c.jpg?imageView&thumbnail=78x78&quality=95',
      title: 'A票男生票C区20男生票C区',
      name: '花花（陈晓华）',
      time: '01-30 16:00 开始',
      status: '未验票',
      price: '￥100 x 10',
      idNo: '460009898989899779',
      gender: '男',
      phone: '13337663721',
      uid: '1433'
    },
  ]
  keyExtractor = (item, index) => {
    return item.id
  }
  onCall = (phone) => {
    Linking.openURL('tel:' + phone)
  }
  onJumpUserDetail = (id) => {
    Alert.alert(
      '跳转用户详情 id:' + id
    )
  }
  onJumpActivityDetail = (id) => {
    this.props.navigation.navigate('ActivityDetail')
  }
  onPullRelease(resolve) {
    //do something
    setTimeout(() => {
      resolve();
    }, 1000);
  }
  static navigationOptions = ({ navigation }) => {
    return {
      title: "活动报名管理",
      headerRight: <HeaderRight />,
    }
  }
  topIndicatorRender(pulling, pullok, pullrelease) {
    return (
      <View style={{ flexDirection: 'row', justifyContent: 'center', alignItems: 'center', height: 60 }}>
        <ActivityIndicator size="small" color="#1eb0fd" />
      </View>
    );
  }
  render() {
    return <View style={styles.container}>
      <View style={{ flex: 1 }}>
        <PullView onPullRelease={this.onPullRelease}
          topIndicatorRender={this.topIndicatorRender} >
          <Text style={styles.countLine}>
            <Text>报名人数：</Text>
            <Text style={{ fontWeight: 'bold', marginRight: px2dp(20) }}>{this.state.dataCount1}</Text>
            <Text>    预计收入：</Text>
            <Text style={{ fontWeight: 'bold' }}>{this.state.dataCount2}</Text>
          </Text>
          <FlatList style={styles.list}
            keyExtractor={this.keyExtractor}
            data={this.state.dataList}
            renderItem={({ item }) =>
              <View style={styles.item}>

                <TouchableWithoutFeedback onPress={() => { this.onJumpUserDetail(item.uid) }}>
                  <Image
                    style={styles.img}
                    source={{ uri: item.img }}
                  />
                </TouchableWithoutFeedback>
                <View style={styles.middle}>
                  <Text style={styles.name}>{item.name}</Text>
                  <Text style={styles.title}>{item.title}</Text>
                  <Text style={styles.price}>{item.price}</Text>
                  <View style={styles.option}>
                    {
                      item.gender ? <Text style={styles.gender}>{item.gender}</Text> : null
                    }
                    {
                      item.idNo ? <Text style={styles.idNo}>{item.idNo}</Text> : null
                    }
                  </View>
                </View>

                <View style={styles.right}>
                  <TouchableWithoutFeedback onPress={() => { this.onCall(item.phone) }}>
                    <View style={styles.callContainer}>
                      <Image style={styles.call} source={require('../static/image/rn_ic_phone.png')} />
                    </View>
                  </TouchableWithoutFeedback>
                  <Text style={[styles.button, this.activeStatus.indexOf(item.status) > -1 ? styles.buttonEnable : null]}>{item.status}</Text>
                </View>
              </View>}
          />
        </PullView>
      </View>
      <TouchableWithoutFeedback onPress={() => { this.onJumpActivityDetail(1111) }}>
        <View><Text style={styles.bottomButton}>查看活动详情</Text></View>
      </TouchableWithoutFeedback>
    </View >
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    flexDirection: 'column',
    backgroundColor: '#ffffff',
  },
  countLine: {
    flexDirection: 'row',
    marginLeft: px2dp(30),
    marginRight: px2dp(30),
    marginTop: px2dp(60),
    paddingBottom: px2dp(30),
    borderBottomWidth: px2dp(1),
    borderColor: '#E5E5E5',
    fontSize: px2dp(28),
    color: '#333333',
  },
  list: {
    flex: 1,
    marginLeft: px2dp(30),
    marginRight: px2dp(30),
  },
  item: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingTop: px2dp(30),
    paddingBottom: px2dp(28),
    borderBottomWidth: px2dp(1),
    borderColor: '#E5E5E5'
  },
  img: {
    height: px2dp(76),
    width: px2dp(76),
    borderRadius: px2dp(38)
  },
  middle: {
    marginLeft: px2dp(21),
    flexDirection: 'column',
    width: px2dp(460)
  },
  name: {
    flex: 1,
    color: '#333333',
    fontSize: px2dp(28),
    lineHeight: px2dp(30),
    height: px2dp(28),
    marginBottom: px2dp(16)
  },
  title: {
    flex: 1,
    color: '#666666',
    fontSize: px2dp(28),
    lineHeight: px2dp(30),
    height: px2dp(28),
    marginBottom: px2dp(16)
  },
  price: {
    flex: 1,
    color: '#666666',
    fontSize: px2dp(28),
    lineHeight: px2dp(30),
    height: px2dp(28),
  },
  option: {
    flexDirection: 'row',
  },
  gender: {
    fontSize: px2dp(28),
    lineHeight: px2dp(30),
    height: px2dp(28),
    marginRight: px2dp(24),
    marginTop: px2dp(16)
  },
  idNo: {
    fontSize: px2dp(28),
    lineHeight: px2dp(30),
    height: px2dp(28),
    marginTop: px2dp(16)
  },
  right: {
    flex: 1,
    flexDirection: 'column',
    justifyContent: 'space-between',
    alignItems: 'flex-end',
  },
  callContainer: {
    width: px2dp(84),
    height: px2dp(84),
    alignItems: 'flex-end',
    paddingRight: px2dp(10),
  },
  call: {
    height: px2dp(50),
    width: px2dp(50),
  },
  button: {
    height: px2dp(38),
    lineHeight: px2dp(38),
    width: px2dp(109),
    borderRadius: px2dp(6),
    borderWidth: px2dp(0.8),
    fontSize: px2dp(20),
    textAlign: 'center',
    color: '#999999',
    borderColor: '#999999'
  },
  buttonEnable: {
    color: '#1EB0FD',
    borderColor: '#1EB0FD'
  },
  bottomButton: {
    height: px2dp(100),
    lineHeight: px2dp(100),
    textAlign: 'center',
    backgroundColor: '#F9F9F9',
    fontSize: px2dp(30),
    color: '#1EB0FD'
  },
  scanImg: {
    width: px2dp(30),
    height: px2dp(29),
    marginRight: px2dp(20)
  },
  scanText: {
    fontSize: px2dp(32),
    color: '#333333',
    marginRight: px2dp(30)
  }
})