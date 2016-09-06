# For Skyline Query
module SkylineQuery

  def brute_force(skyline_hash)
    data_check(skyline_hash)

    result = {}

    skyline_hash.each do |k, v|
      skyline_hash.each do |k1, v2|
        next if k == k1
        next if v2.dominate?(v)
        result[k] = v
      end
    end
    result
  end


  def data_check(skyline_hash)
    unless skyline_hash.class == Hash
      raise ArgumentError, "need to Hash (ID: attributes)"
    end
  end

end
