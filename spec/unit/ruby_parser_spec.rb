# Encoding: UTF-8

require 'rubydot'

# some tests to ensure the ruby parsers works as expected

def find(node, type)
  if node.nil? || !node.is_a?(Sexp)
    return nil
  elsif node.head == type
    return node
  end

  result = find(node.head, type)
  return result unless result.nil?
  find(node.rest, type)
end

def find_all(node, type)
  def f(node, type, acc)
    if node.nil? || !node.is_a?(Sexp)
      return
    elsif node.head == type
      acc << node
      return f(node.rest, type, acc)
    end

    f(node.head, type, acc)
    f(node.rest, type, acc)
  end

  acc = []
  f(node, type, acc)
  acc
end

def super_class(node)
  node.rest && node.rest.rest && node.rest.rest.head && \
  node.rest.rest.head.rest && node.rest.rest.head.rest.head
end

describe 'The RubyParser class' do
  describe 'parses one.rb' do
    before :each do
      parser = RubyParser.new
      @sexp = parser.parse(File.read(File.join(File.dirname(__FILE__),
                                               'one.rb')))
    end

    it 'can find :module' do
      mod = find(@sexp, :module)
      expect(mod).to_not eq(nil)
    end

    it 'can find module name' do
      mod = find(@sexp, :module)
      expect(mod.rest.head).to eq(:OneModuleName)
    end

    it 'can find class inside :module' do
      mod = find(@sexp, :module)

      cls = find(mod, :class)
      expect(cls).to_not eq(nil)
    end

    it 'can find the class name in the class inside :module' do
      mod = find(@sexp, :module)
      cls = find(mod, :class)

      expect(cls.rest.head).to eq(:OneClassName)
    end
  end

  describe 'parses two.rb' do
    before :each do
      parser = RubyParser.new
      @sexp = parser.parse(File.read(File.join(File.dirname(__FILE__),
                                               'two.rb')))
    end

    it 'can find :module' do
      mod = find(@sexp, :module)
      expect(mod).to_not eq(nil)
    end

    it 'can find module name' do
      mod = find(@sexp, :module)
      expect(mod.rest.head).to eq(:TwoModuleName)
    end

    it 'can find two classes' do
      mod = find(@sexp, :module)
      classes = find_all(mod, :class)
      expect(classes.size).to eq(2)
    end

    it 'can find two classes with the correct name' do
      classes = find_all(@sexp, :class)
      expect(classes[0].rest.head).to eq(:BaseClass)
      expect(classes[1].rest.head).to eq(:SubClass)
    end

    it 'can find the parent class of a sub-class' do
      classes = find_all(@sexp, :class)
      classes.each do |cls|
        if cls.rest.head == :SubClass
          super_class = cls.rest.rest.head.rest.head
          expect(super_class(cls)).to eq(:BaseClass)
        end
      end
    end
  end

  describe 'parses moderate.rb' do
    before :each do
      parser = RubyParser.new
      @sexp = parser.parse(File.read(File.join(File.dirname(__FILE__),
                                               'moderate.rb')))
    end


    it 'has four classes' do
      classes = find_all(@sexp, :class)
      expect(classes.size).to eq(4)
    end

    it 'has two classes derived from BaseAPI' do
      classes = find_all(@sexp, :class)
      sub_classes = []
      classes.each do |cls|
        sub_classes << cls if super_class(cls) == :BaseAPI
      end
      expect(sub_classes.size).to eq(2)
    end

    it 'has one class derived from OAuthRestAPI -> BaseAPI' do
      classes = find_all(@sexp, :class)
      sub_classes = []
      classes.each do |cls|
        sub_classes << cls if super_class(cls) == :AuthRestAPI
      end
      expect(sub_classes.size).to eq(1)
    end
  end
end
