# RNfantuanC
fantuanRN项目


访问控制台日志
在运行RN应用时，可以在终端中运行如下命令来查看控制台的日志：

$ react-native log-ios
$ react-native log-android


注意事项：
每个页面第一次设置StatusBar.setBarStyle后
需要设置StatusBar.setTranslucent(true) 让状态栏透明
每个页面每一个设置StatusBar.setBarStyle后
需要设置UtilsModule.autoSetNavBar() 让安卓的navbar内容颜色正确



需要抑制的错误输出
- 三指截屏问题 
- react-native/libraries/renderer/ReactNativeRenderer-dev 
- Ended a touch event which was not counted in `trackedTouchCount`
- Cannot record touch end without a touch start.
- Cannot record touch move without a touch start.

- react-native/libraries/renderer/ReactNativeRenderer-prod
- Ended a touch event which was not counted in `trackedTouchCount`
- Cannot record touch end without a touch start.
- Cannot record touch move without a touch start.

- react-navigation/src/createNavigationContainer
- You should only render one navigator explicitly in your app, and other navigators should by rendered by including them in that navigator. Full details at: ${docsUrl('common-mistakes.html#explicitly-rendering-more-than-one-navigator')}

