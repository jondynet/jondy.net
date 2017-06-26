Title: Mint-ui 开发笔记
Date: 2017-05-22 16:04
Category: Debian
Tags: vue
Slug: vue-mint-ui
Authors: zhangdi
Summary: Mint-ui 开发笔记

# 基本环境搭建

```
vue init webpack myapp
cd myapp
npm install
npm install babel-preset-es2015 --save-dev
npm install babel-plugin-component -D
npm run dev 
```

将 .babelrc 修改为：
```
{
  "presets": [
    ["es2015", { "modules": false }]
  ],
  "plugins": [["component", [
    {
      "libraryName": "mint-ui",
      "style": true
    }
  ]]]
}
```
