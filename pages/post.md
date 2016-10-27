---
title: 投稿
tagline: 欢迎提交团队信息、工作机会、求职简历等
layout: page
group: navigation
highlight: true
permalink: /post/
order: 30
---

Linux Talents 作为一个开放 Linux 人才交流平台，热烈欢迎大家参与。

而参与的最好方式莫过于提交各自 Linux 团队的信息，发布工作机会，递送求职简历。

为了提高团队信息、工作机会和简历的质量，我们也会安排严格的评审。

下面是一般的稿件投递过程。

## 快速上手

* 下载博客仓库

      $ git clone https://github.com/tinyclub/cloud-lab.git
      $ cd cloud-lab/ && tools/docker/choose linux-talents

* 安装 jekyll 编译环境

  Ubuntu 14.04 以上用户可直接执行：

      $ tools/docker/build
      or
      $ tools/docker/pull

  其他用户请先参照 [官方文档](https://docs.docker.com/engine/installation/linux/)安装好 docker，之后通过如下命令搭建环境：

* 启动 jekyll 环境，之后在容器内通过 <http://localhost:8081> 访问站点，如果 `8081` 有冲突，请修改 `configs/linux-talents/docker/portmap` 中的端口号。

      $ tools/docker/uid           # Sync uid between host and container
      $ tools/docker/identify      # Disable password
      $ tools/docker/run

* 生成文章模板, slug 为链接，title 为标题

      $ tools/post slug=the-first-post-slug title="第一篇原创文章。。。"

* 参照模板编辑文章

      $ vim _posts/*the-first-post-slug*

* 投稿

  写完后可直接把稿件发送到 wuzhangjin [AT] gmail [DOT] com 或者按照后面的 “[递送稿件](#section-7)” 过程通过 github 提交（推荐）。如果有图片等资料请一并发送到邮件，通过 github 提交则记得存放并上传到 `uploads/年/月/`。

**注**：推荐遵循下述完整投稿过程，因为所有过程可通过 github 管控，包括评审等流程，非常便利。

## 完整投稿过程

### Fork / Star / Clone 文章仓库

我们的文章仓库托管在 [Github][1] 上，可这样下载：

    $ git clone https://github.com/linux-talents/linux-talents.github.io.git
    $ cd linux-talents.github.io

打开 [在线仓库][1]，并 [Fork](https://github.com/linux-talents/linux-talents.github.io#fork-destination-box) / Star，之后就可持续参与/关注我们的原创进程。

### 搭建 Jekyll 工作环境

Ubuntu 14.04 以上用户，可通过 docker 快速搭建：

    $ sudo ./docker/build
    $ sudo ./docker/run
    $ sudo ./docker/open

### 撰写稿件

通过如下命令创建一份文章模板，然后采用 Markdown 撰写。

    $ rake post

或者

    $ tools/post

后者是前者的封装，可以简化命令行的输入。

或者直接把文件名和短地址设置好：

    $ tools/post slug=the-first-post-slug

当然，也可以同时把其他参数都默认设置好，比如标题：

    $ tools/post slug=the-first-post-slug title="第一篇原创文章。。。"

更多参数请参考：

    author='Author'
    nick="Nick Name"
    title="A Title"
    tags="[tag1,tag2]"
    categories="[category1,category2]"
    group='Article Group'
    album='Article Series'
    tagline='subtitle'
    description="summary"
    slug='URL with English characeters'

Markdown 基本用法请参考 [Markdown 语法说明][2] 以及上面创建的文章模板中的说明。

如果希望使用更多样式，可参照 `_posts/` 目录下的其他文章。

如果有附件或者图片资料，请创建目录 `uploads/年/月/`，并添加资料进去，然后在文章中通过 Markdown 语法引用。

*注*：也可以在 `_data/people.yml` 中添加上作者信息后直接通过如下方式创建一个快捷命令以便自动填充作者信息，例如：

    $ cd tools
    $ ln -s post falcon.post

把 `falcon` 替换为你自己的昵称即可。

### 编译和浏览文稿

如果 jekyll 环境由 docker 搭建，文章会被自动编译，可实时通过 <http://localhost:8080> 查看编译效果。

### 递送稿件

测试完无误后即可通过 Github 发送 Pull Request 进行投稿。

这一步要求事先做如下准备：

* 在 Github Fork 上述 [文章仓库][1]
* 您在本地修改后先提交到刚 Fork 的仓库
* 然后再进入自己仓库，选择合并到我们的 master 分支

提交 Pull Request 后，我们会尽快安排人员评审，评审通过后即可发布到网站。

## 文章模板说明

通过 `rake post` 或者 `tools/post` 可以创建一份文章模板，这里对该模板做稍许说明，更多内容请阅读模板本身。

该模板包括两大部分，第一部分是用两个 `---` 括起来的文件头，剩下的部分为文章正文。

* 文件头包含文章的基本信息，`jekyll` 模板系统用它来构建文章页面
* 文件正文即普通的 Markdown 文件主体，基本遵循 Markdown 规范

模板基本样式如下：

    ---
    layout: post
    author: "Your Name"
    title: "new post"
    permalink: /new-post-slug/
    description: "summary"
    category:
      - category1
      - category2
    tags:
      - tag1
      - tag2
    ---


    > By YOUR NICK NAME of TinyLab.org
    > 2015-09-21



    文章正文




模板文件头中的关键字大部分为 `jekyll` 默认支持，我们加入了少许关键字，这里一并说明：

| 关键字 | 说明              |  备注     |
|:------:|-------------------|---------------|
|layout  | 文章均为 post     | **必须**
|author  | 作者名，同 `_data/people.yml` | **必须**
|title   | 标题名，支持中、英文      | **必须**
|permalink| 英文短链接，不能包含中文 | **必须**
|tagline  | 子标题/副标题            | 可选
|description| 文章摘要              | 可选
|album      | 所属文章系列/专题     | 可选
|group      | 默认 original，可选 translation, news, resume or jobs, 详见 `_data/groups.yml` | 可默认
|category   | 分类，每行1个，至少1个，必须在`_data/categories.yml` | **必须**
|tags       | 标签，每行1个，至少1个，至多5个 | **必须**

## 完善作者信息

为了方便读者和潜在合作伙伴联系到您，请参考如下表格在 `_data/people.yml` 中编辑作者信息并发送 Pull Request 入库。

更多信息说明如下，以网站帐号 `admin` 为例，即 `_data/people.yml` 中左侧的 `admin:`：

|属性    |   属性值      |  说明                    |
|:------:|:-------------:|--------------------------|
|name    | 泰晓科技      | 对应中文名或者全名
|nickname| tinylab       | 网络昵称或者英文名
|archive | true          | 展示作者所有文章
|article | true          | 生成当前文章二维码，手机可扫码阅读
|site    | tinylab.org   | 作者个人站点地址，请不要写 `http://` 头
|email   | xxx@gmail.com | 作者邮箱
|github  | tinyclub             | 作者 github 帐号
|weibo   | tinylaborg           | 新浪微博帐号，务必事先配好短域名，否则须用 `u/xxx`
|weibo-qrcode  | false          | 新浪微博二维码，本站可自动生成，请保留为false
|wechat        | tinylab-org    | 微信或者公众号
|wechat-qrcode | true           | 暂时无法自动生成，需要显示二维码必须先生成一份传到 `images/wechat`，并以 `wechat` 帐号命名，该项为 true
|sponsor       | weixin-pay-admin-9.68 | 如希望获得打赏，请命名二维码图片为：weixin-pay-*author*-*money*
|sponsor-qrcode| true                  | 图片请存到 `images/sponsor` 并设该项为 true
|info          | ...                   | 建议介绍专业、兴趣、特长等，如较多，请用 `;` 分割，以便自动分段展示
|--------------|-----------------------|----------------|

 [1]: https://github.com/linux-talents/linux-talents.github.io.git
 [2]: http://wowubuntu.com/markdown/
