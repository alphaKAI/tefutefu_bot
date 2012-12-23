alpha_kai_NET My_lib
==================
  
  
概要
------------------
Twitter4Cを利用したbotです  
C言語です  
リプライ機能 TL取得機能 自動フォローバック は未実装です  
学習機能一応実装しました詳しくは後述します  
  
  
機能
-----------------
学習機能  語句ファイル data.txtからランダムで読み込んで文章(どちらかというと文字列)生成して投稿  
もう少し頭を良くしてあげたいとは思ってます・・・  
  
  
VERSION
-----------------
2012/2/23 Ver0.0.2公開  
  
  
注意事項
-----------------
このソースコードで発生した損害につきましてはα改は一切の責任を負わないものとします  
Twitter4Cを利用していますので同封のOLD_README-Twitter4C-ORIGN.txtもあわせてお読みください  
最新版のTwitter4Cを利用しておりません 1つ前のを利用しています いずれ移行します  
最新版のTwitter4Cじゃないので認証時にアカウントの表示名に2バイト文字が入っていると認証に失敗します  
  
  
LICENCE
-----------------
ライセンスにつきましてはTwitter4C作者様のReadmeに記載されている  
>5.ライセンス  
>本パッケージの以下に示す私が作成したモジュールについてはライセンスフリーとします。  
>・twilib.c/twilib.h  
>・main.c  
>・urlenc.c/urlenc.h  
>・extract.c/extract.h  
>義務ではないですが、使った後メールなりTwitterなりで「コレ使って**作ったよ！」的なものを送って頂けると嬉しいです。  
>ただし、上記以外のモジュールはGPL2ライセンスで提供されていますので、そちらはそれぞれのライセンスに従って  
>公開等をお願い致します。  
これに従っています  
  
なおα改用ライブラリはGPLv3ライセンスですのでGPLv2ではありませんのでご注意ください  
以下のものはα改自作ののライブラリ関係ですのでGPLv3ライセンスとなります  
*my_lib.c 	--- α改用ライブラリのソースです  
*my_lib.h       --- α改用ライブラリのヘッダーふぁいるです  
*tefutefu_log.c --- てふてふのロガーになります GPLv3ライセンスになります  
  
  
  
コンパイル方法
-------------------
Linux/UNIXの場合  
    $ sudo chmod 777 clal.sh
    $ ./clal.sh
これですべてコンパイルできます  
Makefileの書き方わからないのでMakefileみたいな感じでシェルスクリプトかいて  
あとはmakeコマンド実行するだけのシェルスクリプトです  
Windowsの場合  
てふてふ本体はLinux/UNIX向けなので使えません  
ロガーはコンパイルできますので  
`C:\>cl tefutefu_log.c`
でできます  
  
  
語句ファイルについて
-------------------
文字コードUTF-8N 改行コードUNIX(LF)で保存してください
複数行投稿は一応対応してますが 1行ずつ読み込んでその後に\nを\0で消してるのでできません(今後改善予定)
  
  
ロガーについて
-------------------
コマンドライン引数を指定することによりオプションを加えることができます  
`$ ./tefutefu <OPTION1> <OPTION2>`
<OPTION1>には1または2が入ります  
<OPTION2>には文字列が入ります  
1の場合は  
<OPTION2>を投稿しました  
とかきこまれ  
2の場合は  
<OPTION2>  
が書き込まれます  
  
  
動作環境及び開発環境
--------------------
てふてふ本体の動作はLinux/UNIX/BSD(多分・・・)で動くと思います  
Windowsではコンパイルできません  
ネットワークのとこを書き換えれば何とかなりそうなんですが技術力がなくて・・・  
ロガーはWindowsでも動作します  
  
開発及び動作確認は  
Ubuntu12.10 日本語 Remix 32bit + bashで行なっています  
他のディストリビューションでも動くと思います  
  
  
==今後の予定
各種機能の追加  

==てふてふのアカウント
@tefutefu_tyou<http://twitter.com/tefutefu_tyou>  
になります  
  
  	
Twitter4C作者様への感謝
-------------------
Twitter4C作者のHisaya Okada様(@Plemling138)ありがとうございます  
  
  
作者 WEB SITE
-------------------

個人ブログ <http://blog.alpha-kai-net.info>  
HP <http://alpha-kai-net.info>  
Twitter <http://twitter.com/alpha_kai_net>  
Github <https://github.com/alphaKAI>  
Mail to <alpha.kai.net@alpha-kai-net.info>




COPYRIGHT (c) α改 @alpha_kai_NET http://alha-kai-net.info

