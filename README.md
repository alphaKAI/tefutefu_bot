てふてふ
==================
  
  
概要
------------------
This is one of the twitter's bot "tefutefu_tyou".  
似非英語です、α改が開発してるRuby製botです。  
Copyleft (C) α改 @alpha_kai_NET 2012-2013 http://alpha-kai-net.info/  
Using alphaKAI/TwitRuby Library.  
GPLv3 LICENSE  
  
  
機能
-----------------
*挨拶機能  
*UserStream取得  
*バトルドームおみくじ  
*ふぁぼ  
*天気機能  
*再起動 停止  
*さらにたくさん  
  
  
VERSION
-----------------
2012/12/23  Version:0.0.2                  公開  
2013/3/29   Version:0.4.4α_Rb FIX08        公開 ここよりRubyに移行  
2013/3/29   Version:0.4.5α_Rb              公開 ファイルをわけて管理性の向上及び、可読性の向上  
2013/3/31   Version:0.4.5α_Rb FIX06        公開 語彙を少し増やしたり厄介度を増したりとか  
2013/5/15   Version:0.4.6α_Rb              公開 stop rebootの強化  
2013/6/20   Version:0.5.0α_Rb FIX01        公開 脱Twitter gemした  
2013/6/20   Version:0.5.5α_Rb              公開 新・お天気機能の実装  
2013/7/02   Version:0.5.8α_Rb              公開 リプライパーサーを正規表現で大幅書き直し  
2013/7/02   Version:0.5.8α_Rb FIX01        公開 リプライパーサーを動くようにした  
2013/7/26   Version:0.5.8α_Rb FIX03 stable 公開 23連続のシフト連発してたのをeachでスマートにした  
2013/7/26   Version:0.5.8α_Rb FIX04 stable 公開 HashをXMLから読み込んで生成させるようにしたのとFIX03をなかったことにした  
2013/9/02   Version:0.5.8α_Rb FIX05 stable 公開 リプライパーサーの天気の条件式を修正し、無差別リプライを停止  
2013/9/03   Version:0.5.8α_Rb FIX06        公開 動くようにした module行を消した  
  
　 
ChangeLog
-----------------
Version:0.5.8α_Rb FIX05 stable  
* リプライパーサーの天気の条件式を修正し、無差別リプライを停止  
* リツイートに反応しないようにした  
* READMEにChangeLogをつけるようにした  
  
Version:0.5.8α_Rb FIX06  
* module行を消した おそらく名前空間がアレになって起動しなかったので非module化により解決
  
  
注意事項
-----------------
本スクリプトはてふてふそのものです。
ConsumerKey関係を引きぬいただけです  
Forkしてbot開発してくれて結構です  
  
  
LICENCE
-----------------
GPLv3 LICENSE  
  
  
つかいかた
-------------------
いろいろと必要なところを書き換えてください(setting.rbの中身とか)  
前提gemを用意して下さい  
  

前提gems
--------------------
*OAuth  
*Nokogiri  
多分こんな感じ  
  

動作環境及び開発環境
--------------------
開発及び動作確認はRuby1.9.3と2.0.0が混在していますがどちらでも問題ありません  
Windows8 Pro x64  
ruby 1.9.3p327 (2012-11-10) [i386-mingw32]  
Arch Linux x86_64  
ruby 2.0.0p247 (2013-06-27 revision 41674) [x86_64-linux]  
UbuntuServer 12.10 x86_64  
ruby 1.9.3p194 (2012-04-20 revision 35410) [x86_64-linux]  
  
てふてふのアカウント
--------------------
@tefutefu_tyou<http://twitter.com/tefutefu_tyou>  
  
  
作者 WEB SITE
-------------------
個人ブログ <http://blog.alpha-kai-net.info>  
HP <http://alpha-kai-net.info>  
Twitter <http://twitter.com/alpha_kai_NET>  
Github <https://github.com/alphaKAI>  
Mail to <alpha.kai.net@alpha-kai-net.info>
  
  
Copyleft (c) α改 @alpha_kai_NET http://alpha-kai-net.info　　
