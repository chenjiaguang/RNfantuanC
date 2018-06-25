import React, { Component } from 'react';
import {
  View,
  Image,
  Text,
  StyleSheet
} from 'react-native';
import px2dp from '../lib/px2dp';

class ActivityEmpty extends Component {
  render() {
    return <View style={styles.container}>
      <Image style={styles.img} source={require('../static/image/rn_bg_activity_empty.png')} />
      {
        this.props.mode == 0 ? <Text style={styles.txt}>还没有参加任何活动，赶快报名吧~</Text> : null
      }
      {
        this.props.mode == 1 ? <Text style={styles.txt}>还没有发布过活动，快去圈子里发布活动吧~</Text> : null
      }
    </View>;
  }
};

const styles = StyleSheet.create({
  container: {
    flexDirection: 'column',
    alignItems: 'center'
  },
  img: {
    width: px2dp(240),
    height: px2dp(240),
    marginBottom: px2dp(20),
    marginTop: px2dp(240)
  },
  txt: {
    color: '#999999',
    fontSize: px2dp(28)
  }
})
export default ActivityEmpty;