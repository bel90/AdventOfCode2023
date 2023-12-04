extends Node


func _ready():
	var file = FileAccess.open("res://Day4Input.txt", FileAccess.READ)

	var winningSumPart1: int = 0
	var winningSumPart2: int = 0
	var winningArray: Array = []
	var instancesArray: Array = []

	#part 1
	while !file.eof_reached():
		var amountWinningNumbers: int = calculate_amount_winning_numbers(file.get_line())
		winningArray.append(amountWinningNumbers)
		instancesArray.append(1)
		if amountWinningNumbers > 0:
			winningSumPart1 += pow(2, amountWinningNumbers - 1)

	print(winningSumPart1)

	#part 2
	for i in range(0, winningArray.size()):
		for j in range(0, winningArray[i]):
			if i + j + 1 < instancesArray.size():
				instancesArray[i + j + 1] += instancesArray[i]

	#sum it all together
	for i in range(0, instancesArray.size()):
		winningSumPart2 += instancesArray[i] 

	print(winningSumPart2)
	


func calculate_amount_winning_numbers(card: String) -> int:
	var winningNumbers: Array = card.split(":")[1].split("|")[0].split(" ")
	var playerNumbers: Array = card.split(":")[1].split("|")[1].split(" ")

	winningNumbers = winningNumbers.filter(func(item): return item != "" )
	playerNumbers = playerNumbers.filter(func(item): return item != "" )

	var amountOfWinningNumbers: int = 0 

	for i in playerNumbers:
		if winningNumbers.find(i) != -1:
			amountOfWinningNumbers += 1

	return amountOfWinningNumbers
