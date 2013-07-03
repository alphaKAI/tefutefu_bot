# encoding: utf-8

########################################################################
# ==TwitRuby==                                                         #
# Copyright (C) alphaKAI @alpha_kai_NET 2013 http://alpha-kai-net.info #
# GPLv3 LICENSE                                                        #
#                                                                      #
# Version:0.0.1_alpha FIX05                                            #
# This is one of the Twitter Library                                   #
# inspired by https://gist.github.com/pnlybubbles/5476370              #
# This is development version.                                         #
# So very unstable.                                                    #
# You must accept it when you use this.                                #
########################################################################
require "net/https"
require "oauth"
require "cgi"
require "json"
require "openssl"
require "open-uri"
require "date"

class TwitRuby
	def initalize_connection(consumer_keys)
		ak_exist=true
		#デフォ状態での引数にアクセストークン系があるかないか 初期になかった場合は処理中にfalseに変更
		if consumer_keys.size !=4 then
			puts "error"
			puts "wrong number of arguments"
			puts "arguments array is require 4 element"
			exit
		end
		consumer_key = consumer_keys[0]
		consumer_secret = consumer_keys[1]
		access_token = consumer_keys[2]
		access_token_secret = consumer_keys[3]
		
		@consumer = OAuth::Consumer.new(
		consumer_key,
		consumer_secret,
		:site => "http://api.twitter.com/"
		)
		
		if access_token == nil || access_token == "" || access_token_secret == nil || access_token_secret == ""
			puts "アクセストークンが設定されていないため、アクセストークンを取得します"
			oauth_array = oauth_init
			access_token = oauth_array[0]
			access_token_secret = oauth_array[1]
			ak_exist = false
		end
		
		# puts access_token
		# puts access_token_secret
		
		@access_token = OAuth::AccessToken.new(
		@consumer,
		access_token,
		access_token_secret
		)
	end#end of function
	
	def oauth_init
		begin
			request_token = @consumer.get_request_token

			# require "Win32API"

			# shellexecute = Win32API.new("shell32.dll","ShellExecuteA",%w(p p p p p i),"i")
			# shellexecute.call(0, "open", "#{request_token.authorize_url}", 0, 0, 1)
			
			puts("Access here: #{request_token.authorize_url}\nand...")
			print("Please input pin:=>")
			pin = STDIN.gets.chomp
			puts ""#改行

			access_token = request_token.get_access_token(
			"oauth_token" => request_token.token,
			"oauth_verifier" => pin
			)

			access_tokens = []
			access_tokens  << access_token.token.to_s
			access_tokens  << access_token.secret.to_s
			
			return access_tokens
		end#end of begin
	end#end of function oauth_init

	##########################################################################
	
	#POST statuses/update
	def update(str, id="")
		if (id.empty?) then
			@access_token.post("/1.1/statuses/update.json",
			"status" => str)
		else
			p @access_token.post("/1.1/statuses/update.json",
			"status" => str,
			"in_reply_to_status_id" => id)
		end
	end
	
	#POST favorites/create
	def favorite(id)
		@access_token.post("/1.1/favorites/create.json",
		"id" => id.to_s)
	end

	#POST favorites/destroy
	def unfavorite(id)
		@access_token.post("/1.1/favorites/destroy.json",
		"id" => id.to_s)
	end
 
	#POST statuses/retweet
	def retweet(id)
		@access_token.post("/1.1/statuses/retweet/#{id}.json")
	end
 
	#POST statuses/destroy
	def post_delete(id)
		@access_token.post("/1.1/statuses/destroy/#{id}.json")
	end
	
	#GET account/verify_credentials
	def verify_credentials
		return JSON.parse(@access_token.get("/1.1/account/verify_credentials.json").body)
	end
	
	#POST friendships/create
	def follow(screen_name="",user_id="")
		@access_token.post("/1.1/friendships/create.json",
		"screen_name" => screen_name,
		"user_id" => user_id,
		"follow" => true)
	end
	
	#POST friendships/destroy
	def remove(screen_name="",user_id="")
		@access_token.post("/1.1/friendships/destroy.json",
		"screen_name" => screen_name,
		"user_id" => user_id)
	end
	
	#GET statuses/mentions_timeline
	def mentions_timeline(count="",since_id="",max_id="",trim_user="",contributor_details="",include_entities="")
		return JSON.parse((@access_token.get("/1.1/statuses/mentions_timeline.json",
						"count" => count,
						"since_id" => since_id,
						"max_id" => max_id,
						"trim_user" => trim_user,
						"contributor_details" =>contributor_details,
						"include_entities" =>include_entities)
						).body)
	end
	
	#GET statuses/home_timeline
	def home_timeline(count,since_id="",max_id="",trim_user="",include_entities="",include_user_entities="")
		return JSON.parse(@access_token.get("/1.1/statuses/home_timeline.json",
						"count" =>count,
						"since_id" => since_id,
						"max_id" => max_id,
						"trim_user" => trim_user,
						"include_entities" => include_entities,
						"include_user_entities" => include_user_entities
						).body)
	end
	
	#GET statuses/user_timeline
	def user_timeline(user_id="",screen_name="",since_id="",count="",max_id="",trim_user="",exclude_replies="",contributor_details="",include_rts="")
		return JSON.parse(@access_token.get("/1.1/statuses/user_timeline.json",
						"user_id" => user_id,
						"screen_name" => screen_name,
						"since_id" => since_id,
						"count" => count,
						"max_id" => max_id,
						"trim_user" => trim_user,
						"exclude_replies" => exclude_replies,
						"contributor_details" => contributor_details,
						"include_rts" => include_rts
						).body)
	end
	
	#GET statuses/retweets_of_me
	def get_rom(count,since_id="",max_id="",trim_user="",include_entities="",include_user_entities="")
		return JSON.parse(@access_token.get("/1.1/statuses/retweets_of_me.json",
						"count" =>count,
						"since_id" => since_id,
						"max_id" => max_id,
						"trim_user" => trim_user,
						"include_entities" => include_entities,
						"include_user_entities" => include_user_entities
						).body)
	end
	
	##########################################################################
	
	#POST direct_messages/new
	def dm_send(user_id="",screen_name="",text)
		if user_id.empty? then
			return "Error. user_id => empty"
		end
		@access_token.get("/1.1/direct_messages/new.json",
		"user_id" => user_id,
		"screen_name" => screen_name,
		"text" => text)
	end
	
	#GET direct_messages/sent
	def get_sent_dm(since_id="",max_id="",count="",page="",include_entities="")
		if since_id.empty? || max_id.empty? || count.empty? || page.empty? || include_entities.empty? then
			return "Error. same parms is empty"
		end
		
		return JSON.parse(@access_token.get("/1.1/direct_messages/sent.json",
						"since_id" => since_id,
						"max_id" => max_id,
						"count" => count,
						"page" => page,
						"include_entities" => include_entities,
						).body)
	end
	
	#GET direct_messages
	def dm_msgs(since_id="",max_id="",count="",include_entities="",skip_status="")
		return JSON.parse(@access_token.get("/1.1/direct_messages.json",
						"since_id" => since_id,
						"max_id" => max_id,
						"count" => count,
						"include_entities" => include_entities,
						"skip_status" => skip_status
						).body)
	end
	
	#POST direct_messages/destroy
	def post_dm_destory(id,include_entities="")
		@access_token.post("/1.1/direct_messages/destroy.json",
		"id" => id,
		"include_entities" => include_entities)
	end
	
	##########################################################################
	
	#GET followers/ids
	def follower_ids(user_id="",screen_name="",cursor="",stringify_ids="",count="")
		return JSON.parse(@access_token.get("/1.1/followers/ids.json",
						"user_id" => user_id,
						"screen_name" => screen_name,
						"cursor" => cursor,
						"stringify_ids" => stringify_ids,
						"count" => count
						).body)
	end
	
	#GET username_available?
	#存在確認なので真偽値は逆となる trueなら使用可(IDとして新規作成時に)
	def user_ava?(user_name)
	
		#for https
		https = Net::HTTP.new("twitter.com",443)
		https.use_ssl = true
		https.verify_mode = OpenSSL::SSL::VERIFY_NONE
		
		#get and parse
		get_torf = JSON.parse(https.get("/users/username_available",
										"user_name" => user_name).body)["valid"]
										
		if get_torf == false
			return true#存在する
		elsif get_torf == true
			return false#存在しない
		end
	end
	
	#GET account/rate_limit_status
	def get_rate_limit
		return JSON.parse((@access_token.get("/1.1/application/rate_limit_status.json")).body)
	end
	
	#GET friendships/show
	def friendships?(source_id="",source_screen_name="",target_id="",target_screen_name="")
		
		#Convert and Build
		if source_id.empty? == true && source_screen_name.empty? == false
			source_ = "source_screen_name"
			source=source_screen_name
		elsif source_id.empty? == false && source_screen_name.empty? == true
			source_ = "source_id"
			source = source_id
		else
			return "ERROR"
		end
		
		if target_id.empty? ==true && target_screen_name.empty? == false
			target_ = "target_screen_name"
			target = target_screen_name
		elsif target_id.empty? ==false && target_screen_name.empty? == true
			target_ = "target_id"
			target = target_id
		else
			return "ERROR"
		end
		
		return JSON.parse(@access_token.get("/1.1/friendships/show.json?#{source_}=#{source}&#{target_}=#{target}").body)
	end
	
	##########################################################################
	#Streaming APIs
	#Usage:Call from block
	
	#UserStream
	def user_stream(&block)
		uri = URI.parse("https://userstream.twitter.com/1.1/user.json")
		https = Net::HTTP.new(uri.host, uri.port)
		https.use_ssl = true
		https.verify_mode = OpenSSL::SSL::VERIFY_NONE
		
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
	
	#Public Sample
	def public_sample(&block)
		uri = URI.parse("https://stream.twitter.com/1.1/statuses/sample.json")
		https = Net::HTTP.new(uri.host, uri.port)
		https.use_ssl = true
		https.verify_mode = OpenSSL::SSL::VERIFY_NONE

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
end#End of Class TwitRuby
