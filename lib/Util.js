
import Toast from '../components/Toast'
import {
  Platform,
  BackHandler
} from 'react-native';
import SwipBackModule from '../modules/SwipBackModule'

export default {
  showNetworkErrorToast: function (msg = "网络异常，请检查网络设置") {
    Toast.show(msg)
  },
  exitRn: (pageType) => { // pageType 表示页面弹出方式（针对ios做的判断），如果是从底部弹出，为2，如果是从右侧进入，为1
    if (Platform.OS === 'android') {
      BackHandler.exitApp()
    } else {
      if (pageType === 1) {
        SwipBackModule && SwipBackModule.exit()
      } else if (pageType === 2) {
        SwipBackModule && SwipBackModule.exitForModal()
      } else if (!pageType) {
        SwipBackModule && SwipBackModule.exit()
        SwipBackModule && SwipBackModule.exitForModal()
      }
    }
  }
}