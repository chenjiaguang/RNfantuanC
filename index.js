import {
  AppRegistry, Dimensions, PixelRatio,
  YellowBox,
} from 'react-native';
import App from './App';
import './lib/Global';

// 忽略 "isMounted(...)不支持" 警告，该警告是react bug等待官方修复
YellowBox.ignoreWarnings(['Warning: isMounted(...) is deprecated', 'Module RCTImageLoader']);
AppRegistry.registerComponent('RNfantuanC', () => App);
