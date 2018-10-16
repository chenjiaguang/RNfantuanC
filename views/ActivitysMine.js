import React from "react";
import {
  View,
  Image,
  StyleSheet,
  TouchableWithoutFeedback,
  TouchableHighlight,
  TouchableOpacity,
  Alert,
  Linking
} from 'react-native';
import px2dp from '../lib/px2dp'
import ActivityEmpty from '../components/ActivityEmpty'
import RefreshFlatList from '../components/RefreshFlatList'
import RoundBorderView from '../components/RoundBorderView'
import Text from '../components/MyText'
import FantTouchableHighlight from '../components/FantTouchableHighlight'
import NoNetwork from '../components/NoNetwork'
import Util from '../lib/Util'

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
          text: '取消', onPress: () => { }, style: { color: '#0076FF' }
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
      pn: 1,
      data: null,
      activeStatus: [
        '报名中',
        '审核中'
      ],
      netError: false
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
  onNetReload = () => {
    this.setState({
      netError: false,
    })
    setTimeout(this.onFetch, 0)
  }
  onNetError = (err, pn) => {
    if (pn == 1) {
      this.setState({
        netError: true,
        data: null
      })
    } else {
      Util.showNetworkErrorToast()
    }
  }
  onRefresh = () => {
    this.onFetch(1)
  }
  onLoadMore = () => {
    this.onFetch(this.state.pn + 1)
  }
  onFetch = (pn = 1) => {
    let rData = {
      pn: pn
    }
    this.pullToRefreshListView.startFetching()
    _FetchData(_Api + '/jv/qz/v21/activity/mypublished', rData, { onNetError: (err) => this.onNetError(err, pn) }).then(res => {
      this.pullToRefreshListView.endFetching(res.data.paging.is_end)
      let data
      if (pn == 1) {
        data = res.data.list
      } else {
        data = this.state.data.concat(res.data.list)
      }
      this.setState({
        pn: pn,
        data: data,
        netError: false
      })
    }).catch(err => {
      this.pullToRefreshListView.endFetching()
    })
  }
  componentDidMount = () => {
    this.onRefresh()
  }
  renderItem = ({ item }) => {
    let active = this.state.activeStatus.indexOf(item.status_text) > -1
    return (<FantTouchableHighlight
      onPress={() => this.onJumpActivitysSignUpManagement(item.id)}>
      <View style={styles.itemContainer}>
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
              <RoundBorderView
                fantBorderColor={active ? '#1EB0FD' : '#999999'}
                style={[styles.button, active ? styles.buttonEnable : null]}>
                <Text style={[styles.buttonText, active ? styles.buttonTextEnable : null]}>{item.status_text}</Text>
              </RoundBorderView>
            </View>
          </View>
        </View>
      </View>
    </FantTouchableHighlight>)
  }
  render() {
    return <View style={styles.container}>
      {
        (!this.state.netError) ?
          ((this.state.data != null && this.state.data.length == 0) ? <ActivityEmpty mode={1} /> :
            <RefreshFlatList style={styles.list}
              ref={(component) => this.pullToRefreshListView = component}
              onLoadMore={this.onLoadMore}
              onRefresh={this.onRefresh}
              keyExtractor={(item) => item.id}
              data={this.state.data}
              renderItem={this.renderItem}
            />) :
          <NoNetwork reload={this.onNetReload} />
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
  },
  itemContainer: {
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
    marginBottom: px2dp(24),
    color: '#999999',
    includeFontPadding: false,
  },
  price: {
    fontSize: px2dp(24),
    color: '#FF3F53',
    includeFontPadding: false,
  },
  button: {
    height: px2dp(38),
    width: px2dp(109),
    borderRadius: px2dp(6),
    borderWidth: px2dp(1),
    borderColor: '#999999',
    alignItems: 'center',
    justifyContent: 'center',
    paddingTop: 0
  },
  buttonEnable: {
    borderColor: '#1EB0FD'
  },
  buttonText: {
    textAlign: 'center',
    fontSize: px2dp(20),
    color: '#999999',
  },
  buttonTextEnable: {
    color: '#1EB0FD',
  }
})