extends Node

func _ready():
    var file: FileAccess = FileAccess.open("res://Day3Input.txt", FileAccess.READ)
    var puzzle: Array = []

    while not file.eof_reached():
        var line: String = file.get_line()
        puzzle.append(line)

    #part 1
    var sum: int = calculate_sum(puzzle)
    print(sum)

    #part 2
    var gearRatio: int = calculate_gear_ratio(puzzle)
    print(gearRatio)


func calculate_sum(puzzle: Array) -> int:
    var sum: int = 0

    for i in range(puzzle.size()):
        var line: String = puzzle[i]
        var lineLength: int = line.length()
        var currentNumber: String = ""
        var isPartNumber: bool = false

        for j in range(lineLength):
            var c: String = line[j]

            if is_char_number(c):
                currentNumber += c
                if is_part_number(puzzle, i, j):
                    isPartNumber = true
            elif currentNumber != "":
                if isPartNumber:
                    sum += int(currentNumber)
                currentNumber = ""
                isPartNumber = false
            
            if j == lineLength - 1 and currentNumber != "":
                if isPartNumber:
                    sum += int(currentNumber)
                currentNumber = ""
                isPartNumber = false

    return sum


func is_char_number(c: String) -> bool:
    if c == "0" or c == "1" or c == "2" or c == "3" or c == "4" or c == "5" or c == "6" or c == "7" or c == "8" or c == "9":
        return true
    else:
        return false


func is_part_number(puzzle: Array, i: int, j: int) -> bool:
    for k in range(-1, 2):
        for l in range(-1, 2):
            if i + k >= 0 and i + k < puzzle.size() and j + l >= 0 and j + l < puzzle[i].length():
                var c: String = puzzle[i + k][j + l]
                if (not is_char_number(c)) and c != ".":
                    return true

    return false


func calculate_gear_ratio(puzzle: Array) -> int:
    var sum: int = 0
    for i in range(puzzle.size()):
        for j in range(puzzle[i].length()):
            var c: String = puzzle[i][j]
            if c == "*":
                sum += calculate_gear_value(puzzle, i, j)

    return sum

func calculate_gear_value(puzzle: Array, i: int, j: int) -> int:
    var sum: int = 0
    var adjacentNumbers: Array = []

    for k in range(-1, 2):
        for l in range(-1, 2):
            if i + k >= 0 and i + k < puzzle.size() and j + l >= 0 and j + l < puzzle[i].length():
                var c: String = puzzle[i + k][j + l]
                if is_char_number(c):
                    var fullNumber: Array = get_full_number(puzzle, i + k, j + l)
                    if not adjacent_numbers_contains_number(adjacentNumbers, fullNumber):
                        adjacentNumbers.append(fullNumber)
                    
    if adjacentNumbers.size() == 2:
        sum += int(adjacentNumbers[0][0]) * int(adjacentNumbers[1][0])

    return sum


func adjacent_numbers_contains_number(adjacentNumbers: Array, number: Array) -> bool:
    for i in range(adjacentNumbers.size()):
        if adjacentNumbers[i][0] == number[0] and adjacentNumbers[i][1] == number[1] and adjacentNumbers[i][2] == number[2]:
            return true

    return false


func get_full_number(puzzle: Array, i: int, j: int) -> Array:
    var number: String = puzzle[i][j]
    var start: int = j
    var counter: int = 1

    while j - counter >= 0:
        var c: String = puzzle[i][j - counter]
        if is_char_number(c):
            number = c + number
            start = j - counter
            counter += 1
        else:
            break

    counter = 1

    while j + counter < puzzle.size():
        var c: String = puzzle[i][j + counter]
        if is_char_number(c):
            number += c
            counter += 1
        else:
            break

    return [number, i, start]
