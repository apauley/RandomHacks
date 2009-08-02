class SudokuAlgorithm
  def initialize(puzzle)
    @puzzle = puzzle
    freeze
  end

  def solve
    raise NotImplementedError, 'Please implement this method in a subclass'
  end
end

class TryYourLuckAlgorithm < SudokuAlgorithm
  def solve
    if @puzzle.solved?
      return @puzzle
    end
    luckyrows = @puzzle.rows.clone
    if pos = incomplete_component_index(luckyrows)
      incomplete_row = luckyrows[pos]

      available_elements = (1..@puzzle.size).to_a - incomplete_row.uniq
      luckypuzzle = try_luck_with(available_elements, luckyrows)
      return self.class.new(luckypuzzle).solve
    end
  end

  def try_luck_with(elements, puzzlerows)
    if elements.empty?
      raise 'No elements!'
    end

    luckyrows = puzzlerows.clone
    if (pos = incomplete_component_index(luckyrows))
      incomplete_row = luckyrows[pos].clone
      begin
        luckyrow = improve_component(incomplete_row, elements.first).clone
        luckyrows[pos] = luckyrow.clone

        luckypuzzle = SudokuPuzzle.new(luckyrows.clone)
        return self.class.new(luckypuzzle).solve
      rescue RuntimeError => detail
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
    return nil
  end

  def improve_component(an_array, element)
    if pos = an_array.index(0)
      an_array[pos] = element
    end
    return an_array
  end
end
