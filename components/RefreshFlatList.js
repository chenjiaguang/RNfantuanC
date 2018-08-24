
import React, {
  Component,
} from 'react'
import PropTypes from 'prop-types';
import {
  View,
  Image,
  Animated,
  requireNativeComponent,
  Platform,
  FlatList,
  ViewPropTypes,
  Easing
} from 'react-native'
import px2dp from '../lib/px2dp';
import LoadingView from '../components/LoadingView'
import {PullFlatList} from 'react-native-rk-pull-to-refresh'
import Text from '../components/MyText'
const refreshIcon = require('../static/image/rn_refresh_icon.png')
const refreshingIcon = require('../static/image/rn_refreshing_icon.png')
const RefreshFlatList = Platform.OS == 'ios' ? View : requireNativeComponent('RCTRefreshLayoutView', AndroidRefreshFlatList, {
  nativeOnly: { onRefresh: true, onLoadMore: true }
})

class AndroidRefreshFlatList extends Component {
  constructor(props) {
    super(props)
    this.state = {}
  }

  static propTypes = {
    ...View.propTypes,
    onRefresh: PropTypes.func,
    onLoadMore: PropTypes.func,
    refreshing: PropTypes.bool,
    isend: PropTypes.bool
  }

  setNativeProps = (props) => {
    if (this._nativeSwipeRefreshLayout.setNativeProps) {
      this._nativeSwipeRefreshLayout.setNativeProps(props)
    }
  }

  render() {
    return <View style={{ flex: 1 }}>
      {this.props.data ? null : <LoadingView style={{ height: px2dp(100), paddingTop: px2dp(32) }} />}
      <RefreshFlatList
        {...this.props}
        style={[this.props.style, { display: this.props.data ? 'flex' : 'none',backgroundColor:'#f5f5f5' }]}
        ref={(component) => this._nativeSwipeRefreshLayout = component}
        onLoadMore={this._onLoadMore}
        onRefresh={this._onRefresh}
        refreshing={false}
        isend={false}
      >
        <FlatList
          ListHeaderComponent={this.props.ListHeaderComponent}
          data={this.props.data}
          keyExtractor={this.props.keyExtractor}
          renderItem={this.props.renderItem}
          style={[{backgroundColor:'#ffffff' }]}
        />
      </RefreshFlatList>
    </View>
  }

  //将状态置为正在请求，请求期间不能出发刷新或加载更多，避免异步返回结果导致数据出错
  startFetching = () => {
    this.setNativeProps({refreshing: true})
  }

  //将状态置为结束请求，可执行刷新或加载更多
  endFetching = (isend) => {
    if (isend === false || isend === true) {
      this.setNativeProps({isend: isend})
    }
    this.setNativeProps({refreshing: false})
  }

  _onRefresh = (event) => {
      this.props.onRefresh()
  }

  _onLoadMore = (event) => {
      this.props.onLoadMore()
  }
}

class IosRefreshFlatList extends Component {
  constructor(props) {
    super(props)
    this.state = {
      isend: false,
      fetching: false,
      rotate: new Animated.Value(0)
    }
  }

  topIndicatorRender = () => {
    return <View style={{height: px2dp(100), backgroundColor: 'transparent'}}>
      <Image ref={e => this.ref_refresh_icon = e} source={refreshIcon} style={{width: px2dp(44), height: px2dp(44), position: 'absolute', left: (px2dp(750) - px2dp(44)) / 2, bottom: px2dp(26)}} />
      <Animated.Image ref={e => this.ref_refreshing_icon = e} source={refreshingIcon} style={{width: px2dp(44), height: px2dp(44), position: 'absolute', left: (px2dp(750) - px2dp(44)) / 2, bottom: px2dp(26), transform: [{rotate: this.state.rotate.interpolate({inputRange: [0, 6], outputRange: ['0deg', '2160deg']})}]}} />
    </View>
  }
  bottomIndicatorRender = () => {
    let {isend, fetching} = this.state
    let {data} = this.props
    return (data && data.length > 0 && !isend && fetching) ? <View style={{ height: px2dp(100), justifyContent: 'center', alignItems: 'center', backgroundColor: '#f5f5f5' }}>
      <LoadingView text="加载中..." />
    </View> : null
  }

  emptyComponent = () => {
    let {isend, fetching} = this.state
    let {data} = this.props
    let element = null
    if (!data && !isend && fetching) { // 无数据且正在加载，且不是最后一页
      element = <View style={{alignSelf: 'stretch', flex: 1, backgroundColor: '#f5f5f5'}}>
        <LoadingView style={{ height: px2dp(100), paddingTop: px2dp(32) }} />
      </View>
    }
    return element
  }

  startAnimation = () => {
    let {rotate} = this.state
    rotate.setValue(0)
    Animated.timing(rotate, {
        toValue: 6,
        duration: 3000,
        easing: Easing.linear
    }).start(() => this.startAnimation());
  }

  componentDidMount () {
    this.startAnimation()
  }

  render() {
    let {data, fetching, onRefresh, ...others} = this.props
    let {isend} = this.state
    let state_fetching = this.state.fetching
    return <View style={{flex: 1, backgroundColor: '#f5f5f5'}}>
        <PullFlatList
          {...others}
          data={data}
          ref={(c) => this._nativeSwipeRefreshLayout = c}
          isContentScroll={true}
          style={{flex: 1, backgroundColor: (!data && !isend && state_fetching) ? '#f5f5f5' : '#fff'}}
          onPullRelease={this._onRefresh}
          onEndReached={this._onLoadMore}
          topIndicatorRender={this.topIndicatorRender}
          topIndicatorHeight={px2dp(100)}
          renderItem={this.props.renderItem}
          keyExtractor={this.props.keyExtractor}
          onEndReachedThreshold={0.1}
          ListFooterComponent={this.bottomIndicatorRender()}
          ListEmptyComponent={this.emptyComponent()}
        />
      </View>
  }

  //将状态置为正在请求，请求期间不能出发刷新或加载更多，避免异步返回结果导致数据出错
  startFetching = () => {
    this.setState({
      fetching: true
    })
    this.ref_refresh_icon && this.ref_refresh_icon.setNativeProps({opacity: 0})
    this.ref_refreshing_icon && this.ref_refreshing_icon.setNativeProps({opacity: 1})
  }

  //将状态置为结束请求，可执行刷新或加载更多
  endFetching = (isend) => {
      let _obj = (isend === false || isend === true) ? {
        isend: isend,
        fetching: false
      } : {
        fetching: false
      }
      this.setState(_obj)
      this.ref_refresh_icon && this.ref_refresh_icon.setNativeProps({opacity: 1})
      this.ref_refreshing_icon && this.ref_refreshing_icon.setNativeProps({opacity: 0})
      this._nativeSwipeRefreshLayout.finishRefresh()
  }

  _onRefresh = (event) => {
    if (!this.state.fetching) {
      this.props.onRefresh()
    }
  }

  _onLoadMore = (event) => {
    if (!this.state.isend) {
      this.props.onLoadMore()
    }
  }
}

const ExportList = Platform.OS === 'android' ? AndroidRefreshFlatList : IosRefreshFlatList

export default ExportList
