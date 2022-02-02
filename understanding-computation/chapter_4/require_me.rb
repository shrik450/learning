require_relative "deterministic"
require_relative "stack"

rulebook = 
  DPDARulebook.new(
    [
      PDARule.new(1, '(', '$', 2, ['$', 'b']),
      PDARule.new(2, '(', 'b', 2, ['b', 'b']),
      PDARule.new(2, ')', 'b', 2, []),
      PDARule.new(2, nil, '$', 1, ['$'])
    ]
  )

