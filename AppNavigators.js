import { createStackNavigator } from 'react-navigation';
import React, { componet } from "react";
import { View, TouchableWithoutFeedback, Platform, NativeModules, PixelRatio, Dimensions, Easing, Animated, StatusBar, BackHandler } from 'react-native'
import Util from './lib/Util';
import Index from './views/Index';
import HeadlineIndex from './views/HeadlineIndex';
import HeadlineSelect from './views/HeadlineSelect';
import HeadlineForm from './views/HeadlineForm';
import HeadlineSubmitted from './views/HeadlineSubmitted';
import VerifyPhone from './views/VerifyPhone';
import BindPhone from './views/BindPhone';
import SetPassword from './views/SetPassword';
import ResetPassword from './views/ResetPassword';
import ActivityDetail from './views/ActivityDetail';
import Dynamic from './views/Dynamic';
import WebPage from './views/WebPage';
import ActivitysJoined from './views/ActivitysJoined';
import ActivitysMine from './views/ActivitysMine';
import ActivitysSignUpManagement from './views/ActivitysSignUpManagement';
import ActivityJoiners from './views/ActivityJoiners';
import GrowthCenter from './views/growth/GrowthCenter';
import GrowthIntro from './views/growth/GrowthIntro';
import SetGeoLocation from './views/SetGeoLocation';
import Iconfont from './components/cxicon/CXIcon';
import px2dp from './lib/px2dp'
import SwipBackModule from './modules/SwipBackModule';
import StackViewStyleInterpolator from './anim/StackViewStyleInterpolator'
import commonStyle from './static/commonStyle'

//导航注册,createStackNavigator代替StackNavigator，以消除警告

class HeaderLeft extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        return <TouchableWithoutFeedback disabled={false} onPress={this.props.goBack}>
            <View style={{ width: px2dp(100), height: px2dp(90), flexDirection: 'row', alignItems: 'center' }}>
                <Iconfont name='go_back' size={px2dp(38)} color='#333333' style={{ paddingLeft: px2dp(18) }} />
            </View>
        </TouchableWithoutFeedback>
    }
}
class HeaderRight extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        return <TouchableWithoutFeedback disabled={false} onPress={() => { }} style={{ width: px2dp(80), height: px2dp(90) }}>
            <View></View>
        </TouchableWithoutFeedback>
    }
}
const SimpleApp = createStackNavigator({
    ActivityDetail: { screen: ActivityDetail, path: '/activity/detail' }, // "申请成为头条号"入口
    HeadlineIndex: { screen: HeadlineIndex, path: '/headline/index' }, // "申请成为头条号"入口
    Index: { screen: Index, path: '/Index' }, // RN应用入口
    HeadlineSelect: { screen: HeadlineSelect, path: '/headline/select' }, // "申请成为头条号"选择类型
    HeadlineForm: { screen: HeadlineForm, path: '/headline/form' }, // "申请成为头条号"表单填写
    HeadlineSubmitted: { screen: HeadlineSubmitted, path: '/headline/submitted' }, // "申请成为头条号"提交成功
    VerifyPhone: { screen: VerifyPhone, path: '/phone/verify' }, // 发送短信验证手机号，此页面接受一个手机号和一个方法{phone: xxx, verifySuccess: function}，在验证成功后调用（可用于验证成功后跳转指定页面）
    BindPhone: { screen: BindPhone, path: '/phone/bind' }, // 绑定手机号，当传入isRebind时，认为时新绑手机号
    SetPassword: { screen: SetPassword, path: '/password/set' }, // 首次设置密码
    ResetPassword: { screen: ResetPassword, path: '/password/reset' }, // 修改密码（通过验证原密码修改）
    Dynamic: { screen: Dynamic, path: '/circle' }, // 群组首页
    WebPage: { screen: WebPage, path: '/web' },
    ActivitysJoined: { screen: ActivitysJoined, path: '/ActivitysJoined' },
    ActivitysMine: { screen: ActivitysMine, path: '/ActivitysMine' },
    ActivitysSignUpManagement: { screen: ActivitysSignUpManagement, path: '/ActivitysSignUpManagement' },
    ActivityJoiners: { screen: ActivityJoiners, path: '/ActivityJoiners' },
    GrowthCenter: { screen: GrowthCenter, path: '/growth/center' },
    GrowthIntro: { screen: GrowthIntro, path: '/growth/intro' },
    SetGeoLocation:{ screen: SetGeoLocation, path: '/SetGeoLocation' },
}, {
        navigationOptions: ({ navigation, screenProps }) => {
            return {
                headerTruncatedBackTitle: true,
                headerLeft: <HeaderLeft goBack={() => {
                    navigation.pop()
                }} />,
                headerRight: <HeaderRight />,
                headerStyle: commonStyle.headerStyleNormal,
                headerTitleStyle: commonStyle.headerTitleStyle,
                headerBackTitleStyle: {
                    color: '#333',
                    fontSize: px2dp(34)
                },
                headerTintColor: '#333',
                gesturesEnabled: true
            }
        },
        mode: 'float',
        headerMode: 'screen',
        initialRouteName: 'Index',
        transitionConfig: () => {
            return Platform.OS === 'android' ? { // 修改android页面切换动画（android默认从下往上，现改为从右向左）
                screenInterpolator: StackViewStyleInterpolator.forHorizontal, // 从右向左
                transitionSpec: {
                    duration: 300
                }
            } : {
                    transitionSpec: {
                        duration: 250
                    }
                }
        }
    });
let stateIndex, oStateIndex = false, goBack = false;
let lastBackPressed = false;
const defaultGetStateForAction = SimpleApp.router.getStateForAction;
SimpleApp.router.getStateForAction = (action, state) => {
    if (state) {
        stateIndex = state.index;
        if (action.type === 'Navigation/POP' || action.type === 'Navigation/BACK') { // 封装返回中断逻辑,在需要终止返回的页面设置params中的backFn，则会执行backFn，在backFn中使用返回一个promise并且不resolve的话则中断返回
            if (state.routes[state.index].params) {
                if (state.routes[state.index].params.backFn) {
                    const routes = [...state.routes];
                    let _backFn = async () => {
                        if (goBack) {
                            goBack = false;
                        } else {
                            goBack = await state.routes[state.index].params.backFn();
                        }
                        oStateIndex = state.index;
                        goBack && goBack();
                    }
                    _backFn();
                    if (stateIndex != oStateIndex) {
                        return {
                            ...state,
                            ...state.routes,
                            index: routes.length - 1,
                        }
                    } else {
                        oStateIndex = false
                    }
                }
            }
        }
        // console.log('action', action)
        if (state.routes.length === 1 && (!action.params || !action.params.stopBack)) {
            if (action.type === 'Navigation/POP') {
                // BackHandler.exitApp()
                // SwipBackModule && SwipBackModule.exitForModal();
                Util.exitRn()
            } else if (action.type === 'Navigation/REPLACE' ||
                action.type === 'Navigation/COMPLETE_TRANSITION' ||
                action.type === 'Navigation/SET_PARAMS'
            ) {
                SwipBackModule && SwipBackModule.enable();
            } else {
                SwipBackModule && SwipBackModule.disable();
            }
        } else if (action.params && action.params.stopBack) {
            SwipBackModule && SwipBackModule.disable();
        }
    }
    return defaultGetStateForAction(action, state);
}

export default SimpleApp