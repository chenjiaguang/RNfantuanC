import React from "react";
import {
    ScrollView,
    TouchableOpacity,
    View,
    Image,
    Text,
    StyleSheet
} from 'react-native';
import Iconfont from "../components/cxicon/CXIcon";
import px2dp from '../lib/px2dp'
import { ifIphoneX } from 'react-native-iphone-x-helper'
const bg = require('../static/image/rn_apply_banner.png')
import Button from 'apsl-react-native-button' // 第三方button库，RN官方的库会根据平台不同区别，这里统一
// 申请头条首页

export default class HeadlineIndex extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    static navigationOptions = {
        title: ''
    };
    componentWillMount() {
        // console.log('componentWillMount', this.props)

        let screenProps = this.props.screenProps;
        //testing
        // if (!screenProps) {
        //     screenProps = {
        //         route: "ActivitysJoined",
        //         params: {
        //         }
        //     }
        // }


        if (screenProps.params) {
            _Token=screenProps.params.token
            this.props.navigation.replace(screenProps.route, screenProps.params)
        } else {
            this.props.navigation.replace(screenProps.route)
        }
    }
    render() {
        return <View style={{ flex: 1 }}></View>
    }
}
