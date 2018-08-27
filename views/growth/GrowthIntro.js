import React from "react";
import {
  ScrollView,
  View,
  StyleSheet
} from 'react-native';
import px2dp from '../../lib/px2dp'
import { ifIphoneX } from 'react-native-iphone-x-helper'
import Text from '../../components/MyText'

// 该页面可接受参数: userLevel 用户等级，userName 用户名称，joinDays 加入范团等天数，needScore 离下一级等成长值

export default class GrowthIntro extends React.Component {  // 什么参数都不传，则默认是绑定手机都页面，传入isRebind为true时表示新绑手机，界面稍有差异
  constructor (props) {
    super(props)
    this.state = {
      tableData: [
        [
          ['等级', '成长值'],
          [['LV1', '0-99'], ['LV2', '100-299'], ['LV3', '300-599'], ['LV4', '600-999'], ['LV5', '1000-1499']]
        ],
        [
          ['等级', '成长值'],
          [['LV6', '1500-2099'], ['LV7', '2100-2799'], ['LV8', '2800-3599'], ['LV9', '3600-4499'], ['LV10', '4500及以上']]
        ]
      ]
    }
  }
  static navigationOptions = {
    title: ''
  }
  renderTable = () => {
    let {tableData} = this.state
    let ele = <View style={styles.tableWrapper}>
      {tableData.map((item, idx) => {
        return <View style={styles.tableCors} key={idx}>
          {item.map((it, i) => {
            if (i === 0) {
              return <View key={i} style={styles.tableHead}>
                {it.map((text, textIdx) => <View style={styles.tableHeadItem} key={textIdx}>
                  <Text style={{fontSize: px2dp(24), color: '#666'}}>{text}</Text>
                </View>)}
              </View>
            } else {
              return it.map((lv, lvIdx) => <View key={i.toString() + lvIdx} style={styles.tableLine}>
                {lv.map((text, textIdx) => <View style={styles.tableLineItem} key={textIdx}>
                  <Text style={{fontSize: px2dp(24), color: '#333'}}>{text}</Text>
                </View>)}
              </View>)
            }
          })}
        </View>
      })}
    </View>
    return ele
  }
  render() {
    return <ScrollView style={styles.scrollView}>
      <View style={styles.scrollWrapper}>
        <Text style={styles.header}>什么是等级？</Text>
        <Text style={styles.statement}>等级是用户在范团的成长记录，我们欢迎每位范团er发表自己的想法和见解，陪伴范团的时间越长、分享的状态越多，等级就越高。</Text>
        <Text style={styles.content}>不需要打怪，也不要潜水，只需要积极冒泡分享内容，你就可以站C位！</Text>
        <Text style={styles.header}>什么是成长值？</Text>
        <Text style={styles.statement}>成长值是划分等级的唯一标准，是范团对每一位用户的贡献值记录，成长值越高，等级就越高。</Text>
        <Text style={styles.content}>你的每一次分享都是对范团的贡献，我们将记录你与范团共同的成长足迹！</Text>
        <Text style={styles.header}>等级一共有多少级？</Text>
        <Text style={styles.statement}>范团的等级一共有10级，等级与成长值关系如下表。</Text>
        {this.renderTable()}
        <Text style={styles.content}>你在范团的修炼段位有多高？看看等级就知道！</Text>
        <Text style={styles.header}>如何获得更多的成长值？</Text>
        <Text style={styles.statement}>范团会将每位范团er的登陆频次、在线时长、发表的动态、长文、分享的文章、参加的活动，反馈到范团er的成长值中，越活跃的范团er，成长值就越高！(更详细的成长攻略及任务请移步成长中心页面)</Text>
        <Text style={styles.content}>登录加分，发状态加分，点赞评论分享加分，参与活动加分……各种操作带来成长值飙升666！</Text>
        <Text style={styles.header}>成长值只涨不降吗？</Text>
        <Text style={styles.statement}>当然不是！如果你的发言因违反范团社区规则而遭到范团管理员的删除，你相应的成长值就会被扣除。成长值被扣除而达不到等级要求时，我们将对你进行降级！ 如果一个月内你的成长值没有任何变动，你的等级将自动下降到下一等级的最高分数，一直降到Lv1的最高分为止。</Text>
        <Text style={styles.content}>江湖规矩你懂得！对骨灰级的网络原住民来说那都不是事！</Text>
        <Text style={styles.header}>成长值可以用来干什么？</Text>
        <Text style={styles.statement}>成长值越高的范团er，将来能够优先享受范团平台的各种特权、资源和福利哦！敬请期待！</Text>
        <Text style={styles.content}>我们的小岛那么好，有趣的灵魂那么多，志趣相投的范团er一定会在这里相遇，共同创造一个有调又有品的潮流生活圈！</Text>
      </View>
    </ScrollView>
  }
}

const styles = StyleSheet.create({
  scrollView: {
    flex: 1,
    backgroundColor: '#fff'
  },
  scrollWrapper: {
    alignItems: 'stretch',
    paddingTop: px2dp(10),
    paddingLeft: px2dp(30),
    paddingRight: px2dp(30),
    ...ifIphoneX({
      paddingBottom: px2dp(78)
    }, {
        paddingBottom: px2dp(34)
      })
  },
  header: {
    fontSize: px2dp(28),
    lineHeight: px2dp(34),
    color: '#333',
    paddingBottom: px2dp(22),
    paddingTop: px2dp(22),
    fontWeight: '700'
  },
  statement: {
    fontSize: px2dp(24),
    lineHeight: px2dp(30),
    color: '#666',
    paddingBottom: px2dp(22)
  },
  content: {
    fontSize: px2dp(24),
    lineHeight: px2dp(30),
    color: '#333',
    paddingBottom: px2dp(22)
  },
  tableWrapper: {
    flexDirection: 'row',
    borderWidth: px2dp(1),
    borderColor: '#E5E5E5',
    borderRightWidth: 0,
    marginBottom: px2dp(22)
  },
  tableCors: {
    flex: 1
  },
  tableHead: {
    flexDirection: 'row',
    height: px2dp(72),
    alignItems: 'stretch',
    backgroundColor: '#FAFAFA',
    flex: 1
  },
  tableHeadItem: {
    borderRightWidth: px2dp(1),
    borderRightColor: '#E5E5E5',
    justifyContent: 'center',
    alignItems: 'center',
    flex: 1
  },
  tableLine: {
    flexDirection: 'row',
    height: px2dp(72),
    alignItems: 'stretch',
    flex: 1
  },
  tableLineItem: {
    borderTopWidth: px2dp(1),
    borderTopColor: '#E5E5E5',
    borderRightWidth: px2dp(1),
    borderRightColor: '#E5E5E5',
    justifyContent: 'center',
    alignItems: 'center',
    flex: 1
  }
})
