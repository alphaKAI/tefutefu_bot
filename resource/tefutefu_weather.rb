require "net/http"
require "uri"
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
			num2pref={"2"=>"北海道", "5"=>"青森", "6"=>"岩手", "7"=>"宮城", "8"=>"秋田", "9"=>"山形", "10"=>"福島", "16"=>"東京", "17"=>"神奈川", "14"=>"埼玉", "15"=>"千葉", "11"=>"茨城", "12"=>"栃木", "13"=>"群馬", "22"=>"山梨", "23"=>"長野", "18"=>"新潟", "19"=>"富山", "20"=>"石川", "21"=>"福井", "26"=>"愛知", "24"=>"岐阜", "25"=>"静岡", "27"=>"三重", "30"=>"大阪", "31"=>"兵庫", "29"=>"京都", "28"=>"滋賀", "32"=>"奈良", "33"=>"和歌山", "34"=>"鳥取", "35"=>"島根", "36"=>"岡山", "37"=>"広島", "38"=>"山口", "39"=>"徳島", "40"=>"香川", "41"=>"愛媛", "42"=>"高知", "43"=>"福岡", "44"=>"佐賀", "45"=>"長崎", "46"=>"熊本", "47"=>"大分"}
			pref_cap2num={"北海道"=>"4","青森"=>"17","岩手"=>"22","宮城"=>"25","秋田"=>"20","山形"=>"27","福島"=>"31","東京"=>"63","神奈川"=>"70","埼玉"=>"60","千葉"=>"67","茨城"=>"54","栃木"=>"56","群馬"=>"58","山梨"=>"75","長野"=>"72","新潟"=>"50","富山"=>"44","石川"=>"46","福井"=>"48","愛知"=>"38","岐阜"=>"40","静岡"=>"34","三重"=>"42","大阪"=>"81","兵庫"=>"82","京都"=>"79","滋賀"=>"77","奈良"=>"84","和歌山"=>"86","鳥取"=>"95","島根"=>"92","岡山"=>"88","広島"=>"90","山口"=>"97","徳島"=>"101","香川"=>"103","愛媛"=>"104","高知"=>"107","福岡"=>"110","佐賀"=>"122","長崎"=>"118","熊本"=>"124","大分"=>"114","宮崎"=>"128","鹿児島"=>"132","沖縄"=>"136"}
			num2pref_cap={"4"=>"北海道","17"=>"青森","22"=>"岩手","25"=>"宮城","20"=>"秋田","27"=>"山形","31"=>"福島","63"=>"東京","70"=>"神奈川","60"=>"埼玉","67"=>"千葉","54"=>"茨城","56"=>"栃木","58"=>"群馬","75"=>"山梨","72"=>"長野","50"=>"新潟","44"=>"富山","46"=>"石川","48"=>"福井","38"=>"愛知","40"=>"岐阜","34"=>"静岡","42"=>"三重","81"=>"大阪","82"=>"兵庫","79"=>"京都","77"=>"滋賀","84"=>"奈良","86"=>"和歌山","95"=>"鳥取","92"=>"島根","88"=>"岡山","90"=>"広島","97"=>"山口","101"=>"徳島","103"=>"香川","104"=>"愛媛","107"=>"高知","110"=>"福岡","122"=>"佐賀","118"=>"長崎","124"=>"熊本","114"=>"大分","128"=>"宮崎","132"=>"鹿児島","136"=>"沖縄"}
			prefcap_nums=[4,17,22,25,20,27,31,63,70,60,67,54,56,58,75,72,50,44,46,48,38,40,34,42,81,82,79,77,84,86,95,92,88,90,97,101,103,104,107,110,122,118,124,114,128,132,136]
			return_array=[]
			place=""
			place_str=""
			place2=""
			place_str2=""
			
			pref2num.each{|now,hash|
				place_str=now if reply.include?(now)
				place=hash if reply.include?(now)
			}
			pref_cap2num.each{|now,hash|
				place_str2=now if reply.include?(now)
				place2=hash if reply.include?(now)
			}
			
			return "ERROR2" if place==nil
			
			case weather_type
				when 1#今日
					xml_doc=get_xml("pref_#{place}")
					count_wh=0
					weth=""
					xml_doc.xpath("//title").each{|node|
						weth=node.text if count_wh==2
						break if count_wh==2
						count_wh+=1
					}
					tmp=weth.split
					p tmp
					tmp[0]=tmp[0].split("(")[1].delete(")")
					return_array=tmp
				when 2#明日
					xml_doc=get_xml("city_#{place2}")
					count_wh=0
					weth=""
					xml_doc.xpath("//title").each{|node|
						weth=node.text if count_wh==4
						break if count_wh==4
						count_wh+=1
					}
					tmp=weth.split
					tmp.unshift(num2pref_cap[place2])
					return_array=tmp
				when 3#週間天気
					xml_doc=get_xml("city_#{place2}")
					count_wh=0
					weth=""
					node2=[]
					strs=[]
					array=0
					xml_doc.xpath("//title").each{|node|
						node2 << node.text if array > 1
						array+=1
					}
					strs << node2[0].to_s + node2[1].to_s << node2[2].to_s + node2[3].to_s << node2[4].to_s + node2[5].to_s << node2[6].to_s + node2[7].to_s << node2[8].to_s + node2[9].to_s << node2[10].to_s + node2[11].to_s << node2[12].to_s + node2[13].to_s << node2[14].to_s + node2[15].to_s << node2[16].to_s + node2[17].to_s << node2[18].to_s + node2[19].to_s << node2[20].to_s + node2[21].to_s << node2[22].to_s + node2[23].to_s
					array_tmp=[]
					array=0
					strs.each{|weth2|
						break if weth2.empty?
						tmp=weth2.split
						# tmp[0]=tmp[0].split("(")[1].delete(")")
						tmp.unshift(num2pref_cap[place2])
						array_tmp << tmp
					}
					
					array_tmp2=[]
					strs.size.times{|i|
						tmp=array_tmp[i]
						array_tmp2 << num2pref_cap[place2].to_s+"の"+tmp[1].to_s+"の天気は"+tmp[2].to_s+"で 最高気温(℃)/最低気温(℃)は"+tmp[3].to_s+"です！"
					}
					arrays=[[array_tmp2[0],array_tmp2[1],array_tmp2[2],array_tmp2[3]],[array_tmp2[4],array_tmp2[5],array_tmp2[6],array_tmp2[7]]]
					p arrays[0]
					p arrays[1]
					#Build Array
					
			end
			#puts pref2num[place_str]
			#puts num2pref[place]
			return return_array
		end#main
		
		def get_xml(parm)
			url = URI.parse("http://tenki.jp/")
			res = Net::HTTP.start(url.host, url.port){|http|
				http.get("/component/static_api/rss/forecast/#{parm}.xml")
			}
			xml_doc = Nokogiri.XML(res.body)#parse xml by Nokogiri
		end
	end
	
	class TefuOmikuji
	
	end
end

#FOR DEBUG
include TefuFuncs
te=TefuWeather.new
str="福井の週間天気"
a=te.parse_reply(str)
tmp=te.get_weather(str,a)
# puts tmp[0].to_s+"の"+tmp[1].to_s+"の天気は"+tmp[2].to_s+"で 最高気温(℃)/最低気温(℃)は"+tmp[3].to_s+"です！"