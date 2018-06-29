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
  ActivityIndicator,
  ListView,
  Animated,
  Easing
} from 'react-native';
import px2dp from '../lib/px2dp'
import GoNativeModule from '../modules/GoNativeModule'
import RefreshFlatList from '../components/RefreshFlatList'
import RoundBorderView from '../components/RoundBorderView'

class HeaderRight extends React.Component {
  constructor(props) {
    super(props)
    this.state = {}
  }
  onScan = () => {
    GoNativeModule.goActivityCodeScan(this.props.aid)
  }
  render = () => {
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
      pn: 1,
      isend: false,
      refreshing: false,
      refreshState: 0,
      data: null,
      dataCount1: "0",
      dataCount2: "0",
      aid: this.props.navigation.state.params.aid,
      activeStatus: [
        '未验票'
      ],
    }
  }
  onCall = (phone) => {
    Linking.openURL('tel:' + phone)
  }
  onJumpUserDetail = (id) => {
    GoNativeModule && GoNativeModule.goUserDetail(id)
  }
  onJumpActivityDetail = (id) => {
    this.props.navigation.navigate('ActivityDetail', { id: id })
  }
  static navigationOptions = ({ navigation }) => {
    return {
      title: "活动报名管理",
      headerRight: <HeaderRight aid={navigation.state.params.aid} />,
    }
  }
  componentDidMount = () => {
    //  this.pullToRefreshListView.beginRefresh()
    this.onRefresh()
  }
  renderRow = (info) => {
    let item = info.item
    let rowID = info.index
    return (
      rowID == 0 ?
        <View>
          <Text style={styles.countLine}>
            <Text>报名人数：</Text>
            <Text style={{ fontWeight: 'bold', marginRight: px2dp(20) }}>{this.state.dataCount1}</Text>
            <Text>    预计收入：</Text>
            <Text style={{ fontWeight: 'bold' }}>{this.state.dataCount2}</Text>
          </Text>
        </View> :
        <View style={styles.item}>

          <TouchableWithoutFeedback onPress={() => { this.onJumpUserDetail(item.uid) }}>
            <Image
              style={styles.img}
              source={{ uri: item.avatar }}
            />
          </TouchableWithoutFeedback>
          <View style={styles.middle}>
            <Text style={styles.name}>{item.display_name}</Text>
            <Text style={styles.title}>{item.feename}</Text>
            <Text style={styles.price}>{item.money_text}</Text>
            <View style={styles.option}>
              {
                item.sex ? <Text style={styles.gender}>{item.sex}</Text> : null
              }
              {
                item.idcard ? <Text style={styles.idNo}>{item.idcard}</Text> : null
              }
            </View>
          </View>

          <View style={styles.right}>
            <TouchableWithoutFeedback onPress={() => { this.onCall(item.phone) }}>
              <View style={styles.callContainer}>
                <Image style={styles.call} source={require('../static/image/rn_ic_phone.png')} />
              </View>
            </TouchableWithoutFeedback>
            <RoundBorderView
              borderWidth={px2dp(1)}
              borderRadius={px2dp(6)}
              fantBorderColor={this.state.activeStatus.indexOf(item.state_text) > -1 ? '#1EB0FD' : '#999999'}
              style={[styles.button, this.state.activeStatus.indexOf(item.state_text) > -1 ? styles.buttonEnable : null]}>
              <Text style={[styles.buttonText, this.state.activeStatus.indexOf(item.state_text) > -1 ? styles.buttonTextEnable : null]}>{item.state_text}</Text>
            </RoundBorderView>
          </View>
        </View>
    )
  }
  onRefresh = () => {
    this.onFetch(1)
  }
  onLoadMore = () => {
    this.onFetch(this.state.pn + 1)
  }
  onFetch = (pn) => {
    let rData = {
      id: this.state.aid,
      pn: pn
    }
    _FetchData(_Api + '/jv/qz/v21/activity/joined', rData).then(res => {
      this.pullToRefreshListView.setLoaded(res.data.paging.is_end)
      let data
      if (pn == 1) {
        data = [{ uid: '-1' }].concat(res.data.list)
      } else {
        data = this.state.data.concat(res.data.list)
      }
      this.setState({
        pn: pn,
        dataCount1: res.data.summary.ticket_count,
        dataCount2: res.data.summary.income,
        data: data,
      })
    }, err => {
      this.pullToRefreshListView.setLoaded(true)
    }).catch(err => {
      this.pullToRefreshListView.setLoaded(true)
    })
  }
  render() {
    return <View style={styles.container}>
      <View style={{ flex: 1 }}>
        <RefreshFlatList
          ref={(component) => this.pullToRefreshListView = component}
          style={styles.list}
          onLoadMore={this.onLoadMore}
          onRefresh={this.onRefresh}
          data={this.state.data}
          keyExtractor={(i) => i.uid}
          renderItem={this.renderRow}
        />
      </View>
      <TouchableWithoutFeedback onPress={() => { this.onJumpActivityDetail(this.state.aid) }}>
        <View><Text style={styles.bottomButton}>查看活动详情</Text></View>
      </TouchableWithoutFeedback>
    </View>
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
  },
  item: {
    flex: 1,
    marginLeft: px2dp(30),
    marginRight: px2dp(30),
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
    marginBottom: px2dp(16),
    includeFontPadding: false,
  },
  title: {
    flex: 1,
    color: '#666666',
    fontSize: px2dp(28),
    marginBottom: px2dp(16),
    includeFontPadding: false,
  },
  price: {
    flex: 1,
    color: '#666666',
    fontSize: px2dp(28),
    includeFontPadding: false,
  },
  option: {
    flexDirection: 'row',
  },
  gender: {
    fontSize: px2dp(28),
    marginRight: px2dp(24),
    marginTop: px2dp(16),
    includeFontPadding: false,
  },
  idNo: {
    fontSize: px2dp(28),
    marginTop: px2dp(16),
    includeFontPadding: false,
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
    width: px2dp(109),
    borderRadius: px2dp(6),
    borderWidth: px2dp(1),
    borderColor: '#999999'
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