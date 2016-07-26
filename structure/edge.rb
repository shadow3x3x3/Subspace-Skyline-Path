# Record Edge
class Edge
  attr_accessor :id, :src, :dst, :attrs

  def initialize(attrs)
    @id    = attrs.shift.to_i
    @src   = attrs.shift.to_i
    @dst   = attrs.shift.to_i
    @attrs = attrs
  end

  def set_subspace(postions)
    unless postions.class == Array
      raise ArgumentError, "postions should be an Array"
    end

    if postions.max > @attrs.size - 1
      raise ArgumentError, "postions out of range (#{@attrs.size - 1})"
    end

    subspace_attrs = []
    postions.each do |p|
      subspace_attrs << @attrs[p]
    end
    @attrs = subspace_attrs
  end

  def dist
    @attrs.first
  end
end
