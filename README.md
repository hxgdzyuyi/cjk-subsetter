= subsetter

可以在网页中使用中文字体的 Rack 程序。

=== 原理

通过 sfntly (code.google.com/p/sfntly/) 来切割中文字体

=== 依赖

- java 环境
- Ruby

=== 感谢以下开源项目

- sfntly https://code.google.com/p/sfntly/

=== 不同浏览器下的表现

目前不支持 IE(eot), 因为只会生成 ttf 字体

http://www.browserstack.com/screenshots/d4d8917bd06dcddd17be4706ff4508e5842e5078
