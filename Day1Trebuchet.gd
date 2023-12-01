extends Node
# https://adventofcode.com/2023 


func _ready():
	var file = FileAccess.open("res://Day1Input.txt", FileAccess.READ)

	var output: int	= 0

	while !file.eof_reached():
		var content: String = file.get_line()
		output += get_number(content)

	print(output)


func get_number(input: String) -> int:
	# for part one, comment following line out
	input = replace_string_numbers_with_numbers(input)

	var firstNumber: String = ""
	var secondNumber: String = ""

	for i in range(0, input.length()):
		if is_char_number(input[i]) and firstNumber == "":
			firstNumber = input[i]

		if is_char_number(input[input.length() - i - 1]) and secondNumber == "":
			secondNumber = input[input.length() - i - 1]

		if firstNumber != "" and secondNumber != "":
			break

	return (firstNumber + secondNumber).to_int()


func is_char_number(c: String) -> bool:
	if c == "0" or c == "1" or c == "2" or c == "3" or c == "4" or c == "5" or c == "6" or c == "7" or c == "8" or c == "9":
		return true
	else:
		return false


func replace_string_numbers_with_numbers(input: String) -> String:
	input = input.replace("one", "on1ne")
	input = input.replace("two", "tw2wo")
	input = input.replace("three", "thre3hree")
	input = input.replace("four", "fou4our")
	input = input.replace("five", "fiv5ive")
	input = input.replace("six", "se6ex")
	input = input.replace("seven", "seve7even")
	input = input.replace("eight", "eigh8ight")
	input = input.replace("nine", "nin9ine")

	return input

