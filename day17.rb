require 'set'

DIRECTIONS_3D = [1, 0, -1]
  .repeated_permutation(3)
  .reject {|dir| dir.all? {|dimension| dimension == 0}}

DIRECTIONS_4D = [1, 0, -1]
  .repeated_permutation(4)
  .reject {|dir| dir.all? {|dimension| dimension == 0}}

def day17a
  grid = Hash.new(false)
  fill_3d_grid(grid)
  6.times { cycle_state(grid) }
  grid.values.count {|cube| cube}
end

def day17b
  grid = Hash.new(false)
  fill_4d_grid(grid)
  6.times { cycle_state(grid) }
  grid.values.count {|cube| cube}
end

def cycle_state(grid)
  active_neighbor_counts = Hash.new(0)
  grid.select {|coords, active| active}.each do |coords, active|
    neighbors(coords).each {|n| active_neighbor_counts[n] += 1}
  end
  candidate_cubes = Set.new(active_neighbor_counts.keys).merge(grid.keys)
  candidate_cubes.each do |coords|
    if grid[coords] && (2..3).cover?(active_neighbor_counts[coords])
      grid[coords] = true
    elsif !grid[coords] && active_neighbor_counts[coords] === 3
      grid[coords] = true
    else
      grid[coords] = false
    end
  end
end

def neighbors(coords)
  if coords.has_key?(:w)
    DIRECTIONS_4D.map do |dir|
      {
        x: coords[:x] + dir[0],
        y: coords[:y] + dir[1],
        z: coords[:z] + dir[2],
        w: coords[:w] + dir[3]
      }.freeze
    end
  else
    DIRECTIONS_3D.map do |dir|
      {
        x: coords[:x] + dir[0],
        y: coords[:y] + dir[1],
        z: coords[:z] + dir[2]
      }.freeze
    end
  end
end

def fill_3d_grid(grid)
  File.foreach('input17.txt').each_with_index do |line, y|
    line.strip.each_char.each_with_index do |char, x|
      grid[{x: x, y: y, z: 0}.freeze] = (char == "#")
    end
  end
end

def fill_4d_grid(grid)
  File.foreach('input17.txt').each_with_index do |line, y|
    line.strip.each_char.each_with_index do |char, x|
      grid[{x: x, y: y, z: 0, w: 0}.freeze] = (char == "#")
    end
  end
end

p day17b