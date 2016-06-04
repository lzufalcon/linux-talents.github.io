---
layout: page
group: navigation
toc: false
title: 团队
tagline: Linux 团队介绍
permalink: /team/
keywords: Linux, Team, 团队 
description: 来自高校或者企业的 Linux 团队。
order: 9
---

<section id="home">
  {% assign articles = site.posts %}
  {% assign condition = 'group' %}
  {% assign value = 'team' %}
  {% include widgets/articles %}
</section>
