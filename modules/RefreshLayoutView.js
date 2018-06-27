
import React, {
  Component,
} from 'react'
import PropTypes from 'prop-types';
import {
  View,
  requireNativeComponent,
  Platform,
  ViewPropTypes,
} from 'react-native'
import FantToastModule from '../modules/FantToastModule'

export default class AndroidRefreshLayoutView extends Component {
  constructor() {
    super()
    this._onRefresh = this._onRefresh.bind(this);
    this._onLoadMore = this._onLoadMore.bind(this);
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
      <RefreshLayoutView
        {...this.props}
        ref={(component) => this._nativeSwipeRefreshLayout = component}
        onLoadMore={this._onLoadMore}
        onRefresh={this._onRefresh}
        refreshing={false}
        isend={false}
        showEmptyLoading={true}
      />
    );
  }

  //设置是否正在加载
  setRefreshing = (b) => {
    this.setNativeProps({ refreshing: b })
  }

  //设置是否是最后一页
  setIsend = (b) => {
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
    this.props.onRefresh()
  }

  _onLoadMore = (event) => {
    this.props.onLoadMore()
  }


}

const RefreshLayoutView = Platform.OS == 'ios' ? View : requireNativeComponent('RCTRefreshLayoutView', AndroidRefreshLayoutView, {
  nativeOnly: { onRefresh: true, onLoadMore: true }
})
