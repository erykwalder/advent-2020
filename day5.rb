def seat_id(row, col)
  row * 8 + col
end

def partition_to_num(partition)
  partition.tr("FBLR", "0101").to_i(2)
end

def read_seats
  File.open('input5.txt').each
    .map {|line| line.strip}
    .map do |part|
      seat_id(partition_to_num(part[0..6]), partition_to_num(part[7..9]))
    end
end

def day5a
  read_seats.max
end

def day5b
  seats = read_seats.sort
  seats.each_with_index.find {|seat_id, idx| seats[idx+1] == seat_id + 2}[0]+1
end

p day5b