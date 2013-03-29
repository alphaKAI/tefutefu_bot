てふてふ
==================
  
  
概要
------------------
もともと、CだったbotをRubyで書きなおしたもの  
このスクリプトはあわあわ氏(Twitter:@pn1y)氏にかいてもらったUserStream取得スクリプトを改造する形になっています  
元のスクリプト→ https://gist.github.com/pnlybubbles/4523338  
  
本スクリプトはてふてふオリジナル　公開用にかきかえたり 削ってるとっころあります 
  
Windows/Linux/Mac OSX/UNIX/BSDなどの幅広いプラットフォームでうごきます(Ruby製なので)  
ですが、開発はWindowsで行なっているのでrebootコマンドやstopコマンドでは  
batファイルを呼んだりCMDのコマンドを実行したりしています(将来的にはLinuxで動かします)  
お使いの環境にあったコマンドにしてください  
  
Copyleft (C) α改 @alpha_kai_NET 2012-2013 http://alpha-kai-net.info/  
  
LICENSE CC BY-SA 3.0 http://creativecommons.org/licenses/by-sa/3.0/deed.ja  
この 作品 は クリエイティブ・コモンズ 表示 - 継承 3.0 非移植 ライセンスの下に提供されています。  
  
最後に、いっかいREADME.MDが事故により消えてしまいイライラしながら書きなおしたので少々適当なことになっています  
今度書き直す予定ですのでご了承下さい  
  
  
機能
-----------------
*挨拶機能
*UserStream取得
*バトルドームおみくじ
*ふぁぼ
*あとなんか  
その他の機能は、オリジナルでは実装されずプラグインによる実装なので、ここには書きませんしファイルもアップロードしません ご了承下さい  
  
  
VERSION
-----------------
2012/12/23 Ver0.0.2公開  
2013/3/29 Ver0.4.4_8α_Rb公開 ここよりRubyに移行  
2013/3/29 Ver0.4.5α_Rb公開 ファイルをわけて管理性の向上及び、可読性の向上  
  
  
注意事項
-----------------
本スクリプトはてふてふオリジナル　公開用にかきかえたり 削ってるとっころあります 
  
  
Windows/Linux/Mac OSX/UNIX/BSDなどの幅広いプラットフォームでうごきます(Ruby製なので)  
ですが、開発はWindowsで行なっているのでrebootコマンドやstopコマンドでは  
batファイルを呼んだりCMDのコマンドを実行したりしています(将来的にはLinuxで動かします)  
お使いの環境にあったコマンドにしてください  
あとTefutefuクラスのフォローバックはまだ未完成です    
  
  
LICENCE
-----------------
LICENSE CC BY-SA 3.0 http://creativecommons.org/licenses/by-sa/3.0/deed.ja  
この 作品 は クリエイティブ・コモンズ 表示 - 継承 3.0 非移植 ライセンスの下に提供されています。  
  
  
つかいかた
-------------------
setting.rb変数に適当な値を入れたり"α改"をかきかえたりしてください  
Tokenとかadminあたりをいじればいいです  
Twitter gemが必要なのでインストールして下さいね  
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
Twitter <http://twitter.com/alpha_kai_net>  
Github <https://github.com/alphaKAI>  
Mail to <alpha.kai.net@alpha-kai-net.info>
  
  
COPYRIGHT (c) α改 @alpha_kai_NET http://alha-kai-net.info