# Dijkstra's algorithm for searching shorest path
module Dijkstra
  def shorest_path_query(src_id, dst_id)
    dijkstra_init(src_id)
    until @vertices.empty?
      nearest_node = check_shortest
      break unless @distances[nearest_node]
      return get_path(src_id, dst_id) if dst_id && nearest_node == dst_id
      check_nearest(find_neighbors(nearest_node), nearest_node)
    end
    dst_id ? nil : @distances
  end

  def dijkstra_init(src_id)
    @distances  = {}
    @previouses = {}
    @nodes.each do |n|
      @distances[n]  = nil
      @previouses[n] = nil
    end
    @distances[src_id] = 0
    @vertices = nodes.clone
  end

  def check_shortest
    @vertices.inject do |f, n|
      next n unless @distances[f]
      next f unless @distances[n]
      next f if @distances[f] < @distances[n]
      n
    end
  end

  def check_nearest(neighbors, nn)
    neighbors.each do |n|
      alt = @distances[nn] + length_between(nn, n)
      if @distances[n].nil? || alt < @distances[n]
        @distances[n] = alt
        @previouses[n] = nn
      end
    end
    @vertices.delete(nn)
  end

  def get_path(src_id, dst_id)
    path = get_path_recursively(src_id, dst_id)
    path.is_a?(Array) ? path.reverse : path
  end

  def get_path_recursively(src, dest)
    return src if src == dest
    [dest, get_path_recursively(src, @previouses[dest])].flatten
  end

  def length_between(src, dst)
    find_edge(src, dst).dist
  end
end
