extends Node

func _ready():
	var file = FileAccess.open("res://Day5Input.txt", FileAccess.READ)

	var seeds: Array = []
	var maps: Array = []

	var line = file.get_line()
	var s: Array = line.split(":")[1].split(" ")
	seeds = s.filter(func(item): return item != "")
	seeds = seeds.map(func(item): return int(item))

	var counter: int = -1

	while !file.eof_reached():
		line = file.get_line()

		if line.length() <= 1:
			counter += 1
			maps.append([])
			maps[counter] = []
			#jump over next line, which is text description
			line = file.get_line()
			continue

		var map: Array = line.split(" ")
		var moreValues: Array = map.filter(func(item): return item != "")
		moreValues = moreValues.map(func(item): return int(item))
		maps[counter].append(moreValues)

	var lowest: int = calculate_lowest_location_number(seeds, maps)
	print(lowest)

	#order all entries in maps[i] by their second value
	for i in maps.size():
		maps[i].sort_custom(func(a, b): return a[1] < b[1])

	var lowestRecursive: int = calculate_lowest_location_with_range(seeds, maps)
	print(lowestRecursive)


func calculate_lowest_location_number(seeds: Array, maps: Array) -> int:
	var locations: Array = []

	for i in seeds.size():
		locations.append(seeds[i])
		for map in maps:
			for conf in map:
				if locations[i] >= conf[1] and locations[i] < conf[1] + conf[2]:
					locations[i] = conf[0] + locations[i] - conf[1]
					break

	#get the lowest value
	var lowest: int = locations[0]
	for i in locations.size():
		if locations[i] < lowest:
			lowest = locations[i]

	return lowest


func calculate_lowest_location_with_range(seeds: Array, maps: Array) -> int:
	var lowest: int = 9223372036854775807 # Biggest value an int can store

	for i in seeds.size() / 2:
		var seedInitial: int = get_lowest_location_recursive(seeds[i * 2], seeds[i * 2] + seeds[i * 2 + 1], maps, 0)
		if seedInitial < lowest:
			lowest = seedInitial

	return lowest


func get_range(startValue: int, endValue: int, maps: Array, mapIndex) -> Array:
	for i in maps[mapIndex].size():
		var conf = maps[mapIndex][i]

		if startValue >= conf[1] and startValue < conf[1] + conf[2]:
			if endValue >= conf[1] and endValue < conf[1] + conf[2]:
				return [startValue, endValue, -1, -1, i]
			else:
				return [startValue, conf[1] + conf[2] - 1, conf[1] + conf[2], endValue, i]
		elif startValue < conf[1]:
			if endValue < conf[1]:
				return [startValue, endValue, -1, -1, -1]
			else:
				return [startValue, conf[1] - 1, conf[1], endValue, -1]

	return [startValue, endValue, -1, -1, -1]


func get_lowest_location_recursive(startValue: int, endValue: int, maps: Array, mapIndex: int) -> int:
	if mapIndex >= maps.size():
		return startValue

	var ranges: Array = get_range(startValue, endValue, maps, mapIndex)
	var start1: int = ranges[0]
	var end1: int = ranges[1]
	var conf: Array = maps[mapIndex][ranges[4]]

	if ranges[2] == -1: #only one range
		if ranges[4] == -1: #no conf found, take same values to next conversion
			return get_lowest_location_recursive(start1, end1, maps, mapIndex + 1)
		#conf found, take conf values to next conversion
		return get_lowest_location_recursive(conf[0] + start1 - conf[1], conf[0] + end1 - conf[1], maps, mapIndex + 1)

	else: #two ranges that need to be calles recursively and compared to each other
		var firstValue: int = -1
		if ranges[4] == -1: #no conf found, take same values to next conversion
			firstValue = get_lowest_location_recursive(start1, end1, maps, mapIndex + 1)
		#conf found, take conf values to next conversion
		else:
			firstValue = get_lowest_location_recursive(conf[0] + start1 - conf[1], conf[0] + end1 - conf[1], maps, mapIndex + 1)

		var secondValue: int = get_lowest_location_recursive(ranges[2], ranges[3], maps, mapIndex)

		return min(firstValue, secondValue)

