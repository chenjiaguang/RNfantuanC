export default function (params) {
  return new Promise(function (resolve, reject) {
    let arr = params.path.split('/');
    //设置formData数据
    console.log('param', params)
    let formData = new FormData();
    let file = {uri: params.path, type: 'multipart/form-data', name: arr[arr.length-1]};
    formData.append("file", file);
    //fetch post请求
    fetch(_Api + '/upload/image', {
      method: 'POST',
      //设置请求头，请求体为json格式，identity为未压缩
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'multipart/form-data', // 该接口只接受formdata的形式
        'Content-Encoding': 'identity'
      },
      body: formData,
    }).then((response) => response.json())
      .then((responseData)=> {
        resolve(responseData);
      })
      .catch((err)=> {
        reject(err);
      });
  });
};
