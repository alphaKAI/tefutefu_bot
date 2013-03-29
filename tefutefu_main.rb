# encoding: utf-8
require 'twitter'
require 'pp'
require_relative 'setting.rb'

class Tefutefu

	#OAuth関連
	def oauth
		#gem twitter Authenticate
		Twitter.configure do |config|
			config.consumer_key = CONSUMER_KEY
			config.consumer_secret = CONSUMER_SECRET
			config.oauth_token = ACCESS_TOKEN
			config.oauth_token_secret = ACCESS_TOKEN_SECRET
		end
	end

	#フォロワ取得
	def get_follower
		puts "===Getting followers list.."
		id="tefutefu_tyou"
		id_list=[]
		Twitter.follower_ids(id).ids.each { |id| id_list << id; }
		puts "Ok."
		
		return id_list
	end
	
	#てふてふ起動post
	def on_post
		on_str="てふてふが起動されました"+" "+"Version:"+VERSION+" "+Time.now.instance_eval { '%s.%03d' % [strftime('%Y年%m月%d日%H時%M分%S秒'), (usec / 1000.0).round] }
		Twitter.update(on_str)
	end
	
	#ふぉろば
	def follow_back(id_list)
		fsize=id_list.size
		puts "前回確認したときは"+fsize.to_s+"人のフォロワーがいました"
		puts "開始します"
		
		id_list=[]
		Twitter.follower_ids(id).ids.each { |id| id_list << id; }

		fsize2=id_list.size
		puts "今回　確認した結果:"+fsize2.to_s+"人のフォロワーがいます"
		
		cts=fsize2-fsize

		if cts>0 then
			puts cts.to_s+"人の新規フォロワーがいます"
			puts "フォローを開始します"
			fss=1
			
			for fss in fss..cts
				puts fss.to_s+"人目.."
				Twitter.follow(id_list[fsize+fss])
				puts "完了！"
			end
		end	
		fsize=fsize2
	end	
	
	#リプライ
	def reply_post(sss,in_rp_id,t_id,u_id,id_list)
	
		if (("tefutefu_tyou"!=t_id) && (sss.include?("RT")==false) && (id_list.index(u_id))) then
	
			#定義
			post_yn=false
	
			#てふてふのメイン処理
	
			#時刻
			if (sss.include?("@tefutefu_tyou")) && (sss.include?("時刻")||sss.include?("何時")) && (d_adn==1) then
				reply_str=Time.now.instance_eval { '%s.%03d' % [strftime('%Y年%m月%d日%H時%M分%S秒'), (usec / 1000.0).round] }
				post_yn=true
			#挨拶系
			#おはよ
			elsif (sss.include?("おはよ")) && (sss.include?("@")==false) then #F/F内ならTLに無差別に挨拶
				reply_str="おはようございます！"
				post_yn=true
			#ただいま
			elsif (sss.include?("ただいま")) && (sss.include?("@")==false) then
				reply_str="おかえりなさいませ!"
				post_yn=true
			#疲れた
			elsif (sss.include?("つかれた")) || (sss.include?("疲れた")) && (sss.include?("@")==false) then
				reply_str="お疲れ様です！"
				posy_yn=true
			#離脱 めしる ほかる じゃあの りだつ
			elsif ((sss.include?("離脱")) || (sss.include?("りだつ")) || (sss.include?("めしる")) || (sss.include?("飯る")) || (sss.include?("じゃあの")) || (sss.include?("ほかる")) || (sss.include?("行ってきます"))) && (sss.include?("@")==false) then
				reply_str="いってらっしゃいませ！"
				post_yn=true
			#めしいま
			elsif ((sss.include?("めしった")) || (sss.include?("飯った")) || (sss.include?("めしいま")) || (sss.include?("飯いま"))) && (sss.include?("@")==false) then
				reply_str="飯えりなさいませ！"
				post_yn=true 
			#ほかいま
			elsif ((sss.include?("ほかった")) || (sss.include?("しゃわった")) || (sss.include?("ほかいま")) || (sss.include?("風呂った"))) && (sss.include?("@")==false) then
				reply_str="ほかえりなさいませ！"
				post_yn=true
			#おやすみりぷ
			elsif ((sss.include?("ねるー")) || (sss.include?("おやす"))) && (sss.include?("@")==false) then
				reply_str="おやすみなさい"
				post_yn=true
			#おるか？ｗ
			elsif ((sss.include?("てふてふ"))) && ((sss.include?("おるか？"))) && (sss.include?("@")==false) then
				reply_str="おるでｗ"
				post_yn=true
			#admin ver
			elsif (sss.include?("@tefutefu_tyou")) && ((sss.include?("ver")) || (sss.include?("バージョン")) || (sss.include?("ばーじょん"))) && (ADMINS.index(t_id)) then
				reply_str="てふてふのばーじょん:"+VERSION
				post_yn=true
			#admin F/F数　
			elsif (sss.include?("@tefutefu_tyou")) && ((sss.include?("f/f")) || (sss.include?("F/F"))) && (ADMINS.index(t_id)) then
				tus=Twitter.user("tefutefu_tyou")
				new=tus.followers_count-fsize
				ff_str="(起動時|前回)取得時:フォロワー数 "+fsize.to_s+"\n今回取得時:フォロー数 "+tus.friends_count.to_s+"\n"+"フォロワー数　"+tus.followers_count.to_s+"\n新規フォロワー "+new.to_s
				Twitter.update("@"+t_id+" "+ff_str, :in_reply_to_status_id => in_rp_id)
				fsize=tus.followers_count
			#admin reboot
			elsif (sss.include?("@tefutefu_tyou")) && ((sss.include?("reboot")) || (sss.include?("再起動"))) && (ADMINS.index(t_id)) then
				Twitter.update("管理人("+t_id+")よりrebootコマンドが実行されたため 再起動します "+Time.now.instance_eval { '%s.%03d' % [strftime('%Y年%m月%d日%H時%M分%S秒'), (usec / 1000.0).round] })
				system("reboot.bat")
			elsif (sss.include?("@tefutefu_tyou")) && ((sss.include?("stop")) || (sss.include?("停止"))) && (t_id=="alpha_kai_NET") then
				Twitter.update("管理人("+t_id+")よりstopコマンドが実行されたため 停止します "+Time.now.instance_eval { '%s.%03d' % [strftime('%Y年%m月%d日%H時%M分%S秒'), (usec / 1000.0).round] })
				system("taskkill /im ruby.exe /f")
			#say
			elsif (sss.include?("@tefutefu_tyou")) && (ADMINS.index(t_id)) && (sss.include?("say")) then
				say_str=sss.split(":")
				if (t_id.include?("alpha_kai")) then
					u_name_str="管理人のα改(.@"+t_id+")"+"より"
				else
					u_name_str="プラグイン開発者のだいこん(.@"+t_id+")"+"より  "
				end
				Twitter.update(u_name_str+" : "+say_str[1])
			#@alpha_kai_NET バトルドォムおみくじ：「バ」「ト」「ル」「ド」「ォ」「ム」を組み合わせバトルドォムになれば勝ち
			elsif (sss.include?("@tefutefu_tyou")) && (sss.include?("おみくじ")) && ((sss.include?("バトルドーム")) || (sss.include?("バトルドォム"))) then
				array=["バ","ト","ル","ド","ォ","ム"]
				tmp_str=array[rand(6)] + array[rand(6)] + array[rand(6)] + array[rand(6)] + array[rand(6)] + array[rand(6)]
				if tmp_str=="バトルドォム"
					result="やったね！ バトルドォムになったよ！ おめでとー！"
				else
					result="(´・ω・｀)しょぼーん 残念！ バトルドォムにならなかったよ また遊んでね！"
				end
				reply_str="バトルドオムおみくじ 結果:【"+tmp_str + "】" + " " + result +" #バトルドォム"
				post_yn=true
			#さいごに
			elsif (sss.include?("@tefutefu_tyou")) && post_yn==false then
				sstr=["んぇ","えへへ","( ✹‿✹ )開眼 だァーーーーーーーーーーー！！！！！！！！！（ﾄｩﾙﾛﾛﾃｯﾃﾚｰｗｗｗﾃﾚﾃｯﾃﾃｗｗｗﾃﾃｰｗｗｗ）ｗｗｗﾄｺｽﾞﾝﾄｺﾄｺｼﾞｮﾝｗｗｗｽﾞｽﾞﾝｗｗ（ﾃﾃﾛﾘﾄﾃｯﾃﾛﾃﾃｰｗ","(´へωへ`*)","(´へεへ`*)"]
				ssstr=sstr[rand(sstr.size)]
				Twitter.update("@"+t_id+" "+ssstr, :in_reply_to_status_id => in_rp_id)
			#挨拶ここまで
		end
	
		#投稿
		if (post_yn == true) then
			Twitter.update("@"+t_id+" "+reply_str+" (開発中に付き誤リプの可能性もあります　ご了承お願いします)", :in_reply_to_status_id => in_rp_id)
		end
		
		sss=""
		reply_str=""
		in_rp_id=""
		t_id=""
		#ここまで
	end	
end
end
