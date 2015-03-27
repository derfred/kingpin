module Kingpin
  module DslHelper
    def eval_dsl_block(&block)
      if block.arity == 1
        block.call self
      else
        instance_eval &block
      end
    end
  end
end
