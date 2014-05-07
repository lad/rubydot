# Encoding: UTF-8

# Some utility functions for traversing a Sexp data structure
class Rubydot::Src::SexpUtil
  class << self
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
      # TODO: this can probably be expressed more elegantly
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
      _, name = node
      name = _extract_class_name(name) if name.is_a?(Sexp)
      name
    end

    def super_class(sexp)
      _, _, parent = sexp

      cls_list = _extract_class_name(parent)
      return nil if cls_list.nil?
      cls_list.join('::')
    end

    def _extract_class_name(sexp)
      _, mod, cls = sexp
      return nil if mod.nil? && cls.nil?
      mod = _extract_class_name(mod) if mod.is_a?(Sexp)
      cls = _extract_class_name(cls) if cls.is_a?(Sexp)
      return [mod] if cls.nil?
      [mod, cls].flatten
    end
  end
end
