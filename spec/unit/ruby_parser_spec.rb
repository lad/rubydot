# Encoding: UTF-8

require 'rubydot'

# some tests to ensure the ruby parsers works as expected

describe 'The RubyParser class' do
  describe 'parses one.rb' do
    before :each do
      parser = RubyParser.new
      @sexp = parser.parse(File.read(File.join(File.dirname(__FILE__), 'one.rb')))
    end

    it 'can find :module' do
      while !@sexp.nil? && @sexp.head != :module
        @sexp = @sexp.rest
      end
      expect(@sexp).to_not eq(nil)
    end

    it 'can find module name' do
      while !@sexp.nil? && @sexp.head != :module
        @sexp = @sexp.rest
      end
      expect(@sexp.rest.head).to eq(:ModuleName)
    end

    it 'can find class inside :module' do
      #require 'pry'; binding.pry
      while !@sexp.nil? && @sexp.head != :module
        @sexp = @sexp.rest
      end

      require 'pry'; binding.pry
      # module contents
      @sexp = @sexp.rest
      # name is .head, module definitions in .rest.head
      @sexp = @sexp.rest.head

      while !@sexp.nil? && @sexp.head != :class
        @sexp = @sexp.rest
      end
      expect(@sexp).to_not eq(nil)
    end
  end
end
