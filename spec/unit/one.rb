# one.rb

module OneModuleName
  CONST_1 = { k1: 'const-value-1',
              k2: 'const-value-2' }
  CONST_2 = 'xxxxx'

  class OneClassName
    def initialize(arg1, arg2)
      @a1 = arg1
      @a2 = arg2
    end

    def self.class_fn(arg1)
      # comment...
    end
  end
end
