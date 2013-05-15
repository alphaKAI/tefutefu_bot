﻿# encoding: utf-8

#===========================================================================
# このスクリプトはあわあわ氏(Twitter:@pn1y)氏にかいてもらったUserStream取得スクリプトを改造する形になっています
# 元のスクリプト→ https://gist.github.com/pnlybubbles/4523338
#
# Windows/Linux/Mac OSX/UNIX/BSDなどの幅広いプラットフォームでうごきます(Ruby製なので)
#　rebootとstopを強化したので環境依存がなくなりました
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
require_relative 'tefutefu_main.rb'#α改追記

# SSL証明書のパス
CERTIFICATE_PATH = './userstream.twitter.com.pem'

# UserStreamAPIのurl
USERSTREAM_API_URL = 'https://userstream.twitter.com/1.1/user.json?replies=all'

$DEBUG_ = false

#再起動関連 α改追記
reboot_torf=false

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
        File.open("./blacklist.csv", "w", :encoding => Encoding::UTF_8).close() unless File.exist?("./blacklist.csv")

        File.open('./blacklist.csv', 'r', :encoding => Encoding::UTF_8) do |io|
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
		tafuback=0#ループをするかの条件用変数
		
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
						
						#reply
						tefuback=tefu.reply_post(j['text'], j['id_str'], j['user']['screen_name'], j['user']['id'],id_list,j['user']['name'])
						
						return true if tefuback == 1
						return false if tefuback == 2
						
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
                io.puts("#{@filtered}") if @filtered != ""
            end
        end

        private
        def filter(str)
            return str.gsub(Regexp.union(@@assign.keys),@@assign).gsub(/#{@bls.join("|")}/,"")
        end
    end
end

reboot_torf=Alphakai.new.run
while reboot_torf==true
	reboot_torf=Alphakai.new.run
end