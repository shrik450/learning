# Represents the "state" of the PDA, useful for comparisons.
class PDAConfiguration < Struct.new(:state, :stack)
end

class PDARule < Struct.new(
  :state, 
  :character, 
  :pop_character, 
  :next_state, 
  :push_characters
)
  def applies_to?(configuration, character)
    self.character == character &&
      configuration.state == state &&
      configuration.stack.peek == pop_character
  end

  def next_stack(configuration)
    push_characters.inject(configuration.stack.pop) {|stack, character|
      stack.push character
    }
  end

  def follow(configuration)
    PDAConfiguration.new(next_state, next_stack(configuration))
  end
end

class DPDA < Struct.new(:configuration, :accept_states, :rulebook)
  def accepting?
    accept_states.include? configuration.state
  end

  def read_character(character)
    self.configuration = rulebook.next_configuration(configuration, character)
  end

  def read_string(string)
    string.chars.each do |character|
      read_character character
    end
  end
end

