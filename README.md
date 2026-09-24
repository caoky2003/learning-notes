# 学习笔记

个人学习网站，收录课程要点、回看位置、操作方法和练习清单。

在线阅读：https://caoky2003.github.io/learning-notes/

## 当前内容

- [ASOT 风格 Trance 制作](notes/asot-trance/) — James Dymond，15 节课程。
- [Markdown 原文](content/asot-trance.md)

## 更新现有笔记

1. 修改 `content/asot-trance.md`。
2. 在 PowerShell 7 中执行 `./scripts/build.ps1`，生成网页。
3. 提交 Markdown 和生成的 HTML，推送到 `main`。

GitHub Pages 从 `main` 分支根目录发布，无需服务器或第三方前端依赖。页面使用相对链接，支持仓库子路径部署。

## 添加新课程

将 Markdown 放到 `content/`，为新课程生成独立的 `notes/课程名/index.html`，并在首页增加课程入口。现有构建脚本目前只生成 ASOT 笔记，可在增加第二篇时扩展。

## 内容范围

仅发布整理后的学习笔记，不包含原课程视频、字幕、工程或音频素材。参数与操作说明用于记录课程示范，具体设置应结合自己的素材复核。
