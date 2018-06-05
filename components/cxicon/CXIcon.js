import createIconSet from 'react-native-vector-icons/lib/create-icon-set';
import glyphMap from './iconfont.json';

const iconSet = createIconSet(glyphMap, 'RNfantuanC', 'iconfont.ttf'); // 此处有大坑(RNfantuanC的由来)，小心避免

export default iconSet;

export const Button = iconSet.Button;
export const TabBarItem = iconSet.TabBarItem;
export const TabBarItemIOS = iconSet.TabBarItemIOS;
export const ToolbarAndroid = iconSet.ToolbarAndroid;
export const getImageSource = iconSet.getImageSource;