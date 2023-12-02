extends Node
# https://adventofcode.com/2023 

var RED: int = 12
var GREEN: int = 13
var BLUE: int = 14


func _ready():
	var file = FileAccess.open("res://Day2Input.txt", FileAccess.READ)

	var outputPart1: int = 0
	var outputPart2: int = 0
	var counter: int = 1

	while !file.eof_reached():
		#part 1
		var content: String = file.get_line()
		var game_possible = is_game_possible(content)

		if game_possible:
			outputPart1 += counter

		counter += 1
		
		#part 2
		outputPart2 += get_power_of_game(content)


	print(outputPart1)
	print(outputPart2)


func is_game_possible(content: String) -> bool:
	var games: Array = content.split(":")[1].split(";")

	for game in games:
		var colorNumberPairs: Array = game.split(",")

		for colorNumberPair in colorNumberPairs:
			var numberAndColor: Array = colorNumberPair.split(" ")

			var color: String = numberAndColor[2]
			var number: int = numberAndColor[1].to_int()

			match color:
				"red":
					if number > RED:
						return false
				"green":
					if number > GREEN:
						return false
				"blue":
					if number > BLUE:
						return false
				_:
					print("Something went wrong. Non implemented color: " + color)
					pass
	
	return true


func get_power_of_game(content: String) -> int:
	var games: Array = content.split(":")[1].split(";")
	var red: int = 1
	var green: int = 1
	var blue: int = 1

	for game in games:
		var colorNumberPairs: Array = game.split(",")

		for colorNumberPair in colorNumberPairs:
			var numberAndColor: Array = colorNumberPair.split(" ")

			var color: String = numberAndColor[2]
			var number: int = numberAndColor[1].to_int()

			match color:
				"red":
					if number > red:
						red = number
				"green":
					if number > green:
						green = number
				"blue":
					if number > blue:
						blue = number
				_:
					print("Something went wrong. Non implemented color: " + color)
					pass

	return red * green * blue
