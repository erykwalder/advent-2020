def apply_mask(mask, val)
  (mask.tr("X", "1").to_i(2) & val) | mask.tr("X", "0").to_i(2)
end

def decode_address(mask, address)
  address_bits = address.to_s(2).rjust(mask.size, "0")
  combined = (0...(mask.size)).map do |i|
    mask[i] == "0" ? address_bits[i] : mask[i]
  end
  floating_bits = combined.each_index.select {|i| combined[i] == "X"}
  ["0", "1"].repeated_permutation(floating_bits.size).map do |combo|
    combo.each_index {|i| combined[floating_bits[i]] = combo[i]}
    combined.join.to_i(2)
  end
end

def day14a
  mem = {}
  mask = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  File.foreach('input14.txt') do |line|
    if match = /^mask = ([01X]+)\n$/.match(line)
      mask = match.captures.first
    elsif match = /^mem\[(\d+)\] = (\d+)\n$/.match(line)
      address, val = match.captures
      mem[address] = apply_mask(mask, val.to_i)
    end
  end
  mem.values.sum
end

def day14b
  mem = {}
  mask = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  File.foreach('input14.txt') do |line|
    if match = /^mask = ([01X]+)\n$/.match(line)
      mask = match.captures.first
    elsif match = /^mem\[(\d+)\] = (\d+)\n$/.match(line)
      address, val = match.captures
      addresses = decode_address(mask, address.to_i)
      addresses.each {|addr| mem[addr] = val.to_i}
    end
  end
  mem.values.sum
end

p day14b