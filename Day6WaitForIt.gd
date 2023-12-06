extends Node

func _ready():
	var file = FileAccess.open("res://Day6Input.txt", FileAccess.READ)

	var times: Array = []
	var distances: Array = []

	var line = file.get_line()
	var t: Array = line.split(":")[1].split(" ")
	times = t.filter(func(item): return item != "")
	times = times.map(func(item): return int(item))

	line = file.get_line()
	var d: Array = line.split(":")[1].split(" ")
	distances = d.filter(func(item): return item != "")
	distances = distances.map(func(item): return int(item))

	var total_ways = calculate_ways_to_beat_record(times, distances)
	print(total_ways)

	part_2()


func part_2():
	var file = FileAccess.open("res://Day6Input.txt", FileAccess.READ)

	var times: Array = []
	var distances: Array = []

	var line = file.get_line()
	var t: String = line.split(":")[1].replace(" ", "")
	times = [int(t)]

	line = file.get_line()
	var d: String = line.split(":")[1].replace(" ", "")
	distances = [int(d)]

	var total_ways = calculate_ways_to_beat_record(times, distances)
	print(total_ways)


func calculate_ways_to_beat_record(times: Array, distances: Array):
	var total_ways = 1

	for i in times.size():
		var race_duration = times[i]
		var record_distance = distances[i]

		var ways_to_beat_record = 0
		for holding_duration in range(race_duration + 1):
			var speed = holding_duration
			var remaining_time = race_duration - holding_duration
			var distance = speed * remaining_time

			if distance > record_distance:
				ways_to_beat_record += 1

		total_ways *= ways_to_beat_record

	return total_ways
