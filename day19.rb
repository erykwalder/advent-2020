def day19
  rules, messages = read_input
  messages.count {|msg| test(rules, "0", msg)}
end

def test(rules, num, msg)
  test_at_char(rules, num, msg, 0).any? {|matched| matched == msg.size}
end

def test_at_char(rules, num, msg, char)
  rules[num][:patterns].flat_map do |pattern|
    possibilities = [char]
    pattern.each do |part|
      possibilities = possibilities.filter_map do |pos|
        if part[:type] == :literal && msg[pos] == part[:value]
          pos + 1
        elsif part[:type] == :ref
          test_at_char(rules, part[:value], msg, pos)
        end
      end.flatten
    end
    possibilities
  end
end

def read_input
  rule_lines, message_lines = File.read("input19.txt").split("\n\n")
  rules = Hash.new {|h, k| h[k] = {}}
  rule_lines.split("\n").each do |rl|
    num, patterns = rl.split(": ")
    rules[num][:patterns] = patterns.split(" | ").map do |pattern|
      pattern.split(" ").map do |part|
        if part[0] == "\""
          {type: :literal, value: part[1]}
        else
          {type: :ref, value: part}
        end
      end
    end
  end
  [rules, message_lines.split("\n").reject(&:empty?)]
end

p day19