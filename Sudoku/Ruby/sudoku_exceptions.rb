class SudokuError < RuntimeError
end

class SudokuSizeError < SudokuError
end

class NonSquareGridError < SudokuSizeError
end

class NonSquarePuzzleError < SudokuSizeError
end

class TooLargeCellValueError < SudokuError
end

class DuplicateComponentValueError < SudokuError
end

class NoElementError < SudokuError
end

class InvalidCloneSizeError < SudokuSizeError
end
