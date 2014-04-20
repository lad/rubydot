# encoding: UTF-8

require 'ruby_parser'
require 'pry'

module Rubydot
  # Generate a dot file for ruby source files in the given path
  class Generator
    def initialize(path)
      @files = Generator._files_from_path(path)
      @asts = {}
      @classes = {}
    end

    def self._files_from_path(path)
      if File.file?(path)
        [path]
      elsif Dir.exists?(path)
        files = Dir["#{path}/**/*.rb"]
        fail Rubydot::Error, "No files found in: #{path}" if files.empty?
        files
      else
        fail Errno::ENOENT, "#{path}"
      end
    end

    def asts
      @asts unless @asts.empty?

      parser = RubyParser.new
      @files.each do |filepath|
        @asts[File.basename(filepath)] ||= parser.parse(File.read(filepath))
      end
      @asts
    end

    def run(out_path)
      # File.write(out_path, @asts.to_s)
      asts.values.each do |ast|
        extract(ast)
      end

      @classes.values.each do |cls|
        if !cls.rest.head.nil?
          puts "#{cls.rest.head.rest.head} -> #{cls.head}"
        else
          puts cls.head
        end
      end
    end

    def extract(node, parent = nil, indent = 0)
      return if node.nil?
      if node.is_a?(Sexp)
        extract(node.head, node, indent + 1)
        extract(node.rest, node, indent + 1)
      else
        if parent.node_type == :class
          @classes[parent.to_s] = parent.rest
        end
        # puts ' ' * indent + node.to_s if parent.node_type == :class
      end
    end
  end
end
