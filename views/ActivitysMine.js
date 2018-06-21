import React from "react";
import {
  FlatList,
  Text,
  View,
  Image,
  StyleSheet,
  TouchableWithoutFeedback,
  Alert,
  Linking
} from 'react-native';
import RefreshListView from 'react-native-refresh-list-view'
import px2dp from '../lib/px2dp'

class HeaderRight extends React.Component {
  constructor(props) {
    super(props)
    this.state = {}
  }
  onCall = () => {
    Alert.alert(
      '有特殊原因需要关闭活动请联系 客服处理',
      '客服电话：400-680-6307',
      [
        {
          text: '取消', onPress: () => console.log('Cancel Pressed'), style: { color: '#0076FF' }
        },
        {
          text: '拨打电话', onPress: () =>
            Linking.openURL('tel:' + '4006806307'), style: { color: '#0076FF' }
        },
      ]
    )
  }
  render() {
    return <TouchableWithoutFeedback disabled={false} onPress={this.onCall}>
      <Image style={{ width: px2dp(88), height: px2dp(90) }} source={require('../static/image/rn_ic_call.png')} />
    </TouchableWithoutFeedback>
  }
}
export default class ActivitysMine extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      refreshState: 0,
      dataList: this.data
    }
  }
  data = [
    {
      id: 0,
      img: 'http://yanxuan.nosdn.127.net/3011d972cb4c1e72f38b9838dac7e21c.jpg?imageView&thumbnail=78x78&quality=95',
      title: '啤酒与烧烤，夏日里的绝佳搭配 沙滩BBQ，不要太馋人哦~',
      time: '01-30 16:00 开始',
      status: '已结束',
      price: '￥100 x 10'
    },
  ]
  keyExtractor = (item, index) => item.id;

  onHeaderRefresh = () => {
    this.setState({ refreshState: 1 })
    setTimeout(() => {
      this.setState({
        dataList: this.data
      })
      this.setState({ refreshState: 0 })
    }, 1000);
  }
  static navigationOptions = ({ navigation }) => {
    return {
      title: "我发起的活动",
      headerRight: <HeaderRight />,
    }
  }
  render() {
    return <View style={styles.container}>
      <RefreshListView style={styles.list}
        refreshState={this.state.refreshState}
        onHeaderRefresh={this.onHeaderRefresh}
        keyExtractor={this.keyExtractor}
        data={this.state.dataList}
        renderItem={({ item }) =>
          <View style={styles.item}>
            <Image
              style={styles.img}
              source={{ uri: item.img }}
            />
            <View style={styles.right}>


              <Text style={styles.title}>{item.title}</Text>

              <View style={styles.rightBottom}>

                <View style={styles.rightBottomLeft}>
                  <Text style={styles.time}>{item.time}</Text>
                  <Text style={styles.price}>{item.price}</Text>
                </View>
                <Text style={styles.button}>查看券码</Text>
              </View>
            </View>
          </View>}
      />
    </View>

  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#ffffff',
  },
  list: {
    flex: 1,
    marginLeft: px2dp(30),
    marginRight: px2dp(30),
  },
  item: {
    flex: 1,
    flexDirection: 'row',
    paddingTop: px2dp(30),
    paddingBottom: px2dp(28),
    borderBottomWidth: px2dp(1),
    borderColor: '#E5E5E5'
  },
  img: {
    height: px2dp(138),
    width: px2dp(220)
  },
  right: {
    flex: 1,
    marginLeft: px2dp(21),
    flexDirection: 'column'
  },
  title: {
    flex: 1,
    fontSize: px2dp(26),
    marginTop: px2dp(-4 / 2),
    lineHeight: px2dp(26 + 4),
    marginBottom: px2dp(16 - 4 / 2),
    fontWeight: 'bold',
    color: '#333333'
  },
  rightBottom: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-end'
  },
  rightBottomLeft: {
    flexDirection: 'column',
    justifyContent: 'flex-end'
  },
  time: {
    fontSize: px2dp(20),
    lineHeight: px2dp(20),
    height: px2dp(20),
    marginBottom: px2dp(24),
    color: '#999999',
  },
  price: {
    fontSize: px2dp(24),
    lineHeight: px2dp(24),
    height: px2dp(24),
    color: '#FF3F53',
  },
  button: {
    height: px2dp(38),
    lineHeight: px2dp(38),
    width: px2dp(109),
    borderRadius: px2dp(6),
    borderWidth: px2dp(2),
    fontSize: px2dp(20),
    textAlign: 'center',
    color: '#999999',
    borderColor: '#999999'
  },
  buttonEnable: {
    color: '#1EB0FD',
    borderColor: '#1EB0FD'
  }
})