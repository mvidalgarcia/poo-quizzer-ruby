Dir[File.dirname(__FILE__) + '/exam/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/assessment/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/scores/*.rb'].each { |file| require file }
require_relative 'evaluator'
require_relative 'options'
require 'json'
require 'open-uri' # To get the JSONs from URI

class Quizzer
  def start(options)
    # Case -> Quiz and Assessment files: -f quiz.json, assessment.json
    if options.fileNameQuiz and options.fileNameAssessment
      quizObj, assessmentObj = Evaluator.json_filename_to_obj(options.fileNameQuiz, options.fileNameAssessment)
      return Evaluator.evaluate(quizObj, assessmentObj).scores_obj_to_json_str

      # Case -> Manifest file: -m manifest.json
    elsif options.fileNameManifest
      manifestStr = Evaluator.read_json(options.fileNameManifest)
      # Parse manifest json into a hash array
      manifestJson = JSON.parse(manifestStr)
      return Evaluator.iterateManifest(manifestJson)
    else
      raise "Wrong number of arguments!"
    end
  end

end

class Main
  attr_accessor :options

  def initialize(argv)
    # If no arguments, raise help message
    if argv.eql?([]) then
      argv.push("-h")
    end
    if !(argv[0] == "-m" or argv[0] == "-f" or argv[0] == "-h") then
      argv.push("-h")
    end
    @options = Arguments::Options.new(argv)
    @quizzer = Quizzer.new
  end

  def run
    puts @quizzer.start(@options)
  end
end