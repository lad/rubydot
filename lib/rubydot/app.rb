# encoding: UTF-8

require 'pry'

module Rubydot
  # Generate a UML class diagram for the ruby source files in the given path
  class App
    def initialize(path)
      # input path can be a single filename or a directory
      @files = self.class._files_from_path(path)
      # Output file generator
      @dot_file = DotFileTemplate.new
    end

    def generate(output_path)
      # Get a single AST for all source files.
      ast = AST.new(@files)
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
      _parse_all if @asts.empty?
      @asts
    end

    def _parse_all
      parser = RubyParser.new
      @files.each do |filepath|
        @asts[filepath] = parser.parse(File.read(filepath))
      end
    end

    def node_to_s(node)
      if node.is_a?(Sexp)
        node.rest.head.to_s
      else
        node.to_s
      end
    end

    def run(out_path)
      # File.write(out_path, @asts.to_s)
      def mod(name, rest)
        #puts "MODULE:  #{rest.head}"
        #@current = rest.head.to_s
        @current = node_to_s(rest.head)
        @classes[@current] ||= []
      end

      def klass(name, rest)
        @classes[@current] << [node_to_s(rest.head), node_to_s(rest.rest.head)]
        #puts "CLASS:   #{rest.head}"
        #puts "PARENT:  #{rest.rest.head}"
        #puts "PARENT:  #{rest.head unless rest.nil?}"
      end

      asts.values.each do |ast|
        visit(ast, { :module => proc { |h,r| mod(h,r) }, :class => proc { |h,r| klass(h,r) } })
      end

      @classes.each do |m,c|
        puts m
        c.each do |cls,par|
          if par.empty?
            puts "  #{cls}"
          else
            puts "  '#{par}' -> #{cls}"
          end
        end
      end

      #@classes.values.each do |klass|
        #if !klass.rest.head.nil?
          #puts "#{klass.rest.head.rest.head} -> #{klass.head}"
        #else
          #puts klass.head
        #end
      #end
    end

    def visit(node, types, parent = nil)
      return if node.nil?
      if node.is_a?(Sexp)
        visit(node.head, types, node)
        visit(node.rest, types, node)
      else
        if types.include?(parent.node_type)
          types[parent.node_type].call(parent.head, parent.rest) unless parent.rest.empty?
          #puts "#{parent.node_type}    #{parent.rest.head}"
        end
        # puts ' ' * indent + node.to_s if parent.node_type == :class
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
