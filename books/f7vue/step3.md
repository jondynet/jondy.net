#重新规划单页组件

在上一节我们实现了单页组件，Vue的一大好处是组件化，让我们可以更好的复用代码，

我们的单页应用需要显示一些图文的说明性内容，那么图片应该是随着这个组件使用的，
以后如果删除或修改也都在这个组件内，为了拥有一个更清晰的结构和以后更新和维护方便，
我们调整一下这个组件。

在src/components目录新建wifipage文件夹,
将wifi.vue移动至此，新建内容的图片logo.png。

修改wifi.vue文件

```html
<template>
    <div class="content">
        <p>
            <img :src="logo" alt="wifi">
        </p>
        <div>
            <h3>
                免费Wi-Fi使用说明
            </h3>
            <p>
                长白山风景区已全线免费Wi-Fi覆盖，<br>请接入
                <span>cbs</span> 的Wi-Fi，<br>
                并且关注长白山风景区微信公众号即可免费上网。
            </p>
        </div>
    </div>
</template>

<script>
import logo from './logo.png'
export default {
  data() {
    return {
      logo: logo
    }
  }
}
</script>

<style lang="css">
    .content{
        text-align: center;
    }
</style>
```

目前项目需求并没有App连Wi-Fi或者其它需要通过当前H5内容联网的情况，
此页面以后很可能废弃或者调整，在同一个文件夹的好处就是随时可以干净的处理掉这里内容。
