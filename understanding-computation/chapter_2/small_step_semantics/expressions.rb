class Value < Struct.new(:value)
  def to_s
    value.to_s
  end

  def inspect
    "<<#{self}>>"
  end

  def reducible?
    false
  end
end

class Number < Value
end

class Boolean < Value
end

class BinaryOperator < Struct.new(:left, :right)
  def to_s
    "#{self.class.name}(#{left}, #{right})"
  end

  def inspect
    "<<#{self}>>"
  end

  def reducible?
    true
  end

  def reduce(environment)
    if left.reducible?
      self.class.new(left.reduce(environment), right)
    elsif right.reducible?
      self.class.new(left, right.reduce(environment))
    else
      raise "Don't know how to reduce #{self.class.name}" 
    end
  end
end

class Add < BinaryOperator
  def to_s
    "#{left} + #{right}"
  end

  def reduce(environment)
    if left.reducible?
      super
    elsif right.reducible?
      super
    else
      Number.new(left.value + right.value)
    end
  end
end

class Multiply < BinaryOperator
  def to_s
    "#{left} * #{right}"
  end

  def reduce(environment)
    if left.reducible?
      super
    elsif right.reducible?
      super
    else
      Number.new(left.value * right.value)
    end
  end
end

class LessThan < BinaryOperator
  def to_s
    "#{left} < #{right}"
  end

  def reduce(environment)
    if left.reducible?
      super
    elsif right.reducible?
      super
    else
      Boolean.new(left.value < right.value)
    end
  end
end

