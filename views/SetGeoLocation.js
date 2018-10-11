import React from "react";
import {
  View,
  Image,
  StyleSheet,
  TouchableWithoutFeedback,
  Alert,
  Linking,
  FlatList,
  BackHandler
} from 'react-native';
import px2dp from '../lib/px2dp'
import ActivityEmpty from '../components/ActivityEmpty'
import RefreshFlatList from '../components/RefreshFlatList'
import RoundBorderView from '../components/RoundBorderView'
import Text from '../components/MyText'
import FantTouchableHighlight from '../components/FantTouchableHighlight'
import NoNetwork from '../components/NoNetwork'
import Util from '../lib/Util'
import Iconfont from '../components/cxicon/CXIcon';
import UtilsModule from '../modules/UtilsModule'
import LoadingView from '../components/LoadingView'
import RegionLoader from '../lib/RegionLoader'
import SwipBackModule from '../modules/SwipBackModule'

class HeaderRight extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
    }
  }
  onSubmit = async () => {
    await UtilsModule.setResult(this.props.locationName)
    // BackHandler.exitApp()
    Util.exitRn(2)
  }
  render() {
    return <TouchableWithoutFeedback disabled={this.props.submitTxtDisabled} onPress={this.onSubmit}>
      <View style={[styles.navBtnBox]}>
        <Text style={[styles.submitTxt, this.props.submitTxtDisabled ? styles.submitTxtDisabled : null]}>完成</Text>
      </View>
    </TouchableWithoutFeedback>
  }
}
class HeaderLeft extends React.Component {
  onCancel = () => {
    this.props.navigation.pop()
  }
  render() {
    return <TouchableWithoutFeedback onPress={this.onCancel}>
      <View style={[styles.navBtnBox]}>
        <Text style={[styles.cancelTxt]}>取消</Text>
      </View>
    </TouchableWithoutFeedback>
  }
}
class RegionView extends React.Component {
  constructor(props) {
    super(props)
  }
  render() {
    return <View style={{ flexDirection: 'column' }}>
      <FlatList
        ListHeaderComponent={() =>
          this.props.state.level == 0 ?
            <View>
              <Text style={styles.titleText}>定位到的位置</Text>
              {
                this.props.state.nativeGeoLocationName ?
                  <FantTouchableHighlight onPress={() => this.props.click({
                    n: this.props.state.nativeGeoLocationName,
                    e: true
                  })}>
                    <View style={styles.itemContainer} >
                      <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        <Iconfont name='location' size={px2dp(32)} color='#1eb0fd' style={styles.locationIcon} />
                        <Text style={styles.regionNameTxt}>{this.props.state.nativeGeoLocationName}</Text>
                      </View>
                      {(this.props.state.nativeGeoLocationName == this.props.state.selectName ?
                        <Iconfont name='select' size={px2dp(36)} color='#999999' style={styles.regionRightIcon} /> :
                        null)}
                    </View>
                  </FantTouchableHighlight> :
                  <View style={styles.itemContainer} >
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                      <LoadingView text={""} iconStyle={[styles.locationIcon]} />
                      <Text style={styles.regionNameTxt}>定位中…</Text>
                    </View>
                  </View>
              }
              <Text style={styles.titleText}>全部</Text>
            </View>
            : null
        }
        initialNumToRender={20}
        style={styles.list}
        data={this.props.state.list}
        keyExtractor={(item) => item.n}
        renderItem={({ item }) =>
          <FantTouchableHighlight onPress={() => this.props.click(item)}>
            <View style={styles.itemContainer} >
              <Text style={styles.regionNameTxt}>{item.n}</Text>
              {
                (!item.e) ?
                  <Iconfont name='go_forward' size={px2dp(20)} color='#999999' style={styles.regionRightIcon} /> :
                  (item.n == this.props.state.selectName ?
                    <Iconfont name='select' size={px2dp(36)} color='#999999' style={styles.regionRightIcon} /> :
                    null)
              }
            </View>
          </FantTouchableHighlight>
        }
      />
    </View>
  }
}
export default class SetGeoLocation extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      clicked: false,//防止点击多次的标记
      level: this.props.navigation.state.params.level ? this.props.navigation.state.params.level : 0,
      list: RegionLoader.load(this.props.navigation.state.params.beforeSelectsName),
      nativeGeoLocationName: '',//定位直接获取的完整地理位置名
      selectName: '',//当前页面被选中的名称
      beforeSelectsName: this.props.navigation.state.params.beforeSelectsName ? this.props.navigation.state.params.beforeSelectsName : [],//前面页面已被选中的名称
    }
  }

  componentDidMount() {
    if (this.state.level == '0') {
      this.getNativeGeoLocation()
    }
  }
  getNativeGeoLocation = async () => {
    let string = await UtilsModule.getGeoLocation()
    let [lng, lat] = JSON.parse(string)
    _FetchData(_Api + '/jv/address/geocode', {
      lng: lng, lat: lat
    }).then(res => {
      this.setState({
        nativeGeoLocationName: res.data.list.join(' ')
      })
    })
  }
  onClick = (item) => {
    let beforeSelectsName = [...this.state.beforeSelectsName]
    beforeSelectsName.push(item.n)
    if (item.e) {
      this.setState({
        selectName: item.n
      })
      this.props.navigation.setParams({ rightDisabled: false, locationName: beforeSelectsName.splice(-3).join(' ') })
    } else {
      if (!this.state.clicked) {
        //跳转 取消之前的选中
        this.setState({
          selectName: '',
          clicked: true
        })
        this.props.navigation.setParams({ rightDisabled: true })
        this.props.navigation.push('SetGeoLocation', { level: this.state.level + 1,  beforeSelectsName: beforeSelectsName })

        setTimeout(() => {
          this.setState({
            clicked: false
          })
        }, 1000);
      }
    }
  }
  static navigationOptions = ({ navigation }) => {
    let res = {
      title: "设置地区",
      headerRight: <HeaderRight submitTxtDisabled={navigation.getParam('rightDisabled', true)} locationName={navigation.getParam('locationName', '')} />,
    }
    if (!navigation.state.params.level) {
      res.headerLeft = <HeaderLeft navigation={navigation} />
    }
    return res;
  }
  render() {
    return <View style={{ backgroundColor: '#ffffff', flex: 1 }}>
      <RegionView state={this.state} navigation={this.props.navigation} click={this.onClick} />
    </View>
  }
}

const styles = StyleSheet.create({
  titleText: {
    paddingLeft: px2dp(40),
    paddingTop: px2dp(42),
    paddingBottom: px2dp(20),
    color: '#999999',
    fontSize: px2dp(26),
    backgroundColor: '#F2F2F2',
  },
  list: {
    backgroundColor: '#ffffff'
  },
  itemContainer: {
    height: px2dp(87),
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    borderBottomWidth: px2dp(1),
    borderColor: '#DCDDE0',
    paddingLeft: px2dp(40),
    paddingRight: px2dp(30)
  },
  regionNameTxt: {
    color: '#333333',
    fontSize: px2dp(36),
  },
  locationIcon: {
    width: px2dp(32),
    marginRight: px2dp(30),
  },
  regionRightIcon: {
  },
  submitTxt: {
    color: '#1EB0FD',
    fontSize: px2dp(32),
    paddingRight: px2dp(32),
    fontWeight: 'bold'
  },
  submitTxtDisabled: {
    color: '#D9D9D9',
  },
  cancelTxt: {
    color: '#333333',
    fontSize: px2dp(32),
    paddingLeft: px2dp(40),
  },
  navBtnBox: {
    alignSelf: 'stretch',
    flexDirection: 'row',
    alignItems: 'center',
  }
})