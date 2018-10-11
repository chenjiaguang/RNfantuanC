
import region from '../static/region'
export default {
  load: function (beforeSelectsName = []) {
    let _regions = region.data.regions
    for (let i = 0; i < beforeSelectsName.length; i++) {
      let __regions = _regions.find((item) => {
        return item.n == beforeSelectsName[i]
      }).c
      if (__regions) {
        _regions = __regions
      }
    }
    return _regions.map((item) => {
      return {
        n: item.n,
        e: item.c.length == 0
      }
    })
  }
}