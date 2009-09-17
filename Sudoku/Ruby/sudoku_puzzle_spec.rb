require 'sudoku_puzzle'

describe SudokuPuzzle do
  it "should represent itself as a nice string" do
    puzzle = SudokuPuzzle.new([[1]])
    puzzle.to_s.should == "1x1 puzzle:\n1\n\n"
  end

  it "should use grid rows for default construction" do
    rows = [[1,2,3,4],
            [3,4,1,2],
            [2,1,4,3],
            [4,3,2,1]]
    puzzle = SudokuPuzzle.new(rows)
    puzzle.rows.should == rows
    expected_columns = [[1,3,2,4],
                        [2,4,1,3],
                        [3,1,4,2],
                        [4,2,3,1]]
    puzzle.columns.should == expected_columns

    puzzle = SudokuPuzzle.new([[1]])
    puzzle.rows.should == [[1]]
    puzzle.columns.should == [[1]]
  end

  it "should also allow construction with columns" do
    columns = [[1,2,3,4],
               [3,4,1,2],
               [2,1,4,3],
               [4,3,2,1]]
    puzzle = SudokuPuzzle.columns(columns)
    puzzle.columns.should == columns
    expected_rows = [[1,3,2,4],
                     [2,4,1,3],
                     [3,1,4,2],
                     [4,2,3,1]]

    puzzle.rows.should == expected_rows
  end

  it "should allow the creation of an empty puzzle" do
    puzzle = SudokuPuzzle.empty(4)
    empty4 = [[0,0,0,0],
              [0,0,0,0],
              [0,0,0,0],
              [0,0,0,0]]
    puzzle.rows.should == empty4
    puzzle.columns.should == empty4
  end

  it "should only allow square grids" do
    lambda {SudokuPuzzle.new([[1,2]])}.should raise_error(NonSquareGridError)
  end

  it "should only allow square puzzles" do
    lambda {SudokuPuzzle.new([[1,2], [0,0]])}.should raise_error(NonSquarePuzzleError)
  end

  it "should not allow cell values greater than the puzzle size" do
    lambda {SudokuPuzzle.new([[2]])}.should raise_error(TooLargeCellValueError)
  end

  it "should not allow duplicate values in rows" do
    rows = [[1,2,3,1],
            [0,0,0,0],
            [0,0,0,0],
            [0,0,0,0]]

    lambda {SudokuPuzzle.new(rows)}.should raise_error(DuplicateComponentValueError)
  end

  it "should not allow duplicate values in columns" do
    rows = [[1,0,0,0],
            [2,0,0,0],
            [3,0,0,0],
            [2,0,0,0]]
    lambda {SudokuPuzzle.new(rows)}.should raise_error(DuplicateComponentValueError)
  end

  it "should not allow duplicate values in blocks" do
    rows = [[1,2, 3,4],
            [2,0, 0,0],

            [3,0, 0,0],
            [4,0, 0,0]]
    lambda {SudokuPuzzle.new(rows)}.should raise_error(DuplicateComponentValueError)
  end

  it "should know when another puzzle is equal to itself" do
    a_puzzle = SudokuPuzzle.new([[1]])
    same_puzzle = SudokuPuzzle.new([[1]])
    empty_puzzle = SudokuPuzzle.empty(1)
    a_puzzle.should == same_puzzle
    a_puzzle.should_not == empty_puzzle
  end

  it "should know whether it is solved" do
    empty_puzzle = SudokuPuzzle.empty(4)

    rows = [[1,0,0,0],
            [2,0,0,0],
            [3,0,0,0],
            [4,0,0,0]]
    unsolved_puzzle = SudokuPuzzle.new(rows)

    rows = [[1,2,3,4],
            [3,4,1,2],
            [2,1,4,3],
            [4,3,2,1]]
    solved_puzzle = SudokuPuzzle.new(rows)

    empty_puzzle.solved?.should == false
    unsolved_puzzle.solved?.should == false
    solved_puzzle.solved?.should == true
  end

  it "should know its block size" do
    SudokuPuzzle.empty(1).block_size.should == 1
    SudokuPuzzle.empty(4).block_size.should == 2
    SudokuPuzzle.empty(9).block_size.should == 3
  end

  it "should know its blocks" do
    puzzle = SudokuPuzzle.new([[4,2,3,1], [1,3,4,2], [3,1,2,4], [2,4,1,3]])
    puzzle.blocks.size.should == puzzle.size
    puzzle.blocks[0].should == [[4,2],[1,3]]
    puzzle.blocks[1].should == [[3,1],[4,2]]
    puzzle.blocks[2].should == [[3,1],[2,4]]
    puzzle.blocks[3].should == [[2,4],[1,3]]
  end

  it "should return blocks for 9x9 puzzles correctly" do
    rows = [[0,4,7, 0,0,0, 0,0,0],
            [0,0,5, 0,0,0, 0,0,0],
            [8,0,0, 0,0,9, 0,1,0],

            [0,0,0, 0,0,0, 6,2,3],
            [5,0,0, 0,0,0, 0,7,0],
            [0,2,0, 0,8,4, 9,0,0],

            [2,0,0, 0,9,0, 0,0,0],
            [0,0,0, 3,2,0, 0,0,9],
            [0,8,0, 7,0,0, 4,0,0],
           ]
    puzzle = SudokuPuzzle.new(rows)

    puzzle.blocks[0].should == [[0,4,7], [0,0,5], [8,0,0]]
    puzzle.blocks[1].should == [[0,0,0], [0,0,0], [0,0,9]]
    puzzle.blocks[2].should == [[0,0,0], [0,0,0], [0,1,0]]

    puzzle.blocks[3].should == [[0,0,0], [5,0,0], [0,2,0]]
    puzzle.blocks[4].should == [[0,0,0], [0,0,0], [0,8,4]]
    puzzle.blocks[5].should == [[6,2,3], [0,7,0], [9,0,0]]

    puzzle.blocks[6].should == [[2,0,0], [0,0,0], [0,8,0]]
    puzzle.blocks[7].should == [[0,9,0], [3,2,0], [7,0,0]]
    puzzle.blocks[8].should == [[0,0,0], [0,0,9], [4,0,0]]
  end

  it "should know its expected component total" do
    puzzle = SudokuPuzzle.empty(1)
    puzzle.component_total.should == 1

    puzzle = SudokuPuzzle.empty(4)
    puzzle.component_total.should == 10

    puzzle = SudokuPuzzle.empty(9)
    puzzle.component_total.should == 45
  end

  it "should be able to clone itself using new rows" do
    puzzle = SudokuPuzzle.empty(1)
    cloned_puzzle = puzzle.clone_with_rows([[1]])
    cloned_puzzle.object_id.should_not == puzzle.object_id
    cloned_puzzle.rows.should == [[1]]
  end

  it "should not allow a clone with a different puzzle size" do
    puzzle = SudokuPuzzle.empty(4)
    lambda {puzzle.clone_with_rows([[1]])}.should raise_error(InvalidCloneSizeError)
  end
end
