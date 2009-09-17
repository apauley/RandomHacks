require 'solver'
require 'sudoku_puzzle'

describe SudokuSolver do
  it "should return time stats" do
    solver = SudokuSolver.newWithEmptyPuzzle(1)
    stats_keeper = solver.stats_keeper
    stats_keeper.start_time.should < Time.now
    stats_keeper.end_time.should > stats_keeper.start_time
    stats_keeper.elapsed_time.should == stats_keeper.end_time - stats_keeper.start_time
  end

  it "should have a computed puzzle" do
    solver = SudokuSolver.newWithEmptyPuzzle(1)
    solver.crunched_puzzle.should == SudokuPuzzle.new([[1]])
  end

  it "should count attempts and errors" do
    puzzle = SudokuPuzzle.new([[1,2,3,0],
                               [3,4,1,2],
                               [2,1,4,3],
                               [4,3,2,1]])

    solver = SudokuSolver.new(puzzle)
    solver.stats_keeper.valid_attempts.should == 2
    solver.stats_keeper.error_attempts.should == 3
  end

  it "should have an informative string representation" do
    solver = SudokuSolver.newWithEmptyPuzzle(1)
    stats_keeper = solver.stats_keeper
    solver.to_s.include?("Start time:\t#{stats_keeper.start_time}").should == true
    solver.to_s.include?("End time:\t#{stats_keeper.end_time}").should == true
    solver.to_s.include?("Elapsed time:\t#{stats_keeper.elapsed_time}").should == true
    solver.to_s.include?("Algorithm:").should == true
    solver.to_s.include?("Valid attempts:\t#{stats_keeper.valid_attempts}").should == true
    solver.to_s.include?("Error attempts:\t#{stats_keeper.error_attempts}").should == true
    solver.to_s.include?("Total attempts:\t#{stats_keeper.total_attempts}").should == true
    solver.to_s.include?("Input #{solver.input_puzzle}").should == true
    solver.to_s.include?("Crunched #{solver.crunched_puzzle}").should == true
  end

  it "should work with all available algorithms" do
    SudokuAlgorithm.algorithms.keys.each{|x|
      solver = SudokuSolver.newWithEmptyPuzzle(1, algorithm_to_use=x)
      solver.algorithm.should == SudokuAlgorithm.algorithms[x]
    }
  end

  it "should work in parallel" do
    slow_puzzle = SudokuPuzzle.new([[1,0,0,0],
                                    [0,0,0,0],
                                    [0,0,0,0],
                                    [0,0,0,4]])

    quick_puzzle = SudokuPuzzle.new([[1]])

    # Add the slow puzzle first
    slow_solver, quick_solver = SudokuSolver.solve([slow_puzzle, quick_puzzle])

    slow_stats = slow_solver.stats_keeper
    quick_stats = quick_solver.stats_keeper
    quick_stats.elapsed_time.should < slow_stats.elapsed_time

    # The quick puzzle should have started after the slow puzzle
    quick_stats.start_time.should > slow_stats.start_time

    # The quick puzzle should still have ended before the slow puzzle
    quick_stats.end_time.should < slow_stats.end_time
  end
end
