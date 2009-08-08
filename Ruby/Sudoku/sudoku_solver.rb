require 'sudoku_algorithm'

class SudokuSolver
  def SudokuSolver.algorithms
    {"trial_and_error" => RecursiveTrialAndErrorAlgorithm}
  end

  def initialize(algorithm_to_use="trial_and_error")
    @algorithm_to_use = algorithm_to_use
    freeze
  end

  def solve(puzzle)
    results = {}
    algorithm = self.class.algorithms[@algorithm_to_use]
    results['puzzle'] = algorithm.new(puzzle).solve
    return results
  end
end
