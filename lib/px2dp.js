import {Dimensions,PixelRatio,Platform,StatusBar} from 'react-native';
let designSize = {width:750,height:1336}; // 设计稿尺寸
export default function px2dp (px) {
  let {width} = Dimensions.get("window");
  let scale = width/designSize.width
  return px * scale
};