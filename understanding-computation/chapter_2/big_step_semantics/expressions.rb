class Value < Struct.new(:value)
  def to_s
    value.to_s
  end

  def inspect
    "<<#{self}>>"
  end
  
  def evaluate(environment)
    self
  end
end

class Boolean < Value
end

class Number < Value
end

class BinaryOperator < Struct.new(:left, :right)
  def to_s
    "#{left} #{operator} #{right}"
  end

  def inspect
    "<<#{self}>>"
  end

  def evaluate(environment)
    result_type.new(left.evaluate(environment).value.send(operator, right.evaluate(environment).value))
  end
end

class Add < BinaryOperator
  def operator
    :+
  end

  def result_type
    Number
  end
end

class Multiply < BinaryOperator
  def operator
    :*
  end

  def result_type
    Number
  end
end

class LessThan < BinaryOperator
  def operator
    :<
  end

  def result_type
    Boolean
  end
end


