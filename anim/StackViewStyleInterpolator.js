
import getSceneIndicesForInterpolationInputRange from 'react-navigation/src/utils/getSceneIndicesForInterpolationInputRange';
import { I18nManager } from 'react-native';

function forInitial(props) {
  const { navigation, scene } = props;

  const focused = navigation.state.index === scene.index;
  const opacity = focused ? 1 : 0;
  // If not focused, move the scene far away.
  const translate = focused ? 0 : 1000000;
  return {
    opacity,
    transform: [{ translateX: translate }, { translateY: translate }],
  };
}
/**
 * Standard iOS-style slide in from the right.
 */
function forHorizontal(props) {
    const { layout, position, scene } = props;
  
    if (!layout.isMeasured) {
      return forInitial(props);
    }
    const interpolate = getSceneIndicesForInterpolationInputRange(props);
  
    if (!interpolate) return { opacity: 0 };
  
    const { first, last } = interpolate;
    const index = scene.index;
    const opacity = position.interpolate({
      inputRange: [first, first + 0.01, index, last - 0.01, last],
      outputRange: [0, 1, 1, 0.85, 0],
    });
  
    const width = layout.initWidth;
    const translateX = position.interpolate({
      inputRange: [first, index, last],
      outputRange: I18nManager.isRTL
        ? [-width, 0, width * 0.3]
        : [width, 0, width * -0.3],
    });
    const translateY = 0;
  
    return {
      opacity,
      transform: [{ translateX }, { translateY }],
    };
  }

  export default {
    forHorizontal,
  };