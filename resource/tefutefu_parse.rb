#encoding:utf-8
class TefuParser
	def parse(str,id)
		if str.empty? || id.empty?
			$stderr.puts("ERROR!")
			return nil
		end

		catm=false
		rst=false
		#check tweet status
		if /@tefutefu_tyou/ =~ str
			rst=true
		elsif /@/ =~ str
			catm=true
		end
		
		#parse
		case str
			when /時刻/,/何時/
				if rst
					time=Time.now.instance_eval { "%s.%03d" % [strftime("%Y年%m月%d日%H時%M分%S秒"), (usec / 1000.0).round] }
					return time
				end
			when /おはよ/
				unless catm
					return "おはようございます！"
				end
			when /ただいま/,/めしった/,/飯った/,/めしいま/,/ほかった/,/ほかいま/
				unless catm
					return "おかえりなさいませ！"
				end
			when /つかれた/,/疲れた/
				unless catm
					return "お疲れ様です！"
				end
			when /離脱/,/りだつ/,/めしる/,/飯る/,/じゃあの/,/ほかる/,/行ってきます/
				unless catm
					return "いってらっしゃいませ！"
				end
			when /寝る/,/おやす/
				unless catm
					return "おやすみなさい"
				end
			when /(てふてふ).*(お|い)るか/
				unless catm
					return "おるでｗ"
				end
			when /ぬるぽ/,/NullPointerException/,/NullPointerAssignment/
				unless catm
					return "ガッ"
				end
			when /ver/
				if rst && ADMINS.index(id)
					return "てふてふのばーじょん"+VERSION
				end
			when /天気/,/てんき/
				unless catm
					if rst
						return "weather"
					end
				end
			when /reboot/
				if rst && ADMINS.index(id)
					return 1#再起動
				end
			when /stop/
				if rst && ADMINS.index(id)
					return 2#停止
				end
			when /say/
				if rst && ADMINS.index(id)
					say_str=str.split(":")
					return "管理者のα改(@#{id})より : "+say_str[1]
				end
			when /(バトルドーム|バトルドォム).*(おみくじ)/
				if rst
					array=["バ","ト","ル","ド","ォ","ム"]
					tmp_str=array[rand(6)] + array[rand(6)] + array[rand(6)] + array[rand(6)] + array[rand(6)] + array[rand(6)]
					if tmp_str=="バトルドォム"
						result="やったね！ バトルドォムになったよ！ おめでとー！"
					else
						result="(´・ω・｀)しょぼーん 残念！ バトルドォムにならなかったよ また遊んでね！"
					end
					reply_str="バトルドオムおみくじ 結果:【"+tmp_str + "】" + " " + result +" #バトルドォム"
					post_torf=true
				end
			when /ふぁぼれよ/
				if rst
					return "fav"
				end
			when /開眼/
				if rst
					return "( ✹‿✹ )開眼 だァーーーーーーーーーーー！！！！！！！！！（ﾄｩﾙﾛﾛﾃｯﾃﾚｰｗｗｗﾃﾚﾃｯﾃﾃｗｗｗﾃﾃｰｗｗｗ）ｗｗｗﾄｺｽﾞﾝﾄｺﾄｺｼﾞｮﾝｗｗｗｽﾞｽﾞﾝｗｗ（ﾃﾃﾛﾘﾄﾃｯﾃﾛﾃﾃｰｗ"
				end
			#感謝
			when /ありー/,/あり/,/ありがと/
				if rst
					return "えへへっ　どういたしまして！"
				end
			#今の気分は？
			when /今の気分は/
				#語彙
				kanjyou=[]
				#読み込んで,区切りで読んで配列に突っ込む
				kanjyou=File.read("#{$CDIR}/csv/kanjyou.csv", :encoding => Encoding::UTF_8).split(",")
				return kanjyou[rand(kanjyou.size)]
			#さいごに		
			else
				if rst
					#語彙
					words=[]
					#読み込んで,区切りで読んで配列に突っ込む
					words=File.read("#{$CDIR}/csv/words.csv", :encoding => Encoding::UTF_8).split(",")
	
					#イタ電
					itaden=["結婚しろ","ﾁｯｽｗｗｗｗｗｗｗｗｗｗ","あっオカン来たから切るわ","今あなたの後ろにいるの","なんでもねぇよｗｗｗｗｗｗｗｗｗｗｗｗｗ",
							"間違えましたｗｗｗｗｗｗｗｗ","めしなう",id.to_s+"ですか"*3,
							"☎☎☎☎☎☎☎☎☎☎☎☎☎☎☎☎","やったｗｗｗｗｗｗｗｗｗｗイタ電成功ｗｗｗｗｗｗｗ"]
					make_str=words[rand(words.size)]
					if make_str=="イタ電" then
						make_str=""#初期化
						make_str="┗(^o^)┛イタ電するぞぉぉぉｗｗ( ^o^)☎┐もしもしｗｗｗｗｗｗ"+id.to_s+"ですかｗｗｗｗｗｗｗｗ"+itaden[rand(itaden.size)]+"( ^o^)Г☎ﾁﾝｯ"
					end
					return make_str
				end
		end
	end
end