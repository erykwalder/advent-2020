def read_input
  File.open('input13.txt') do |f|
    departure_ready = f.readline.to_i
    bus_lines = f.readline.strip.split(",")
    [departure_ready, bus_lines]
  end
end

def day13a
  departure_ready, bus_lines = read_input
  bus_lines = bus_lines.reject {|bl| bl == "x"}.map(&:to_i)
  wait_time, idx = bus_lines.map do |bl|
    next_arrival = (departure_ready / bl) * bl
    next_arrival += bl if next_arrival < departure_ready
    next_arrival - departure_ready
  end.each_with_index.min
  wait_time * bus_lines[idx]
end

def day13b
  _, bus_schedule = read_input
  bus_lines = bus_schedule.reject {|bl| bl == "x"}.map(&:to_i)
  offsets = bus_schedule.each_index.reject {|i| bus_schedule[i] == "x"}
  
  incr = bus_lines[0]
  num = 0
  (1...bus_lines.size).each do |i|
    until (num + offsets[i]) % bus_lines[i] == 0
      num += incr
    end
    incr *= bus_lines[i]
  end
  num % bus_lines.reduce(1, &:*)
end

p day13b