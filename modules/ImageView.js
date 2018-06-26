// ImageView.js

import { requireNativeComponent, View } from 'react-native';
import PropTypes from 'prop-types';

var iface = {
  name: 'RCTRotateImageView',
  propTypes: {
    type: PropTypes.number,
    ...View.propTypes // 包含默认的View的属性
  },
};

module.exports = requireNativeComponent('RCTRotateImageView', iface);