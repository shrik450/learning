class DFARulebook < Struct.new(:rules)
  def next_state(state, character)
    rule_for(state, character).follow
  end

  def rule_for(state, character)
    rules.find {|rule| rule.applies_to? state, character }
  end

  def inspect
    "#<DFARulebook rules=#{rules.inspect}>"
  end
end

class DFA < Struct.new(:current_state, :accept_states, :rulebook)
  def accepting?
    accept_states.include? current_state
  end

  def read_character(character)
    self.current_state = rulebook.next_state(current_state, character)
  end

  def read_string(string)
    string.chars.each do |char|
      read_character char
    end
  end
end

class DFADesign < Struct.new(:current_state, :accept_states, :rulebook)
  def to_dfa
    DFA.new(current_state, accept_states, rulebook)
  end

  def accepts?(string)
    to_dfa.tap {|dfa| dfa.read_string(string) }.accepting?
  end
end

