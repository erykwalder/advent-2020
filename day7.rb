require 'set'
require 'strscan'

class RuleScanner
  def initialize(rule_str)
    @s = StringScanner.new(rule_str)
  end

  def scan
    color = scan_bag_color
    contained = []
    @s.scan(" bags contain ")
    @s.scan("no other bags")
    while @s.scan(".").nil?
      contained << scan_contained_bag
      @s.scan(/ bags?(, )?/)
    end
    {color: color, contains: contained}
  end

  private
  def scan_bag_color
    @s.scan(/\w+ \w+/)
  end

  def scan_contained_bag
    num = @s.scan(/\d+/).to_i
    @s.scan(" ")
    color = scan_bag_color
    {color: color, quantity: num}
  end
end

def read_rules
  File.foreach("input7.txt")
    .reject(&:empty?)
    .map {|line| RuleScanner.new(line).scan}
end

def day7a
  contained_by = Hash.new {|h, k| h[k] = []}

  read_rules.each do |rule|
    rule[:contains].each do |bag|
      contained_by[bag[:color]] << rule[:color]
    end
  end

  containers = Set.new
  traverse_list = Set["shiny gold"]
  until traverse_list.empty?
    next_list = Set.new
    traverse_list.each do |bag|
      next_list += contained_by[bag]
    end
    traverse_list = next_list - containers
    containers += traverse_list
  end
  containers.size
end

def sum_contained_bags(color, lookup)
  lookup[color][:contains].map do |bag|
    (sum_contained_bags(bag[:color], lookup) + 1) * bag[:quantity]
  end.sum
end

def day7b
  rule_hash = {}
  read_rules.each {|rule| rule_hash[rule[:color]] = rule}
  sum_contained_bags("shiny gold", rule_hash)
end

p day7b