require 'set'

def read_numbers
  File.foreach("input9.txt").reject(&:empty?).map(&:to_i)
end

def find_invalid_num(nums)
  num_pool = Set.new(nums[0..24])
  (25...nums.size).each do |idx|
    current = nums[idx]
    if num_pool.any? {|half_sum| num_pool.include?(current - half_sum)}
      num_pool.add(current)
      num_pool.delete(nums[idx - 25])
    else
      return current
    end
  end
end

def day9a
  find_invalid_num(read_numbers)
end

def find_continguous_addends(target_sum, nums)
  bottom_idx, sum = 0, 0
  (0...nums.size).each do |top_idx|
    sum += nums[top_idx]
    while sum > target_sum
      sum -= nums[bottom_idx]
      bottom_idx += 1
    end
    if sum === target_sum
      return bottom_idx, top_idx
    end
  end
end

def day9b
  nums = read_numbers
  bottom, top = find_continguous_addends(find_invalid_num(nums), nums)
  nums[bottom..top].minmax.sum
end

p day9b