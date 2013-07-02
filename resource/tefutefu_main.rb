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
					
			str=TefuParser.parse(sss,id)
			case str
				when /weather/
					tw=TefuWeather.new
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
				when 1
					@twi.update("管理者("+t_id+")よりrebootコマンドが実行されたため 再起動します "+Time.now.instance_eval { "%s.%03d" % [strftime("%Y年%m月%d日%H時%M分%S秒"), (usec / 1000.0).round] }) if TEFU_DEBUG==false
					return 1
				when 2
					@twi.update("管理者("+t_id+")よりstopコマンドが実行されたため 停止します "+Time.now.instance_eval { "%s.%03d" % [strftime("%Y年%m月%d日%H時%M分%S秒"), (usec / 1000.0).round] }) if TEFU_DEBUG==false
					return 2
				when /fav/
					@twi.favorite(in_rp_id)
					reply_str="ふぁぼったよ！ (´へωへ`*)　→　"+"https://twitter.com/"+ t_id +"/status/"+in_rp_id
					post_torf=true
				else
					reply_str=str
					post_torf=true
				end
			end
	
		#投稿
		if post_torf
			@twi.update("@"+t_id+" "+reply_str,in_rp_id)
		end
		
		#ふぁぼ
		if sss.include?("てふてふ") then
			@twi.favorite(in_rp_id)
		end
		
		sss=""
		reply_str=""
		in_rp_id=""
		t_id=""
		#ここまで
	end
end
