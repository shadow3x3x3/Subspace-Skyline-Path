# Record Edge
class Edge
  attr_reader :id, :src, :dst, :attrs, :norm_attrs, :max_attrs, :min_attrs

  def initialize(attrs)
    @id                 = attrs.shift.to_i
    @src                = attrs.shift.to_i
    @dst                = attrs.shift.to_i
    @attrs              = attrs
    @norm_attrs         = @attrs.clone
    @max_attrs          = []
    @min_attrs          = []
    @max_attrs_postions = []
    @min_attrs_postions = []
  end

  def set_subspace(postions)
    unless postions.class == Array
      raise ArgumentError, "postions should be an Array"
    end
    postion_check(postions)

    @attrs      = find_attrs_in(postions)
    @norm_attrs = @attrs.clone
  end

  def set_max_attrs(postions)
    postion_type_check(postions)
    postion_check(postions)

    @max_attrs_postions = postions.class == Array ? postions : [postions]
    set_normal_attrs
    @max_attrs = find_attrs_in(postions)
  end

  def set_min_attrs(postions)
    postion_type_check(postions)
    postion_check(postions)

    @min_attrs_postions = postions.class == Array ? postions : [postions]
    set_normal_attrs
    @min_attrs = find_attrs_in(postions)
  end

  def dist
    @attrs.first
  end

  private

  def postion_check(postions)
    if postions.class == Fixnum && postions > @attrs.size - 1
      raise ArgumentError, "postions out of range (#{@attrs.size - 1})"
    elsif postions.class == Array && postions.max > @attrs.size - 1
      raise ArgumentError, "postions out of range (#{@attrs.size - 1})"
    end
  end

  def postion_type_check(postions)
    unless postions.class == Array || postions.class == Fixnum
      raise ArgumentError, "postions should be an Array or Fixnum"
    end
  end

  def find_attrs_in(postions)
    if postions.class == Fixnum
      return [@attrs[postions]]
    else
      target_attrs = []
      postions.sort.each do |postion|
        target_attrs << @attrs[postion]
      end
    end
    target_attrs
  end

  def set_normal_attrs
    full_postions = []
    0.upto(@attrs.size - 1) { |postion| full_postions << postion }

    norm_postions = full_postions - (@max_attrs_postions | @min_attrs_postions)
    @norm_attrs = find_attrs_in(norm_postions)
  end
end
