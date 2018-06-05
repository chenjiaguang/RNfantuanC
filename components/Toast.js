import React from 'react';
import {View, Text} from 'react-native';
import Toast from 'react-native-root-toast';
import px2dp from "../lib/px2dp";

export default class MyToast {
  static show (msg, duration) {
    const element = <View style={{borderRadius: px2dp(6), paddingTop: px2dp(8), paddingRight: px2dp(22), paddingBottom: px2dp(8), paddingLeft: px2dp(22)}}>
      <Text style={{fontSize: px2dp(30), lineHeight: px2dp(38), textAlign: 'center', color: '#fff'}}>{msg}</Text>
    </View>
    this.hide()
    this.toast = Toast.show(element, {
      duration: duration || 2000,
      position: -120,
      backgroundColor: 'rgba(0,0,0,0.85)',
      shadow: false,
      animation: true,
      hideOnPress: false,
      delay: 0,
      onShow: () => {
        // calls on toast\`s appear animation start
      },
      onShown: () => {
        // calls on toast\`s appear animation end.
      },
      onHide: () => {
        // calls on toast\`s hide animation start.
      },
      onHidden: () => {
        // calls on toast\`s hide animation end.
      }
    })
  }
  static hide () {
    this.toast && Toast.hide(this.toast)
  }
};
