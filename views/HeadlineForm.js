import React from "react";
import {
  ScrollView,
  TouchableOpacity,
  View,
  Image,
  StyleSheet,
  Platform,
  Modal,
  TouchableWithoutFeedback,
  Alert
} from 'react-native';
import Iconfont from "../components/cxicon/CXIcon"; // 自定义iconfont字体文字，基于"react-native-vector-icons"
import commonStyle from '../static/commonStyle' // 公共样式，方便以后换肤，换主题色
import { ifIphoneX } from 'react-native-iphone-x-helper' // 判断是否iphoneX，适配底部开口
const defaultAvatar = require('../static/image/rn_apply_default_avatar.png')
const defaultPic = require('../static/image/rn_apply_default_pic.png')
import Picker from 'react-native-picker'; // RN官方提供的只有ios是滚轮的,引入滚轮选择（ios/android）
import px2dp from '../lib/px2dp' // 将设计稿的尺寸转为可用的dp单位(以设计稿宽度750)
import { getStatusBarHeight } from 'react-native-iphone-x-helper' // 获取状态栏高度(ios/android)，RN官方提供的只在android上有效
import MyTextInput from '../components/MyTextInput' // 封装RN官方的TextInput以处理中文输入问题（RN官方bug）
import ImagePicker from 'react-native-image-crop-picker'; // 选择图片插件(ios/android)，提供从相册和拍照中获取
import UploadImage from '../lib/UploadImage' // 上传图片方法，目前封装了单张图片的情况
import MakeCancelAble from '../lib/MakeCancelAble' // 封装的可一步终止promise方法
import ActionSheet from 'react-native-actionsheet' // RN官方提供ios的ActionSheet，此处引入双平台的ActionSheet(ios/android)
import Toast from '../components/Toast'
import Button from 'apsl-react-native-button' // 第三方button库，RN官方的库会根据平台不同区别，这里统一
import KeyboardSpacer from 'react-native-keyboard-spacer'
import { KeyboardAwareScrollView } from 'react-native-keyboard-aware-scroll-view'
import Text from '../components/MyText'
// 申请头条表单填写

export default class HeadlineForm extends React.Component {
  constructor (props) {
    super(props)
    this.state = {
      actionSheetOptions: Platform.OS === 'android' ? [<Text style={{ color: '#333333', fontSize: px2dp(34) }}>选择照片</Text>,
      <Text style={{ color: '#333333', fontSize: px2dp(34) }}>拍照上传</Text>,
      <Text style={{ color: '#333333', fontSize: px2dp(34) }}>取消</Text>] : ['选择照片', '拍照上传', '取消'],
      form: { // 提交前表单存储，需做过滤筛选，此处为了方便展示表单内容
        avatar: {
          value: '',
          url: '',
          uploading: false,
          uploadText: ''
        },
        name: '',
        phone: '',
        area: {},
        intro: '',
        idCardImage: {
          value: '',
          url: '',
          uploading: false,
          uploadText: ''
        },
        realName: '',
        idCardNumber: '',
        organizationName: '',
        organizationAddress: '',
        organizationWebsite: '',
        agreement: true
      },
      validates: { // 实时检测输入是否合法
        avatar: v => v.value,
        name: v => v && v.length <= 10,
        phone: v => /^1[34578][0-9]\d{8}$/.test(v),
        area: v => v.value || (v.value && !v.value && v.value !== '' && v.value !== undefined && v.value.toString() === '0'),
        intro: v => v && v.length >= 10 && v.length <= 30,
        idCardImage: v => v.value,
        realName: v => v,
        idCardNumber: v => v,
        organizationName: v => v,
        organizationAddress: v => v,
        organizationWebsite: v => true,
        agreement: v => v,
      },
      errorTip: { // 错误提示内容
        avatar: '请上传头像',
        name: '请输入1~10字，不含特殊符号的头条号名称',
        phone: '请输入正确的联系电话',
        area: '请选择专注的领域',
        intro: '请输入10~30个字的简介',
        idCardImage: '请上传身份证正面照',
        realName: '请输入真实姓名',
        idCardNumber: '请输入身份证号',
        organizationName: '请输入组织名称',
        organizationAddress: '请输入组织地址',
        organizationWebsite: false,
        agreement: '需阅读并同意范团用户协议'
      },
      areas: [], // 专注领域  [{value: xxx,label: yyy}]
      areasLabel: [], // 专注领域展示的标签，用于在滚轮选择领域里展示领域名称  [xxx,yyy]
      keyboardHeight: 0,
      topSpacing: 0,
      buttonClicked: false, // 是否显示错误提示依据(初始无数据时不展示)
      activePic: '', // 用于选择图片成功后应赋给那个值
      loadStorageSuccess: false, // 缓存是否加载成功，判断之前是否存过表单
      submitting: false
    }
  }
  static navigationOptions = { // 导航配置
    title: ''
  };
  goNext = () => { // 下一步
    let {form, validates, buttonClicked, submitting} = this.state
    let has_error = false
    let _validates = Object.assign({}, validates)
    if (this.props.navigation.state.params && this.props.navigation.state.params.type.toString() === '1') {
      _validates.organizationName = v => true
      _validates.organizationAddress = v => true
    }
    for (let key in form) {
      if (!_validates[key](form[key])) { // 有不满足条件的表单项时
        has_error = true
        break
      }
    }
    if (!buttonClicked) { // 允许显示错误信息
      this.setState({
        buttonClicked: true
      })
    }
    if (has_error) { // 错误返回
      Toast.show('请更正未正确填写的内容')
      return false
    }
    if (submitting) { // 一般不会走这部，保险起见
      Toast.show('正在提交，请稍后...')
      return false
    }
    let rData = {
      account_type: (this.props.navigation.state.params && this.props.navigation.state.params.type) || 1, // 默认个人
      name: form.name,
      avatar: form.avatar.value,
      intro: form.intro,
      cid: form.area.value,
      phone: form.phone,
      real_name: form.realName,
      idcard: form.idCardNumber,
      id_img: form.idCardImage.value,
      company: form.organizationName,
      address: form.organizationAddress,
      link: form.organizationWebsite
    }
    this.setState({
      submitting: true
    })
    console.log('rData', rData)
    _FetchData(_Api + '/news/apply', rData).then(res => { // 提交信息给后端
      console.log('申请成功', res)
      this.setState({
        submitting: false
      })
      if (res.error && Number(res.error) && res.msg) {
        Toast.show(res.msg)
        return  false
      }
      this.props.navigation.navigate('HeadlineSubmitted')
    }, err => {
      console.log('申请失败', err)
      // 发生错误
      this.setState({
        submitting: false
      })
    })
  }
  showActionSheet = (value) => { // 拉起ActionSheet
    if (!value) { // 不指定值的时候，不响应
      return false
    }
    this.setState({
      activePic: value
    }, () => {
      this.ActionSheet.show()
    })
  }
  selectPic = (key) => { // "选择照片"回调
    ImagePicker.openPicker({
      width: 400,
      height: 400,
      cropping: true
    }).then(image => {
      // 选择图片成功
      this.uploadPic(key, image)
    }, err => {
      // 选择图片失败
    });
  }
  takePhoto = (key, image) => { // "拍照上传"回调
    ImagePicker.openCamera({
      width: 400,
      height: 400,
      cropping: true
    }).then(image => {
      // 拍照并选择成功
      this.uploadPic(key, image)
    }, err => {
      // 拍照或选择失败
    });
  }
  uploadPic = (key, image) => { // 调用上传图片
    let {form} = this.state
    let _form = Object.assign({}, form)
    // return false
    let uri = image.path
    this[key] && this[key].cancel()
    this[key] = MakeCancelAble(UploadImage(image))
    this[key].promise.then((res) => {
      // 上传成功
      if (!res.error && res.data) {
        let {form} = this.state
        let _form = Object.assign({}, form)
        _form[key].value = res.data.id[0]
        _form[key].uploading = false
        this.setState({
          form: _form
        })
      }
    }, (err) => {
      // 上传失败
      let {form} = this.state
      let _form = Object.assign({}, form)
      if (err.isCanceled) { // 手动取消
        _form[key].uploadText = '取消上传'
      } else {
        _form[key].uploadText = '上传失败'
      }
      this.setState({
        form: _form
      })
    })
    _form[key].url = {uri: uri}
    _form[key].uploading = true
    _form[key].uploadText = '上传中...'
    this.setState({
      form: _form
    })
  }
  inputChange = (key, value) => { // 输入框的值改变后处理
    let { form } = this.state
    let _form = Object.assign({}, form)
    _form[key] = value
    this.setState({
      form: _form
    })
  }
  showAreaPicker = () => { // 调起滚轮选择器
    this.initAreaPicker(() => this.setState({ showModal: true }))
  }
  renderInputItem = (option) => { // 渲染单行输入框，option: {title: 填写项文字, value: 绑定的数据[String]}
    let { form, error, validates, errorTip, buttonClicked } = this.state
    return <View style={{paddingTop: px2dp(20), borderBottomWidth: px2dp(1), borderBottomColor: buttonClicked && !validates[option.value](form[option.value]) ? commonStyle.color.border.error : commonStyle.color.border.default}}>
      <Text style={{fontSize: px2dp(28), lineHeight: px2dp(68), color: commonStyle.color.text.para_primary}}>{option.title}</Text>
      <View style={{flexDirection: 'row', alignItems: 'center'}}>
        <MyTextInput autoCorrect={false} ref={option.value} value={form[option.value]} autoCapitalize="none" placeholder={option.placeholder} placeholderTextColor={commonStyle.color.text.para_thirdly} onChangeText={(value) => this.inputChange(option.value, value)} onFocus={() => {this.setState({focus: option.value})}} keyboardType={option.value === 'phone' ? 'phone-pad' : 'default'} style={{flex: 1, height: px2dp(72), color: commonStyle.color.text.para_primary, fontSize: px2dp(32), fontWeight: '600', padding: 0}} underlineColorAndroid="transparent"/>
        {buttonClicked && !validates[option.value](form[option.value]) ? <View style={{flexDirection: 'row', alignItems: 'center', marginLeft: px2dp(10), width: px2dp(326), overflow: 'visible'}}>
          <Iconfont name='warn' size={px2dp(24)} color={commonStyle.color.themeSecondary} style={{marginRight: px2dp(20), overflow: 'visible'}}></Iconfont>
          <View style={{flex: 1, flexDirection: 'row', alignItems: 'center'}}>
            <Text style={{fontSize: px2dp(24), lineHeight: px2dp(24), paddingTop: Platform.OS === 'android' ? px2dp(8) : 0, color: commonStyle.color.text.error}}>{errorTip[option.value]}</Text>
          </View>
        </View> : null}
      </View>
    </View>
  }
  renderAreaItem = () => { // 渲染专业领域
    let { form, error, validates, errorTip, buttonClicked } = this.state
    return <View style={{paddingTop: px2dp(20), borderBottomWidth: px2dp(1), borderBottomColor: buttonClicked && !validates.area(form.area) ? commonStyle.color.border.error : commonStyle.color.border.default}}>
      <Text style={{fontSize: px2dp(28), lineHeight: px2dp(68), color: commonStyle.color.text.para_primary}}>专注领域</Text>
      <TouchableWithoutFeedback onPress={this.showAreaPicker}>
        <View style={{flexDirection: 'row', alignItems: 'center', height:  px2dp(72)}}>
          {form.area.label ? <Text style={{flex: 1, fontSize: px2dp(32), color: commonStyle.color.text.para_primary, fontWeight: '600'}}>{form.area.label}</Text> : <Text style={{flex: 1, fontSize: px2dp(32), color: commonStyle.color.text.para_thirdly, fontWeight: '600'}}>请选择专注领域</Text>}
          <View style={{flexDirection: 'row', width: px2dp(326), justifyContent: 'flex-end', alignItems: 'center'}}>
            {buttonClicked && !validates.area(form.area) ? <View style={{flexDirection: 'row', alignItems: 'center', flex: 1}}>
              <Iconfont name='warn' size={px2dp(24)} color={commonStyle.color.themeSecondary} style={{marginRight: px2dp(20)}}></Iconfont>
              <Text style={{fontSize: px2dp(24), lineHeight: px2dp(32), color: commonStyle.color.text.error, flex: 1}}>{errorTip.area}</Text>
            </View> : null}
            <Iconfont name='next' size={px2dp(18)} color={commonStyle.color.text.para_thirdly} style={{marginRight: -px2dp(3)}}></Iconfont>
          </View>
        </View>
      </TouchableWithoutFeedback>
    </View>
  }
  renderIntroItem = () => { // 渲染多行输入框（简介）
    let { form, error, validates, errorTip, buttonClicked } = this.state
    return <View style={{paddingTop: px2dp(20), paddingBottom: px2dp(40)}}>
      <View style={{flexDirection: 'row', alignItems: 'center'}}>
        <Text style={{fontSize: px2dp(28), lineHeight: px2dp(68), color: commonStyle.color.text.para_primary, flex: 1}}>简介</Text>
        {buttonClicked && !validates.intro(form.intro) ? <View style={{flexDirection: 'row', alignItems: 'center', marginLeft: px2dp(10), width: px2dp(326), overflow: 'visible'}}>
          <Iconfont name='warn' size={px2dp(24)} color={commonStyle.color.themeSecondary} style={{marginRight: px2dp(20), overflow: 'visible'}}></Iconfont>
          <View style={{flex: 1, flexDirection: 'row', alignItems: 'center'}}>
            <Text style={{fontSize: px2dp(24), lineHeight: px2dp(24), paddingTop: Platform.OS === 'android' ? px2dp(8) : 0, color: commonStyle.color.text.error}}>{errorTip.intro}</Text>
          </View>
        </View> : null}
      </View>
      <View style={{flex: 1, height: px2dp(150), marginTop: px2dp(20), borderRadius: px2dp(4), borderWidth: px2dp(1), borderColor: buttonClicked && !validates.intro(form.intro) ? commonStyle.color.border.error : commonStyle.color.border.default}}>
        <MyTextInput autoCorrect={false} ref="intro" multiline={true} value={form.intro} placeholder="10~30字，简单介绍你的头条号。要求内容完整通顺，无特殊符号" placeholderTextColor={commonStyle.color.text.para_thirdly} autoCapitalize="none" onChangeText={(value) => this.inputChange('intro', value)} onFocus={() => this.setState({focus: 'intro'})} keyboardType="default" style={{flex: 1, color: commonStyle.color.text.para_primary, fontSize: px2dp(32), fontWeight: '600', paddingLeft: px2dp(20), paddingRight: px2dp(20), textAlignVertical: 'top'}} underlineColorAndroid="transparent"/>
      </View>
    </View>
  }
  renderImageItem = (option) => { // 渲染上传图片项，option: {title: 填写项文字，value: 绑定的数据[String], tip: 数组，浅色提示文字，icon: 默认icon，callback: 上传图片回调}
    let { form, error, validates, errorTip, buttonClicked } = this.state
    return <View style={{flexDirection: 'row', justifyContent: 'space-between', alignItems: 'flex-end', paddingTop: px2dp(20), paddingBottom: px2dp(36), borderBottomWidth: px2dp(1), borderBottomColor: buttonClicked && !validates[option.value](form[option.value]) ? commonStyle.color.border.error : commonStyle.color.border.default}}>
      <View>
        <View style={{flexDirection: 'row', alignItems: 'flex-end'}}>
          <Text style={{fontSize: px2dp(28), lineHeight: px2dp(40), fontWeight: '600', color: commonStyle.color.text.para_primary}}>{option.title}</Text>
          {buttonClicked && !validates[option.value](form[option.value]) ? <View style={{flexDirection: 'row', alignItems: 'center', marginLeft: px2dp(22)}}>
            <Iconfont name='warn' size={px2dp(24)} color={commonStyle.color.themeSecondary} style={{marginRight: px2dp(20)}}></Iconfont>
            <Text style={{fontSize: px2dp(24), lineHeight: px2dp(36), color: commonStyle.color.text.error}}>{errorTip[option.value]}</Text>
          </View> : null}
        </View>
        {option.tip.map((item, idx) => <Text key={idx} style={{fontSize: px2dp(24), lineHeight: px2dp(32), color: commonStyle.color.text.para_thirdly}}>{item}</Text>)}
      </View>
      <TouchableOpacity activeOpacity={0.8} onPress={option.callback} style={{marginBottom: px2dp(4)}}>
        {form[option.value].url ? <View style={{width: px2dp(120), height: px2dp(120), position: 'relative', borderRadius: option.value === 'avatar' ? option.iconSize.width / 2 : 0, overflow: 'hidden'}}>
          <Image source={form[option.value].url} resizeMode={option.value === 'avatar' ? 'cover' : 'contain'} style={{width: px2dp(120), height: px2dp(120), position: 'absolute', zIndex: 1, top: 0, left: 0}}></Image>
            {form[option.value].uploading ? <View style={{width: px2dp(120), height: px2dp(120), position: 'absolute', zIndex: 2, top: 0, left: 0, justifyContent: 'center', alignItems: 'center', backgroundColor: 'rgba(0,0,0,0.5)'}}>
              <Text style={{fontSize: px2dp(24), color: '#fff'}}>{form[option.value].uploadText}</Text>
            </View> : null}
        </View> : <Image source={option.icon} resizeMode="contain" style={{width: option.iconSize.width, height: option.iconSize.height}}></Image>}
      </TouchableOpacity>
    </View>
  }
  loadStorage = () => {
    let {params} = this.props.navigation.state
    AppStorage.load({ // 尝试从存储中获取填写的信息
      key: params && params.type.toString() === '2' ? 'ApplyFormOrganization' : 'ApplyFormPerson',
      autoSync: false,
      syncInBackground: true
    }).then(res => {
      let storage_form = {}
      for (let key in res) {
        if (key !== 'avatar' && key !== 'idCardImage' && key !== 'area') { // 不获取头像、身份证照片、专注领域，避免结构有变导致报错崩溃
          storage_form[key] = res[key]
        }
      }
      let {form} = this.state
      let _form = Object.assign({},form, storage_form)
      this.setState({
        form: _form,
        loadStorageSuccess: true
      })
    }).catch(err => {
      // do nothing
      console.log('AppStorage_err', err)
    })
  }
  saveStorage = () => {
    let {form} = this.state
    let {params} = this.props.navigation.state
    AppStorage.save({ // 定义的全局AppStorage
      key: params && params.type.toString() === '2' ? 'ApplyFormOrganization' : 'ApplyFormPerson',  // 注意:请不要在key中使用_下划线符号!
      data: form,
      // 如果不指定过期时间，则会使用defaultExpires参数
      // 如果设为null，则永不过期
      expires: 1000 * 3600 * 24
    });
  }
  componentDidMount () {
    this.fetchArea()
    this.loadStorage()
    this.props.navigation.setParams({ // 设置返回时的提示
      backFn: () => {
        return new Promise((resolve, reject) => {
          let {form, loadStorageSuccess} = this.state
          let has_data = false
          for (let key in form) {
            if (key !== 'agreement' && key !== 'avatar' && key !== 'idCardImage' && key !== 'area' && form[key]) {
              has_data = true
              break;
            }
          }
          if (has_data && !loadStorageSuccess) {
            Alert.alert(
              '提示',
              '确定离开吗？离开我们将为您保存所填数据24小时',
              [
                {
                  text: '继续填写',
                  onPress: () => {},
                  style: 'cancel'
                },
                {
                  text: '暂时离开',
                  onPress: () => { // 保存数据并返回
                    this.saveStorage()
                    resolve(this.props.navigation.goBack);
                  }
                }
              ],
              {
                cancelable: true
              }
            )
          } else {
            this.saveStorage()
            resolve(this.props.navigation.goBack);
          }
        }).catch(err => {
          console.log('返回错误捕获')
        })
      }
    });
  }
  fetchArea = (callback) => { // 获取专业领域数据，传入callback时,在获取数据完毕后执行回调
    _FetchData(_Api + '/news/apply/initform').then(res => {
      let label = []
      res.data.category_list.forEach(item => {
        label.push(item.label)
      });
      if (!res.error) {
        label[0] && callback && callback(() => this.setState({showModal: true}))
        this.setState({
          areas: res.data.category_list,
          areasLabel: label
        })
      }
    }, err => {
      console.log('发生错误')
    })
  }
  initAreaPicker = (callback) => { // 初始化滚轮选择
    let { areasLabel, form } = this.state
    if (areasLabel && areasLabel[0]) {
      Picker.init({
        pickerBg: [255,255,255,1],
        pickerToolBarBg: [255,255,255,1],
        pickerData: areasLabel,
        selectedValue: [form.area.label || areasLabel[0]],
        pickerConfirmBtnText: '完成',
        pickerCancelBtnText: '取消',
        pickerTitleText: '专注领域',
        pickerConfirmBtnColor: [30,176,253,1],
        pickerCancelBtnColor: [102,102,102,1],
        pickerTitleColor: [51,51,51,1],
        onPickerConfirm: data => {
          let { form, areas } = this.state
          const selected = areas.filter(item => item.label === data[0])[0]
          const _form = Object.assign({}, form, {area: selected})
          this.setState({
            form: _form,
            showModal: false
          })
        },
        onPickerCancel: data => {
          this.setState({
            showModal: false
          })
        }
      });
      callback && callback()
    } else {
      this.fetchArea(this.initAreaPicker)
    }
  }
  changeAgreement = () => {
    let {form} = this.state
    let _form = Object.assign({}, form)
    _form.agreement = !form.agreement
    this.setState({
      form: _form
    })
  }
  renderScrollView = () => {
    return <View style={style.scrollView}>
      <KeyboardAwareScrollView enableResetScrollToCoords={false} style={style.scrollView} keyboardDismissMode={Platform.OS === 'ios' ? 'on-drag' : 'none'} keyboardShouldPersistTaps="handled">
        <View style={style.contentWrapper}>
          <View style={style.area}>
            <Text style={style.header}>主要信息填写</Text>
            {this.renderImageItem({title: '请上传头像', value: 'avatar', tip: ['选择文件要求清晰、健康、代表品牌形象'], icon: defaultAvatar, iconSize: {width: px2dp(120), height: px2dp(120)}, callback: () => this.showActionSheet('avatar')})}
            {this.renderInputItem({title: '头条号名称', value: 'name', placeholder: '请输入1-10个字'})}
            {this.renderInputItem({title: '联系电话', value: 'phone', placeholder: '请输入正确的联系电话'})}
            {this.renderAreaItem()}
            {this.renderIntroItem()}
            <Modal
              animationType="fade"
              transparent={true}
              visible={this.state.showModal || false}
              onRequestClose={() => {
                Picker.hide()
                this.setState({
                showModal: false
              })}}
              style={{flex: 1}}
            >
              <TouchableWithoutFeedback onPress={() => { this.setState({showModal: false}); Picker.hide();}} onLayout={() => Picker.show()}>
                <View style={{flex:1, backgroundColor: 'rgba(0,0,0,0.5)'}}></View>
              </TouchableWithoutFeedback>
            </Modal>
          </View>
          <View style={style.separator}></View>
          <View style={[style.area, {paddingTop: px2dp(20)}]}>
            <Text style={style.header}>负责人资料</Text>
            {this.renderImageItem({title: '手持身份证正面照', value: 'idCardImage', tip: ['照片要求要有持证人的半身像，', '身份证信息可明显识别'], icon: defaultPic, iconSize: {width: px2dp(130), height: px2dp(85)}, callback: () => this.showActionSheet('idCardImage')})}
            {this.renderInputItem({title: '真实姓名', value: 'realName', placeholder: '请输入真实姓名'})}
            {this.renderInputItem({title: '身份证号', value: 'idCardNumber', placeholder: '请输入真实身份证号'})}
            <Text style={{fontSize: px2dp(28), lineHeight: px2dp(38), color: commonStyle.color.text.para_primary, paddingTop: px2dp(30), paddingBottom: px2dp(30)}}>负责人资料提交审核通过后，不可进行修改</Text>
          </View>
          {this.props.navigation.state.params && this.props.navigation.state.params.type && this.props.navigation.state.params.type.toString() === '2' && <View style={style.separator}></View>}
          {this.props.navigation.state.params && this.props.navigation.state.params.type && this.props.navigation.state.params.type.toString() === '2' && <View style={[style.area, {paddingTop: px2dp(20)}]}>
            <Text style={style.header}>组织机构资料</Text>
            {this.renderInputItem({title: '组织名称', value: 'organizationName', placeholder: '请输入组织名称'})}
            {this.renderInputItem({title: '组织地址', value: 'organizationAddress', placeholder: '请输入正确的地址'})}
            {this.renderInputItem({title: '官网地址', value: 'organizationWebsite', placeholder: '请输入正确的官网地址'})}
            <Text style={{fontSize: px2dp(28), lineHeight: px2dp(38), color: commonStyle.color.text.para_primary, paddingTop: px2dp(30), paddingBottom: px2dp(30)}}>组织机构资料提交审核通过后，不可进行修改</Text>
          </View>}
          <View style={{height: px2dp(60), marginLeft: commonStyle.page.left, marginRight: commonStyle.page.right, flexDirection: 'row', alignItems: 'flex-start'}}>
            <TouchableWithoutFeedback onPress={this.changeAgreement}>
              <View style={{flexDirection: 'row'}}>
                <Iconfont name={this.state.form.agreement ? 'checked' : 'uncheck'} size={px2dp(24)} color={this.state.form.agreement ? commonStyle.color.themePrimary : commonStyle.color.text.para_secondary} style={{marginRight: px2dp(20), marginTop: Platform.OS === 'ios' ? px2dp(4) : 0, overflow: 'visible'}}></Iconfont>
                <Text style={{paddingTop: px2dp(4), fontSize: px2dp(24), lineHeight: px2dp(24)}}>
                  <Text style={{color: commonStyle.color.text.para_primary}}>我已同意</Text>
                  <Text style={{color: commonStyle.color.text.positive}} onPress={() => this.props.navigation.navigate('WebPage',{title: '范团头条号用户协议', url: _Api + '/cweb/index.html#/agreement?type=author'})}>《范团头条号用户协议》</Text>
                </Text>
              </View>
            </TouchableWithoutFeedback>
            {this.state.buttonClicked && !this.state.validates.agreement(this.state.form.agreement) ? <View style={{flexDirection: 'row', alignItems: 'flex-start', marginLeft: px2dp(10), flex: 1, overflow: 'visible'}}>
              <Iconfont name='warn' size={px2dp(24)} color={commonStyle.color.themeSecondary} style={{marginRight: px2dp(20), marginTop: Platform.OS === 'ios' ? px2dp(4) : 0, overflow: 'visible'}}></Iconfont>
              <View style={{flex: 1, flexDirection: 'row', alignItems: 'center'}}>
                <Text style={{paddingTop: px2dp(4), fontSize: px2dp(24), lineHeight: px2dp(24), color: commonStyle.color.text.error}}>{this.state.errorTip.agreement}</Text>
              </View>
            </View> : null}
          </View>
          <Button style={style.button} textStyle={style.buttonText} disabledStyle={{opacity: 0.8}} onPress={this.goNext} activeOpacity={0.8}>下一步</Button>
          <ActionSheet
            ref={el => this.ActionSheet = el}
            options={this.state.actionSheetOptions}
            cancelButtonIndex={2}
            onPress={(index) => {
              let {activePic} = this.state
              if (!activePic) { // 无指定值时不响应
                return false
              }
              switch (index) {
                case 0: // 选择照片
                  this.selectPic(activePic)
                  break;
                case 1:
                  this.takePhoto(activePic)
                  break;
                default:
                // do nothing
              }
            }}
          />
        </View>
      </KeyboardAwareScrollView>
    </View>
  }
  render() {
    return this.renderScrollView()
  }
}

const style = StyleSheet.create({
  scrollView: {
    flex: 1,
    backgroundColor: commonStyle.color.bg.primary
  },
  contentWrapper: {
    ...ifIphoneX({
      paddingBottom: px2dp(124)
    }, {
      paddingBottom: px2dp(80)
    })
  },
  area: {
    marginLeft: commonStyle.page.left,
    marginRight: commonStyle.page.right
  },
  header: {
    fontSize: px2dp(48),
    lineHeight: px2dp(88),
    fontWeight: '700',
    color: commonStyle.color.text.para_primary
  },
  separator: {
    height: px2dp(10),
    backgroundColor: commonStyle.color.border.default
  },
  button: {
    width:px2dp(690),
    height:px2dp(90),
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#1EB0FD',
    marginTop: px2dp(40),
    alignSelf: 'center',
    borderRadius: px2dp(6),
    borderWidth: 0
  },
  buttonText: {
    fontSize: px2dp(34),
    color: '#fff'
  }
})
