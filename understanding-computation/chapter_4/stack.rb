class Stack < Struct.new(:contents)
  def push(character)
    Stack.new(contents + [character])
  end

  def pop
    Stack.new(contents[..-2])
  end

  def peek
    contents[-1]
  end

  def inspect
    "<Stack (#{peek})#{contents[..-2].join}>"
  end
end

