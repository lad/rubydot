# one.rb

module ModuleName
  CONST_1 = { k1: 'const-value-1',
              k2: 'const-value-2' }
  CONST_2 = 'application/x-www-form-urlencoded'

  class ClassName
    @@class_var = 'xx'

    def initialize(arg1, arg2)
      @a1 = arg1
      @a2 = arg2
      @a3 = nil
    end

    def self.class_fn(arg1)
      # comment...
    end
  end
end
