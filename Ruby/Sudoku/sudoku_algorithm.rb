require 'sudoku_puzzle'

class SudokuAlgorithm
  def initialize(puzzle)
    @puzzle = puzzle
    freeze
  end

  def to_s
    self.class.name
  end

  def puzzle
    @puzzle
  end

  def solve
    raise NotImplementedError, 'Please implement this method in a subclass'
  end
end

class RecursiveTrialAndErrorAlgorithm < SudokuAlgorithm

  def RecursiveTrialAndErrorAlgorithm.improve_component(an_array, element)
    if pos = an_array.index(0)
      an_array[pos] = element
    end
    return an_array
  end

  def solve
    if @puzzle.solved?
      return self
    end
    luckyrows = @puzzle.rows.clone
    if pos = incomplete_component_index(luckyrows)
      incomplete_row = luckyrows[pos]

      available_elements = (1..@puzzle.size).to_a
      luckypuzzle = try_luck_with(available_elements, luckyrows).puzzle
      return self.class.new(luckypuzzle).solve
    end
  end

  def try_luck_with(elements, puzzlerows)
    if elements.empty?
      # I raised a RuntimeError to see why elements were sometimes empty,
      # and then everything suddenly worked. Weird.
      raise NoElementError, 'No elements!'
    end

    luckyrows = puzzlerows.clone
    if (pos = incomplete_component_index(luckyrows))
      incomplete_row = luckyrows[pos].clone
      begin
        luckyrow = self.class.improve_component(incomplete_row, elements.first).clone
        luckyrows[pos] = luckyrow.clone

        luckypuzzle = SudokuPuzzle.new(luckyrows.clone, stats_keeper=@puzzle.stats_keeper)
        return self.class.new(luckypuzzle).solve
      rescue SudokuError => detail
        elements.delete_at(0)
        return try_luck_with(elements, puzzlerows)
      end
    end
  end

  def incomplete_component_index(an_array)
    an_array.each_with_index {|each, index|
      if @puzzle.sum(each) < @puzzle.component_total
        return index
      end
    }
  end
end
