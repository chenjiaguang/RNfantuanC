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
  ListView
} from 'react-native';
import px2dp from '../lib/px2dp'
import PullToRefreshListView from 'react-native-smart-pull-to-refresh-listview';
import JumpNativeModule from '../modules/JumpNativeModule'

class HeaderRight extends React.Component {
  constructor(props) {
    super(props)
    this.state = {}
  }
  onScan = () => {
    JumpNativeModule.activityCodeScan()
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
  defaultData = [{
    //第一个留空，用于渲染头部统计数据
  }]
  constructor(props) {
    super(props)
    this.state = {
      refreshState: 0,
      data: this.defaultData,
      dataList: (new ListView.DataSource({ rowHasChanged: (r1, r2) => r1 !== r2 })).cloneWithRows(this.defaultData),
      dataCount1: "0",
      dataCount2: "0",
      aid: this.props.navigation.state.params.aid,
      pn: 1,
      activeStatus: [
        '未验票'
      ],
    }
  }
  keyExtractor = (item, index) => {
    return item.uid
  }
  onCall = (phone) => {
    Linking.openURL('tel:' + phone)
  }
  onJumpUserDetail = (id) => {
    JumpNativeModule && JumpNativeModule.userDetail(id)
  }
  onJumpActivityDetail = (id) => {
    this.props.navigation.navigate('ActivityDetail')
  }
  static navigationOptions = ({ navigation }) => {
    return {
      title: "活动报名管理",
      headerRight: <HeaderRight />,
    }
  }
  componentDidMount = () => {
    this._pullToRefreshListView.beginRefresh()
  }
  _renderHeader = (viewState) => {
    return (
      <View style={{ flexDirection: 'row', justifyContent: 'center', alignItems: 'center', height: 60 }}>
        <ActivityIndicator size="small" color="#1eb0fd" />
      </View>
    );
  }
  _renderRow = (item, sectionID, rowID) => {
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
            <Text style={[styles.button, this.state.activeStatus.indexOf(item.state_text) > -1 ? styles.buttonEnable : null]}>{item.state_text}</Text>
          </View>
        </View>
    )
  }
  _onRefresh = () => {
    this.getData(1)
  }
  getData = (pn) => {
    let rData = {
      id: this.state.aid,
      pn: pn
    }
    _FetchData(_Api + '/jv/qz/v21/activity/joined', rData).then(res => {
      this._pullToRefreshListView.endRefresh()
      let data
      if (pn == 1) {
        data = this.defaultData.concat(res.data.list)
      } else {
        data = this.state.data.concat(res.data.list)
      }
      this.setState({
        pn: pn,
        dataCount1: res.data.summary.ticket_count,
        dataCount2: res.data.summary.income,
        data: data,
        dataList: (new ListView.DataSource({ rowHasChanged: (r1, r2) => r1 !== r2 })).cloneWithRows(data),
      })
    }, err => {
      // 绑定出错
      this._pullToRefreshListView.endRefresh()
    }).catch(err => {
      this._pullToRefreshListView.endRefresh()
    })
  }
  render() {
    return <View style={styles.container}>
      <View style={{ flex: 1 }}>
        <PullToRefreshListView
          ref={(component) => this._pullToRefreshListView = component}
          viewType={PullToRefreshListView.constants.viewType.listView}
          style={styles.list}
          keyExtractor={this.keyExtractor}
          renderRow={this._renderRow}
          renderHeader={this._renderHeader}
          dataSource={this.state.dataList}
          onRefresh={this._onRefresh}
          pullUpDistance={35}
          pullUpStayDistance={50}
          pullDownDistance={35}
          pullDownStayDistance={50}
          pageSize={20}
          initialListSize={20}
          enableEmptySections={true}
        />
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
    marginTop: px2dp(60),
    paddingBottom: px2dp(30),
    borderBottomWidth: px2dp(1),
    borderColor: '#E5E5E5',
    fontSize: px2dp(28),
    color: '#333333',
  },
  list: {
    flex: 1,
    paddingLeft: px2dp(30),
    paddingRight: px2dp(30),
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