﻿# encoding: utf-8

#===========================================================================
# This is one of the twitter"s bot "tefutefu_tyou".
# Copyleft (C) α改 @alpha_kai_NET 2012-2013 http://alpha-kai-net.info/
# Using alphaKAI/TwitRuby Library.
# GPLv3 LICENSE
#===========================================================================

require_relative "resource/requires.rb"

# UserStreamAPIのurl
USERSTREAM_API_URL = "https://userstream.twitter.com/1.1/user.json?replies=all"

$DEBUG_ = false

$CDIR=Dir::pwd

reboot_torf=false

class MainLoop
	attr_reader :blacklist
	def initialize
		File.open("#{$CDIR}/csv/blacklist.csv", "w", :encoding => Encoding::UTF_8).close() unless File.exist?("./csv/blacklist.csv")

		File.open("#{$CDIR}/csv/blacklist.csv", "r", :encoding => Encoding::UTF_8){|io|
			@blacklist = io.read.strip.split(",")
		}

		cunsmer_array=[]
		cunsmer_array << CONSUMER_KEY << CONSUMER_SECRET << ACCESS_TOKEN << ACCESS_TOKEN_SECRET
		@TwitRuby=TwitRuby.new
		@TwitRuby.initalize_connection(cunsmer_array)
	end

	def run
		bot=TwitterBot.new
		bot.oauth
		id_list=bot.get_follower#get list
		bot.on_post
		bot_back=nil

		#起動から30秒後にツイート
		Thread.new{
			sleep 30
			#ツイート
			bot.build_post
		}

		loop{
			puts "==== connecting..."
			begin
				@TwitRuby.user_stream{|j|
					#follow　back?
					if j["event"] == "follow"
						bot.follow_back(j["source"]["screen_name"],j["source"]["name"])
						id_list << j["user"]["screen_name"].to_s#絡むfollower追加
					end


					if(j["text"])
						puts "@#{j["user"]["screen_name"]}:#{j["text"]}"
						text = j["retweeted_status"] ? j["retweeted_status"]["text"] : j["text"]
						alpha_handler = Tools.new(j["user"]["screen_name"], text)
						alpha_handler.bls = @blacklist
						alpha_handler.output
						puts "=> #{alpha_handler.filtered}" if $DEBUG_

						#reply
						if j["retweeted_status"].to_s.empty?#リツイートに反応しないようにした
							bot_back=bot.reply_post(j["text"], j["id_str"], j["user"]["screen_name"], j["user"]["id"],id_list,j["user"]["name"])
						end

						case bot_back
							when 1
								return true
							when 2
								return false
							when 0
								next
						end
					end
				}
			rescue Exception => e
				puts "#### #{e} ####"
				puts e.backtrace if $DEBUG_
				break if e.to_s == ""
			end

			puts "==== connection lost."
		}
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
			File.open("#{$CDIR}/output/output.txt", "a"){|io|
				@filtered = filter(@text)
				io.puts("#{@filtered}") if @filtered != ""
			}
		end

		private
		def filter(str)
			return str.gsub(Regexp.union(@@assign.keys),@@assign).gsub(/#{@bls.join("|")}/,"")
		end
	end
end

reboot_torf=MainLoop.new.run
while reboot_torf==true
	reboot_torf=MainLoop.new.run
end