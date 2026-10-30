## zzidun的博客

内容在 posts, 其他目录都是博客框架用的。

## 写文章

- Markdown：`posts/你的文章.md`，开头是 `title:` / `author:` / `date:` / `tags:`，以 `---` 结束。
- LaTeX：`posts/你的文章.tex`，元数据同样写在开头，但每行用 `%` 注释，以 `% ---` 结束，这样文件仍可以直接用 latex 编译：

  ```latex
  % title: 文章标题
  % author: zzidun
  % date: 2026-03-01
  % tags: 编程学习
  % ---
  \documentclass{article}
  \begin{document}
  \section{第一节}
  行内公式 $x_1^2$。
  \end{document}
  ```

  `.tex` 正文由 pandoc 转成 HTML，公式由自托管的 MathJax 渲染。只支持 pandoc 能解析的 LaTeX 子集；TikZ、特殊宏包、参考文献等需要额外处理。

## 构建

```bash
make build     # 在 manifest.scm 的环境里构建到 docs/
make serve     # 本地预览
make publish   # 构建并提交 docs/ 与源码
```

依赖（guile、haunt、pandoc）都在 `manifest.scm` 里，刻意不锁版本。
