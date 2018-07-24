import React from "react";
import {
  ScrollView,
  View,
  StyleSheet,
  TouchableWithoutFeedback,
  LayoutAnimation,
  UIManager
} from 'react-native';
import px2dp from '../../lib/px2dp'
import { ifIphoneX } from 'react-native-iphone-x-helper'
import Iconfont from "../../components/cxicon/CXIcon"; // 自定义iconfont字体文字，基于"react-native-vector-icons"
import Toast from  '../../components/Toast'
import Text from '../../components/MyText'
import Progress from '../../components/Progress'
import Image from '../../components/SmoothImage'
import TaskItems from './TaskItem'
import Swiper from 'react-native-swiper'

// 该页面可接受参数: userLevel 用户等级，userName 用户名称，joinDays 加入范团等天数，needScore 离下一级等成长值

export default class GrowthCenter extends React.Component {  // 什么参数都不传，则默认是绑定手机都页面，传入isRebind为true时表示新绑手机，界面稍有差异
  constructor (props) {
    super(props)
    UIManager.setLayoutAnimationEnabledExperimental && UIManager.setLayoutAnimationEnabledExperimental(true)
    let {params} = props.navigation.state
    this.state = {
      userAvatar: (params && params.userAvatar) ? {uri: params.userAvatar} : null,
      userLevel: (params && params.userLevel) ? params.userLevel : 0,
      userName: (params && params.userName) ? params.userName : '',
      joinDays: (params && params.joinDays) ? params.joinDays : 0,
      levelPercent: 0,
      needScore: (params && params.needScore) ? params.needScore : 0,
      notice: [],
      todayMissions: [
        {
          title: '发动态',
          content: '成长值+5，每日上限20',
          missionPoint: '0',
          limit: '20'
        },
        {
          content: '成长值+8，每日上限24',
          limit: '24',
          missionPoint: '0',
          title: '发长文'
        },
        {
          content: '成长值+1，每日上限8',
          limit: '8',
          missionPoint: '0',
          title: '发表评论/回复'
        },
        {
          content: '成长值+2，每日上限4',
          limit: '4',
          missionPoint: '0',
          title: '分享长文，微海南文章'
        },
        {
          content: '成长值+1',
          limit: '',
          missionPoint: '',
          title: '举报并且后台通过'
        },
        {
          content: '成长值+1',
          limit: '',
          missionPoint: '+1',
          title: '今日首次登录范团'
        }
      ],
      mainMissions: [
        {
          title: '报名参加免费活动',
          content: '成长值+5,每日上限10',
          missionPoint: '0',
          limit: '10'
        },
        {
          content: '成长值+10,每日上限20',
          limit: '10',
          missionPoint: '0',
          title: '报名参加付费活动'
        },
        {
          content: '成长值+10',
          limit: '',
          missionPoint: '未完成',
          title: '绑定微信号'
        },
        {
          content: '成长值+5',
          limit: '',
          missionPoint: '未完成',
          title: '完善个人资料'
        },
        {
          content: '成长值+10',
          limit: '',
          missionPoint: '',
          title: '成为圈主'
        },
        {
          content: '成长值+8',
          limit: '',
          missionPoint: '',
          title: '成为圈管'
        }
      ]
    }
  }
  static navigationOptions = {
    title: '成长中心'
  }
  goIntro = () => {
    let {navigate} = this.props.navigation
    navigate('GrowthIntro')
  }
  goBindWeChat = () => { // _todo
    console.log('跳转绑定微信')
  }
  goCompleteInfo = () => { // _todo
    console.log('完善个人资料')
  }
  fetchInfo = () => {
    _FetchData(_Api + '/jv/user/point/getUserPoint').then(res => {
      if (res && Boolean(res.error) && res.msg) {
        Toast.show(res.msg)
      } else if (res && !Boolean(res.error) && res.data) {
        let _obj = {}
        _obj.userAvatar = {uri: res.data.avatarUrl}
        _obj.joinDays = Number(res.data.day)
        _obj.userLevel = Number(res.data.level)
        _obj.userName = res.data.name
        _obj.levelPercent = Number(res.data.totalPoint) / (Number(res.data.totalPoint) + Number(res.data.needPointUp))
        _obj.needScore = Number(res.data.needPointUp)
        _obj.notice = res.data.content
        _obj.todayMissions = res.data.todayMissions
        _obj.mainMissions = res.data.mainMissions
        this.setState(_obj)
      }
    }).catch(err => {
      console.log('获取成长值失败')
    })
  }
  componentDidMount () {
    this.fetchInfo()
  }
  componentWillUpdate (nextProps, nextState) {
    let {levelPercent, notice} = this.state
    if (levelPercent !== nextState.levelPercent || (notice.length === 0 && nextState.notice.length !== 0)) {
      LayoutAnimation.easeInEaseOut()
    }
  }
  renderTaskItemRight = (item) => {
    if (item.title === '绑定微信号') { // 绑定微信号
      return item.missionPoint === '未完成' ? <Text onPress={this.goBindWeChat} style={{fontSize: px2dp(30), color: '#1EB0FD'}} suppressHighlighting={true}>去完成</Text> : <Text style={{fontSize: px2dp(30), color: '#999'}}>已完成</Text>
    } else if (item.title === '完善个人资料') {
      return item.missionPoint === '未完成' ? <Text onPress={this.goCompleteInfo} style={{fontSize: px2dp(30), color: '#1EB0FD'}} suppressHighlighting={true}>去完成</Text> : <Text style={{fontSize: px2dp(30), color: '#999'}}>已完成</Text>
    } else {
      return <Text style={{fontSize: px2dp(30), color: '#999'}}><Text style={{fontWeight: '700'}}>{item.missionPoint}</Text>{item.limit ? ('/' + item.limit) : null}</Text>
    }
  }
  render() {
    let {userAvatar, userLevel, userName, joinDays, levelPercent, needScore, notice, todayMissions, mainMissions} = this.state
    return <ScrollView style={styles.scrollView}>
      <View style={styles.scrollWrapper}>
        <View style={styles.header}>
          <Image style={styles.avatar} source={userAvatar || defaultAvatar} />
          <Image style={[styles.level, {width: userLevel >= 10 ? px2dp(63) : px2dp(53)}]} source={levelImage['lv' + userLevel]} resizeMode={'contain'} />
          <View style={styles.name} numberOfLines={1}>
            <Text numberOfLines={1} style={{fontSize: px2dp(34), color: '#333'}}>{userName}</Text>
          </View>
          <View style={styles.joinDays}>
            <Text numberOfLines={1} style={{fontSize: px2dp(20), color: '#666'}}>今天是你加入范团的第{joinDays}天哦</Text>
          </View>
          <Progress width={px2dp(600)} height={px2dp(10)} colors={['#40D8FF', '#1EB0FD']} percent={levelPercent} style={{marginTop: px2dp(30)}} />
          <View style={styles.nextLevelNeed}>
            <Text numberOfLines={1} style={{fontSize: px2dp(20), color: '#333'}}>{userLevel >= 10 ? '恭喜你等级达到Lv10~' : ('距LV' + (userLevel + 1) + '还需' + needScore + '成长值')}</Text>
          </View>
          <TouchableWithoutFeedback onPress={this.goIntro}>
            <View style={styles.knowMore}>
              <Text style={styles.knowMoreText}>了解更多</Text>
              <Iconfont name="help" color="#1EB0FD" size={px2dp(25)} />
            </View>
          </TouchableWithoutFeedback>
        </View>
        <View style={styles.grayBlock}></View>
        <View style={styles.centerMain}>
          {(notice && notice.length > 0) ? <View onStartShouldSetResponderCapture={() => true} style={[styles.noticeWrapper, {height: px2dp(100)}]}>
            <Iconfont name="notice" color="#333" size={px2dp(30)} style={{marginRight: px2dp(15)}} />
            <Swiper showsPagination={false} autoplay={true} autoplayTimeout={3} horizontal={false} index={0}>
              {notice.map((item, idx) => <View onStartShouldSetResponderCapture={() => true} style={[styles.noticeItem, {height: px2dp(100)}]} key={idx}>
                <Text onStartShouldSetResponderCapture={() => true} style={styles.noticeText}>{item}</Text>
              </View>)}
            </Swiper>
          </View> : null}
          <View style={styles.centerMainHeader}>
            <Text style={{fontSize: px2dp(32), color: '#333', fontWeight: '700', marginRight: px2dp(10)}}>今日任务</Text>
            <Text style={{fontSize: px2dp(24), color: '#999', marginRight: px2dp(10)}}>花点小时间做任务，轻松升级</Text>
          </View>
          {(todayMissions && todayMissions.length > 0) ? todayMissions.map((item, idx) => <TaskItems key={idx} icon={taskImage['task' + (idx + 1)]} title={item.title} state={item.content} rightArea={this.renderTaskItemRight(item)} />) : null}
          <View style={styles.centerMainHeader}>
            <Text style={{fontSize: px2dp(32), color: '#333', fontWeight: '700', marginRight: px2dp(10)}}>主线任务</Text>
            <Text style={{fontSize: px2dp(24), color: '#999', marginRight: px2dp(10)}}>主线任务，带你深入玩转范团</Text>
          </View>
          {(mainMissions && mainMissions.length > 0) ? mainMissions.map((item, idx) => <TaskItems key={idx} icon={taskImage['task' + (idx + 7)]} title={item.title} state={item.content} rightArea={this.renderTaskItemRight(item)} />) : null}
        </View>
      </View>
    </ScrollView>
  }
}

const defaultAvatar = require('../../static/image/rn_user.png')
const levelImage = {
  lv1: require('../../static/image/level1.png'),
  lv2: require('../../static/image/level2.png'),
  lv3: require('../../static/image/level3.png'),
  lv4: require('../../static/image/level4.png'),
  lv5: require('../../static/image/level5.png'),
  lv6: require('../../static/image/level6.png'),
  lv7: require('../../static/image/level7.png'),
  lv8: require('../../static/image/level8.png'),
  lv9: require('../../static/image/level9.png'),
  lv10: require('../../static/image/level10.png')
}

const taskImage = {
  task1: require('../../static/image/task1.png'),
  task2: require('../../static/image/task2.png'),
  task3: require('../../static/image/task3.png'),
  task4: require('../../static/image/task4.png'),
  task5: require('../../static/image/task5.png'),
  task6: require('../../static/image/task6.png'),
  task7: require('../../static/image/task7.png'),
  task8: require('../../static/image/task8.png'),
  task9: require('../../static/image/task9.png'),
  task10: require('../../static/image/task10.png'),
  task11: require('../../static/image/task11.png'),
  task12: require('../../static/image/task12.png')
}

const styles = StyleSheet.create({
  scrollView: {
    flex: 1,
    backgroundColor: '#fff'
  },
  scrollWrapper: {
    alignItems: 'stretch',
    ...ifIphoneX({
      paddingBottom: px2dp(204)
    }, {
        paddingBottom: px2dp(160)
      })
  },
  grayBlock: {
    height: px2dp(10),
    backgroundColor: '#F3F3F3'
  },
  header: {
    height: px2dp(430),
    justifyContent: 'flex-start',
    alignItems: 'center'
  },
  avatar: {
    width: px2dp(120),
    height: px2dp(120),
    marginTop: px2dp(40),
    borderRadius: px2dp(60)
  },
  level: {
    width:px2dp(53),
    height: px2dp(26),
    marginTop: px2dp(20)
  },
  name: {
    height: px2dp(54),
    justifyContent: 'center',
    marginTop: px2dp(10)
  },
  joinDays: {
    height: px2dp(40),
    justifyContent: 'center'
  },
  nextLevelNeed: {
    height: px2dp(40),
    marginTop: px2dp(10),
    justifyContent: 'center'
  },
  knowMore: {
    position: 'absolute',
    top: px2dp(20),
    right: px2dp(30),
    flexDirection: 'row',
    justifyContent: 'flex-end',
    alignItems: 'center',
    paddingTop: px2dp(20),
    paddingBottom: px2dp(20),
    paddingRight: px2dp(2)
  },
  knowMoreText: {
    color: '#333',
    fontSize: px2dp(24),
    marginRight: px2dp(9)
  },
  noticeWrapper: {
    flexDirection: 'row',
    borderBottomWidth: px2dp(1),
    borderBottomColor: '#E5E5E5',
    marginLeft: px2dp(30),
    marginRight: px2dp(30),
    paddingLeft: px2dp(5),
    alignItems: 'center'
  },
  noticeItem: {
    flexDirection: 'row',
    alignItems: 'center'
  },
  noticeText: {
    fontSize: px2dp(24),
    color: '#333'
  },
  centerMainHeader: {
    height: px2dp(72),
    marginTop: px2dp(20),
    marginRight: px2dp(30),
    marginLeft: px2dp(30),
    paddingBottom: px2dp(20),
    flexDirection: 'row',
    alignItems: 'flex-end'
  }
})
