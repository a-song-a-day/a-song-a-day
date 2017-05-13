class ParamsConstraint
  attr_accessor :block
  def initialize(block)
    self.block = block
  end
  def matches?(request)
    return block.call((request.query_parameters || {}).merge(request.request_parameters || {}))
  end
end
