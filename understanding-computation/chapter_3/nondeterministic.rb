require 'set'

class NFARulebook < Struct.new(:rules)
  def rules_for(state, character)
    rules.find_all {|rule|
      rule.applies_to? state, character
    }
  end

  def follow_for(state, character)
    rules_for(state, character).map &:follow  
  end

  def next_states(states, character)
    states.flat_map {|state|
      follow_for state, character
    }.to_set
  end

  def follow_free_moves(states)
    this_iteration_of_sets = next_states(states, nil)

    # This is recursive, because the states you can be in after making free 
    # moves may have free moves of their own.
    if this_iteration_of_sets.subset? states
      states
    else
      follow_free_moves states + this_iteration_of_sets
    end
  end

  def inspect
    "#<NFARulebook rules=#{rules.inspect}>"
  end

  def alphabet
    @alphabet ||= rules.map(&:character).compact.uniq
  end
end

class NFA < Struct.new(:current_states, :accept_states, :rulebook)
  def accepting?
    (accept_states & current_states).size > 0
  rescue
    puts "#{accept_states.inspect}"
    puts "#{current_states.inspect}"
    raise
  end

  def current_states
    # Very clever.
    rulebook.follow_free_moves super
  end

  def read_character(character)
    self.current_states = rulebook.next_states(current_states, character)  
  end

  def read_string(string)
    string.chars.each do |char|
      read_character char
    end
  end
end

class NFADesign < Struct.new(:start_state, :accept_states, :rulebook)
  def to_nfa(current_states = Set[start_state])
    NFA.new(current_states, accept_states, rulebook)
  end

  def accepts?(string)
    to_nfa.tap {|nfa|
      nfa.read_string string
    }.accepting?
  end
end

class NFASimulation < Struct.new(:nfa_design)
  def next_state(state, character)
    nfa = nfa_design.to_nfa(state)
    nfa.read_character(character)
    nfa.current_states
  end

  def rulebook
    nfa_design.rulebook
  end

  def rules_for(state)
    rulebook.alphabet.map {|character|
      FARule.new(state, character, next_state(state, character))
    }
  end

  # @param [Set<Set>] states
  # @return [Array]
  def discover_states_and_rules(states)
    rules = states.flat_map {|state| rules_for state }
    next_states = rules.map(&:follow).to_set
    if next_states.subset? states
      [states, rules]
    else
      discover_states_and_rules(states)
    end
  end

  def to_dfa_design
    start_state = nfa_design.to_nfa.current_states
    states, rules = discover_states_and_rules(Set[start_state])
    accept_states = states.filter {|state| nfa_design.to_nfa(state).accepting? }

    DFADesign.new(start_state, accept_states, DFARulebook.new(rules))
  end
end

