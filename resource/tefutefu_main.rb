# encoding: utf-8
require_relative "../module/tefutefu_weather.rb"
class Tefutefu
include TefuFuncs
	#OAuth関連
	def oauth
		cunsmer_array=[]
		cunsmer_array << CONSUMER_KEY << CONSUMER_SECRET << ACCESS_TOKEN << ACCESS_TOKEN_SECRET
		@twi=TwitRuby.new
		@twi.initalize_connection(cunsmer_array)
	end

	#フォロワ取得
	def get_follower
		puts "===Getting followers list.."
		id="tefutefu_tyou"
		id_list=[]
		@twi.follower_ids("alpha_kai_NET")["ids"].each { |id| id_list << id; }
		puts "OK."
		return id_list
	end
	
	#てふてふ起動post
	def on_post
		on_str="てふてふが起動されました"+" "+"Version:"+VERSION+" "+Time.now.instance_eval { "%s.%03d" % [strftime("%Y年%m月%d日%H時%M分%S秒"), (usec / 1000.0).round] }
		@twi.update(on_str) if TEFU_DEBUG==false
	end
	
	#ふぉろば
	def follow_back(target,tname)
		me="tefutefu_tyou"
		
		if(@twi.friendships?("",target,"",me)["relationship"]["source"]["followed_by"]==true) then#フォローされ確認
			@twi.follow(target)
			@twi.update("@"+target.to_s+" "+tname.to_s+"さん！ フォロー返したよ！　よろしくね！"+Time.now.instance_eval { "%s.%03d" % [strftime("%Y年%m月%d日%H時%M分%S秒"), (usec / 1000.0).round] })
		end
		Thread.new do
			get_follower
		end
	end	
	
	#リプライ
	def reply_post(sss,in_rp_id,t_id,u_id,id_list,user_name)
	
		if (("tefutefu_tyou"!=t_id) && (sss.include?("RT")==false) && (id_list.index(u_id))) then
			#定義
			post_torf=false
	
			#てふてふのメイン処理
	
			#時刻
			if (sss.include?("@tefutefu_tyou")) && (sss.include?("時刻")||sss.include?("何時")) then
				reply_str=Time.now.instance_eval { "%s.%03d" % [strftime("%Y年%m月%d日%H時%M分%S秒"), (usec / 1000.0).round] }
				post_torf=true
			#挨拶系
			#おはよ
			elsif (sss.include?("おはよ")) && (sss.include?("@")==false) then #F/F内ならTLに無差別に挨拶
				reply_str="おはようございます！"
				post_torf=true
			#ただいま
			elsif (sss.include?("ただいま")) && (sss.include?("@")==false) then
				reply_str="おかえりなさいませ!"
				post_torf=true
			#疲れた
			elsif (sss.include?("つかれた")) || (sss.include?("疲れた")) && (sss.include?("@")==false) then
				reply_str="お疲れ様です！"
				posy_yn=true
			#離脱 めしる ほかる じゃあの りだつ
			elsif ((sss.include?("離脱")) || (sss.include?("りだつ")) || (sss.include?("めしる")) || (sss.include?("飯る")) || (sss.include?("じゃあの")) || (sss.include?("ほかる")) || (sss.include?("行ってきます"))) && (sss.include?("@")==false) then
				reply_str="いってらっしゃいませ！"
				post_torf=true
			#めしいま
			elsif ((sss.include?("めしった")) || (sss.include?("飯った")) || (sss.include?("めしいま")) || (sss.include?("飯いま"))) && (sss.include?("@")==false) then
				reply_str="飯えりなさいませ！"
				post_torf=true 
			#ほかいま
			elsif ((sss.include?("ほかった")) || (sss.include?("しゃわった")) || (sss.include?("ほかいま")) || (sss.include?("風呂った"))) && (sss.include?("@")==false) then
				reply_str="ほかえりなさいませ！"
				post_torf=true
			#おやすみりぷ
			elsif ((sss.include?("ねるー")) || (sss.include?("おやす"))) && (sss.include?("@")==false) then
				reply_str="おやすみなさい"
				post_torf=true
			#おるか？ｗ
			elsif (sss.include?("てふてふ")) && ((sss.include?("おる")) || (sss.include?("いる"))) && (sss.include?("@")==false) then
				reply_str="おるでｗ"
				post_torf=true
			#@wild_world_end : @alpha_kai_NET ｶﾞｯの機能つけろよ
			elsif ((sss.include?("ぬるぽ")) || (sss.include?("NullPointerException")) || (sss.include?("NullPointerAssignment"))) && (sss.include?("@")==false) then
				reply_str="ｶﾞｯ"
				post_torf=true
			#Weather
			elsif (/天気/ =~ sss) && (/@/ =~ sss) != nil then
				
				tw=TefuWeather.new
				str="福井の週間天気"
				type=tw.parse_reply(sss)
				if type==4
					type=1#オプションのない場合は今日に
				end
				tmp=tw.get_weather(sss,type)
				if tmp==5
					@twi.update("@"+t_id+"地名が登録されてないよ！", in_rp_id)
					return nil
				end
				case type
					when 1,2#今日or明日
						make_str=tmp[0].to_s+"の"+tmp[1].to_s+"の天気は"+tmp[2].to_s+"で 最高気温(℃)/最低気温(℃)は"+tmp[3].to_s+"です！"
						@twi.update("@"+t_id+" "+make_str, in_rp_id)
					when 3#週間
						strs_size=tmp[0]
						loc=tmp[1]

						array=0
						tmp2=""
						(strs_size).times{|i|
							break if array >= 7
							tmp2+=tmp[2][i][1].to_s+"の天気は"+tmp[2][i][2].to_s+"で 最高気温(℃)/最低気温(℃)"+tmp[2][i][3].to_s+"\n"
							array+=1
						}
						arrays=[[tmp2.split("\n")[0],tmp2.split("\n")[1],tmp2.split("\n")[2],tmp2.split("\n")[3]],[tmp2.split("\n")[4],tmp2.split("\n")[5],tmp2.split("\n")[6]]]
						@twi.update("@"+t_id+" "+"#{loc}の週間天気(3/1)\n"+arrays[0][0]+"\n"+arrays[0][1]+"\n", in_rp_id)
						@twi.update("@"+t_id+" (2/3)\n"+arrays[0][2]+"\n"+arrays[0][3]+"\n(続く)", in_rp_id)
						@twi.update("@"+t_id+" (3/3)\n"+arrays[1][0]+"\n"+arrays[1][1]+"\n"+arrays[1][2], in_rp_id)
				end				
			#admin ver
			elsif (sss.include?("@tefutefu_tyou")) && ((sss.include?("ver")) || (sss.include?("バージョン")) || (sss.include?("ばーじょん"))) && (ADMINS.index(t_id)) then
				reply_str="てふてふのばーじょん:"+VERSION
				post_torf=true
			#admin F/F数　
			elsif (sss.include?("@tefutefu_tyou")) && ((sss.include?("f/f")) || (sss.include?("F/F"))) && (ADMINS.index(t_id)) then
				tus=Twitter.user("tefutefu_tyou")
				new=tus.followers_count-fsize
				ff_str="(起動時|前回)取得時:フォロワー数 "+fsize.to_s+"\n今回取得時:フォロー数 "+tus.friends_count.to_s+"\n"+"フォロワー数　"+tus.followers_count.to_s+"\n新規フォロワー "+new.to_s
				Twitter.update("@"+t_id+" "+ff_str, :in_reply_to_status_id => in_rp_id)
				fsize=tus.followers_count
			#admin reboot
			elsif (sss.include?("@tefutefu_tyou")) && ((sss.include?("reboot")) || (sss.include?("再起動"))) && (ADMINS.index(t_id)) then
				Twitter.update("管理者("+t_id+")よりrebootコマンドが実行されたため 再起動します "+Time.now.instance_eval { "%s.%03d" % [strftime("%Y年%m月%d日%H時%M分%S秒"), (usec / 1000.0).round] }) if TEFU_DEBUG==false
				return 1#再起動
			#admin stop
			elsif (sss.include?("@tefutefu_tyou")) && ((sss.include?("stop")) || (sss.include?("停止"))) && (t_id=="alpha_kai_NET") then
				Twitter.update("管理者("+t_id+")よりstopコマンドが実行されたため 停止します "+Time.now.instance_eval { "%s.%03d" % [strftime("%Y年%m月%d日%H時%M分%S秒"), (usec / 1000.0).round] }) if TEFU_DEBUG==false
				return 2#停止
			#say
			elsif (sss.include?("@tefutefu_tyou")) && (ADMINS.index(t_id)) && (sss.include?("say")) then
				say_str=sss.split(":")
				if (t_id.include?("alpha_kai")) then
					u_name_str="管理者のα改(.@"+t_id+")"+"より"
				else
					u_name_str="プラグイン開発者のだいこん(.@"+t_id+")"+"より  "
				end
				Twitter.update(u_name_str+" : "+say_str[1])
			#@mz_:@alpha_kai_NET バトルドォムおみくじ：「バ」「ト」「ル」「ド」「ォ」「ム」を組み合わせバトルドォムになれば勝ち
			elsif (sss.include?("@tefutefu_tyou")) && (sss.include?("おみくじ")) && ((sss.include?("バトルドーム")) || (sss.include?("バトルドォム"))) then
				array=["バ","ト","ル","ド","ォ","ム"]
				tmp_str=array[rand(6)] + array[rand(6)] + array[rand(6)] + array[rand(6)] + array[rand(6)] + array[rand(6)]
				if tmp_str=="バトルドォム"
					result="やったね！ バトルドォムになったよ！ おめでとー！"
				else
					result="(´・ω・｀)しょぼーん 残念！ バトルドォムにならなかったよ また遊んでね！"
				end
				reply_str="バトルドオムおみくじ 結果:【"+tmp_str + "】" + " " + result +" #バトルドォム"
				post_torf=true
			#ふぁぼれよ
			elsif (sss.include?("@tefutefu_tyou")) && (sss.include?("ふぁぼれよ")) then
				Twitter.favorite(in_rp_id)
				reply_str="ふぁぼったよ！ (´へωへ`*)　→　"+"https://twitter.com/"+ t_id +"/status/"+in_rp_id
				post_torf=true
			#開眼コマンド
			elsif (sss.include?("@tefutefu_tyou")) && (sss.include?("開眼")) then
				reply_str="( ✹‿✹ )開眼 だァーーーーーーーーーーー！！！！！！！！！（ﾄｩﾙﾛﾛﾃｯﾃﾚｰｗｗｗﾃﾚﾃｯﾃﾃｗｗｗﾃﾃｰｗｗｗ）ｗｗｗﾄｺｽﾞﾝﾄｺﾄｺｼﾞｮﾝｗｗｗｽﾞｽﾞﾝｗｗ（ﾃﾃﾛﾘﾄﾃｯﾃﾛﾃﾃｰｗ"
				post_torf=true
			#感謝
			elsif (sss.include?("@tefutefu_tyou")) && ((sss.include?("ありー")) || (sss.include?("あり")) || (sss.include?("ありがと"))) then
				reply_str="えへへっ　どういたしまして！"
				post_torf=true
			#今の気分は？
			elsif (sss.include?("@tefutefu_tyou")) && (sss.include?("今の気分は")) then
				#語彙
				kanjyou=[]
				#読み込んで,区切りで読んで配列に突っ込む
				kanjyou=File.read("./kanjyou.csv", :encoding => Encoding::UTF_8).split(",")
				make_str=kanjyou[rand(kanjyou.size)]
				Twitter.update("@"+t_id+" "+make_str, :in_reply_to_status_id => in_rp_id)
			#さいごに
			elsif (sss.include?("@tefutefu_tyou")) && (post_torf==false) && (sss.delete("@tefutefu_tyou").include?("@")==false) then			
				#語彙
				words=[]
				#読み込んで,区切りで読んで配列に突っ込む
				words=File.read("./words.csv", :encoding => Encoding::UTF_8).split(",")
	
				#イタ電
				itaden=["結婚しろ","ﾁｯｽｗｗｗｗｗｗｗｗｗｗ","あっオカン来たから切るわ","今あなたの後ろにいるの","なんでもねぇよｗｗｗｗｗｗｗｗｗｗｗｗｗ",
						"間違えましたｗｗｗｗｗｗｗｗ","めしなう",user_name+"ですか"+user_name+"ですか"+user_name+"ですか",
						"☎☎☎☎☎☎☎☎☎☎☎☎☎☎☎☎","やったｗｗｗｗｗｗｗｗｗｗイタ電成功ｗｗｗｗｗｗｗ"]
				make_str=words[rand(words.size)]
				if make_str=="イタ電" then
					make_str=""#初期化
					make_str="┗(^o^)┛イタ電するぞぉぉぉｗｗ( ^o^)☎┐もしもしｗｗｗｗｗｗ"+user_name+"ですかｗｗｗｗｗｗｗｗ"+itaden[rand(itaden.size)]+"( ^o^)Г☎ﾁﾝｯ"
				end
				Twitter.update("@"+t_id+" "+make_str, :in_reply_to_status_id => in_rp_id)
			#挨拶ここまで
			end
		end
	
		#投稿
		if (post_torf == true) then
			@twi.update("@"+t_id+" "+reply_str,in_rp_id)
		end
		
		#ふぁぼ
		if sss.include?("てふてふ") then
			@twi.favorite(t_id)
		end
		
		sss=""
		reply_str=""
		in_rp_id=""
		t_id=""
		#ここまで
	end
end
