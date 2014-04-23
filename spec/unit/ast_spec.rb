# Encoding: UTF-8

require 'rubydot'

TEST_DIR = File.join(File.dirname(__FILE__), 'data')
MODULE_NO_CLASSES_DIR = File.join(TEST_DIR, 'module', 'no_classes')

describe 'The Rubydot module' do
  it 'has an AST class' do
    expect(Rubydot::AST.class).to eq(Class)
  end

  describe 'with a single input file' do
    it 'parses a single module with no classes' do
      ast = Rubydot::AST.new(File.join(MODULE_NO_CLASSES_DIR, 'one.rb'))
      expect(ast.modules).to eq({ModuleName: {}})
    end

    it 'parses two separate modules with no classes' do
      ast = Rubydot::AST.new(File.join(MODULE_NO_CLASSES_DIR, 'two_separate.rb'))
      expect(ast.modules).to eq({ModuleName1: {}, ModuleName2: {}})
    end

    it 'parses two modules of the same name with no classes' do
      ast = Rubydot::AST.new(File.join(MODULE_NO_CLASSES_DIR, 'two_same.rb'))
      expect(ast.modules).to eq({ModuleName: {}})
    end
  end
end
