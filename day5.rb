def partition_to_seat_id(partition)
  partition.tr("FBLR", "0101").to_i(2)
end

def read_seats
  File.foreach('input5.txt')
    .map {|part| partition_to_seat_id(part.strip)}
end

def day5a
  read_seats.max
end

def day5b
  seats = read_seats.sort
  seats.each_with_index.find {|seat_id, idx| seats[idx+1] == seat_id + 2}[0]+1
end

p day5b