def read_starting_nums
  File.read('input15.txt').split(",").map(&:to_i)
end

def play_memory_game_until(last_turn, starting_nums)
  last_spoken = {}
  (0...last_turn).reduce(-1) do |spoken, turn|
    if turn < starting_nums.size
      next_spoken = starting_nums[turn]
    elsif last_spoken.has_key?(spoken)
      next_spoken = turn - last_spoken[spoken]
    else
      next_spoken = 0
    end
    last_spoken[spoken] = turn
    next_spoken
  end
end

starting_nums = read_starting_nums

p play_memory_game_until(2020, starting_nums)
p play_memory_game_until(30000000, starting_nums)