def read_instructions
  File.foreach('input12.txt').filter_map do |line|
    unless line.empty?
      action, value = /([NSEWLRF])(\d+)/.match(line).captures
      {action: action, value: value.to_i}
    end
  end
end

def move(coords, dir, amount)
  case dir
    when "N"
      coords[:north] += amount
    when "S"
      coords[:north] -= amount
    when "E"
      coords[:east] += amount
    when "W"
      coords[:east] -= amount
  end
end

DIRECTIONS = {
  0 => "E",
  90 => "N",
  180 => "W",
  270 => "S"
}

def day12a
  coords = {north: 0, east: 0}
  direction = 0
  read_instructions.each do |inst|
    case inst[:action]
    when "N", "S", "E", "W"
      move(coords, inst[:action], inst[:value])
    when "L"
      direction = (direction + inst[:value]) % 360
    when "R"
      direction = (direction - inst[:value]) % 360
    when "F"
      move(coords, DIRECTIONS[direction], inst[:value])
    end
  end
  [coords[:north].abs, coords[:east].abs].sum
end

def day12b
  waypoint = {north: 1, east: 10}
  coords = {north: 0, east: 0}
  read_instructions.each do |inst|
    case inst[:action]
    when "N", "S", "E", "W"
      move(waypoint, inst[:action], inst[:value])
    when "L", "R"
      inst[:value] = 360 - inst[:value] if inst[:action] == "R"
      (inst[:value]/90).times do 
        waypoint = {north: waypoint[:east], east: -waypoint[:north]}
      end
    when "F"
      coords[:north] += waypoint[:north] * inst[:value]
      coords[:east] += waypoint[:east] * inst[:value]
    end
  end
  [coords[:north].abs, coords[:east].abs].sum
end

p day12b