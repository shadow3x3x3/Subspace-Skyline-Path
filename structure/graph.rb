require_relative 'util/read_util'
require_relative 'edge'

# Normal Graph class
class Graph
  include ReadUtil

  attr_accessor :edges, :nodes

  def initialize(params = {})
    raw_nodes = params[:raw_nodes]
    raw_edges = params[:raw_edges]
    @nodes = []
    @edges = []
    initialize_nodes(raw_nodes) unless raw_nodes.nil?
    initialize_edges(raw_edges) unless raw_edges.nil?
    @dim = @edges.first.attrs.size unless @edges.empty?

    @neighbors_hash = set_neighbors
    @edges_hash     = set_edges_hash
  end

  def add_node(node)
    @nodes << node unless @nodes.include?(node)
  end

  def add_edge(edge)
    new_edge = edge.class == Edge ? edge : Edge.new(edge)
    @edges << new_edge unless duplicate_edge?(new_edge)
  end

  def find_neighbors_at(node)
    @neighbors_hash[node]
  end

  def set_neighbors
    n_hash = {}
    nodes.each do |node|
      n_hash[node] = find_neighbors(node)
    end
    n_hash
  end

  def set_edges_hash
    e_hash = {}
    @edges.each do |edge|
      e_hash[[edge.src, edge.dst]] = edge
      e_hash[[edge.dst, edge.src]] = edge
    end
    e_hash
  end

  def find_neighbors(node)
    neighbors = []
    @edges.each do |edge|
      neighbors << check_neighbor(node, edge)
    end
    neighbors.compact!
  end

  def check_neighbor(node, edge)
    case node
    when edge.src
      return edge.dst
    when edge.dst
      return edge.src
    end
  end

  def duplicate_edge?(new_edge)
    @edges.each do |edge|
      return true if same_edge?(edge, new_edge)
    end
    false
  end

  def find_edge(src, dst)
    @edges.each do |edge|
      return edge if edge.src == src && edge.dst == dst
      return edge if edge.src == dst && edge.dst == src
    end
    raise ArgumentError, "not connect between #{src} and #{dst}"
  end

  def partition(path)
    result = []
    0.upto(path.size - 2) do |i|
      result << [path[i], path[i + 1]]
    end
    result
  end

  def same_edge?(edge1, edge2)
    edge1_src_id = edge1.src
    edge1_dst_id = edge1.dst
    edge2_src_id = edge2.src
    edge2_dst_id = edge2.dst
    return true if edge1_src_id == edge2_src_id && edge1_dst_id == edge2_dst_id
    return true if edge1_dst_id == edge2_src_id && edge1_src_id == edge2_dst_id
    false
  end
end
