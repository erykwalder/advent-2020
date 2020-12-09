require 'set'

def read_customs_groups
  File.read('input6.txt').split("\n\n").each.map do |cg|
    cg.split("\n").map {|person| person.chars.to_set}
  end
end

def day6a
  read_customs_groups.map {|cg| cg.reduce(&:|).size}.sum
end

def day6b
  read_customs_groups.map {|cg| cg.reduce(&:&).size}.sum
end

p day6b