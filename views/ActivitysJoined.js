import React from "react";
import {
  Text,
  View,
  Image,
  StyleSheet,
  TouchableWithoutFeedback,
} from 'react-native';
import px2dp from '../lib/px2dp'
import ActivityEmpty from '../components/ActivityEmpty'
import GoNativeModule from '../modules/GoNativeModule'
import RefreshFlatList from '../components/RefreshFlatList'
import RoundBorderView from '../components/RoundBorderView'

export default class ActivitysJoined extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      pn: 1,
      data: null,
      activeStatus: [
        '待参与'
      ],
      loaded: false
    }
  }
  onJumpActivityCodeDetail = (code) => {
    GoNativeModule && GoNativeModule.goActivityCodeDetail(code)
  }
  componentDidMount() {
    this.onRefresh()
  }
  onRefresh = () => {
    this.onFetch(1)
  }
  onLoadMore = () => {
    this.onFetch(this.state.pn + 1)
  }
  onFetch = (pn) => {
    let rData = {
      pn: pn
    }
    _FetchData(_Api + '/jv/qz/v21/activity/myjoined', rData).then(res => {
      this.pullToRefreshListView.setLoaded(res.data.paging.is_end)
      let data
      if (pn == 1) {
        data = res.data.list
      } else {
        data = this.state.data.concat(res.data.list)
      }
      this.setState({
        pn: pn,
        data: data,
        loaded: true
      })
    }).catch(err => {
      this.pullToRefreshListView.setLoaded(true)
    })
  }
  static navigationOptions = ({ navigation }) => {
    return {
      title: "我参加的活动"
    }
  }
  renderItem = ({ item }) => {
    let active = this.state.activeStatus.indexOf(item.status_text) > -1
    return (<TouchableWithoutFeedback onPress={() => this.onJumpActivityCodeDetail(item.check_code)}>
      <View style={styles.item}>
        <Image
          style={styles.img}
          source={{ uri: item.covers[0].compress }}
        />
        <View style={styles.right}>

          <View style={styles.rightTop}>
            <Text style={styles.title} numberOfLines={2}>{item.title}</Text>
            <Text style={[styles.status, active ? styles.statusEnable : null]}>{item.status_text}</Text>
          </View>

          <View style={styles.rightBottom}>

            <View style={styles.rightBottomLeft}>
              <Text style={styles.time}>{item.time_text}</Text>
              <Text style={styles.price}>{item.money_text}</Text>
            </View>
            <RoundBorderView
              fantBorderColor={active ? '#1EB0FD' : '#999999'}
              style={[styles.button, active ? styles.buttonEnable : null]}>
              <Text style={[styles.buttonText, active ? styles.buttonTextEnable : null]}>查看券码</Text>
            </RoundBorderView>
          </View>
        </View>
      </View>
    </TouchableWithoutFeedback>)

  }
  render() {
    return <View style={styles.container}>
      {
        this.state.loaded == true && (this.state.data == null || this.state.data.length == 0) ?
          <ActivityEmpty mode={0} /> :
          <RefreshFlatList style={styles.list}
            ref={(component) => this.pullToRefreshListView = component}
            onLoadMore={this.onLoadMore}
            onRefresh={this.onRefresh}
            keyExtractor={(item) => item.id}
            data={this.state.data}
            renderItem={this.renderItem}
          />
      }
    </View>

  }
}
StyleSheet.flatten

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#ffffff',
  },
  list: {
    flex: 1,
  },
  item: {
    flex: 1,
    marginLeft: px2dp(30),
    marginRight: px2dp(30),
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
    includeFontPadding: false,
    marginBottom: px2dp(16),
    color: '#999999',
  },
  price: {
    fontSize: px2dp(24),
    includeFontPadding: false,
    color: '#FF3F53',
  },
  button: {
    height: px2dp(38),
    width: px2dp(106),
    marginRight: px2dp(1),
    borderRadius: px2dp(6),
    borderWidth: px2dp(1),
    borderColor: '#999999',
  },
  buttonEnable: {
    borderColor: '#1EB0FD'
  },
  buttonText: {
    lineHeight: px2dp(36),
    fontSize: px2dp(20),
    textAlign: 'center',
    color: '#999999',
  },
  buttonTextEnable: {
    color: '#1EB0FD',
  },
})