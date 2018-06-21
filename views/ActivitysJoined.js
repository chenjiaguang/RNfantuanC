import React from "react";
import {
  FlatList,
  Text,
  View,
  Image,
  StyleSheet
} from 'react-native';
import RefreshListView from 'react-native-refresh-list-view'
import px2dp from '../lib/px2dp'

export default class ActivitysJoined extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      refreshState: 0,
      dataList: [
        {
          id: 0,
          img: 'http://yanxuan.nosdn.127.net/3011d972cb4c1e72f38b9838dac7e21c.jpg?imageView&thumbnail=78x78&quality=95',
          title: '啤酒与烧烤，夏日里的绝佳搭配 沙滩BBQ，不要太馋人哦~',
          time: '01-30 16:00 开始',
          status: '已结束',
          price: '￥100 x 10'
        },
      ]
    }
  }
  keyExtractor = (item, index) => item.id;
  onHeaderRefresh = () => {
    this.setState({ refreshState: 1 })
    setTimeout(() => {
      this.setState({
        dataList: [
          {
            id: 0,
            img: 'http://yanxuan.nosdn.127.net/3011d972cb4c1e72f38b9838dac7e21c.jpg?imageView&thumbnail=78x78&quality=95',
            title: '啤酒与烧烤，夏日里的绝佳搭配 沙滩BBQ，不要太馋人哦~',
            time: '01-30 16:00 开始',
            status: '已结束',
            price: '￥100 x 10'
          },
        ]
      })
      this.setState({ refreshState: 0 })
    }, 1000);
  }
  static navigationOptions = ({ navigation }) => {
    return {
      title: "我参加的活动"
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

              <View style={styles.rightTop}>
                <Text style={styles.title}>{item.title}</Text>
                <Text style={styles.status}>{item.status}</Text>
              </View>

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
    borderColor: '#E5E5E5',
  },
  img: {
    height: px2dp(90),
    width: px2dp(90)
  },
  right: {
    flex: 1,
    marginLeft: px2dp(21),
    flexDirection: 'column',
  },
  rightTop: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
  },
  title: {
    width: px2dp(483),
    fontSize: px2dp(30),
    marginTop: px2dp(-2),
    lineHeight: px2dp(34),
    marginBottom: px2dp(24),
    color: '#333333'
  },
  status: {
    fontSize: px2dp(24),
    // marginTop: px2dp(-1),
    lineHeight: px2dp(26),
    textAlign: 'center',
    color: '#999999'
  },
  statusEnable: {
    color: '#FF691F'
  },
  rightBottom: {
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-end',
  },
  rightBottomLeft: {
    width: px2dp(400),
    flexDirection: 'column',
    justifyContent: 'flex-end',
  },
  time: {
    fontSize: px2dp(24),
    lineHeight: px2dp(24),
    height: px2dp(24),
    marginBottom: px2dp(16),
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
    width: px2dp(106),
    marginRight:px2dp(1),
    borderRadius: px2dp(6),
    borderWidth: px2dp(1),
    fontSize: px2dp(20),
    textAlign: 'center',
    color: '#999999',
    borderColor: '#999999',
  },
  buttonEnable: {
    color: '#1EB0FD',
    borderColor: '#1EB0FD'
  }
})