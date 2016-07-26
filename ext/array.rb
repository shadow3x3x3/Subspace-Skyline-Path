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
  def aggregate(array, type = 'normal')
    raise "Need Array not #{array.class}"    unless array.class == Array
    raise 'Two Arrays are not the same size' unless size == array.size

    case type
    when 'normal'
      return aggregate_normal(array)
    when 'max'
      return aggregate_max(array)
    when 'min'
      return aggregate_min(array)
    when 'avg'
      return aggregate_avg(array)
    when 'median'
      return aggregate_median(array)
    end
  end

  def aggregate_normal(array)
    aggregate_array = []
    each_with_index do |attr, index|
      aggregate_array << (attr + array[index]).round(6)
    end
    aggregate_array
  end

  def aggregate_max(array)
    aggregate_array = []
    each_with_index do |attr, index|
      aggregate_array << (attr > array[index] ? attr : array[index])
    end
    aggregate_array
  end

  def aggregate_min(array)
    aggregate_array = []
    each_with_index do |attr, index|
      aggregate_array << (attr < array[index] ? attr : array[index])
    end
    aggregate_array
  end

  def aggregate_avg(array)
  end

  def aggregate_median(array)
  end

end
