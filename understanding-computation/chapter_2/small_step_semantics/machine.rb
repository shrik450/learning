class Machine < Struct.new(:statement, :environment)
  def step
    self.statement, self.environment = statement.reduce(environment)
  end

  def state
    "#{statement} [#{environment}]"
  end

  def run
    while statement.reducible?
      puts state 
      step
    end

    puts state
  end
end

