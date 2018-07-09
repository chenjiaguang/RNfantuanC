
import React, {
  Component,
} from 'react'
import PropTypes from 'prop-types';
import {
  View,
  requireNativeComponent,
  Platform,
  FlatList,
  Text,
  ViewPropTypes,
} from 'react-native'
import FantToastModule from '../modules/FantToastModule'
import px2dp from '../lib/px2dp';
import LoadingView from '../components/LoadingView'

export default class AndroidRefreshFlatList extends Component {
  constructor(props) {
    super(props)
    this.state = {
      isend: false,
      refreshing: false
    }
  }

  static propTypes = {
    ...View.propTypes,
    onRefresh: PropTypes.func,
    onLoadMore: PropTypes.func,
    refreshing: PropTypes.bool,
    isend: PropTypes.bool
  }

  setNativeProps = (props) => {
    this._nativeSwipeRefreshLayout.setNativeProps(props)
  }

  render() {
    return (
      Platform.OS == 'ios' ?
        <FlatList
          {...this.props}
          onRefresh={this._onRefresh}
          onEndReached={this._onLoadMore}
          refreshing={this.state.refreshing}
          ref={(component) => this._nativeSwipeRefreshLayout = component}
          onEndReachedThreshold={0.1}
          ListFooterComponent={<View style={{ flexDirection: 'column', alignItems: 'center' }}>
            {this.state.isend ? null : <Text style={{ height: px2dp(100), lineHeight: px2dp(100) }}>正在加载..</Text>}
          </View>}
        /> :
        <View style={{ flex: 1 }}>
          <LoadingView style={{ display: this.props.data ? 'none' : 'flex', height: px2dp(100) }} />
          <RefreshFlatList
            {...this.props}
            style={[this.props.style, { display: this.props.data ? 'flex' : 'none' }]}
            ref={(component) => this._nativeSwipeRefreshLayout = component}
            onLoadMore={this._onLoadMore}
            onRefresh={this._onRefresh}
            refreshing={false}
            isend={false}
          >
            <FlatList
              data={this.props.data}
              keyExtractor={this.props.keyExtractor}
              renderItem={this.props.renderItem}
            />
          </RefreshFlatList>
        </View>
    );
  }

  //设置是否正在加载
  setRefreshing = (b) => {
    this.setState({
      refreshing: b
    })
    this.setNativeProps({ refreshing: b })
  }

  //设置是否是最后一页
  setIsend = (b) => {
    this.setState({
      isend: b
    })
    this.setNativeProps({ isend: b })
  }


  //统一处理加载完成后动作
  setLoaded = (isEnd) => {
    this.setIsend(isEnd)
    this.setRefreshing(false)
  }

  _onRefresh = (event) => {
    this.setRefreshing(true)
    this.props.onRefresh()
  }

  _onLoadMore = (event) => {
    if (!this.state.isend) {
      this.props.onLoadMore()
    }
  }


}

const RefreshFlatList = Platform.OS == 'ios' ? View : requireNativeComponent('RCTRefreshLayoutView', AndroidRefreshFlatList, {
  nativeOnly: { onRefresh: true, onLoadMore: true }
})
