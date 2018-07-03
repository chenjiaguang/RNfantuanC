// ImageView.js

import { requireNativeComponent, View, Platform } from 'react-native';
import PropTypes from 'prop-types';
import React, {
  Component,
} from 'react'
import px2dp from '../lib/px2dp';



export default class AndroidRoundBorderView extends Component {
  constructor(props) {
    super(props)
  }
  static propTypes = {
    ...View.propTypes, // 包含默认的View的属性
    borderRadius: PropTypes.number,
    borderWidth: PropTypes.number,
    fantBorderColor: PropTypes.string,
  }


  render() {
    return (
      <RoundBorderView
        {...this.props}
        borderRadius={this.props.borderRadius == undefined ? px2dp(6) : this.props.borderRadius}
        borderWidth={this.props.borderWidth == undefined ? px2dp(1) : this.props.borderWidth}
        fantBorderColor={this.props.fantBorderColor == undefined ? '#333333' : this.props.fantBorderColor}
      >
      </RoundBorderView>
    )
  }
}

const RoundBorderView = Platform.OS == 'ios' ? View : requireNativeComponent('RCTRoundBorderView', AndroidRoundBorderView)