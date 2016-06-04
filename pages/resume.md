---
layout: page
group: navigation
toc: false
title: 简历
tagline: Linux 人才简历
permalink: /resume/
keywords: Linux, Resume, 人才, 简历
description: 来自一线 Linux 工程师的简历。
order: 20
---

<section id="home">
  {% assign articles = site.posts %}
  {% assign condition = 'group' %}
  {% assign value = 'team' %}
  {% include widgets/articles %}
</section>
