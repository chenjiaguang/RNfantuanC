import React from "react";
import {
  ScrollView,
  View,
  StyleSheet
} from 'react-native';
import px2dp from '../lib/px2dp'
import { ifIphoneX } from 'react-native-iphone-x-helper'
import Text from '../components/MyText'
import TestRefresh from '../components/TestRefresh'

export default class TestFlatList extends React.Component {
  constructor (props) {
    super(props)
    this.state = {
      listData: []
    }
  }
  static navigationOptions = {
    title: '测试下拉刷新'
  }
  render() {
    return <View style={styles.page}>
      <TestRefresh />
    </View>
  }
}

const styles = StyleSheet.create({
  page: {
    flex: 1,
    backgroundColor: '#fff'
  }
})
