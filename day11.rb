DIRECTIONS = [
  [-1, -1],
  [-1, 0],
  [-1, 1],
  [0, -1],
  [0, 1],
  [1, -1],
  [1, 0],
  [1, 1]
]
EMPTY = "L"
OCCUPIED = "#"
FLOOR = "."

def read_seat_map
  File.foreach('input11.txt').reject(&:empty?).map(&:strip).map(&:chars)
end

def in_map_bounds?(seat_map, r, c)
  r >= 0 && r < seat_map.size && c >= 0 && c < seat_map[0].size
end

def adjacent_seats(seat_map, r, c)
  DIRECTIONS.filter_map do |rv, cv|
    row, col = rv + r, cv + c
    seat_map[row][col] if in_map_bounds?(seat_map, row, col)
  end
end

def visible_seats(seat_map, r, c)
  DIRECTIONS.filter_map do |rv, cv|
    row, col = rv + r, cv + c
    while in_map_bounds?(seat_map, row, col) && seat_map[row][col] === FLOOR
      row, col = row + rv, col + cv
    end
    seat_map[row][col] if in_map_bounds?(seat_map, row, col)
  end
end

def seat_passengers(seat_map)
  changed = false
  seat_map = seat_map.each_index.map do |r|
    seat_map[r].each_index.map do |c|
      seat = yield(seat_map, r, c)
      changed ||= (seat != seat_map[r][c])
      seat
    end
  end
  [seat_map, changed]
end

def seat_passengers_until_stable(seat_map, &seat_rules)
  loop do
    seat_map, changed = seat_passengers(seat_map, &seat_rules)
    return seat_map if !changed
  end
end

def day11a
  seat_passengers_until_stable(read_seat_map) do |seat_map, r, c|
    seat = seat_map[r][c]
    if seat === EMPTY && adjacent_seats(seat_map, r, c).none?(OCCUPIED)
      OCCUPIED
    elsif seat === OCCUPIED && adjacent_seats(seat_map, r, c).count(OCCUPIED) >= 4
      EMPTY
    else
      seat
    end
  end.map {|row| row.count(OCCUPIED)}.sum
end

def day11b
  seat_passengers_until_stable(read_seat_map) do |seat_map, r, c|
    seat = seat_map[r][c]
    if seat === EMPTY && visible_seats(seat_map, r, c).none?(OCCUPIED)
      OCCUPIED
    elsif seat === OCCUPIED && visible_seats(seat_map, r, c).count(OCCUPIED) >= 5
      EMPTY
    else
      seat
    end
  end.map {|row| row.count(OCCUPIED)}.sum
end

p day11b