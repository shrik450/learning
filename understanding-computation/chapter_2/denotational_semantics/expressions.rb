class Value < Struct.new(:value)
  def to_s
    value.to_s
  end

  def inspect
    "<<#{self}>>"
  end

  def to_ruby
    "-> e { #{value.inspect} }" 
  end
end

class Number < Value
end

class Boolean < Value
end

class BinaryOperator < Struct.new(:left, :right)
  def to_s
    "#{left} #{operator} #{right}"
  end

  def inspect
    "<<#{self}>>"
  end

  def to_ruby
    "-> e { #{left.to_ruby}.call(e).send(:#{operator}, #{right.to_ruby}.call(e)) }"
  end
end

class Add < BinaryOperator
  def operator
    :+
  end
end

class Multiply < BinaryOperator
  def operator
    :*
  end
end

class LessThan < BinaryOperator
  def operator
    :<
  end
end

