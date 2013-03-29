# encoding: utf-8

#===========================================================================
# このスクリプトはあわあわ氏(Twitter:@pn1y)氏にかいてもらったUserStream取得スクリプトを改造する形になっています
# 元のスクリプト→ https://gist.github.com/pnlybubbles/4523338
#
# 本スクリプトはてふてふオリジナル　公開用にかきかえたり 削ってるとっころあります たとえばbot_enやbot_jaはもともと宣言していませんでしたが
# 公開用にtefutefu_botをbot_enにてふてふをbot_jaにおきかえました
# つまり(sss.include?("@tefutefu_tyou"))→(sss.include?("@"+bot_en))
#
# Windows/Linux/Mac OSX/UNIX/BSDなどの幅広いプラットフォームでうごきます(Ruby製なので)
# ですが、開発はWindowsで行なっているのでrebootコマンドやstopコマンドでは
# batファイルを呼んだりCMDのコマンドを実行したりしています(将来的にはLinuxで動かします)
# お使いの環境にあったコマンドにしてください
#
# Copyleft (C) α改 @alpha_kai_NET 2012-2013 http://alpha-kai-net.info/
#
# LICENSE CC BY-SA 3.0 http://creativecommons.org/licenses/by-sa/3.0/deed.ja
# この 作品 は クリエイティブ・コモンズ 表示 - 継承 3.0 非移植 ライセンスの下に提供されています。
#===========================================================================

require 'rubygems'
require 'net/https'
require 'openssl'
require 'oauth'
require 'cgi'
require 'json'
require 'Twitter'#α改追記
require 'pp'#α改追記

# コンシュマーキーとアクセストークン
CONSUMER_KEY        = ""
CONSUMER_SECRET     = ""
ACCESS_TOKEN        = ""
ACCESS_TOKEN_SECRET = ""

#α改追記 Twitter gem用
#gem twitter Authenticate
Twitter.configure do |config|
	config.consumer_key = CONSUMER_KEY
	config.consumer_secret = CONSUMER_SECRET
	config.oauth_token = ACCESS_TOKEN
	config.oauth_token_secret = ACCESS_TOKEN_SECRET
end
#botのバージョン
VERSION=""
#ここまで

# SSL証明書のパス
CERTIFICATE_PATH = './userstream.twitter.com.pem'

# UserStreamAPIのurl
USERSTREAM_API_URL = 'https://userstream.twitter.com/1.1/user.json?replies=all'

$DEBUG_ = false

class Account
    def initialize
        @consumer = OAuth::Consumer.new(
        CONSUMER_KEY,
        CONSUMER_SECRET,
        :site => 'http://api.twitter.com/1.1'
        )

        @access_token = OAuth::AccessToken.new(
        @consumer,
        ACCESS_TOKEN,
        ACCESS_TOKEN_SECRET
        )
    end

    def connect
        uri = URI.parse(USERSTREAM_API_URL)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        https.ca_file = CERTIFICATE_PATH
        https.verify_mode = OpenSSL::SSL::VERIFY_PEER
        https.verify_depth = 5

        https.start do |https|
            request = Net::HTTP::Get.new(uri.request_uri)
            request.oauth!(https, @consumer, @access_token)
            buf = ""
            https.request(request) do |response|
                response.read_body do |chunk|
                    buf << chunk
                    while(line = buf[/.*(\r\n)+/m])
                        begin
                            buf.sub!(line,"")
                            line.strip!
                            status = JSON.parse(line)
                        rescue
                            break
                        end
                        yield status
                    end
                end
            end
        end
    end
end

class Alphakai
    attr_reader :blacklist

    def initialize
        File.open("./blacklist.csv", "w").close() unless File.exist?("./blacklist.csv")

        File.open('./blacklist.csv', 'r') do |io|
            @blacklist = io.read.strip.split(',')
        end

        @account = Account.new
    end

    def run
	
		#bot名定義
		bot_ja="日本語のbot名 表示名的な"
		bot_en="TwitterのID"
		#α改追記 起動post
		on_str=bot_ja+"が起動されました"+" "+"Version:"+VERSION+" "+Time.now.instance_eval { '%s.%03d' % [strftime('%Y年%m月%d日%H時%M分%S秒'), (usec / 1000.0).round] }
		Twitter.update(on_str)
		
		puts "===Getting followers list.."
		id=bot_en
		id_list=[]
		Twitter.follower_ids(id).ids.each { |id| id_list << id; }
		puts "Ok."
		
		#Admin定義 array
		#e.g. admins=["alpha_kai_NET","alpha_kai_KISEI"]
		admins=[""]
		#ここまで

        loop do
            puts "==== connecting..."			
            begin
                @account.connect do |j|
                    if(j['text'])
                        puts "@#{j['user']['screen_name']}:#{j['text']}"
                        text = j['retweeted_status'] ? j['retweeted_status']['text'] : j['text']
                        alpha_handler = Tools.new(j['user']['screen_name'], text)
                        alpha_handler.bls = @blacklist
                        alpha_handler.output
                        puts "=> #{alpha_handler.filtered}" if $DEBUG_

						#時刻関連
						t = Time.now
						
						fsize=id_list.size

						if t.hour==0 && t.min==0
							Twitter.update("よるほー！")
						end
						
						#ここまで
						#α改追記 リプライ
						if ((bot_en!=j['user']['screen_name']) && (j['text'].include?("RT")==false) && (id_list.index(j['user']['id']))) then
							
							#定義
							sss=j['text']
							in_rp_id=j['id_str']
							t_id=j['user']['screen_name']
							post_yn=false
							
							#時刻
								if (sss.include?("@"+bot_en)) && (sss.include?("時刻")||sss.include?("何時")) && (d_adn==1) then
									reply_str=Time.now.instance_eval { '%s.%03d' % [strftime('%Y年%m月%d日%H時%M分%S秒'), (usec / 1000.0).round] }
									post_yn=true
							#挨拶系
							#F/F内ならTLに無差別に挨拶
								#おはよ
								elsif (sss.include?("おはよ")) && (j['text'].include?("@")==false) then
									reply_str="おはようございます！"
									post_yn=true
								#ただいま
								elsif (sss.include?("ただいま")) && (j['text'].include?("@")==false) then
									reply_str="おかえりなさいませ!"
									post_yn=true
								#疲れた
								elsif (sss.include?("つかれた")) || (sss.include?("疲れた")) && (j['text'].include?("@")==false) then
									reply_str="お疲れ様です！"
									posy_yn=true
								#離脱 めしる ほかる じゃあの りだつ
								elsif ((sss.include?("離脱")) || (sss.include?("りだつ")) || (sss.include?("めしる")) || (sss.include?("飯る")) || (sss.include?("じゃあの")) || (sss.include?("ほかる")) || (sss.include?("行ってきます"))) && (j['text'].include?("@")==false) then
									reply_str="いってらっしゃいませ！"
									post_yn=true
								#めしいま
								elsif ((sss.include?("めしった")) || (sss.include?("飯った")) || (sss.include?("めしいま")) || (sss.include?("飯いま"))) && (j['text'].include?("@")==false) then
									reply_str="飯えりなさいませ！"
									post_yn=true 
								#ほかいま
								elsif ((sss.include?("ほかった")) || (sss.include?("しゃわった")) || (sss.include?("ほかいま")) || (sss.include?("風呂った"))) && (j['text'].include?("@")==false) then
									reply_str="ほかえりなさいませ！"
									post_yn=true
								#おやすみりぷ
								elsif ((sss.include?("ねるー")) || (sss.include?("おやす"))) && (j['text'].include?("@")==false) then
									reply_str="おやすみなさい"
									post_yn=true
								#おるか？ｗ
								elsif ((sss.include?("てふてふ"))) && ((sss.include?("おるか？"))) && (j['text'].include?("@")==false) then
									reply_str="おるでｗ"
									post_yn=true
								#admin ver
								elsif (j['text'].include?("@"+bot_en)) && ((j['text'].include?("ver")) || (j['text'].include?("バージョン")) || (j['text'].include?("ばーじょん"))) && (admins.index(j['user']['screen_name'])) then
									reply_str=bot_ja+"のばーじょん:"+VERSION
									post_yn=true
								#admin F/F数　
								elsif (j['text'].include?("@"+bot_en)) && ((j['text'].include?("f/f")) || (j['text'].include?("F/F"))) && (admins.index(j['user']['screen_name'])) then
									tus=Twitter.user(bot_en)
									new=tus.followers_count-fsize
									ff_str="(起動時|前回)取得時:フォロワー数 "+fsize.to_s+"\n今回取得時:フォロー数 "+tus.friends_count.to_s+"\n"+"フォロワー数　"+tus.followers_count.to_s+"\n新規フォロワー "+new.to_s
									Twitter.update("@"+t_id+" "+ff_str, :in_reply_to_status_id => in_rp_id)
									fsize=tus.followers_count
								#admin reboot やっつけのbat
								elsif (j['text'].include?("@"+bot_en)) && ((j['text'].include?("reboot")) || (j['text'].include?("再起動"))) && (admins.index(j['user']['screen_name'])) then
									Twitter.update("管理人("+j['user']['screen_name']+")よりrebootコマンドが実行されたため 再起動します "+Time.now.instance_eval { '%s.%03d' % [strftime('%Y年%m月%d日%H時%M分%S秒'), (usec / 1000.0).round] })
									system("reboot.bat")
								#admin やっつけのstop
								elsif (j['text'].include?("@"+bot_en)) && ((j['text'].include?("stop")) || (j['text'].include?("停止"))) && (admins.index(j['user']['screen_name'])) then
									Twitter.update("管理人("+j['user']['screen_name']+")よりstopコマンドが実行されたため 停止します "+Time.now.instance_eval { '%s.%03d' % [strftime('%Y年%m月%d日%H時%M分%S秒'), (usec / 1000.0).round] })
									system("taskkill /im ruby.exe /f")
								#admin say
								elsif (j['text'].include?("@"+bot_en)) && (admins.index(j['user']['screen_name'])) && (j['text'].include?("say")) then
									say_str=j['text'].split(":")
									u_name_str="管理人の.@"+j['user']['screen_name']+"より"
									Twitter.update(u_name_str+" : "+say_str[1])
								#@alpha_kai_NET バトルドォムおみくじ：「バ」「ト」「ル」「ド」「ォ」「ム」を組み合わせバトルドォムになれば勝ち
								elsif (j['text'].include?("@"+bot_en)) && (j['text'].include?("おみくじ")) && ((j['text'].include?("バトルドーム")) || (j['text'].include?("バトルドォム"))) then
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
								elsif (j['text'].include?("@"+bot_en)) && post_yn==false then
									sstr=["んぇ","えへへ","( ✹‿✹ )開眼 だァーーーーーーーーーーー！！！！！！！！！（ﾄｩﾙﾛﾛﾃｯﾃﾚｰｗｗｗﾃﾚﾃｯﾃﾃｗｗｗﾃﾃｰｗｗｗ）ｗｗｗﾄｺｽﾞﾝﾄｺﾄｺｼﾞｮﾝｗｗｗｽﾞｽﾞﾝｗｗ（ﾃﾃﾛﾘﾄﾃｯﾃﾛﾃﾃｰｗ","(´へωへ`*)","(´へεへ`*)"]
									ssstr=sstr[rand(sstr.size)]
									Twitter.update("@"+t_id+" "+ssstr, :in_reply_to_status_id => in_rp_id)
							#挨拶ここまで
							end
							
							#投稿
							if (post_yn == true) then
								Twitter.update("@"+t_id+" "+reply_str+" (開発中に付き誤リプの可能性もあります　ご了承お願いします)", :in_reply_to_status_id => in_rp_id)
							end
							#よみこんだぽすとにbot_jaがふくまれてたらふぁぼるふぁぼ
							if j['text'].include?(bot_ja) then
								Twitter.favorite(j['id_str'])
							end
							j=[]#初期化しとく
							sss=""
							reply_str=""
							in_rp_id=""
							t_id=""
							#ここまで
						end
                    end
                end
            rescue Exception => e
                puts "#### #{e} ####"
                puts e.backtrace if $DEBUG_
                break if e.to_s == ""
            end

            puts "==== connection lost."
        end
    end

    class Tools
        attr_reader :text
        attr_reader :scrnm
        attr_reader :filtered
        attr_accessor :bls

        @@assign = {
            /\n/ => " ",
            /(RT|QT).*$/ => "",
            /^@[A-Za-z0-9_]+\s?/ => "",
            /https?:\/\/.*(?=(\s|\n|$))/ => ""
        }

        def initialize(screen_name, text)
            @text = text
            @scrnm = screen_name
            @filtered = nil
            @bls = []
        end

        def output
            File.open('./output.txt', 'a') do |io|
                @filtered = filter(@text)
                io.puts("#{@scrnm}:#{@filtered}") if @filtered != ""
            end
        end

        private
        def filter(str)
            return str.gsub(Regexp.union(@@assign.keys),@@assign).gsub(/#{@bls.join("|")}/,"")
        end
    end
end

Alphakai.new.run
