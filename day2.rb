def valid_password_a?(policy, password)
  min, max, char = /(\d+)\-(\d+) ([a-z])/.match(policy).captures
  password.count(char).between?(min.to_i, max.to_i)
end

def valid_password_b?(policy, password)
  a, b, char = /(\d+)\-(\d+) ([a-z])/.match(policy).captures
  (password[a.to_i - 1] === char) ^ (password[b.to_i - 1] === char)
end

def day2
  File.open("input2.txt").each
    .map {|line| line.strip}
    .reject {|line| line.empty?}
    .count do |line|
      policy, password = line.split(": ")
      valid_password_b?(policy, password)
    end
end

p day2
