def read_candidates
  File.open("input1.txt").each
    .map {|line| line.strip}
    .reject {|line| line.empty?}
    .map(&:to_i)
end

def day1a
  candidate_map = Hash[read_candidates.map {|k| [k, true]}]
  match = candidate_map.keys.find {|c| candidate_map.has_key?(2020 - c)}
  match * (2020 - match)
end

def day1b
  read_candidates.combination(3).find {|set| set.sum === 2020}.reduce(1, :*)
end

p day1b