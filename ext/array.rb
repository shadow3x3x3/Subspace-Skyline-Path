# EXT Array
class Array
  # dominate function in skyline for array
  def dominate?(array)
    flag       = 0
    check_flag = size
    each_with_index do |attr, index|
      flag += 1       if attr >  array[index]
      flag -= 1       if attr <  array[index]
      check_flag -= 1 if attr == array[index]
    end
    return false if flag == check_flag     # be dominated
    return true  if flag == 0 - check_flag # dominate
    nil
  end

  # skyline attributes aggregate for array
  def aggregate(array)
    aggregate_array = []
    raise "Need Array not #{array.class}"    unless array.class == Array
    raise 'Two Arrays are not the same size' unless size == array.size
    each_with_index do |attr, index|
      aggregate_array << (attr + array[index]).round(6)
    end
    aggregate_array
  end
end
