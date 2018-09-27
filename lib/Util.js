
import Toast from '../components/Toast'
export default {
  showNetworkErrorToast: function (msg = "网络异常，请检查网络设置") {
    Toast.show(msg)
  }
}