require 'sudoku_puzzle'

def check_size(puzzle, expected_size)
  puzzle.grid.row_size().should == expected_size
  puzzle.grid.column_size().should == expected_size
end

describe SudokuPuzzle do
  it "should allow the grid contents to be supplied on creation" do
    puzzle = SudokuPuzzle.new([[1,2], [2,1]])
    check_size(puzzle, 2)
  end

  it "should only allow square grids" do
    lambda {SudokuPuzzle.new([[1,2]])}.should raise_error()
  end
end
