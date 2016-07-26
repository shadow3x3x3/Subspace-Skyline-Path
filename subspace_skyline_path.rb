require_relative 'lib/skyline_path'


class SubspaceSkylinePath < SkylinePath

  def initialize(params = {})
    super
  end

  def set_subspace_attrs(postions)
    edges.each do |edge|
      edge.set_subspace(postions)
    end
  end

  def query_subspace_skyline_path(src_id: nil, dst_id: nil, limit: nil)

  end

end
