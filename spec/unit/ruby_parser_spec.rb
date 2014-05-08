# Encoding: UTF-8

require 'rubydot'
require 'spec_helper'

# some tests to ensure the ruby parsers works as expected
ONE_RB = <<END
module OneModuleName
  class OneClassName
  end
end
END

SUB_CLASS_RB = <<END
module TwoModuleName
  class BaseClass
  end
  class SubClass < BaseClass
    BaseClass
  end
end
END

SUB_CLASSES_RB = <<END
module TheModuleName
  class BaseAPI
  end

  class PublicRestAPI < BaseAPI
  end

  class AuthRestAPI < BaseAPI
  end

  class OAuthRestAPI < AuthRestAPI
  end
end
END

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

def node_name(node)
  node.rest && node.rest.head
end

def super_class(node)
  node.rest && node.rest.rest && node.rest.rest.head && \
  node.rest.rest.head.rest && node.rest.rest.head.rest.head
end

describe 'The RubyParser class' do
  describe 'parses one class' do
    before :each do
      parser = RubyParser.new
      @sexp = parser.parse(ONE_RB)
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

  describe 'parses one sub-classes' do
    before :each do
      parser = RubyParser.new
      @sexp = parser.parse(SUB_CLASS_RB)
    end

    it 'can find :module' do
      mod = find(@sexp, :module)
      expect(mod).to_not eq(nil)
    end

    it 'can find module name' do
      mod = find(@sexp, :module)
      expect(node_name(mod)).to eq(:TwoModuleName)
    end

    it 'can find two classes' do
      mod = find(@sexp, :module)
      classes = find_all(mod, :class)
      expect(classes.size).to eq(2)
    end

    it 'can find two classes with the correct name' do
      classes = find_all(@sexp, :class)
      expect(node_name(classes[0])).to eq(:BaseClass)
      expect(node_name(classes[1])).to eq(:SubClass)
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

  describe 'parses several sub-classes' do
    before :each do
      parser = RubyParser.new
      @sexp = parser.parse(SUB_CLASSES_RB)
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
