# encoding: UTF-8

module Rubydot
  # Generate a UML class diagram for the ruby source files in the given path
  class App
    def initialize(path)
      @path = path
    end

    def generate(output_path)
      # Get a single AST for all source files.
      ast = Src::AST.new(@path)
    end
  end
end
