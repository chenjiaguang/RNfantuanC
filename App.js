/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, { Component } from 'react';
import {
  Platform,
  StyleSheet,
  View,
  StatusBar
} from 'react-native';
import AppNavigators from './AppNavigators';
import Resolution from "./lib/Resolution";
import { NativeModules } from 'react-native';

const instructions = Platform.select({
  ios: 'Press Cmd+R to reload,\n' +
    'Cmd+D or shake for dev menu',
  android: 'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});

export default class App extends React.Component {
  constructor (props) {
    super(props)
    StatusBar.setBarStyle('dark-content')
    if (Platform.OS === 'android') {
      StatusBar.setTranslucent(true)
    }
  }
  componentWillMount () {
    // console.log('appWillMount', this.props, AppNavigators)
    //   let CalendarManager = NativeModules.CalendarManager;
    //   CalendarManager.addEvent('Birthday Party', '4 Privet Drive, Surrey');
  }
  render() {
    return <AppNavigators screenProps={this.props.screenProps} />
  }
}

const style = StyleSheet.create({
  container: {
    width:Resolution.get().width,
    height:Resolution.get().height,
    backgroundColor: '#fff',
    transform:[{translateX:-Resolution.get().width*.5},
      {translateY:-Resolution.get().height*.5},
      {scale:Resolution.get().scale},
      {translateX:Resolution.get().width*.5},
      {translateY:Resolution.get().height*.5}]
  }
})
