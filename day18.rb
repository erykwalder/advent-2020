require 'strscan'

def day18(evaluator)
  read_expressions.map {|expr| evaluator.eval(scan(expr))}.sum
end

def scan(expr)
  tokens = []
  s = StringScanner.new(expr)
  until s.eos?
    case
    when s.scan(/\s+/)
      # do nothing
    when s.scan("(")
      tokens << {type: :left_paren}
    when s.scan(")")
      tokens << {type: :right_paren}
    when s.scan("+")
      tokens << {type: :plus}
    when s.scan("*")
      tokens << {type: :star}
    when num = s.scan(/\d+/)
      tokens << {type: :number, value: num.to_i}
    end
  end
  tokens
end

class Evaluator
  def eval(tokens)
    val = value(tokens)
    while !tokens.empty?
      if tokens.shift[:type] == :plus
        val += value(tokens)
      else
        val *= value(tokens)
      end
    end
    val
  end

  protected
  def value(tokens)
    tok = tokens.shift
    case tok[:type]
    when :left_paren
      depth = 1
      sub_expr = []
      while depth > 0
        tok = tokens.shift
        if tok[:type] == :left_paren
          depth += 1
        elsif tok[:type] == :right_paren
          depth -= 1
        end
        sub_expr << tok
      end
      sub_expr.pop
      eval(sub_expr)
    when :number
      tok[:value]
    end
  end
end

class PrecedenceEvaluator < Evaluator
  def eval(tokens)
    multiply(tokens)
  end

  protected
  def multiply(tokens)
    val = add(tokens)
    while !tokens.empty? and tokens[0][:type] == :star
      tokens.shift
      val *= add(tokens)
    end
    val
  end

  def add(tokens)
    val = value(tokens)
    while !tokens.empty? and tokens[0][:type] == :plus
      tokens.shift
      val += value(tokens)
    end
    val
  end
end

def read_expressions
  File.foreach('input18.txt').reject(&:empty?).map(&:strip)
end

p day18(PrecedenceEvaluator.new)