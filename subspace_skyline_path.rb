require 'pry'

require_relative 'lib/skyline_path'


class SubspaceSkylinePath < SkylinePath

  def initialize(params = {})
    super
  end

  def set_subspace_attrs(postions)
    set_attrs(postions, 'subspace')
    @dim = postions.size
  end

  def set_max_attrs(postions)
    set_attrs(postions, 'max')
    @max_size = postions.size
  end

  def set_min_attrs(postions)
    set_attrs(postions, 'min')
    @min_size = postions.size
  end

  def query_subspace_skyline_path(params)
    query_skyline_path(params)
  end

  def attrs_in(path)
    if path.size > 2
      edges_of_path = partition(path)
      attr_full = edges_of_path.inject(Array.new(@dim, 0)) do |attrs, edges|
        target_edge = find_edge(edges[0], edges[1])
        combine_aggregate(attrs, target_edge)
      end
    else
      attr_full = attr_between(path.first, path.last)
    end
    attr_full
  end

  def attr_between(src, dst)
    target_edge = find_edge(src, dst)
    target_edge.attrs + target_edge.min_attrs + target_edge.max_attrs
  end

  def sky_path(cur, dst, pass = [], cur_attrs = Array.new(@dim, 0))
    pass << cur
    if cur == dst
      pass = arrived(cur, pass, cur_attrs) unless full_dominance?(cur_attrs)
      return
    end
    find_neighbors(cur).each do |n|
      next_path_attrs = combine_aggregate(cur_attrs.clone, find_edge(cur, n))
      sky_path(n, dst, pass, next_path_attrs) if next_hop?(n, pass, next_path_attrs)
    end
    pass.delete(cur)
  end

  def combine_aggregate(attrs, target_edge)
    min_attrs = attrs.pop(target_edge.min_attrs.size)
                     .aggregate_min(target_edge.min_attrs)
    max_attrs = attrs.pop(target_edge.max_attrs.size)
                     .aggregate_max(target_edge.max_attrs)
    attrs.aggregate(target_edge.norm_attrs) + max_attrs + min_attrs
  end

  def set_attrs(postions, type = nil)
    raise ArgumentError, 'set the type please' if type.nil?
    case type
    when 'subspace'
      edges.each { |edge| edge.set_subspace(postions) }
    when 'max'
      edges.each { |edge| edge.set_max_attrs(postions) }
    when 'min'
      edges.each { |edge| edge.set_min_attrs(postions) }
    end
  end

end
