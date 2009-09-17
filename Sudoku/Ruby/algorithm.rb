class SudokuAlgorithm
  def SudokuAlgorithm.algorithms
    {"trial_and_error" => TrialAndErrorAlgorithm,
      "do_nothing" => DoNothingAlgorithm}
  end

  def SudokuAlgorithm.solve(puzzle)
    raise NotImplementedError, 'Please implement this method in a subclass'
  end

  def SudokuAlgorithm.solveRows(puzzleRows)
    puzzle = SudokuPuzzle.new(puzzleRows)
    return solve(puzzle)
  end
end

class DoNothingAlgorithm < SudokuAlgorithm
  def DoNothingAlgorithm.solve(puzzle)
    return puzzle
  end
end
