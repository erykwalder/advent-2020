def read_volts
  File.foreach('input10.txt').reject(&:empty?).map(&:to_i)
end

def day10a
  last_volt = 0
  diffs = read_volts.sort.map do |volt|
    diff = volt - last_volt
    last_volt = volt
    diff
  end.reduce(Hash.new(0)) {|h, v| h[v] += 1; h}
  diffs[3] += 1
  diffs[1] * diffs[3]
end

def day10b
  volts = read_volts.push(0).sort
  volts << volts[-1] + 3
  memos = {}
  count_paths = lambda do |i|
    memos[i] ||= [
      (i+1..i+3)
        .reject {|j| j >= volts.size || volts[j] > volts[i] + 3}
        .map {|j| count_paths.call(j)}
        .sum,
      1
    ].max
  end
  count_paths.call(0)
end

p day10b