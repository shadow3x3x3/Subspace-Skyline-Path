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
    postion_check(postions)

    subspace_attrs = []
    postions.sort.each do |p|
      subspace_attrs << @attrs[p]
    end
    @attrs = subspace_attrs
  end

  def set_max_attrs(postions)
    postion_check(postions)
  end

  def set_min_attrs(postions)
    postion_check(postions)
  end

  def dist
    @attrs.first
  end

  private

  def postion_check(postions)
    unless postions.class == Array
      raise ArgumentError, "postions should be an Array"
    end

    if postions.max > @attrs.size - 1
      raise ArgumentError, "postions out of range (#{@attrs.size - 1})"
    end
  end
end
