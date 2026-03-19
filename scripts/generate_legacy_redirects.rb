#!/usr/bin/env ruby
# frozen_string_literal: true

require "cgi"
require "csv"
require "digest/sha1"
require "fileutils"
require "json"
require "yaml"

ROOT = File.expand_path("..", __dir__)
CSV_PATH = ARGV[0] || "/Users/jtianling/Downloads/jtianling.com-Coverage-Drilldown-2026-03-19/Table.csv"
OUTPUT_DIR = File.join(ROOT, "legacy-redirects")
SITE_URL = "https://www.jtianling.com"

def parse_front_matter(path)
  content = File.read(path)
  match = content.match(/\A---\s*\n(.*?)\n---\s*\n/m)
  return {} unless match

  YAML.safe_load(match[1], permitted_classes: [Date, Time], aliases: true) || {}
end

def normalize(value)
  CGI.unescape(value.to_s)
    .unicode_normalize(:nfkc)
    .downcase
    .gsub(%r{https?://[^/]+}, "")
    .tr("（）()《》【】[]，,。.!！?？：:；;、“”\"'‘’`·|", " ")
    .gsub(/[%]/, " ")
    .gsub(/[-_\/\.]/, " ")
    .gsub(/\b(html|aspx)\b/, " ")
    .gsub(/\s+/, "")
end

def normalize_slug_from_path(path)
  slug = path.sub(%r{^/+}, "").sub(%r{/+$}, "")
  slug = slug.split("/").last.to_s
  slug = slug.sub(/\.(html|aspx)\z/, "")
  normalize(slug)
end

def build_current_targets
  title_index = Hash.new { |h, k| h[k] = [] }
  slug_index = Hash.new { |h, k| h[k] = [] }
  paths = {}

  Dir.glob(File.join(ROOT, "_posts", "*.{md,markdown,html}")).sort.each do |path|
    data = parse_front_matter(path)
    basename = File.basename(path).sub(/\.(md|markdown|html)\z/, "")
    slug = basename.sub(/\A\d{4}-\d{2}-\d{2}-/, "")
    permalink = data["permalink"] || "/#{slug}.html"

    title = data["title"].to_s
    title_index[normalize(title)] << permalink
    slug_index[normalize(slug)] << permalink
    paths[permalink] = true
  end

  Dir.glob(File.join(ROOT, "pages", "*.{md,markdown,html}")).sort.each do |path|
    data = parse_front_matter(path)
    next unless data["permalink"]

    permalink = data["permalink"]
    title = data["title"].to_s
    title_index[normalize(title)] << permalink
    slug_index[normalize_slug_from_path(permalink)] << permalink
    paths[permalink] = true
  end

  [title_index, slug_index, paths]
end

MANUAL = {
  "/archive/2007/10/12/1821091.aspx" => "/c-lamentable-memory-management-discussion-and-strange-auto-ptr-introduction.html",
  "/archive/2008/01/04/2025395.aspx" => "/dos-commands-in-c-remembering-from-dir-on.html",
  "/archive/2008/04/23/2316681.aspx" => "/windows-multiple-pointer-input-technology-implementation-and-application-6-single-display-groupware-toolkit-application.html",
  "/archive/2008/04/23/2316694.aspx" => "/windows-multiple-pointer-input-technology-implementation-and-application-summarizing-and-continuing-mfc-discussion.html",
  "/archive/2008/11/23/3352969.aspx" => "/windows-multiple-pointer-input-technology-implementation-and-application-10-double-mouse-gomoku-source-code-complete-series.html",
  "/archive/2009/06/07/4246470.aspx" => "/boost-thread-library-the-odd-documentation-without-tutorials-yet-still-pretty-powerful.html",
  "/archive/2009/06/08/4248655.aspx" => "/asio-the-next-generation-c-standard-possibly-accepted-network-library-1-simple-application.html",
  "/archive/2009/06/14/4267359.aspx" => "/pyqt-learning-getting-started-discussion-on-current-gui-choices.html",
  "/archive/2009/06/20/4281633.aspx" => "/pyqt-2-dialogues.html",
  "/archive/2009/07/27/4382591.aspx" => "/exception-handling-minidump-seh-structured-exception.html",
  "/archive/2009/09/26/4593687.aspx" => "/distributed-new-generation-version-control-system-mercurial-introduction-and-brief-getting-started.html",
  "/archive/2009/09/28/4602961.aspx" => "https://www.cnblogs.com/xuejinhui/p/4350717.html",
  "/archive/2009/10/17/4689516.aspx" => "https://www.cnblogs.com/smartgloble/articles/5690393.html",
  "/archive/2010/06/15/5672068.aspx" => "/orx-1-2-version-preview-evaluation-of-sfml-and-sdl-by-iarwain.html",
  "/archive/2010/06/18/5679217.aspx" => "/standing-on-the-shoulders-of-giants-game-development-2-orx-getting-started-and-hello-world.html",
  "/archive/2010/07/09/5724112.aspx" => "/new-feature-custom-fonts-and-unicode-displaying-chinese-examples.html",
  "/archive/2010/07/15/5735979.aspx" => "/sdl-simple-getting-started-guide.html",
  "/archive/2010/07/15/5738421.aspx" => "/glfw-getting-started-guide.html",
  "/archive/2010/07/17/5740993.aspx" => "/using-opengl-in-sdl.html",
  "/archive/2010/07/31/5777944.aspx" => "/unconventional-2d-game-engine-orx-source-code-reading-notes-1-overall-structure.html",
  "/archive/2010/08/01/5780357.aspx" => "/unconventional-2d-game-engine-orx-source-code-reading-notes-3-memory-management.html",
  "/archive/2010/10/09/5930269.aspx" => "/bullet-3ds-max-plugin.html",
  "/archive/2010/10/25/5963301.aspx" => "/line-razoring-algorithm.html",
  "/articles/1002.html" => "/frightening-boost-library-what-more-could-there-be-changing-views-on-existing-cross-platform-support-library-development-what-if-i-cant-use-boost-library-in-the-future.html",
  "/articles/1172.html" => "/lisp-powerful-features-v-s-python3-part-1.html",
  "/articles/1278.html" => "/programmers-quiet-by-nature-become-genius-in-tech-topics-discuss-language-tool-choice.html",
  "/articles/1848.html" => "/write-blog-with-markdown-and-vimpress.html",
  "/articles/1920.html" => "/the-right-way-to-write-recursive-function.html",
  "/articles/1988.html" => "/multiple-inheritance-is-not-bad.html",
  "/articles/1998.html" => "/multiple-inheritance-is-not-bad.html",
  "/articles/2049.html" => "/the-features-of-javascript.html",
  "/articles/2079.html" => "/repl-read-eval-print-loop.html",
  "/articles/2176.html" => "/use-rakefile-to-manage-project.html",
  "/articles/2220.html" => "/use-spine-with-cocos2d-x.html",
  "/article/details/5754179" => "/data-configuration-storage-json-example-jsoncpp-library.html",
  "/category/554877.aspx" => "/tags.html#Qt",
  "/library/bisect.html" => "https://docs.python.org/3/library/bisect.html",
  "/page18/Eclipse IDE for C/C Developers /(79 MB/)" => "https://www.eclipse.org/downloads/packages/",
  "/win32-opengl系列专题.html" => "http://blog.csdn.net/vagrxie/article/details/4776410",
  "/一个最最简单的画图软件.html" => "/the-simplest-drawing-software.html",
  "/基本ok-开始正常的写博客.html" => "/basic-ok-start-writing-blog-normally.html",
  "/转-游戏设计的秘密-翻译gdc2010-blizzard的一个演讲.html" => "/translate-game-design-secrets-gdc2010-blizzard-speech.html",
  "/转-翻译-orx官方教程-05-视口与摄像机-viewport-camera.html" => "/translate-orx-official-tutorial-5-viewport-camera.html",
  "/转-翻译-orx官方教程-6-声音和音乐-sound-music.html" => "/translate-orx-official-tutorial-6-sound-music.html",
  "/程序员平时都是木讷的-但是谈到计算机或者程序的时候简直就是天才-兼借题发挥-谈谈语言及工具的选择.html" => "/programmers-quiet-by-nature-become-genius-in-tech-topics-discuss-language-tool-choice.html",
  "/n1744-给c-0x标准的大整数库提案-粗略翻译稿.html" => "/add-infinite-precision-integer-proposal-for-c-standard-library-translation-n1692.html",
  "/n1744-big-integer-library-proposal-for-c-0x-粗略翻译稿-双语对照-有什么不妥-请参看原文.html" => "/add-infinite-precision-integer-proposal-for-c-standard-library-translation-n1692.html",
  "/对提案n1692-a-proposal-to-add-the-infinite-precision-integer-to-the-c-standard-library-的看法.html" => "/views-on-proposal-n1692-a-proposal-to-add-the-infinite-precision-integer-to-the-c-standard-library.html",
  "/debug思考模式-1-关注更改.html" => "/debug-thinking-mode-1-focusing-on-changes.html",
  "/c-中的dos命令调用-1-还可以记起什么-从dir开始.html" => "/dos-commands-in-c-remembering-from-dir-on.html",
  "/c-中的dos命令调用-2-瞒天过海-隐藏dos调用的命令行窗口.html" => "/dos-commands-in-c-hiding-the-command-line-window-magic-trick.html",
  "/c-中的dos命令调用-3-我不提倡大量使用dos命令.html" => "/dos-commands-in-c-3-avoid-abundant-use.html",
  "/asio-下一代c-标准可能接纳的网络库-2-tcp网络应用.html" => "/asio-the-next-generation-c-standard-possibly-accepted-network-library-2-tcp-network-applications.html",
  "/asio-下一代c-标准可能接纳的网络库-3-udp网络应用.html" => "/asio-the-next-generation-c-standard-possibly-accepted-network-library-3-udp-network-application.html",
  "/序列化支持-3-boost的序列化库的使用.html" => "/serialization-support-boost-serialization-library-usage.html",
  "/序列化支持-4-boost的序列化库的强大之处.html" => "/serialization-support-boost-serialization-libraries-strengths.html",
  "/一天一个c-run-time-library-函数-1-isascii-iswascii-toascii.html" => "/one-c-run-time-library-function-1-isascii-iswascii-toascii.html",
  "/一天一个c-run-time-library-函数-2-max-min.html" => "/c-run-time-library-function-2-max-min.html",
  "/疯狂猎鸟项目小结-技术篇.html" => "/crazy-bird-hunting-project-summary-technical-essay.html",
  "/pyqt学习-的开始-顺面小谈目前gui的选择.html" => "/pyqt-learning-getting-started-discussion-on-current-gui-choices.html",
  "/简单图形编程的学习-1-文字-small-basic实现.html" => "/simple-graphic-programming-learning-1-text-small-basic-implementation.html",
  "/简单图形编程的学习-1-文字-windows-gdi实现.html" => "/simple-graphic-programming-learning-1-text-windows-gdi-implementation.html",
  "/简单图形编程的学习-2-点-windows-gdi实现.html" => "/simple-graphic-programming-learning-2-point-windows-gdi-implementation.html",
  "/frightening-boost-library-what-more-could-there-be-changing-views-on-existing-cross-platform-support-library-development-what-if-i-cant-use-boost-library-in-the-future/" => "/frightening-boost-library-what-more-could-there-be-changing-views-on-existing-cross-platform-support-library-development-what-if-i-cant-use-boost-library-in-the-future.html"
}.freeze

IGNORED = [
  "/转-我不是谁的代言-我是程序员-程序员版的凡客体.html"
].freeze

def target_for(path, title_index, slug_index)
  return MANUAL[path] if MANUAL.key?(path)

  if (match = path.match(%r{\A/page\d+/page(\d+)/?\z}))
    return "/page#{match[1]}/"
  end

  slug_key = normalize_slug_from_path(path)
  title_hits = title_index[slug_key].uniq
  slug_hits = slug_index[slug_key].uniq

  candidates = (slug_hits + title_hits).uniq
  return candidates.first if candidates.size == 1

  nil
end

def absolute_target(target)
  target.start_with?("http://", "https://") ? target : "#{SITE_URL}#{target}"
end

title_index, slug_index, current_paths = build_current_targets
urls = CSV.read(CSV_PATH, headers: true)["URL"].uniq
paths = urls.map { |url| url.sub(%r{https?://[^/]+}, "") }.uniq.sort

mapping = {}
unresolved = []

paths.each do |path|
  if IGNORED.include?(path)
    next
  end

  if current_paths[path]
    next
  end

  target = target_for(path, title_index, slug_index)
  if target.nil?
    unresolved << path
    next
  end

  if !target.start_with?("http://", "https://")
    target_path = target.sub(/#.*/, "")
    unless current_paths[target_path] || target.start_with?("/page")
      raise "Target does not exist for #{path}: #{target}"
    end
  end

  mapping[path] = target
end

unless unresolved.empty?
  warn "Unresolved paths:"
  unresolved.each { |path| warn "  #{path}" }
  exit 1
end

FileUtils.rm_rf(OUTPUT_DIR)
FileUtils.mkdir_p(OUTPUT_DIR)

mapping.sort.each do |source, target|
  filename = "#{Digest::SHA1.hexdigest(source)}.html"
  filepath = File.join(OUTPUT_DIR, filename)
  absolute = absolute_target(target)
  escaped = CGI.escapeHTML(absolute)

  File.write(filepath, <<~HTML)
    ---
    layout: null
    permalink: #{source}
    sitemap: false
    ---
    <!doctype html>
    <html lang="zh-CN">
      <head>
        <meta charset="utf-8">
        <title>Redirecting...</title>
        <meta name="robots" content="noindex">
        <meta http-equiv="refresh" content="0; url=#{escaped}">
        <link rel="canonical" href="#{escaped}">
        <script>
          window.location.replace(#{absolute.to_json});
        </script>
      </head>
      <body>
        <p>Redirecting to <a href="#{escaped}">#{escaped}</a>.</p>
      </body>
    </html>
  HTML
end

puts "Generated #{mapping.size} redirect pages into #{OUTPUT_DIR}"
