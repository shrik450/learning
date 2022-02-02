require_relative "pushdown"

class DPDARulebook < Struct.new(:rules)
  def rule_for(configuration, character)
    rules.find {|rule|
      rule.applies_to? configuration, character
    }
  end

  def next_configuration(configuration, character)
    rule_for(configuration, character).follow(configuration)
  end
end

