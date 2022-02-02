require_relative "automata.rb"
require_relative "nondeterministic.rb"

module Pattern
  def bracket(outer_precedence)
    if outer_precedence >= precedence
      "(#{self})"
    else
      to_s
    end
  end

  def inspect
    "/#{self}/"
  end

  def matches? string
    to_nfa_design.accepts? string
  end
end

class Empty
  include Pattern

  def to_s
    ''
  end

  def precedence
    3
  end

  def to_nfa_design
    start_state = Object.new
    accept_states = Set[start_state]
    rulebook = NFARulebook.new([])

    NFADesign.new(start_state, accept_states, rulebook)
  end
end

class Literal < Struct.new(:character)
  include Pattern

  def to_s
    character
  end
  
  def precedence
    3
  end

  def to_nfa_design
    start_state = Object.new
    end_state = Object.new
    rulebook =
      NFARulebook.new(
        [FARule.new(start_state, character, end_state)]
      )

    NFADesign.new(start_state, Set[end_state], rulebook)
  end
end

class Concatenate < Struct.new(:first, :second)
  include Pattern

  def to_s
    [first, second].map {|pattern|
      pattern.bracket(precedence)
    }.join('')
  end

  def precedence
    1
  end

  def to_nfa_design
    first_nfa = first.to_nfa_design
    second_nfa = second.to_nfa_design
    start_state = first_nfa.start_state
    accept_states = second_nfa.accept_states
    bridge_rules = first_nfa.accept_states.map {|state|
      FARule.new(state, nil, second_nfa.start_state)
    }
    rulebook = 
      NFARulebook.new(
        first_nfa.rulebook.rules + 
        second_nfa.rulebook.rules +
        bridge_rules
      )

    NFADesign.new(
      start_state,
      accept_states,
      rulebook
    )
  end
end

class Choose < Struct.new(:first, :second)
  include Pattern

  def to_s
    [first, second].map {|pattern|
      pattern.bracket(precedence)
    }.join('|')
  end

  def precedence
    0
  end

  def to_nfa_design
    first_nfa = first.to_nfa_design
    second_nfa = second.to_nfa_design
    start_state = Object.new
    accept_states = first_nfa.accept_states + second_nfa.accept_states
    bridge_rules = [first_nfa, second_nfa].map {|nfa|
      FARule.new(start_state, nil, nfa.start_state)
    }
    rulebook = 
      NFARulebook.new(
        first_nfa.rulebook.rules + 
        second_nfa.rulebook.rules +
        bridge_rules
      )

    NFADesign.new(
      start_state,
      accept_states,
      rulebook
    )
  end
end
    
class Repeat < Struct.new(:pattern)
  include Pattern

  def to_s
    "#{pattern.bracket(precedence)}*"
  end

  def precedence
    2
  end

  def to_nfa_design
    nfa = pattern.to_nfa_design
    start_state = Object.new
    accept_states = Set[start_state] + nfa.accept_states
    jump_rule = FARule.new(start_state, nil, nfa.start_state)
    bridge_rules = accept_states.map {|state|
      FARule.new(state, nil, start_state)
    }
    rulebook =
      NFARulebook.new(
        nfa.rulebook.rules +
        bridge_rules + 
        [jump_rule]
      )

    NFADesign.new(start_state, accept_states, rulebook)
  end
end

