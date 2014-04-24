# Encoding: UTF-8

require 'rubydot'
require 'spec_helper'

TEST_DIR = spec_test_dir(__FILE__)
MULTI_TEST_DIR = File.join(TEST_DIR, 'multi')

describe 'The Rubydot module' do
  it 'has an AST class' do
    expect(Rubydot::AST.class).to eq(Class)
  end

  describe 'with a single input file: one.rb' do
    before :each do
      @ast = Rubydot::AST.new(File.join(TEST_DIR, 'one.rb'))
    end

    it 'finds one module' do
      expect(@ast.modules.keys).to eq([:OneModuleName])
    end
  end

  describe 'with several source files' do
    before :each do
      @ast = Rubydot::AST.new(MULTI_TEST_DIR)
    end

    it 'finds the two modules' do
      expect(@ast.modules.keys).to eq([:Mod1, [:Mod1, :Mod11], :Mod2])
    end

    it 'finds six classes in the first module' do
      expect(@ast.modules[:Mod1].size).to eq(6)
    end

    it 'finds correct class definitions in the first module' do
      classes = @ast.modules[:Mod1]
    end

    it 'finds three classes in the second module' do
      expect(@ast.modules[:Mod2].size).to eq(3)
    end
  end
end
