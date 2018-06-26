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
import px2dp from '../lib/px2dp'
import ActivityEmpty from '../components/ActivityEmpty'
import FantToastModule from '../modules/FantToastModule'

class HeaderRight extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
    }
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
      dataList: [],
      activeStatus: [
        '报名中',
        '审核中'
      ],
      loaded: false
    }
  }
  onJumpActivitysSignUpManagement = (id) => {
    this.props.navigation.navigate('ActivitysSignUpManagement', { aid: id })
  }
  static navigationOptions = ({ navigation }) => {
    return {
      title: "我发起的活动",
      headerRight: <HeaderRight />,
    }
  }
  getData = () => {
    let rData = {
    }
    _FetchData(_Api + '/jv/qz/v21/activity/mypublished', rData).then(res => {
      this.setState({
        dataList: this.state.dataList.concat(res.data.list),
        loaded: true
      })
    }).catch(err => {
    })
  }
  componentDidMount() {
    this.getData()
  }
  render() {
    return <View style={styles.container}>
      {
        this.state.loaded ?
          (this.state.dataList && this.state.dataList.length > 0) ?
            <FlatList style={styles.list}
              keyExtractor={(item) => item.id}
              data={this.state.dataList}
              renderItem={({ item }) =>
                <TouchableWithoutFeedback onPress={() => this.onJumpActivitysSignUpManagement(item.id)}>
                  <View style={styles.item}>
                    <Image
                      style={styles.img}
                      source={{ uri: item.covers[0].compress }}
                    />
                    <View style={styles.right}>


                      <Text style={styles.title} numberOfLines={2}>{item.title}</Text>

                      <View style={styles.rightBottom}>

                        <View style={styles.rightBottomLeft}>
                          <Text style={styles.time}>{item.time_text}</Text>
                          <Text style={styles.price}>{item.money}</Text>
                        </View>
                        <Text style={[styles.button, this.state.activeStatus.indexOf(item.status_text) > -1 ? styles.buttonEnable : null]}>{item.status_text}</Text>
                      </View>
                    </View>
                  </View>
                </TouchableWithoutFeedback>
              }
            /> :
            <ActivityEmpty mode={1} />
          : null
      }

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
    lineHeight: px2dp(22),
    height: px2dp(20),
    marginBottom: px2dp(24),
    color: '#999999',
  },
  price: {
    fontSize: px2dp(24),
    lineHeight: px2dp(26),
    height: px2dp(24),
    color: '#FF3F53',
  },
  button: {
    height: px2dp(38),
    lineHeight: px2dp(40),
    width: px2dp(109),
    borderRadius: px2dp(6),
    borderWidth: px2dp(1),
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