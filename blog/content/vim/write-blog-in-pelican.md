Title: 用vim写pelican的博客
Date: 2016-08-21 19:07
Modified: 2016-08-21 19:07:11
Category: Vim
Tags: Vim
Slug: write-blog-in-pelican
Authors: zhangdi
Summary: 用vim写pelican的博客

我的vim配置在github上[https://github.com/jondynet/myfiles](https://github.com/jondynet/myfiles)

### 主要的插件snippets设置

增加markdown的snippets

```vim
snippet -
  Title: ${1:title}                                                                                                     
  Date: `strftime("%Y-%m-%d %H:%I")`
  Modified: `strftime("%Y-%m-%d %H:%I")`
  Category: ${2:Python}
  Tags: ${3:tags}
  Slug: `Filename("$1")`
  Authors: zhangdi
  Summary: ${4:summary}
  
snippet link
  [${1:name}](${2:url})
```

### Config 自动修改最后更新时间

```vim
" pelican 博客头部处理
autocmd BufWritePre,FileWritePre *.md   ks|call Pelican()|'s
fun Pelican()
    if line("$") > 10
        let l = 10
    else
        let l = line("$")
    endif
    exe "1," . l . "g/Modified: /s/Modified: .*/Modified: " .                                                           
        \ strftime("%Y-%m-%d %H:%I:%S")
endfun
```
