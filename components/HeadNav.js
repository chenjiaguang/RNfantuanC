import React, { Component } from "react";
import {
    View,
    StyleSheet,
    Platform,
    TouchableWithoutFeedback
} from 'react-native';
import px2dp from '../lib/px2dp'
import Iconfont from '../components/cxicon/CXIcon';
import { getStatusBarHeight } from 'react-native-iphone-x-helper'
import commonStyle from '../static/commonStyle'
import Text from '../components/MyText'


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
        let { fetching } = this.props
        let rgb = this.getRGB()
        let text = this.props.title
        return <View style={[styles.container, { backgroundColor: fetching ? 'rgba(250,250,250,1)' : 'rgba(250,250,250,' + this.state.value + ')', borderBottomWidth: px2dp(1), borderBottomColor: (this.state.value.toString() === '1' || fetching) ? '#E5E5E5' : 'transparent' }]}>
            <TouchableWithoutFeedback disabled={false} onPress={() => { this.props.navigation.pop() }}>
                <View style={{ width: px2dp(80), height: px2dp(90), flexDirection: 'row', alignItems: 'center' }}>
                    <Iconfont name='go_back' size={px2dp(38)} color={fetching ? '#666' : rgb} style={{ paddingLeft: px2dp(18) }} />
                </View>
            </TouchableWithoutFeedback>
            <Text style={[commonStyle.headerTitleStyle, { color: fetching ? 'rgba(0,0,0,0)' : 'rgba(0,0,0,' + this.state.value + ')' }]}>{text}</Text>
            {this.props.headerRight(fetching ? '#666' : rgb)}

        </View >;
    }
};


const styles = StyleSheet.create({
    container: {
        width: px2dp(750),
        height: Platform.OS === 'android' ? 50 + getStatusBarHeight(true) : px2dp(90) + getStatusBarHeight(true),
        flexDirection: 'row',
        justifyContent: 'space-between',
        position: 'absolute',
        top: 0,
        zIndex: 9999,
        paddingTop: getStatusBarHeight(true),
        alignItems: 'center',
    },
})

export default HeadNav;