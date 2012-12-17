README

==概要(?)

	Twitter4Cを利用したbotです(Twitter4C-masterにはいってたmain.cを書き換えただけ・・・)
	C言語です
	低レベルbotです
	学習機能 リプライ機能 TL取得機能 自動フォローバック は未実装です
	投稿のみできます

==機能

	語句ファイルからランダムで読み込んで投稿します
	空白の行も読み込んでしまうので空白があるとたまにそれを投稿しちゃいます・・・
	直します・・・

==注意事項

	このソースコードで発生した損害につきましてはα改は一切の責任を負わないものとします
	Twitter4Cを利用していますので同封のOLD_README-Twitter4C-ORIGN.txtもあわせてお読みください
	最新版のTwitter4Cを利用しておりません 1つ前のを利用しています いずれ移行します
	最新版のTwitter4Cじゃないので認証時にアカウントの表示名に2バイト文字が入っていると認証に失敗します

==LICENCE

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
	・libmy_lib.a 	--- α改用ライブラリのLinux向けバイナリです
	・my_lib.lib 	--- α改用ライブラリのWindows向けバイナリです
	.my_lib.c 	--- α改用ライブラリのソースです
	・my_lib.h       --- α改用ライブラリのヘッダーふぁいるです
	・tefutefu_log.c --- てふてふのロガーになります GPLv3ライセンスになります
	・tefutefu_log   --- てふてふのロガーのバイナリです

==コンパイル方法

	てふてふ本体のコンパイル
	$ make
	これでできます
	てふてふのロガーのコンパイルは
	$ gcc -o tefutefu_log tefutefu_log.c libmy_lib.a
	Windowsでしたらロガーのみコンパイルできます(本体はできません 対応予定は。。。微妙です)
	C:\>cl tefutefu_log.c
	コンパイルの時にlibmy_lib.aまたはmy_lib.libとmy_lib.hが存在する必要があります
	
==実行方法
	$ ./tweet
	これでできます
	
==語句ファイルについて

	文字コードUTF-8N 改行コードUNIX(LF)で保存してください
	1行を読み込む仕様なので、複数行はできません(できるようにはしたい・・・)
	
==ロガーについて

	コマンドライン引数を指定することによりオプションを加えることができます
	$ ./tefutefu <OPTION1> <OPTION2>
	<OPTION1>には1または2が入ります
	<OPTION2>には文字列が入ります
	1の場合は
	<OPTION2>を投稿しました
	とかきこまれ
	2の場合は
	<OPTION2>
	が書き込まれます
	
==動作環境及び開発環境

	てふてふ本体の動作はLinux/Unix/BSD(多分・・・)で動くと思います
	Windowsではコンパイルできません
	ネットワークのとこを書き換えれば何とかなりそうなんですが技術力がなくて・・・
	ロガーはWindowsでも動作します
	
	開発及び動作確認は
	Ubuntu12.10 日本語 Remix 32bit + bashで行なっています
	他のディストリビューションでも動くと思います
	
==今後の予定

	各種機能の追加
	Twitter4C最新版の利用
	
==てふてふのアカウント

	@tefutefu_tyou
	になります
	
==Twitter4C作者様への感謝

	Twitter4C作者のHisaya Okada様(@Plemling138)ありがとうございます
	
==てふてふの作者について

	α改
	Twitter: @alpha_kai_NET
	Mail: alpha.kai.net@alpha-kai-net.info
	HP: http://alpha-kai-net.info
	Blog: http://blog.alpha-kai-net.info
	
