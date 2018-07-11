
import React, { Component } from 'react';
import RNFetchBlob from "react-native-fetch-blob";
import { CameraRoll, Alert } from 'react-native';

export default class DownloadUtil extends Component {

  /**
   * 保存网络图片到相册
   * @param imageUrl 图片url
   */
  static saveImageAlbum(imageUrl) {
    if (imageUrl.length > 0) {
      return RNFetchBlob
        .config({
          // add this option that makes response data to be stored as a file,
          // this is much more performant.
          fileCache: true,
          appendExt: 'png'
        })
        .fetch('GET', imageUrl, {
          //some headers ..
        })
        .then((res) => {
          // the temp file path
          return CameraRoll.saveToCameraRoll(res.path()).then(() => {
            DownloadUtil.deleteCacheImage(res.path());
          })
        })
        .catch((err) => {
          DownloadUtil.deleteCacheImage(res.path());
        })
    }
  }

  /**
   * 删除缓存图片
   * @param path
   */
  static deleteCacheImage(path) {
    RNFetchBlob.fs.unlink(path).then(() => {
      // console.warn('Deleted successfully')
    })
  }
}