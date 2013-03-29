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
require_relative 'setting.rb'#α改追記
require_relative 'tefutefu_main.rb'#α改追記

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
	
		#Tefutefuクラスnew
		tefu=Tefutefu.new
		#OAuth
		tefu.oauth
		#フォロワー取得
		id_list=tefu.get_follower
		#起動ポスト
		tefu.on_post
	
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
						
					#ここにてふてふのしょりとか
					#α改追記ここより
						t = Time.now
						if t.min%30==0 && t.sec==0 then#
							str="自己紹介:てふてふ 作者:α改 Ruby製bot UserStreamに対応で素早い返信ができるよ！　よろしくね！\n挨拶リプライ、バトルドームおみくじそのた機能があるから気軽に喋りかけてね!"
						end
						#よるほ
						if t.hour==0 && t.min==0
							Twitter.update("よるほー！")
						end
						#ふぁぼ
						if j['text'].include?("てふてふ") then
							Twitter.favorite(j['id_str'])
						end
						
						#reply
						tefu.reply_post(j['text'], j['id_str'], j['user']['screen_name'], j['user']['id'],id_list)
						
					#ここまで
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
