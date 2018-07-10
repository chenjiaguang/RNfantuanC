import px2dp from "../lib/px2dp";
import { Platform } from 'react-native';
import { getStatusBarHeight } from 'react-native-iphone-x-helper'
let statusBarHeight = getStatusBarHeight(true)
const commonStyle = {
  /** color **/
  // 常用颜色
  color: {
    themePrimary: '#1EB0FD', // 风格主色
    themeSecondary: '#FD6070', // 风格副色

    btn_primary: { // 主按钮
      bg: '#1EB0FD', // 背景
      bgTap: '#97DBFF', // 按下的背景
      bgDisabled: '#97DBFF', // 不可点击的背景
    },
    bg: {
      primary: '#fff', // 主背景
      secondary: '#F5F5F5' // 副背景
    },
    inputBg: '#F1F1F1', // 输入框背景
    text: {
      btn_primary: '#fff', // 主按钮文字颜色
      positive: '#1EB0FD', // 可点击文字积极色
      negative: '#FF3B30', // 可点击文字消极色
      para_primary: '#333', // 段落主文字
      para_secondary: '#666', // 段落次文字
      para_thirdly: '#999', // 段落轻文字
      error: '#FF3F53', // 段落轻文字
    },
    mask: {
      black: 'rgba(0,0,0,0.5)', // 黑色遮罩
      white: 'rgba(255,255,255,0.5)' // 白色遮罩
    },
    border: {
      default: '#E5E5E5', // 主线条颜色
      error: '#FF3F53' // 错误提示线条颜色
    }
  },
  page: {
    left: px2dp(30), // 页面左侧距离
    right: px2dp(30), // 页面右侧距离
  },
  nav: {
    height: px2dp(90), // 导航高度
    left: px2dp(18), // 导航左侧距离
    right: px2dp(18) // 导航右侧距离
  },
  headerTitleStyle: Platform.OS == 'android' ?
    {
      fontSize: 19,//不用px2dp
      color: '#333',
      alignSelf: 'center',
      textAlign: 'center',
      flex: 1,
      fontWeight: 'normal'
    } :
    {
      fontSize: px2dp(34),
      color: '#333',
      alignSelf: 'center',
      textAlign: 'center',
      flex: 1
    },
    headerStyleNormal: {
      width: px2dp(750),
      height: Platform.OS === 'android' ? 50 + statusBarHeight : px2dp(90),
      paddingTop: 0,
      backgroundColor: '#fafafa',
      borderTopColor: Platform.OS === 'android' && Platform.Version < 23 ? '#8c8c8c' : '#fafafa',//8c=fa*(256-112)/256
      borderTopWidth: Platform.OS === 'android' ? statusBarHeight : 0,
      borderBottomWidth: px2dp(1),
      borderBottomColor: '#E5E5E5',
      elevation: 0,
  }
}

export default commonStyle
