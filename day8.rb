require 'set'

class VM
  def initialize(instructions)
    @instructions = instructions
    @ptr = 0
    @accumulator = 0
    @visited = Set.new
    @looped = false
  end

  def looped
    @looped
  end

  def execute
    until @looped or @ptr >= @instructions.size
      step
    end
    @accumulator
  end

  def step
    if @visited.include?(@ptr)
      @looped = true
      return
    end
    @visited.add(@ptr)

    inst = @instructions[@ptr]
    case inst[:op]
    when "acc"
      @accumulator += inst[:arg]
      @ptr += 1
    when "jmp"
      @ptr += inst[:arg]
    when "nop"
      @ptr += 1
    end
  end
end

def read_instructions
  File.foreach("input8.txt")
    .reject(&:empty?)
    .map do |line|
      op, arg = /^(acc|jmp|nop) ([+-]\d+)$/.match(line).captures
      {op: op, arg: arg.to_i}
    end
end

def day8
  VM.new(read_instructions).execute
end

def swap_inst(inst)
  if inst[:op] === "nop"
    inst[:op] = "jmp"
  else
    inst[:op] = "nop"
  end
end

def instructions_loop?(instructions)
  vm = VM.new(instructions)
  vm.execute
  vm.looped
end

def find_faulty_inst
  instructions = read_instructions
  instructions.each_with_index do |inst, idx|
    if inst[:op] === "nop" || inst[:op] === "jmp"
      swap_inst(inst)
      if !instructions_loop?(instructions)
        return idx
      end
      swap_inst(inst)
    end
  end
end

p day8