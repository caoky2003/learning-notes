$ErrorActionPreference = 'Stop'
$siteRoot = Split-Path $PSScriptRoot -Parent
$courses = @(
    @{ Slug = 'asot-trance'; Title = 'ASOT 风格 Trance 制作'; Heading = 'ASOT 风格<br class="title-break">Trance 制作'; Deck = 'James Dymond · 从低频基础到完整编曲'; Count = 15; Duration = '4 小时 14 分钟'; Description = 'James Dymond ASOT 风格 Trance 制作学习笔记：15 节课程重点、回看时间、参数速查和练习计划。' },
    @{ Slug = 'signature-trance'; Title = 'The Complete Trance Tutorial'; Heading = 'The Complete<br class="title-break">Trance Tutorial'; Deck = 'Signature Sound · Metta & Glyde · 从旋律写作到完整混音'; Count = 10; Duration = '6 小时 38 分钟'; Description = 'Signature Sound 完整 Trance 制作学习笔记：10 节课程、回看时间、配套讲义要点、低频与空间排错、六次跟做计划。' }
)
foreach ($course in $courses) {
$sourcePath = Join-Path $siteRoot ('content/' + $course.Slug + '.md')
$outputDir = Join-Path $siteRoot ('notes/' + $course.Slug)
New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
$body = (ConvertFrom-Markdown -LiteralPath $sourcePath).Html
$toc = [Collections.Generic.List[string]]::new()
$headings = [regex]::Matches($body, '<h2(?:\s[^>]*)?>(.*?)</h2>')
$index = 0
foreach ($heading in $headings) {
    $label = [Net.WebUtility]::HtmlDecode(($heading.Groups[1].Value -replace '<[^>]+>', ''))
    $anchor = if ($label -match '^(\d{2}) ·') { 'chapter-' + $Matches[1] } else { 'section-' + $index }
    $safeLabel = [Net.WebUtility]::HtmlEncode($label)
    $toc.Add('<a href="#' + $anchor + '">' + $safeLabel + '</a>')
    $body = $body.Replace($heading.Value, '<h2 id="' + $anchor + '" tabindex="-1">' + $heading.Groups[1].Value + '</h2>')
    $index++
}
$body = [regex]::Replace($body, '<h1(?:\s[^>]*)?>.*?</h1>', '', 1)
$body = $body -replace '<table>', '<div class="table-scroll" role="region" aria-label="可横向滚动的数据表" tabindex="0"><table>' -replace '</table>', '</table></div>'
$template = @'
<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="James Dymond ASOT 风格 Trance 制作学习笔记：15 节课程重点、回看时间、参数速查和练习计划。">
  <meta name="theme-color" content="#142b3b">
  <title>ASOT 风格 Trance 制作 · 学习笔记</title>
  <link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'%3E%3Crect width='32' height='32' rx='7' fill='%23142b3b'/%3E%3Cpath d='M9 8h14M9 16h10M9 24h14' stroke='%23e4b25c' stroke-width='3'/%3E%3C/svg%3E">
  <link rel="stylesheet" href="../../assets/site.css">
  <script src="../../assets/reader.js" defer></script>
</head>
<body class="reading-page">
  <a class="skip-link" href="#main">跳到笔记正文</a>
  <header class="site-header"><a class="brand" href="../../">学习笔记<span>CAOKY / NOTES</span></a><a class="back-link" href="../../">全部笔记</a></header>
  <div class="reader-layout">
    <aside class="reader-nav" aria-label="笔记导航">
      <details class="chapter-menu" open>
        <summary>本篇目录 <span class="menu-hint">展开 / 收起</span></summary>
        <nav aria-label="章节目录">{{TOC}}</nav>
      </details>
    </aside>
    <main id="main" class="reading-main" tabindex="-1">
      <div class="article-heading"><div class="eyebrow">音乐制作 / TRANCE</div><h1>ASOT 风格<br class="title-break">Trance 制作</h1><p class="article-deck">James Dymond · 从低频基础到完整编曲</p><div class="article-meta"><span>15 节课程</span><span>原课约 4 小时 14 分钟</span><time datetime="2026-09-24">2026.09.24 整理</time></div><div class="article-actions"><a href="../../content/asot-trance.md" download>下载 Markdown</a><button type="button" id="print-note" hidden>打印 / 保存 PDF</button></div></div>
      <article class="prose">{{BODY}}</article>
      <footer class="article-footer"><a href="../../">返回全部笔记</a><a href="#main">回到顶部 ↑</a></footer>
    </main>
  </div>
</body>
</html>
'@
$template = $template.Replace('James Dymond ASOT 风格 Trance 制作学习笔记：15 节课程重点、回看时间、参数速查和练习计划。', $course.Description)
$template = $template.Replace('ASOT 风格 Trance 制作 · 学习笔记', $course.Title + ' · 学习笔记')
$template = $template.Replace('ASOT 风格<br class="title-break">Trance 制作', $course.Heading)
$template = $template.Replace('James Dymond · 从低频基础到完整编曲', $course.Deck)
$template = $template.Replace('15 节课程', [string]$course.Count + ' 节课程').Replace('4 小时 14 分钟', $course.Duration)
$template = $template.Replace('content/asot-trance.md', 'content/' + $course.Slug + '.md')
$output = $template.Replace('{{TOC}}', ($toc -join "`n")).Replace('{{BODY}}', $body)
[IO.File]::WriteAllText((Join-Path $outputDir 'index.html'), $output, [Text.UTF8Encoding]::new($false))
Write-Output ('Generated {0}: {1} sections.' -f $course.Slug, $headings.Count)
}
