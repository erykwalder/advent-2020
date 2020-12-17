def day16a
  input = read_input
  error_rate = 0
  input[:nearby].each do |ticket|
    ticket.each do |val|
      if !valid_for_any_field?(input[:rules], val)
        error_rate += val
      end
    end
  end
  error_rate
end

def day16b
  input = read_input
  valid_tickets = input[:nearby].select {|t| valid_ticket?(input[:rules], t)}
  valid_tickets << input[:your_ticket]
 
  possible_fields = []
  input[:your_ticket].each_index do |i|
    possible_fields << input[:rules].find_all do |rule|
      valid_tickets.all? {|ticket| valid_for_rule?(rule, ticket[i])}
    end
  end

  mapping = {}
  while idx = possible_fields.find_index {|pf| pf.size == 1}
    rule = possible_fields[idx][0]
    mapping[rule[:field]] = idx
    possible_fields.map! {|rules| rules.reject {|r| r === rule}}
  end
  
  mapping.each.filter_map do |field, ticket_idx|
    if field.start_with?("departure")
      input[:your_ticket][ticket_idx]
    end
  end.reduce(1, :*)
end

def valid_ticket?(rules, ticket)
  ticket.all? {|val| valid_for_any_field?(rules, val)}
end

def valid_for_any_field?(rules, val)
  rules.any? {|rule| valid_for_rule?(rule, val)}
end

def valid_for_rule?(rule, val)
  rule[:ranges].any? {|range| range.cover?(val)}
end

def read_input
  input = {}
  File.open('input16.txt') do |f|
    input[:rules] = read_rules(f)
    input[:your_ticket] = read_your_ticket(f)
    input[:nearby] = read_nearby_tickets(f)
  end
  input
end

def read_rules(io)
  rules = []
  io.each do |line|
    line.strip!
    break if line.empty?
    match = /^([a-z ]+): (\d+)-(\d+) or (\d+)-(\d+)$/.match(line)
    field = match[1]
    lowrange = ((match[2].to_i)..(match[3]).to_i)
    highrange = ((match[4].to_i)..(match[5]).to_i)
    rules << {field: field, ranges: [lowrange, highrange]}
  end
  rules
end

def read_your_ticket(io)
  ticket = []
  io.each do |line|
    line.strip!
    next if /^your ticket:\n$/.match?(line)
    break if line.empty?
    ticket = line.split(",").map(&:to_i)
  end
  ticket
end

def read_nearby_tickets(io)
  nearby = []
  io.each do |line|
    line.strip!
    next if /^nearby tickets:\n$/.match?(line)
    break if line.empty?
    nearby << line.split(",").map(&:to_i)
  end
  nearby
end

p day16b