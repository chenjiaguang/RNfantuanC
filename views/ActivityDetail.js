import React from "react";
import {
    ScrollView,
    View,
    Text,
    Image,
    StyleSheet,
    Linking,
    Animated
} from 'react-native';
import px2dp from '../lib/px2dp'
import { ifIphoneX, getStatusBarHeight } from 'react-native-iphone-x-helper'
import Iconfont from '../components/cxicon/CXIcon';
import MyTextInput from '../components/MyTextInput' // 自己封装的输入框，解决ios中文输入问题
import CodeInput from '../components/CodeInput' // 自己封装的获取验证码输入框，自带获取验证码处理逻辑
import Button from 'apsl-react-native-button' // 第三方button库，RN官方的库会根据平台不同区别，这里统一
import Toast from  '../components/Toast'
import commonStyle from "../static/commonStyle";

export default class ActivityDetail extends React.Component {  // 什么参数都不传，则默认是绑定手机都页面，传入isRebind为true时表示新绑手机，界面稍有差异
    constructor (props) {
        super(props)
        this.state = {
            activity: {
                bannerUrl: 'http://www.znsfagri.com/uploadfile/editor/image/20170626/20170626151136_11631.jpg',
                title: '三月不减肥，四月徒伤悲 | 节后甩肉计划第一期 正式启动！羽毛球篇',
                from: '周末去哪浪',
                sponsorName: '海口禹讯信息技术有限公司',
                sponsorPhone: '17508959493',
                address: '海口市龙华区滨海大道百方大厦15楼BBBBBB',
                location: {
                    lng: 55,
                    lat: 55
                },
                date: '01-03 18:30 至 05-06 18:30',
                cost: '15-16',
                deadline: '02-15 18:30',
                tags: [
                    '不可退票',
                    '费用中包含保险'
                ]
            }
        }
    }
    static navigationOptions = ({navigation}) => {
        return{
            title: navigation.state.params && navigation.state.params.isRebind ? '新的手机号' : '绑定手机',
            headerStyle: {
                width: px2dp(750),
                height: px2dp(90),
                backgroundColor: 'rgba(250,250,250,' + ((navigation.state.params && navigation.state.params.opacity) ? navigation.state.params.opacity : 0) + ')',
                borderBottomWidth: 0,
                elevation: 0,
                position: 'absolute'
            }
        }
    }
    handleScroll = (event) => {
        this.props.navigation.setParams({'opacity': event.nativeEvent.contentOffset.y >= 0 ? event.nativeEvent.contentOffset.y / (px2dp(332) - getStatusBarHeight(true)) : 0})
    }
    callPhone = () => {
        console.log('callPhone')
        let {sponsorPhone} = this.state.activity
        if (!sponsorPhone) {
            return false
        }
        let url = 'tel:' + sponsorPhone
        Linking.canOpenURL(url).then(supported => {
            if (!supported) {
                console.log('Can\'t handle url: ' + url);
            } else {
                return Linking.openURL(url);
            }
        }).catch(err => console.error('An error occurred', err));
    }
    showMap = () => {
        console.log('调用原生显示地图页面')
    }
    animate = () => {
        let {initialHeight, maxHeight, currentHeight} = this.state
        console.log('animate', initialHeight, maxHeight, currentHeight)
        if (this.state.currentHeight > this.state.maxHeight) {
            Animated.timing(
                this.state.currentHeight,
                {
                    toValue: this.state.maxHeight
                }
            ).start()
        } else {
            Animated.timing(
                this.state.currentHeight,
                {
                    toValue: this.state.initialHeight
                }
            ).start()
        }
    }
    introBoxLayout = (event) => {
        console.log('introBoxLayout', event.nativeEvent.layout.height)
        let {initialHeight, currentHeight, maxHeight} = this.state
        if (initialHeight && currentHeight && maxHeight) {
            return false
        }
        this.setState({
            initialHeight: event.nativeEvent.layout.height,
            maxHeight: px2dp(700),
            currentHeight: event.nativeEvent.layout.height > px2dp(700) ? px2dp(700) : event.nativeEvent.layout.height
        })
    }
    render() {
        let {bannerUrl, title, from, sponsorName, sponsorPhone, address, location, date, cost, deadline, tags} = this.state.activity
        let {initialHeight, currentHeight, maxHeight} = this.state
        return <ScrollView style={styles.scrollView} onScroll={this.handleScroll} scrollEventThrottle={15}>
            <Image source={{uri: bannerUrl}} style={styles.header} />
            <View style={styles.contentWrapper}>
                <Text style={styles.title}>{title}</Text>
                <Text style={styles.from}>来自"{from}"的活动</Text>
                <View style={styles.infoBox}>
                    <View style={styles.infoItem}>
                        <Text style={styles.infoLeft}>主办方</Text>
                        <Text style={[styles.infoRight, {fontWeight: '600'}]} numberOfLines={1}>{sponsorName}</Text>
                        {sponsorPhone && <Iconfont onPress={this.callPhone} name='phone' size={px2dp(33)} color='#1EB0FD' style={{paddingLeft: px2dp(20), paddingTop: px2dp(15), paddingBottom: px2dp(15)}}/>}
                    </View>
                    <View style={styles.infoItem}>
                        <Text style={styles.infoLeft}>地点</Text>
                        <Text style={styles.infoRight} numberOfLines={1}>{address || '线上活动'}</Text>
                        {address && location && <Iconfont name='location' onPress={this.showMap} size={px2dp(24)} color='#1EB0FD' style={{paddingLeft: px2dp(20), paddingTop: px2dp(20), paddingBottom: px2dp(20)}}/>}
                    </View>
                    <View style={styles.infoItem}>
                        <Text style={styles.infoLeft}>时间</Text>
                        <Text style={styles.infoRight} numberOfLines={1}>{date}</Text>
                    </View>
                    <View style={styles.infoItem}>
                        <Text style={styles.infoLeft}>费用</Text>
                        <Text style={[styles.infoRight, {color: '#FF3F53'}]} numberOfLines={1}>{cost.toString() === '0' ? '免费' : '¥' + cost}</Text>
                    </View>
                    <View style={styles.infoItem}>
                        <Text style={styles.infoLeft}>报名截止时间</Text>
                        <Text style={styles.infoRight} numberOfLines={1}>{deadline}</Text>
                    </View>
                    <View style={styles.tags}>
                        {tags.map((item, idx) => <View key={idx} style={styles.tagItem}><Text style={{fontSize: px2dp(24), color: '#666'}}>{item}</Text></View>)}
                    </View>
                </View>
                <View style={[styles.introBox, {height: currentHeight || 'auto'}]} onLayout={this.introBoxLayout}>
                    <Text style={styles.introHeader}>活动介绍</Text>
                    <Text style={styles.introText}>工作两周，假期里养的肉都下去了么？</Text>
                    <Text style={styles.introText}>如果没有，</Text>
                    <Text style={styles.introText}>那就 来找点乐子吧！</Text>
                    <Text style={styles.introText}>不想养膘？</Text>
                    <Text style={styles.introText}>打球去吧！</Text>
                    <Text style={styles.introText}>不想无所事事？</Text>
                    <Text style={styles.introText}>打球去吧！</Text>
                    <Image source={{uri: bannerUrl}} style={styles.introImage} resizeMode={'cover'} />
                    <Text style={styles.introText}>羽毛球比赛即将于三月中旬举行，该比赛注重同学们的 身心健康发展，旨在宽阔学生们的业余活动，望大家踊 跃参与。</Text>
                    <Text style={styles.introText}>主办单位：中国工商银行广东省分行</Text>
                    <Text style={styles.introText}>报名时间：近期</Text>
                    <Text style={styles.introText}>比赛时间：三月</Text>
                    {initialHeight && currentHeight && maxHeight && <Text onPress={this.animate} style={{position: 'absolute', left: 0, bottom: 0}}>{currentHeight === maxHeight ? '展开' : '收起'}</Text>}
                </View>
            </View>
        </ScrollView>
    }
}

const styles = StyleSheet.create({
    scrollView: {
        backgroundColor: '#fff',
    },
    contentWrapper: {
        paddingLeft: px2dp(30),
        paddingRight: px2dp(30),
        alignItems: 'stretch',
        ...ifIphoneX({
            paddingBottom: px2dp(124)
        }, {
            paddingBottom: px2dp(80)
        })
    },
    header: {
        height: px2dp(422)
    },
    title: {
        fontSize: px2dp(32),
        lineHeight: px2dp(46),
        paddingTop: px2dp(27)
    },
    from: {
        fontSize: px2dp(24),
        lineHeight: px2dp(56),
        color: '#666'
    },
    infoBox: {
        paddingTop: px2dp(20)
    },
    infoItem: {
        height: px2dp(76),
        flexDirection: 'row',
        alignItems: 'center',
        borderBottomWidth: px2dp(1),
        borderBottomColor: '#E5E5E5'
    },
    infoLeft: {
        width: px2dp(198),
        fontSize: px2dp(28),
        color: '#666',
        flex: 0
    },
    infoRight: {
        fontSize: px2dp(28),
        flex: 1
    },
    tags: {
        flexDirection: 'row',
        flexWrap: 'wrap',
        paddingTop: px2dp(24),
        paddingBottom: px2dp(24)
    },
    tagItem: {
        height: px2dp(40),
        paddingLeft: px2dp(14),
        paddingRight: px2dp(14),
        marginTop: px2dp(6),
        marginRight: px2dp(12),
        marginBottom: px2dp(6),
        borderWidth: px2dp(1),
        borderRadius: px2dp(6),
        borderColor: '#BBB',
        justifyContent: 'center'
    },
    introBox: {
        height: 'auto',
        overflow: 'hidden',
        backgroundColor: 'red'
    },
    introHeader: {
        fontSize: px2dp(32),
        lineHeight: px2dp(92),
        fontWeight: '600'
    },
    introText: {
        fontSize: px2dp(28),
        lineHeight: px2dp(46)
    },
    introImage: {
        alignSelf: 'stretch',
        height: px2dp(388),
        marginTop: px2dp(20),
        marginBottom: px2dp(20),
    }
})
