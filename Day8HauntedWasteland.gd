extends Node

func _ready():
	var file = FileAccess.open("res://Day8Input.txt", FileAccess.READ)

	var instructions: String = file.get_line()
	var nodes: Dictionary = {}

	#jump over empty line 
	file.get_line()
	var line: String

	while !file.eof_reached():
		line = file.get_line()
		var split = line.split("=")

		var key: String = split[0].strip_edges()
		var values: Array = split[1].replace(" ", "").replace("(", "").replace(")", "").split(",")

		nodes[key] = values 

	var steps: int = calculate_steps(nodes, instructions, "AAA", true)
	print(steps)

	var similtaniousSteps: int = calculate_simultanious_steps_(nodes, instructions)
	print(similtaniousSteps)


func calculate_steps(nodes: Dictionary, instructions: String, currentNode: String, isPartOne: bool = false) -> int:
	var steps: int = 0
	var current_node: String = currentNode

	while current_node[2] != "Z" or (isPartOne and current_node != "ZZZ"):
		var leftNode: String = nodes[current_node][0]
		var rightNode: String = nodes[current_node][1]

		if instructions[steps % instructions.length()] == "L":
			current_node = leftNode
		else:
			current_node = rightNode

		steps += 1

	return steps


func calculate_simultanious_steps_(nodes: Dictionary, instructions: String) -> int:
	var steps: Array = []
	var currentNodes: Array = []
	var similtaniousSteps: int = 1
	for node in nodes:
		if node[2] == "A":
			currentNodes.append(node)
			steps.append(calculate_steps(nodes, instructions, node))

	var primes: Array = []
	for step in steps:
		var factors: Array = prime_factorization(step)
		primes.append(factors)

	var usedPrimesAndPower: Dictionary = {}
	for prime in primes:
		for factor in prime:
			if factor in usedPrimesAndPower:
				usedPrimesAndPower[factor] = max(usedPrimesAndPower[factor], prime.count(factor))
			else:
				usedPrimesAndPower[factor] = prime.count(factor)

	for key in usedPrimesAndPower:
		similtaniousSteps *= pow(key, usedPrimesAndPower[key])
	
	return similtaniousSteps


func prime_factorization(num: int) -> Array:
	var factors = []
	var divisor = 2

	while num > 1:
		while num % divisor == 0:
			factors.append(divisor)
			num = num / divisor
		divisor += 1

	return factors

