# Encoding: UTF-8

require 'rubydot'
require 'spec_helper'

TEST_DIR = spec_test_dir(__FILE__)
MULTI_TEST_DIR = File.join(TEST_DIR, 'multi')

describe 'The Rubydot module' do
  describe 'with a single input file: one.rb' do
    before :each do
      @tree = Rubydot::Src::Tree.new(File.join(TEST_DIR, 'one.rb'))
    end

    it 'finds one module' do
      expect(@tree.modules.keys).to eq([:OneModuleName])
    end
  end

  describe 'with several source files' do
    before :each do
      @tree = Rubydot::Src::Tree.new(MULTI_TEST_DIR)
    end

    it 'finds the two modules' do
      expect(@tree.modules.keys).to eq([:Mod1, [:Mod1, :Mod11], :Mod2])
    end

    it 'finds six classes in the first module' do
      expect(@tree.modules[:Mod1].size).to eq(6)
    end

    it 'finds correct class definitions in the first module' do
      classes = @tree.modules[:Mod1]
    end

    it 'finds three classes in the second module' do
      expect(@tree.modules[:Mod2].size).to eq(3)
    end
  end
end
