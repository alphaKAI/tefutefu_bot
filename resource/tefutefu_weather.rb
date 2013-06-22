require "open-uri"
require "nokogiri"

module TefuFuncs

	class TefuWeather
		def parse_reply(reply)
			unless /天気/ =~ reply
				return "ERROR"#reject parse if not exist "天気" in reply
			end
			weather_type=0#今日 or 明日 or 週間
			case reply
				when /今日/
					weather_type=1
				when /明日/
					weather_type=2
				when /週間/
					weather_type=3
			else
				return "when?"
			end
			return weather_type
		end
		
		def get_weather(reply,weather_type)
			unless (1..3).include?(weather_type)
				return "ERROR"
			end
			pref2num={"北海道"=>"2","青森"=>"5","岩手"=>"6","宮城"=>"7","秋田"=>"8","山形"=>"9","福島"=>"10","東京"=>"16","神奈川"=>"17","埼玉"=>"14","千葉"=>"15","茨城"=>"11","栃木"=>"12","群馬"=>"13","山梨"=>"22","長野"=>"23","新潟"=>"18","富山"=>"19","石川"=>"20","福井"=>"21","愛知"=>"26","岐阜"=>"24","静岡"=>"25","三重"=>"27","大阪"=>"30","兵庫"=>"31","京都"=>"29","滋賀"=>"28","奈良"=>"32","和歌山"=>"33","鳥取"=>"34","島根"=>"35","岡山"=>"36","広島"=>"37","山口"=>"38","徳島"=>"39","香川"=>"40","愛媛"=>"41","高知"=>"42","福岡"=>"43","佐賀"=>"44","長崎"=>"45","熊本"=>"46","大分"=>"47"}
			num2pref={"2"=>"道央", "5"=>"青森", "6"=>"岩手", "7"=>"宮城", "8"=>"秋田", "9"=>"山形", "10"=>"福島", "16"=>"東京", "17"=>"神奈川", "14"=>"埼玉", "15"=>"千葉", "11"=>"茨城", "12"=>"栃木", "13"=>"群馬", "22"=>"山梨", "23"=>"長野", "18"=>"新潟", "19"=>"富山", "20"=>"石川", "21"=>"福井", "26"=>"愛知", "24"=>"岐阜", "25"=>"静岡", "27"=>"三重", "30"=>"大阪", "31"=>"兵庫", "29"=>"京都", "28"=>"滋賀", "32"=>"奈良", "33"=>"和歌山", "34"=>"鳥取", "35"=>"島根", "36"=>"岡山", "37"=>"広島", "38"=>"山口", "39"=>"徳島", "40"=>"香川", "41"=>"愛媛", "42"=>"高知", "43"=>"福岡", "44"=>"佐賀", "45"=>"長崎", "46"=>"熊本", "47"=>"大分"}
			
			place=""
			place_str=""
			
			pref2num.each{|now,hash|
				place_str=now if reply.include?(now)
				place=hash if reply.include?(now)
			}
			
			puts place
			puts place_str
			
			return "ERROR2" if place==nil
			
			puts pref2num[place_str]
			puts num2pref[place]
		end
	end
	
	class TefuOmikuji
	
	end
end

#FOR DEBUG
include TefuFuncs
te=TefuWeather.new
str="福井の明日の天気"
a=te.parse_reply(str)
puts a
p te.get_weather(str,a)