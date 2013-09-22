#encoding:utf-8
require "igo-ruby"
require "net/http"
class Splitter
	def initialize()
		@tagger = Igo::Tagger.new(IGO_DIC_DIRECTORY)
	end
	def split(str)
		array = Array.new
		array << BEGIN_DELIMITER
		array += @tagger.wakati(str)
		array << END_DELIMITER
		array
	end
end
class BuildTools
	def initialize
		@markov = Markov.new
		@markov_mention = Markov.new
		@splitter = Splitter.new
	end
	def http_query(method, uri_str, query)
		uri = URI.parse(uri_str)
		query_string = query.map{|k,v| URI.encode(k) + "=" + URI.encode(v) }.join("&")
		Net::HTTP.start(uri.host, uri.port) {|http|
			if method == "get"
				query_string = "?" + query_string unless query_string.empty?
				http.get(uri.path + query_string)
			else
				http.post(uri.path, query_string)
			end
		}
	end
	def build_tweet()
		counter = 0
		while counter <= 10 do
			result = @markov.build.join("")
			return result if result.size <= 140 # 140文字以内なら採用
			counter += 1
		end
		raise StandardError.new("retry limit is exceeded")
	end
	def study(give_text)
		Thread.new{
			give_text.each {|str|
				Thread.new{
					begin
						words = @splitter.split(str)
						@markov.study(words)
						# puts "study: #{str}"
					rescue
						next
					end
				}
			}
			# sleep 3
		}.join
	end
end
class Markov
	def initialize()
		@table = Array.new
	end
	def study(words)
		return if words.size < 3
		for i in 0..(words.size - 3) do
			@table << [words[i], words[i + 1], words[i + 2]]
		end
	end
	def search1(key)
		array = Array.new
		@table.each {|row|
			array << row[1] if row[0] == key
		}
		array.sample
	end
	def search2(key1, key2)
		array = Array.new
		@table.each {|row|
			array << row[2] if row[0] == key1 && row[1] == key2
		}
		array.sample
	end
	def build
		array = Array.new
		key1 = BEGIN_DELIMITER
		key2 = search1(key1)
		while key2 != END_DELIMITER do
			array << key2
			key3 = search2(key1, key2)
			key1 = key2
			key2 = key3
		end
		array
	end
end