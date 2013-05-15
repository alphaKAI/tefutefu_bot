てふてふ
==================
  
  
概要
------------------
もともと、CだったbotをRubyで書きなおしたもの  
このスクリプトはあわあわ氏(Twitter:@pn1y)氏にかいてもらったUserStream取得スクリプトを改造する形になっています  
元のスクリプト→ https://gist.github.com/pnlybubbles/4523338  
  
本スクリプトはてふてふオリジナル　公開用にかきかえたり 削ってるところがあります 
  
Windows/Linux/Mac OSX/UNIX/BSDなどの幅広いプラットフォームでうごきます(Ruby製なので)  
rebootとstopを強化したので環境依存がなくなりました　　
  
Copyleft (C) α改 @alpha_kai_NET 2012-2013 http://alpha-kai-net.info/  
  
LICENSE CC BY-SA 3.0 http://creativecommons.org/licenses/by-sa/3.0/deed.ja  
この 作品 は クリエイティブ・コモンズ 表示 - 継承 3.0 非移植 ライセンスの下に提供されています。  
    
  
機能
-----------------
*挨拶機能
*UserStream取得
*バトルドームおみくじ
*ふぁぼ
*あとなんか  
*再起動 停止その辺に対応しました
その他の機能は、オリジナルでは実装されずプラグインによる実装なので、ここには書きませんしファイルもアップロードしません ご了承下さい  
  
  
VERSION
-----------------
2012/12/23 Ver0.0.2公開  
2013/3/29 Ver0.4.4_8α_Rb公開 ここよりRubyに移行  
2013/3/29 Ver0.4.5α_Rb公開 ファイルをわけて管理性の向上及び、可読性の向上  
2013/3/31 Ver0.4.5_6α_Rb公開 語彙を少し増やしたり厄介度を増したりとか
2013/5/15 Ver0.4.6α_Rb公開 stop rebootの強化  
　　
  
注意事項
-----------------
本スクリプトはてふてふオリジナル　公開用にかきかえたり 削ってるとっころあります 
  
  
Windows/Linux/Mac OSX/UNIX/BSDなどの幅広いプラットフォームでうごきます(Ruby製なので)  
rebootとstopを強化したので環境依存がなくなりました　　
あとTefutefuクラスのフォローバックはまだ未完成です    
  
  
LICENCE
-----------------
LICENSE CC BY-SA 3.0 http://creativecommons.org/licenses/by-sa/3.0/deed.ja  
この 作品 は クリエイティブ・コモンズ 表示 - 継承 3.0 非移植 ライセンスの下に提供されています。  
  
  
つかいかた
-------------------
いろいろと必要なところを書き換えてください  
リプライの検出フィルタ等 やsetting.rbの中身 それに前提gem(Twitter,OAuth)を用意して下さい  
あと、SSL証明書も必要なので、userstream.twitter.comから取得して下さい
  
  
動作環境及び開発環境
--------------------
Windows/Linux/UNIX/OSX/BSDなどのRubyインタプリタが動く環境であれば動きます  
  
開発及び動作確認は  
Windows8 Pro x64  
ruby 1.9.3p327 (2012-11-10) [i386-mingw32]  

  
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