def read_instructions
  File.open('input12.txt').each.filter_map do |line|
    unless line.empty?
      action, value = /([NSEWLRF])(\d+)/.match(line).captures
      {action: action, value: value.to_i}
    end
  end
end

def day12a
  coords = {north: 0, east: 0}
  direction = 0
  read_instructions.each do |inst|
    case inst[:action]
    when "N"
      coords[:north] += inst[:value]
    when "S"
      coords[:north] -= inst[:value]
    when "E"
      coords[:east] += inst[:value]
    when "W"
      coords[:east] -= inst[:value]
    when "L"
      direction = (direction + inst[:value]) % 360
    when "R"
      direction = (direction - inst[:value]) % 360
    when "F"
      case direction
      when 0
        coords[:east] += inst[:value]
      when 90
        coords[:north] += inst[:value]
      when 180
        coords[:east] -= inst[:value]
      when 270
        coords[:north] -= inst[:value]
      end
    end
  end
  [coords[:north].abs, coords[:east].abs].sum
end

def day12b
  waypoint = {north: 1, east: 10}
  coords = {north: 0, east: 0}
  read_instructions.each do |inst|
    case inst[:action]
    when "N"
      waypoint[:north] += inst[:value]
    when "S"
      waypoint[:north] -= inst[:value]
    when "E"
      waypoint[:east] += inst[:value]
    when "W"
      waypoint[:east] -= inst[:value]
    when "L", "R"
      inst[:value] = 360 - inst[:value] if inst[:action] == "R"
      case inst[:value]
      when 90
        waypoint = {north: waypoint[:east], east: -waypoint[:north]}
      when 180
        waypoint = {north: -waypoint[:north], east: -waypoint[:east]}
      when 270
        waypoint = {north: -waypoint[:east], east: waypoint[:north]}
      end
    when "F"
      coords[:north] += waypoint[:north] * inst[:value]
      coords[:east] += waypoint[:east] * inst[:value]
    end
  end
  [coords[:north].abs, coords[:east].abs].sum
end

p day12b