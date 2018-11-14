import React from "react";
import {
    View,
} from 'react-native';
import Iconfont from "../components/cxicon/CXIcon";
import px2dp from '../lib/px2dp'
import { ifIphoneX } from 'react-native-iphone-x-helper'
const bg = require('../static/image/rn_apply_banner.png')
import Button from 'apsl-react-native-button' // 第三方button库，RN官方的库会根据平台不同区别，这里统一
// 申请头条首页

export default class Index extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    static navigationOptions = {
        title: ''
    };
    componentWillMount() {
        let screenProps = this.props.screenProps;
        //testing
    //    _Token = screenProps.params.token
    //     this.props.navigation.replace('SetGeoLocation')
    //     return false

        // console.log('################', screenProps)
        // if (screenProps) {
        //     screenProps.route = 'ActivityDetail'
        //     if (screenProps.params) {
        //         screenProps.params.id = '12'
        //     }
        // }
        // if (!screenProps) {
        //     this.props.navigation.replace('HeadlineIndex')
        //     return false
        // }


        if (screenProps) {
            if (screenProps.params) {
                _Token = screenProps.params.token
                if (screenProps.params.env == "prod") {
                    _Env = "prod"
                    _Api = "https://fant.fantuan.cn"
                } else if (screenProps.params.env == "pre") {
                    _Env = "pre"
                    _Api = "https://fant.fantuan.cn/pre"
                } else {
                    _Env = "dev"
                    _Api = "https://fanttest.fantuan.cn"
                }
                this.props.navigation.replace(screenProps.route, screenProps.params)
            } else {
                this.props.navigation.replace(screenProps.route)
            }
        }
    }
    render() {
        return <View style={{ flex: 1 }}></View>
    }
}
