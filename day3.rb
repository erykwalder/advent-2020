def read_map
  read_map = File.foreach("input3.txt")
    .map(&:strip)
    .reject(&:empty?)
end

def trees_hit(map, right, down)
  modulus = map[0].size
  map.each_with_index.count do |row, depth|
    depth % down === 0 && row[(depth * right / down) % modulus] === "#"
  end
end

def day3a
  trees_hit(read_map, 3, 1)
end

def day3b
  map = read_map
  slopes = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
  slopes.map do |slope|
    right, down = slope
    trees_hit(map, right, down)
  end.reduce(1, :*)
end

p day3b