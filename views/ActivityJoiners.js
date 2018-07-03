import React from "react";
import {
  FlatList,
  Text,
  View,
  Image,
  StyleSheet,
  TouchableWithoutFeedback,
  Alert
} from 'react-native';
import px2dp from '../lib/px2dp'
import ActivityEmpty from '../components/ActivityEmpty'
import GoNativeModule from '../modules/GoNativeModule'
import RefreshFlatList from '../components/RefreshFlatList'
import RoundBorderView from '../components/RoundBorderView'

export default class ActivitysJoined extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      pn: 1,
      data: null,
      loaded: false
    }
  }
  onJumpUserDetail = (id) => {
    GoNativeModule && GoNativeModule.goUserDetail(id)
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
    }, err => {
      this.pullToRefreshListView.setLoaded(true)
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
          <TouchableWithoutFeedback onPress={() => this.onJumpUserDetail(item.uid)}>
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