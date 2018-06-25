import React from "react";
import {
  FlatList,
  Text,
  View,
  Image,
  StyleSheet,
  TouchableWithoutFeedback,
  Alert
} from 'react-native';
import px2dp from '../lib/px2dp'
import ActivityEmpty from '../components/ActivityEmpty'
import JumpNativeModule from '../modules/JumpNativeModule'

export default class ActivitysJoined extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      dataList: [],
      activeStatus: [
        '待参与'
      ]
    }
  }
  onJumpActivityCodeDetail = (id) => {
    JumpNativeModule && JumpNativeModule.activityCodeDetail(id)
  }
  componentDidMount() {
    this.getData()
  }
  getData = () => {
    let rData = {
    }
    _FetchData(_Api + '/jv/qz/v21/activity/myjoined', rData).then(res => {
      this.setState({
        dataList: this.state.dataList.concat(res.data.list)
      })
    }).catch(err => {
    })
  }
  static navigationOptions = ({ navigation }) => {
    return {
      title: "我参加的活动"
    }
  }
  render() {
    return <View style={styles.container}>
      {
        (this.state.dataList && this.state.dataList.length > 0) ?
          <FlatList style={styles.list}
            keyExtractor={(item) => item.id}
            data={this.state.dataList}
            renderItem={({ item }) =>
              <TouchableWithoutFeedback onPress={() => this.onJumpActivityCodeDetail(item.id)}>
                <View style={styles.item}>
                  <Image
                    style={styles.img}
                    source={{ uri: item.covers[0].compress }}
                  />
                  <View style={styles.right}>

                    <View style={styles.rightTop}>
                      <Text style={styles.title} numberOfLines={2}>{item.title}</Text>
                      <Text style={[styles.status, this.state.activeStatus.indexOf(item.status_text) > -1 ? styles.statusEnable : null]}>{item.status_text}</Text>
                    </View>

                    <View style={styles.rightBottom}>

                      <View style={styles.rightBottomLeft}>
                        <Text style={styles.time}>{item.time_text}</Text>
                        <Text style={styles.price}>{item.money_text}</Text>
                      </View>
                      <Text style={[styles.button, this.state.activeStatus.indexOf(item.status_text) > -1 ? styles.buttonEnable : null]}>查看券码</Text>
                    </View>
                  </View>
                </View>
              </TouchableWithoutFeedback>}
          /> :
          <ActivityEmpty mode={0} />
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
    marginRight: px2dp(1),
    borderRadius: px2dp(6),
    borderWidth: px2dp(0.8),
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