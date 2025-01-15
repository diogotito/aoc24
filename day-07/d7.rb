class Equation
  # Isto podia ser um Data.define(:lhs, :operands) ou Struct.new(:lhs, operands),
  # mas `lhs` e `operands` não seriam instance variables!
  # e eu gosto de ver nomes a começar com @, que também ficam mais syntax highlighted
  def self.[](lhs:, operands:) = \
    self.new.instance_exec { @lhs = lhs; @operands = operands; self }

  def possible_with?(operators)
    all_operator_permutations = operators.repeated_permutation(@operands.size - 1)
    all_operator_permutations.any? do |operator_perm|
      (start_value, *expr, _) = @operands.zip(operator_perm).flatten
      rhs = expr.each_slice(2).reduce(start_value) { |n, msg| n.__send__ *msg }
      @lhs == rhs
    end
  end

  attr_reader :lhs
end

parsed_input = File.foreach('../in/07')
  .map { |line| line.split(':') }
  .map { Equation[lhs: _1.to_i, operands: _2.split.map(&:to_i)] }

parsed_input
  .filter { _1.possible_with? %i(+ *) }
  .sum(&:lhs)
  .then { puts "Part 1: #{_1}" }

Integer.define_method(:'||') { (to_s + _1.to_s).to_i }

parsed_input
  .filter { _1.possible_with? %i(+ * ||) }
  .sum(&:lhs)
  .then { puts "Part 2: #{_1}" }
