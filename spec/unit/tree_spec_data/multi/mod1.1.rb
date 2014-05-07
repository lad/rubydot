
module Mod1
  class Class3
  end
end

module Mod1
  class Class4 < Mod1::Class3
  end
end

module Mod1
  module Mod1::Mod11
    class Class5
    end

    class Class6 < Mod1::Mod11::Class5
    end
  end
end
