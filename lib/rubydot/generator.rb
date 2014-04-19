# encoding: UTF-8

require 'ruby_parser'

module Rubydot
  class Generator
    def initialize(path)
      if File.file?(path)
        @files = [path]
      elsif Dir.exists?(path)
        @files = Dir["#{path}/**/*.rb"]
        fail Rubydot::Error, "No files found in: #{path}" if @files.empty?
      end
      @parsed = {}
    end

    def parsed
      @parsed unless @parsed.empty?

      parser = RubyParser.new
      @files.each do |filepath|
        @parsed[File.basename(filepath)] ||= parser.parse(File.read(filepath))
      end
      @parsed
    end

    def run(out_path)
      #File.write(out_path, @parsed.to_s)
      require 'pry'; pry.binding
      require 'pp'
      pp parsed
    end
  end
end

