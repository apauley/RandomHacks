require 'trial_error_algorithm'
require 'sudoku_puzzle'

describe TrialAndErrorAlgorithm do
  it "should find the first incomplete component index" do
    rows = [[1,2,3,4],
            [3,4,1,2],
            [2,1,4,3],
            [4,3,2,0]]

    puzzle = SudokuPuzzle.new(rows)
    TrialAndErrorAlgorithm.incomplete_component_index(rows, puzzle).should == 3
  end

  it "should replace first 0 in a row with an element" do
    newrow = TrialAndErrorAlgorithm.improve_component([3,0,1,2], 2)
    newrow.should == [3,2,1, 2]
    newrow = TrialAndErrorAlgorithm.improve_component([4,3,2,0], 3)
    newrow.should == [4,3,2,3]
  end

  it "should return the row unchanged when it has nothing to do" do
    newrow = TrialAndErrorAlgorithm.improve_component([1], 500)
    newrow.should == [1]
  end

  it "should try its luck with the rows" do
    rows = [[1,2,0,0],
            [3,0,0,2],
            [0,0,0,0],
            [4,3,2,0]]
    puzzle = SudokuPuzzle.new(rows)
    newpuzzle = TrialAndErrorAlgorithm.try_luck_with([1,2,3,4], puzzle)
    expected_rows = [[1,2,3,4],
                     [3,4,1,2],
                     [2,1,4,3],
                     [4,3,2,1]]
    newpuzzle.should == SudokuPuzzle.new(expected_rows)
  end

  it "should return a solved puzzle unchanged" do
    puzzle = SudokuPuzzle.new([[1]])
    solved_puzzle = TrialAndErrorAlgorithm.solve(puzzle)
    solved_puzzle.object_id.should == puzzle.object_id
  end

  it "should solve a 1x1 puzzle" do
    solved_puzzle = TrialAndErrorAlgorithm.solveRows([[0]])
    solved_puzzle.should == SudokuPuzzle.new([[1]])
  end

  it "should solve a 4x4 puzzle" do
    puzzle = SudokuPuzzle.empty(4)
    solved_puzzle = TrialAndErrorAlgorithm.solve(puzzle)
    rows = [[1,2,3,4],
            [3,4,1,2],
            [2,1,4,3],
            [4,3,2,1]]

    solved_puzzle.solved?.should == true
    solved_puzzle.rows.should == rows
  end
end
