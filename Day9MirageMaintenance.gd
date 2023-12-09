extends Node

func _ready():
	var file = FileAccess.open("res://Day9Input.txt", FileAccess.READ)

	var line: String

	var part1: int = 0
	var part2: int = 0

	while !file.eof_reached():
		line = file.get_line()
		var split: Array = line.split(" ")
		split = split.map(func(item): return int(item))
		var solution: Array = extrapolate(split)
		part1 += solution[1]
		part2 += solution[0]

	print("Part 1: " + str(part1))
	print("Part 2: " + str(part2))


func extrapolate(numbers: Array) -> Array: 
	var lines: Array = []
	lines.append(numbers)
	var lastIndex: int = lines.size() - 1

	while lines[lastIndex].count(0) != lines[lastIndex].size() && lines[lastIndex].size() > 1:
		lines.append([])
		lastIndex = lines.size() - 1
		for i in range(lines[lastIndex - 1].size() - 1):
			lines[lastIndex].append(lines[lastIndex - 1][i + 1] -lines[lastIndex - 1][i])
		
	lines[lastIndex].append(0)
	var beginningValue: int = 0
	#go back up and add one value each line
	for i in range(lastIndex):
		lines[lastIndex - i - 1].append(lines[lastIndex - i][lines[lastIndex - i].size() - 1] + lines[lastIndex - i - 1][lines[lastIndex - i - 1].size() - 1])
		beginningValue = lines[lastIndex - i - 1][0] - beginningValue

	return [beginningValue, lines[0][lines[0].size() - 1]]




