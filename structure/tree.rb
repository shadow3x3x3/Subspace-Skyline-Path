require_relative 'graph'

# Tree
class Tree
  def initialize(params)
    @root = Node.new
    super(params)
  end

  def search_node(node)
    raise ArgumentError,
          'wrong type of arguments (need to a Node)' unless node.class == Node
  end

  def bulid
    raise NotImplementedError,
          'implemente this function in child class'
  end
end
