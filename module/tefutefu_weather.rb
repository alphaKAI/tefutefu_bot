#encoding:utf-8
require "net/http"
require "nokogiri"
require "uri"
######################################################
# This is a tefutefu's extend module.
# Copyleft (C) α改 @alpha_kai_NET 2012-2013 http://alpha-kai-net.info/
# GPLv3 LICENSE
######################################################

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
				return 4
			end
			return weather_type
		end
		
		def get_weather(reply,weather_type)
			unless (1..3).include?(weather_type)
				return "ERROR"
			end
			
			pref2num=Hash.new
			num2pref=Hash.new
			pref_cap2num=Hash.new
			num2pref_cap=Hash.new

			doc = Nokogiri::HTML(open("./module/pref.xml"))
			#pref2num
			doc.xpath("//pref2num/prefs").each{|node|
			  name=node.xpath("name").text
			  num=node.xpath("num").text
			  pref2num.store(name,num)#Add key and value
			}
			#num2pref
			doc.xpath("//num2pref/prefs").each{|node|
 			  name=node.xpath("name").text
			  num=node.xpath("num").text
			  num2pref.store(num,name)
			}
			#pref_cap2num
			doc.xpath("//pref_cap2num/prefs").each{|node|
			  name=node.xpath("name").text
			  num=node.xpath("num").text
			  pref_cap2num.store(name,num)
			}
			doc.xpath("//num2pref_cap/prefs").each{|node|
   			  name=node.xpath("name").text
			  num=node.xpath("num").text
			  num2pref_cap.store(num,name)
			}

			return_array=[]
			place=""
			place_str=""
			place2=""
			place_str2=""
			
			exist_check=false
			
			pref2num.each{|now,hash|
				if reply.include?(now)
				  place_str=now
				  place=hash
				  exist_check=true
				end
			}
			pref_cap2num.each{|now,hash|
			  if reply.include?(now)
				place_str2=now
				place2=hash
			  end
			}
			if exist_check==false
				return 5
			end
			
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
						tmp.unshift(num2pref_cap[place2])
						array_tmp << tmp
					}

					array_tmp2=[]
					array_tmp2 << strs.size << num2pref_cap[place2] << array_tmp
					return_array = array_tmp2
			end
			return return_array
		end#End of function
		
		def get_xml(parm)
			url = URI.parse("http://tenki.jp/")
			res = Net::HTTP.start(url.host, url.port){|http|
				http.get("/component/static_api/rss/forecast/#{parm}.xml")
			}
			xml_doc = Nokogiri.XML(res.body)#parse xml by Nokogiri
		end#End of function
	end#End of class
	
	class TefuOmikuji
	  def parse_reply(reply)
		if reply.empty? || reply =~ /おみくじ/
		  return "ERROR"
		end
		if reply =~ /バトルドーム/
		  return
		end
	  end
	end#End of class
end#End of module
