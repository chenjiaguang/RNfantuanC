import React, { Component } from "react";
import {
    View,
    StyleSheet,
    Platform,
    TouchableWithoutFeedback,
    Text
} from 'react-native';
import px2dp from '../lib/px2dp'
import Iconfont from '../components/cxicon/CXIcon';
import { getStatusBarHeight } from 'react-native-iphone-x-helper'
import commonStyle from '../static/commonStyle'


class HeadNav extends Component {
    constructor(props) {
        super(props)
        this.state = {
            value: 0
        }
    }
    getRGB() {
        let color = 250 * (1 - this.state.value)
        return 'rgb(' + color + ',' + color + ',' + color + ')';
    }
    render() {
        let rgb = this.getRGB()
        let text = this.state.value.toString() === '1' ? this.props.title : ''
        return <View style={[styles.container, { backgroundColor: 'rgba(250,250,250,' + this.state.value + ')' }]}>
            <TouchableWithoutFeedback disabled={false} onPress={() => { this.props.navigation.pop() }}>
                <View style={{ width: px2dp(80), height: px2dp(90), flexDirection: 'row', alignItems: 'center' }}>
                    <Iconfont name='go_back' size={px2dp(38)} color={rgb} style={{ paddingLeft: px2dp(18) }} />
                </View>
            </TouchableWithoutFeedback>
            <Text style={commonStyle.headerTitleStyle}>{text}</Text>
            {this.props.headerRight(rgb)}

        </View >;
    }
};


const styles = StyleSheet.create({
    container: {
        width: px2dp(750),
        height: px2dp(90) + getStatusBarHeight(true),
        flexDirection: 'row',
        justifyContent: 'space-between',
        position: 'absolute',
        top: 0,
        zIndex: 9999,
        paddingTop: getStatusBarHeight(true),
        alignItems: 'flex-end',
    },
})

export default HeadNav;