# Record Edge
class Edge
  attr_reader :id, :src, :dst, :attrs, :max_attrs, :min_attrs

  def initialize(attrs)
    @id    = attrs.shift.to_i
    @src   = attrs.shift.to_i
    @dst   = attrs.shift.to_i
    @attrs = attrs
  end

  def set_subspace(postions)
    postion_check(postions)

    @attrs = find_attrs_in(postions)
  end

  def set_max_attrs(postions)
    postion_check(postions)

    @max_attrs = find_attrs_in(postions)
  end

  def set_min_attrs(postions)
    postion_check(postions)

    @min_attrs = find_attrs_in(postions)
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

  def find_attrs_in(postions)
    target_attrs = []
    postions.sort.each do |p|
      target_attrs << @attrs[p]
    end
    target_attrs
  end
end
