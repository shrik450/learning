class DoNothing
  def to_s
    "Do Nothing"
  end

  def inspect
    "<<#{self}>>"
  end

  def to_ruby
    "-> e { e }"
  end
end

class Assign < Struct.new(:name, :expression)
  def to_s
    "#{name} = #{expression}"
  end

  def inspect
    "<<#{self}>>"
  end

  def to_ruby
    "-> e { e.merge({#{name.inspect} => (#{expression.to_ruby}.call(e))}) }"
  end
end

class If < Struct.new(:condition, :consequence, :alternative)
  def to_s
    "if (#{condition}) { #{consequence} } else { #{alternative} }"
  end

  def inspect
    "<<#{self}>>"
  end

  def to_ruby
    "-> e { \n" \
    "  if (#{condition.to_ruby}).call(e) \n" \
    "    (#{consequence.to_ruby}).call(e) \n" \
    "  else \n" \
    "    (#{alternative.to_ruby}).call(e) \n" \
    "  end \n" \
    "}"
  end
end

class Sequence < Struct.new(:first, :second)
  def to_s
    "#{first}; #{second}"
  end

  def inspect
    "<<#{self}>>"
  end

  def to_ruby
    "-> e { \n" \
    "  new_e = (#{first.to_ruby}).call(e) \n" \
    "  (#{second.to_ruby}).call(new_e) \n"\
    "}"
  end
end

class While < Struct.new(:condition, :body)
  def to_s
    "while ( #{condition} ) { #{body} }"
  end

  def inspect
    "<<#{self}>>"
  end

  def to_ruby
    "-> e { \n" \
    "  while (#{condition.to_ruby}).call(e) \n" \
    "    e = (#{body.to_ruby}).call(e) \n" \
    "  end \n" \
    "  e \n" \
    "}"
  end
end

