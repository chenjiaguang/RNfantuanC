import React, { Component } from 'react';
import {
  View,
  Image,
  StyleSheet,
  Alert,
  NetInfo
} from 'react-native';
import px2dp from '../lib/px2dp';
import Util from '../lib/Util';
import UtilsNetwork from '../lib/UtilsNetwork';
import Toast from './Toast'
import Text from './MyText'
import Button from 'apsl-react-native-button' // 第三方button库，RN官方的库会根据平台不同区别，这里统一

class NoNetwork extends Component {
  constructor(props) {
    super(props)
    this.state = {
      isConnected: false
    }
  }
  reload=()=>{
    if (this.state.isConnected) {
      this.props.reload()
    } else {
      Util.showNetworkErrorToast()
    }
  }
  handleConnectivityChange=(connectionInfo)=>{
    if (connectionInfo.type !== 'none' && connectionInfo.type !== 'unknown') {
      this.setState({
        isConnected: true
      })
    } else {
      this.setState({
        isConnected: false
      })
    }
  }
  componentDidMount () {
    NetInfo.addEventListener(
      'connectionChange',
      this.handleConnectivityChange
    );
  }
  componentWillUnmount () {
    NetInfo.removeEventListener(
      'connectionChange',
      this.handleConnectivityChange
    );
  }
  render() {
    return <View style={[this.props.style,styles.container]}>
      <Image style={styles.img} source={require('../static/image/no_network.png')} />
      <Text style={styles.txt}>网络异常啦，检查一下网络设置吧~</Text>
      <Button style={styles.button} textStyle={styles.buttonTxt} onPress={this.reload}>点击重试</Button>
    </View>;
  }
};

const styles = StyleSheet.create({
  container: {
    flexDirection: 'column',
    alignItems: 'center'
  },
  img: {
    width: px2dp(149),
    height: px2dp(165),
    marginBottom: px2dp(52),
    marginTop: px2dp(302)
  },
  txt: {
    color: '#999999',
    fontSize: px2dp(28),
    marginBottom: px2dp(50)
  },
  button: {
    borderRadius:px2dp(6),
    borderWidth:0,
    backgroundColor:'#1EB0FD',
    width: px2dp(256),
    height: px2dp(78),
    alignSelf: 'center',
  },
  buttonTxt: {
    color: '#ffffff',
    fontSize: px2dp(30)

  }
})
export default NoNetwork;