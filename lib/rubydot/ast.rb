# encoding: UTF-8

require 'ruby_parser'

module Rubydot
  # This class can create a single AST from multiple ruby source files
  # module definitions spanning multiple files are merged together, as
  # are classes that span multiple files.
  class AST
    attr_reader :modules

    # a class instance variable for the parser - we only ever need one
    class << self; attr_reader :parser end
    @parser = RubyParser.new

    def initialize(path)
      @paths = File.directory?(path) ? Dir["#{path}/**/*.rb"] : [path]
      fail Errno::ENOENT, 'No ruby files found in path' if @paths.empty?
      @modules = {}
      _parse_all
    end

    def _parse_all
      @paths.each do |path|
        sexp = self.class.parser.parse(File.read(path))
        if sexp.node_type == :module
          _add_module(sexp)
        else
          sexp.each_of_type(:module).each do |sexp_module|
            _add_module(sexp_module)
          end
        end
      end
    end

    def _add_module(sexp)
      name = sexp.rest.head
      @modules[name] = {}
      modules[name] ||= Sexp.new
      # [2] skips the type and name of the Sexp
      modules[name].add(sexp[2]) if sexp.size >= 3
    end
  end
end
