import React from "react";
import {
  View,
  StyleSheet
} from 'react-native';
import px2dp from '../../lib/px2dp'
import Text from '../../components/MyText'
import Image from '../../components/SmoothImage'

export default class GrowthCenter extends React.Component {  // 什么参数都不传，则默认是绑定手机都页面，传入isRebind为true时表示新绑手机，界面稍有差异
  constructor (props) {
    super(props)
    this.state = {}
  }
  render() {
    let {icon, title, state, rightArea} = this.props
    return <View style={styles.wrapper}>
      <Image style={styles.icon} source={icon} resizeMode={'contain'} />
      <View style={styles.center}>
        <Text style={styles.title}>{title}</Text>
        <Text style={styles.state}>{state}</Text>
      </View>
      <View style={styles.rightArea}>
        {rightArea ? rightArea : null}
      </View>
    </View>
  }
}

const styles = StyleSheet.create({
  wrapper: {
    height: px2dp(116),
    flexDirection: 'row',
    alignItems: 'center',
    paddingLeft: px2dp(30),
    paddingRight: px2dp(30)
  },
  icon: {
    width: px2dp(68),
    height: px2dp(68)
  },
  center: {
    width: px2dp(500),
    height: px2dp(68),
    paddingLeft: px2dp(24),
    justifyContent: 'space-between'
  },
  title: {
    fontSize: px2dp(30),
    color: '#333'
  },
  state: {
    fontSize: px2dp(24),
    color: '#999'
  },
  rightArea: {
    flex: 1,
    height: px2dp(116),
    flexDirection: 'row',
    justifyContent: 'flex-end',
    alignItems: 'center'
  }
})
