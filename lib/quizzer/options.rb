require 'optparse'

module Arguments

class Options

	attr_reader :fileNameQuiz
  attr_reader :fileNameAssessment
  attr_reader :fileNameManifest
	
	def initialize(argv)
		@fileNameQuiz
    @fileNameAssessment
    @fileNameManifest
		parse(argv)
	end

	private
	
	def parse(argv)
		OptionParser.new do |opts|
		opts.banner = "Usage: ruby -Ilib bin\\evaluate [ options ]"

    opts.on("-f", "--files quiz.json,assessment.json", Array, "quiz and assessment JSON file names") do |list|
      @fileNameQuiz = list[0]
      @fileNameAssessment = list[1]
    end

		opts.on("-m", "--manifest manifest.json", String, "Manifest file name") do |p|
			@fileNameManifest = p
		end
	
		opts.on("-h", "--help", "Show this message") do
			puts opts
			exit
		end

		begin
			opts.parse!(argv)
			rescue OptionParser::ParseError => e
				STDERR.puts e.message, "\n", opts
				exit(-1)
			end
		end
    end 
  end # class
end # module