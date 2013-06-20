# encoding: utf-8

#===========================================================================
# このスクリプトはあわあわ氏(Twitter:@pn1y)氏にかいてもらったUserStream取得スクリプトを改造する形になっています
# 元のスクリプト→ https://gist.github.com/pnlybubbles/4523338
#
# 新バージョンより、大規模な書き換え(自作ライブラリの導入)によりカナリコード削減化などを測りました
#
# Windows/Linux/Mac OSX/UNIX/BSDなどの幅広いプラットフォームでうごきます(Ruby製なので)
# rebootとstopを強化したので環境依存がなくなりました
#
# Copyleft (C) α改 @alpha_kai_NET 2012-2013 http://alpha-kai-net.info/
#
# LICENSE CC BY-SA 3.0 http://creativecommons.org/licenses/by-sa/3.0/deed.ja
# この 作品 は クリエイティブ・コモンズ 表示 - 継承 3.0 非移植 ライセンスの下に提供されています。
#===========================================================================

require_relative "requires.rb"

# UserStreamAPIのurl
USERSTREAM_API_URL = 'https://userstream.twitter.com/1.1/user.json?replies=all'

$DEBUG_ = false

#再起動関連 α改追記
reboot_torf=false

class Alphakai
	attr_reader :blacklist
	
	def initialize
		File.open("./blacklist.csv", "w", :encoding => Encoding::UTF_8).close() unless File.exist?("./blacklist.csv")

		File.open('./blacklist.csv', 'r', :encoding => Encoding::UTF_8) do |io|
			@blacklist = io.read.strip.split(',')
		end

		cunsmer_array=[]
		cunsmer_array << CONSUMER_KEY << CONSUMER_SECRET << ACCESS_TOKEN << ACCESS_TOKEN_SECRET
		@TwitRuby=TwitRuby.new
		@TwitRuby.initalize_connection(cunsmer_array)
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
				@TwitRuby.user_stream do |j|
					#follow　back?
					if(j['event'] == "follow") == true then
						puts "follow sareta!"
						tefu.follow_back(j["source"]["screen_name"],j["source"]["name"])
						
						id_list << j['user']['screen_name'].to_s#絡むfollower追加
					end
					

					if(j['text'])
						puts "@#{j['user']['screen_name']}:#{j['text']}"
						text = j['retweeted_status'] ? j['retweeted_status']['text'] : j['text']
						alpha_handler = Tools.new(j['user']['screen_name'], text)
						alpha_handler.bls = @blacklist
						alpha_handler.output
						puts "=> #{alpha_handler.filtered}" if $DEBUG_
							
					#ここにてふてふのしょりとか
					#α改追記ここより
						
						Thread.new do
							#reply
							tefuback=tefu.reply_post(j['text'], j['id_str'], j['user']['screen_name'], j['user']['id'],id_list,j['user']['name'])
						
							return true if tefuback == 1
							return false if tefuback == 2
						end
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