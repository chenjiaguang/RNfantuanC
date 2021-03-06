import React from "react";
import {
  View,
  Image,
  StyleSheet,
  TouchableWithoutFeedback,
} from 'react-native';
import px2dp from '../lib/px2dp'
import GoNativeModule from '../modules/GoNativeModule'
import RefreshFlatList from '../components/RefreshFlatList'
import Text from '../components/MyText'

export default class ActivitysJoined extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      pn: 1,
      data: null,
      loaded: false
    }
  }
  onJumpUserDetail = (id, is_news) => {
    GoNativeModule && GoNativeModule.goUserDetail(id, "1", is_news ? '1' : '0')
  }
  componentDidMount() {
    this.onRefresh()
  }
  onRefresh = () => {
    this.onFetch(1)
  }
  onLoadMore = () => {
    this.onFetch(this.state.pn + 1)
  }
  onFetch = (pn) => {
    let rData = {
      pn: pn,
      id: this.props.navigation.state.params.id
    }
    _FetchData(_Api + '/jv/qz/v21/activityjoined', rData).then(res => {
      this.pullToRefreshListView.setLoaded(res.data.paging.is_end)
      let data
      if (pn == 1) {
        data = res.data.list
      } else {
        data = this.state.data.concat(res.data.list)
      }
      this.setState({
        pn: pn,
        data: data,
        loaded: true
      })
    }).catch(err => {
      this.pullToRefreshListView.setLoaded(true)
    })
  }
  static navigationOptions = ({ navigation }) => {
    return {
      title: "已经报名的小伙伴"
    }
  }
  render() {
    return <View style={styles.container}>
      <RefreshFlatList style={styles.list}
        ref={(component) => this.pullToRefreshListView = component}
        onLoadMore={this.onLoadMore}
        onRefresh={this.onRefresh}
        keyExtractor={(item) => item.uid}
        data={this.state.data}
        renderItem={({ item }) =>
          <TouchableWithoutFeedback onPress={() => this.onJumpUserDetail(item.uid, item.is_news)}>
            <View style={styles.item}>
              <Image
                style={styles.img}
                source={{ uri: item.avatar }}
              />
              <Text style={styles.name}>{item.username}</Text>
            </View>
          </TouchableWithoutFeedback>}
      />
    </View>

  }
}
StyleSheet.flatten

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#ffffff',
  },
  list: {
    flex: 1,
  },
  item: {
    flex: 1,
    marginLeft: px2dp(30),
    marginRight: px2dp(30),
    height: px2dp(100),
    flexDirection: 'row',
    alignItems: 'center'
  },
  img: {
    height: px2dp(60),
    width: px2dp(60),
    borderRadius: px2dp(30)
  },
  name: {
    marginLeft: px2dp(20),
    color: '#333333'
  },
})