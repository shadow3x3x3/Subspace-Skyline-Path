require 'benchmark'
include Benchmark

require_relative '../ext/array'
require_relative '../structure/graph'

require_relative 'dijkstra'

# for query skyline path
class SkylinePath < Graph
  include Dijkstra

  def initialize(params = {})
    super
    @skyline_path      = {}
    @part_skyline_path = {}
  end

  def query_skyline_path(src_id: nil, dst_id: nil, limit: nil)
    @distance_limit = limit
    query_check(src_id, dst_id)

    Benchmark.benchmark(CAPTION, 22, FORMAT, 'total:') do |step|
      t1 = step.report('Shorest path') do
        shorest_path = shorest_path_query(src_id, dst_id)
        @skyline_path[path_to_sym(shorest_path)] = attrs_in(shorest_path)
        @shorest_distance = attrs_in(shorest_path).first
      end
      t2 = step.report('SkyPath') do
        sky_path(src_id, dst_id)
      end
      [t1 + t2]
    end
    puts "Found #{@skyline_path.size} Skyline paths"
    @skyline_path
  end

  def attrs_in(path)
    if path.size > 2
      edges_of_path = partition(path)
      attr_full = edges_of_path.inject(Array.new(@dim, 0)) do |attrs, edges|
        attrs.aggregate(attr_between(edges[0], edges[1]))
      end
    else
      attr_full = attr_between(path.first, path.last)
    end
    attr_full
  end

  private

  def sky_path(cur, dst, pass = [])
    pass << cur
    if cur == dst
      pass = arrived(cur, pass, attrs_in(pass)) unless full_dominance?(attrs_in(pass))
      return
    end
    find_neighbors(cur).each do |n|
      sky_path(n, dst, pass) if next_hop?(n, pass)
    end
    pass.delete(cur)
  end

  def arrived(cur, pass, attrs)
    new_skyline_check(pass, attrs)
    pass.delete(cur)
  end

  def new_skyline_check(pass, attrs)
    non_skyline = []
    new_skyline_flag = true

    @skyline_path.each do |key, s_attrs|
      flag = s_attrs.dominate?(attrs)
      new_skyline_flag = false if flag
      non_skyline << key if flag == false
    end

    non_skyline.each { |key| @skyline_path.delete(key) }

    @skyline_path[path_to_sym(pass)] = attrs if new_skyline_flag
  end

  def next_hop?(n, pass)
    next_path_attrs = attrs_in(pass + [n])
    unless @distance_limit.nil?
      return false if out_of_limit?(next_path_attrs.first)
    end
    return false if pass.include?(n)
    partial_result = partial_dominance?(pass + [n], next_path_attrs)
    return false if partial_result
    add_part_skyline(pass + [n], next_path_attrs) unless partial_result.nil?
    return false if full_dominance?(next_path_attrs)
    true
  end

  def out_of_limit?(distance)
    distance > @shorest_distance * @distance_limit ? true : false
  end

  def partial_dominance?(path, path_attrs)
    sym = "p#{path.first}_#{path.last}".to_sym
    result = false
    unless @part_skyline_path[sym].nil?
      result = @part_skyline_path[sym].dominate?(path_attrs)
    end
    result
  end

  def full_dominance?(path_attrs)
    @skyline_path.each do |_path, attrs|
      return true if attrs.dominate?(path_attrs)
    end
    false # not be dominance
  end

  def add_part_skyline(path, path_attrs)
    sym = "p#{path.first}_#{path.last}".to_sym
    @part_skyline_path[sym] = path_attrs
  end

  def attr_between(src, dst)
    find_edge(src, dst).attrs
  end

  def query_check(src_id, dst_id)
    if src_id.nil? || dst_id.nil?
      raise ArgumentError, 'have to set src and dst both'
    end
    raise ArgumentError, 'src and dst have to different' if src_id == dst_id
    unless @nodes.include?(src_id)
      raise ArgumentError, 'src id needs to exist Node'
    end
    unless @nodes.include?(dst_id)
      raise ArgumentError, 'dst id needs to exist Node'
    end
  end

  def path_to_sym(path)
    raise ArgumentError, 'path must be Array' unless path.class == Array
    "p#{path.join('_')}".to_sym
  end


end

experiment = 'go'

case experiment
when 'salu'
  EDGE_PATH = './salu-data/salu_edge_160203_450.txt'.freeze
  NODE_PATH = './salu-data/salu_node_160203.txt'.freeze
  DIM       = 7
when 'test'
  EDGE_PATH = './test-data/test-edge.txt'.freeze
  NODE_PATH = './test-data/test-node.txt'.freeze
  DIM       = 4
when 'go'
  EDGE_PATH = './go-data/4_goEdge.txt'.freeze
  NODE_PATH = './go-data/node.txt'.freeze
  DIM       = 4
end

test_edges = File.read(EDGE_PATH)
test_nodes = File.read(NODE_PATH)

sp = SkylinePath.new(dim: DIM, raw_edges: test_edges, raw_nodes: test_nodes)
p sp.query_skyline_path(src_id: 0, dst_id: 987)
# p sp.attrs_in([2590,971,973,1075,1077,1081,1082,1032,1357,1338,1337,1349,1071,934,933,964,963,938,937,978,977])
# p sp.attrs_in([2590, 971, 973, 2588, 3130, 1582, 3114, 1066, 2394, 2238, 2388, 2385, 970, 1033, 1520, 2430, 1421, 1262, 814, 813, 982, 1424, 977])
# p sp.attrs_in([2359, 2357, 1165])
# p sp.attrs_in([0, 1, 2, 4, 5])
