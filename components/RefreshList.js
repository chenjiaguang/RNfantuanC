import React, {
  Component,
} from 'react';
import {
  Easing,
  View,
  Image,
  Animated,
  Text,
  ActivityIndicator,
  Platform
} from 'react-native';
import PullToRefreshListView from 'react-native-smart-pull-to-refresh-listview';
import px2dp from '../lib/px2dp'
import RotateImageView from '../modules/ImageView'


/**
 * 下拉刷新组件
 * 需要转入以下字段
 * style
 * keyExtractor
 * renderRow
 * dataSource
 * onRefresh
 * onLoadMore
 */
class RefreshList extends Component {
  constructor(props) {
    super(props)
    this.state = {
      rotateValue: new Animated.Value(0),
      isEnd: false
    }
  }
  beginRefresh = () => {
    this.pullToRefreshListView.beginRefresh()
  }
  endRefresh = () => {
    this.pullToRefreshListView.endRefresh()
  }
  endLoadMore = (b) => {
    this.setState({
      isEnd: b
    })
    this.pullToRefreshListView.endLoadMore(b)
  }
  componentDidMount = () => {
    this.startAnimation()
  }
  startAnimation() {
    this.state.rotateValue.setValue(0);
    Animated.parallel([
      Animated.timing(this.state.rotateValue, {
        toValue: 10,  //角度从0变1
        duration: 5000,  //从0到1的时间
        easing: Easing.out(Easing.linear),//线性变化，匀速旋转
      }),
    ]).start(() => this.startAnimation());
  }
  renderHeader = (viewState) => {
    let { pullState } = viewState
    let { refresh_none, refresh_idle, will_refresh, refreshing, } = PullToRefreshListView.constants.viewState
    if (pullState == refreshing || pullState == refresh_none) {
      return (
        <View style={{ flexDirection: 'row', height: px2dp(74), justifyContent: 'center', alignItems: 'center' }}>
          {
            Platform.OS === 'android' ?
              <RotateImageView style={{ height: px2dp(44), width: px2dp(44) }} type={0} /> :
              <Animated.Image source={require('../static/image/rn_ic_fan_header_refreshing.png')}
                style={{
                  width: px2dp(44),
                  height: px2dp(44),
                  transform: [
                    //使用interpolate插值函数,实现了从数值单位的映
                    //射转换,上面角度从0到1，这里把它变成0-360的变化
                    {
                      rotateZ: this.state.rotateValue.interpolate({
                        inputRange: [0, 10],
                        outputRange: ['0deg', '3600deg'],
                      })
                    },
                  ]
                }}>
              </Animated.Image>
          }
        </View>
      )
    } else {
      return (
        <View style={{ flexDirection: 'row', height: px2dp(74), justifyContent: 'center', alignItems: 'center' }}>
          <Image style={{ height: px2dp(44), width: px2dp(44) }} source={require('../static/image/rn_ic_fan_header_noraml.png')} />
        </View>
      )
    }
  }
  renderFooter = (viewState) => {
    return (!this.state.isEnd ?
      <View style={{ flexDirection: 'row', height: px2dp(74), justifyContent: 'center', alignItems: 'center' }}>
        {
          Platform.OS === 'android' ?
            <RotateImageView style={{ height: px2dp(44), width: px2dp(44) }} type={0} /> :
            <Animated.Image source={require('../static/image/rn_ic_fan_header_refreshing.png')}
              style={{
                width: px2dp(44),
                height: px2dp(44),
                transform: [
                  //使用interpolate插值函数,实现了从数值单位的映
                  //射转换,上面角度从0到1，这里把它变成0-360的变化
                  {
                    rotateZ: this.state.rotateValue.interpolate({
                      inputRange: [0, 10],
                      outputRange: ['0deg', '3600deg'],
                    })
                  },
                ]
              }}>
            </Animated.Image>
        }<Text> 正在加载...</Text>
      </View> :
      null
    )
  }
  render() {
    return <PullToRefreshListView
      {...this.props}
      ref={(component) => this.pullToRefreshListView = component}
      viewType={PullToRefreshListView.constants.viewType.listView}
      renderHeader={this.renderHeader}
      renderFooter={this.renderFooter}
      pullUpDistance={px2dp(74)}
      pullUpStayDistance={px2dp(74)}
      pullDownDistance={px2dp(74)}
      pullDownStayDistance={px2dp(74)}
      pageSize={20}
      initialListSize={20}
      onEndReachedThreshold={200}
      enableEmptySections={true}
      autoLoadMore={true}
    />;
  }
};

export default RefreshList;