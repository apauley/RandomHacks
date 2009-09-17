require 'algorithm'
require 'trial_error_algorithm'
require 'sudoku_puzzle'

class SudokuSolver
  def SudokuSolver.newWithEmptyPuzzle(size, algorithm_to_use="trial_and_error")
    puzzle = SudokuPuzzle.empty(size)
    solver = self.new(puzzle, algorithm_to_use)
    return solver
  end

  def SudokuSolver.solve(puzzle_collection)
    threads = puzzle_collection.collect { |puzzle|
      Thread.new {
        Thread.current['solver'] = self.new(puzzle)
      }
    }
    threads.collect {|each| each.join; each['solver']}
  end

  def initialize(puzzle, algorithm_to_use="trial_and_error")
    @input_puzzle = puzzle
    @stats_keeper = puzzle.stats_keeper
    @algorithm = SudokuAlgorithm.algorithms[algorithm_to_use]
    @crunched_puzzle = @algorithm.solve(@input_puzzle)
    @stats_keeper.end_time!
    freeze
  end

  def to_s
    "Start time:\t#{@stats_keeper.start_time}\n" +
    "End time:\t#{@stats_keeper.end_time}\n" +
    "Elapsed time:\t#{@stats_keeper.elapsed_time}\n" +
    "Algorithm:\t#{@algorithm}\n" +
    "Valid attempts:\t#{@stats_keeper.valid_attempts}\n" +
    "Error attempts:\t#{@stats_keeper.error_attempts}\n" +
    "Total attempts:\t#{@stats_keeper.total_attempts}\n" +
    "\nInput #{input_puzzle}\n" +
    "\nCrunched #{crunched_puzzle}\n"
  end

  def algorithm
    @algorithm
  end

  def stats_keeper
    @stats_keeper
  end

  def input_puzzle
    @input_puzzle
  end

  def crunched_puzzle
    @crunched_puzzle
  end
end
