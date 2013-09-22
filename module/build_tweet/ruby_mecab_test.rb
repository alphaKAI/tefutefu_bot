#encoding:utf-8
require_relative "ruby_mecab.rb"

BEGIN_DELIMITER      = "__BEGIN__" + "\n"
END_DELIMITER         = "__END__" + "\n"
IGO_DIC_DIRECTORY = Dir.pwd + "/ipadic"

tools=Tools.new
class Build_tweet
	def tweet(path)
		tools.study(File.read(path, :encoding => Encoding::UTF_8).split("\n"))
		tools.build_tweet
	end	
end