require 'matrix'
require 'sudoku_exceptions'
require 'stats_keeper'

class SudokuPuzzle
  def SudokuPuzzle.columns(grid_columns)
    matrix = Matrix.columns(grid_columns)
    return self.new(matrix.to_a)
  end

  def SudokuPuzzle.empty(puzzle_size)
    matrix = Matrix.zero(puzzle_size)
    return self.new(matrix.to_a)
  end

  def initialize(grid_rows, stats_keeper=StatsKeeper.new)
    @grid = Matrix[*grid_rows]
    @stats_keeper = stats_keeper

    begin
      validate
      @stats_keeper.valid_attempt!
    rescue SudokuError
      @stats_keeper.error_attempt!
      raise
    end

    freeze
  end

  def clone_with_rows(grid_rows)
    if grid_rows.size != self.size
      raise InvalidCloneSizeError
    end
    return self.class.new(grid_rows, stats_keeper=@stats_keeper)
  end

  def to_s
    grid_s = (rows.collect {|row| row.to_s + "\n"}).to_s + "\n"
    preamble = size.to_s + "x" + size.to_s + " puzzle:\n"
    return preamble + grid_s
  end

  def validate
    validate_grid
    validate_entries
    validate_no_duplicates(rows)
    validate_no_duplicates(columns)
    validate_no_duplicates(blocks)
  end

  def validate_grid
    if not @grid.square?
      raise NonSquareGridError
    end

    x = Math.sqrt(size)
    if x.to_i != x
      raise NonSquarePuzzleError
    end
  end

  def validate_entries
    grid.to_a.flatten.each {|x|
      if x > size
        msg = "Invalid entry #{x} for puzzle with size #{size}"
        raise TooLargeCellValueError, msg
      end
    }
  end

  def validate_no_duplicates(an_array)
    an_array.each {|x|
      list = x.flatten
      list.delete(0)
      if list.uniq != list
        msg = "Duplicates in component #{an_array} for #{self}"
        raise DuplicateComponentValueError, msg
      end}
  end

  def ==(anotherObject)
    grid == anotherObject.grid
  end

  def size
    grid.row_size()
  end

  def sum(an_array)
    # FIXME: How do you sum a list of numbers idiomatically?
    total = 0
    an_array.each {|x| total = total + x}
    return total
  end

  def component_total
    sum((1...size+1).to_a)
  end

  def grid
    @grid
  end

  def stats_keeper
    @stats_keeper
  end

  def rows
    return grid.row_vectors.collect {|each| each.to_a}
  end

  def columns
    return grid.column_vectors.collect {|each| each.to_a}
  end

  def blocks
    b = []
    block_ranges.each {|row_range|
      block_ranges.each {|column_range|
        b.push(row_range.to_a.collect {|x| @grid[x, column_range]})
      }
    }
    return b
  end

  def block_ranges
    if block_size == 3
      return [0..2, 3..5, 6..8]
    elsif block_size == 2
      return [0..1, 2..3]
    else
      return [0..0]
    end
  end

  def block_size
    return Math.sqrt(size).to_i
  end

  def solved?
    row_totals = rows.collect {|each| sum(each) }
    column_totals = columns.collect {|each| sum(each) }
    uniq_totals = row_totals|column_totals

    return ((uniq_totals.size == 1) and (sum(uniq_totals) == component_total))
  end
end
