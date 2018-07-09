import React from 'react';
import Toast from 'react-native-root-toast';
import px2dp from '../lib/px2dp'
import {
  View,
  StyleSheet,
  Platform
} from 'react-native'
import Text from '../components/MyText'

export default class MyToast {
  static show (msg, duration) {
    let toastElement = <View style={styles.content}><Text style={styles.contentText}>{msg}</Text></View>
    this.hide()
    this.toast = Toast.show(toastElement, {
      duration: duration || 2000,
      position: Platform.OS === 'ios' ? Toast.positions.CENTER : Toast.positions.BOTTOM,
      backgroundColor: 'transparent',
      shadow: false,
      animation: true,
      hideOnPress: false,
      delay: 0
    })
  }
  static hide () {
    this.toast && Toast.hide(this.toast)
  }
};

const styles = StyleSheet.create({
  content: {
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: px2dp(6),
    paddingTop: px2dp(24),
    paddingBottom: px2dp(24),
    paddingLeft: px2dp(20),
    paddingRight: px2dp(20),
    backgroundColor: 'red',
    maxWidth: px2dp(560),
    backgroundColor: 'rgba(0,0,0,0.85)'
  },
  contentText: {
    fontSize: px2dp(24),
    lineHeight: px2dp(28),
    color: '#fff',
    textAlign: 'center'
  }
}) 
