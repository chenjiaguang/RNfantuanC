import {Dimensions,PixelRatio,Platform,StatusBar} from 'react-native';
let designSize = {width:750,height:1336}; // 设计稿尺寸
export default class Resolution {
  static get(type){
    let pxRatio = PixelRatio.get();
    let {width,height} = Dimensions.get("window");
    height = Platform.OS === 'ios' ? height : height - StatusBar.currentHeight // iphone上Dimensions的高度包括StatusBar在内，而安卓不是
    let w = PixelRatio.getPixelSizeForLayoutSize(width);
    let h = PixelRatio.getPixelSizeForLayoutSize(height);

    let scale = width/designSize.width;
    let winSize = {width:designSize.width,height:h*scale};
    return {
      width:winSize.width,
      height:winSize.height,
      scale:scale
    }
  }
};