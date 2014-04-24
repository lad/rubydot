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
        mods = SexpUtil.find_all(sexp, :module)
        mods.each do |mod|
          name = SexpUtil.node_name(mod)
          @modules[name] ||= []

          SexpUtil.find_all(mod, :class).each do |cls|
            @modules[name] << [SexpUtil.node_name(cls),
                               SexpUtil.super_class(cls)]
          end
        end
      end
    end
  end
end
