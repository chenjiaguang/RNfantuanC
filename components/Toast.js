import React from 'react';
import Toast from 'react-native-root-toast';

export default class MyToast {
  static show (msg, duration) {
    this.hide()
    this.toast = Toast.show(msg, {
      duration: duration || 2000,
      position: -120,
      backgroundColor: 'rgba(0,0,0,0.85)',
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
