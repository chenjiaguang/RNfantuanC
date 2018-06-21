import React from "react";
import {
    ScrollView,
    View,
    Text,
    StyleSheet
} from 'react-native';
import px2dp from '../lib/px2dp'
import { ifIphoneX } from 'react-native-iphone-x-helper'
import MyTextInput from '../components/MyTextInput' // 自己封装的输入框，解决ios中文输入问题
import CodeInput from '../components/CodeInput' // 自己封装的获取验证码输入框，自带获取验证码处理逻辑
import Button from 'apsl-react-native-button' // 第三方button库，RN官方的库会根据平台不同区别，这里统一
import Toast from  '../components/Toast'
import commonStyle from "../static/commonStyle";

export default class ActivityDetail extends React.Component {  // 什么参数都不传，则默认是绑定手机都页面，传入isRebind为true时表示新绑手机，界面稍有差异
    constructor (props) {
        super(props)
        this.state = {}
    }
    static navigationOptions = ({navigation}) => {
        return{
            title: navigation.state.params && navigation.state.params.isRebind ? '新的手机号' : '绑定手机',
            headerStyle: {
                width: px2dp(750),
                height: px2dp(90),
                backgroundColor: 'transparent',
                borderBottomWidth: 0,
                elevation: 0,
                position: 'absolute'
            }
        }
    }
    handleScroll = (event) => {
        console.log('scroll', event)
    }
    render() {
        return <ScrollView style={style.scrollView} onScroll={this.handleScroll}>
            <View style={style.contentWrapper}>
                <View style={style.header}>
                    <Text>sdfsdfsd</Text>
                </View>
                <View style={style.content}></View>
            </View>
        </ScrollView>
    }
}

const style = StyleSheet.create({
    scrollView: {
        backgroundColor: 'pink',
    },
    contentWrapper: {
        backgroundColor: 'yellow',
        alignItems: 'stretch',
        ...ifIphoneX({
            paddingBottom: px2dp(124)
        }, {
            paddingBottom: px2dp(80)
        })
    },
    header: {
        height: px2dp(422),
        backgroundColor: 'red'
    },
    content: {
        height: px2dp(2000),
        backgroundColor: 'green'
    }
})
