
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

export default class AndroidRefreshFlatList extends Component {
  constructor() {
    super()
    this._onRefresh = this._onRefresh.bind(this);
    this._onLoadMore = this._onLoadMore.bind(this);
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
    showEmptyLoading: PropTypes.bool,
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
          ListFooterComponent={<View style={{flexDirection: 'column', alignItems: 'center'}}>
            {this.state.isend ? null : <Text style={{height:px2dp(100),lineHeight:px2dp(100)}}>正在加载..</Text>}
          </View>}
        /> :
        <RefreshFlatList
          {...this.props}
          ref={(component) => this._nativeSwipeRefreshLayout = component}
          onLoadMore={this._onLoadMore}
          onRefresh={this._onRefresh}
          refreshing={false}
          isend={false}
          showEmptyLoading={true}
        >
          <FlatList
            data={this.props.data}
            keyExtractor={this.props.keyExtractor}
            renderItem={this.props.renderItem}
          />
        </RefreshFlatList>
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

  //设置是否显示空页面时的loading
  setShowEmptyLoading = (b) => {
    this.setNativeProps({ showEmptyLoading: b })
  }

  //统一处理加载完成后动作
  setLoaded = (isEnd) => {
    this.setIsend(isEnd)
    this.setRefreshing(false)
    this.setShowEmptyLoading(false)
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
