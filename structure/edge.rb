# Record Edge
class Edge
  attr_accessor :id, :src, :dst, :attrs

  def initialize(attrs)
    @id    = attrs.shift.to_i
    @src   = attrs.shift.to_i
    @dst   = attrs.shift.to_i
    @attrs = attrs
  end

  def dist
    @attrs.first
  end

  def min_value
    @attrs.last
  end
end
