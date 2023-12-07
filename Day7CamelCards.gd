extends Node

var isPart1: bool = true

func _ready():
	var file = FileAccess.open("res://Day7Input.txt", FileAccess.READ)

	var hands: Array = []
	var line: String

	while !file.eof_reached():
		line = file.get_line()

		var handAndBid: Array = line.split(" ")
		hands.append([handAndBid[0], int(handAndBid[1])])

	print(calculate_total_winnings(hands))
	isPart1 = false
	print(calculate_total_winnings(hands))


func calculate_total_winnings(hands: Array):
	var totalWinnings: int = 0
	
	#order all hand in hands by their value hand[0] with the function is_first_hand_higher
	hands.sort_custom(is_first_hand_smaller)

	for i in hands.size():
		totalWinnings += hands[i][1] * (i + 1)

	return totalWinnings


func is_first_hand_smaller(firstHand: Array, secondHand: Array) -> bool:
	var firstHandValue: int 
	var secondHandValue: int 

	if isPart1:
		firstHandValue = get_hand_value(firstHand[0])
		secondHandValue = get_hand_value(secondHand[0])
	else:
		firstHandValue = get_hand_value_joker(firstHand[0])
		secondHandValue = get_hand_value_joker(secondHand[0])

	if firstHandValue < secondHandValue:
		return true
	elif firstHandValue > secondHandValue:
		return false
	else:
		return is_first_hand_smaller_by_card(firstHand[0], secondHand[0])


func get_hand_value(hand: String) -> int:
	var cardsCounted: Dictionary = {}

	for card in hand:
		if cardsCounted.has(card):
			cardsCounted[card] += 1
		else:
			cardsCounted[card] = 1

	var keys: Array = cardsCounted.keys()
	if keys.size() == 5: #all duplicates
		return 0
	if keys.size() == 1: #no duplicates
		return 6

	#size is larger then 1 and smaller then 5, so there are duplicates 
	if cardsCounted[keys[0]] == 4 or cardsCounted[keys[1]] == 4: #four of a kind
		return 5

	if (cardsCounted[keys[0]] == 3 and cardsCounted[keys[1]] == 2) or (cardsCounted[keys[1]] == 3 and cardsCounted[keys[0]] == 2): #three of a kind
		return 4 #full house

	if keys.size() == 3 and (cardsCounted[keys[0]] == 3 or cardsCounted[keys[1]] == 3 or cardsCounted[keys[2]] == 3):
		return 3 #three of a kind

	#two pairs or one pair: has to be one of the two 
	if keys.size() == 3:
		return 2 #two pairs

	return 1 #one pair


func get_hand_value_joker(hand: String) -> int:
	var cardsCounted: Dictionary = {}
	var jokerCount: int = 0

	for card in hand:
		if card == "J":
			jokerCount += 1
		else:
			if cardsCounted.has(card):
				cardsCounted[card] += 1
			else:
				cardsCounted[card] = 1

	var keys: Array = cardsCounted.keys()

	if jokerCount == 0: #no jokers, so calculate normal
		return get_hand_value(hand)

	if jokerCount >= 4: #Jokers for 5 of a kind
		return 6 

	if jokerCount == 3: #Jokers for 4 of a kind or 5 of a kind
		if cardsCounted.size() == 1:
			return 6
		else:
			return 5

	if jokerCount == 2: #Jokers for 3, 4 or 5 of a kind
		if cardsCounted.size() == 1:
			return 6 #5 of a kind
		elif cardsCounted.size() == 2:
			return 5 #4 of a kind
		else:
			return 3 #3 of a kind

	#1 joker, for pair, 3, 4, 5 of a kind or full house
	if cardsCounted.size() == 1:
		return 6 #5 of a kind
	elif cardsCounted.size() == 2:
		if cardsCounted[keys[0]] == 2 or cardsCounted[keys[1]] == 2:
			return 4 #full house
		else:
			return 5 #4 of a kind
	elif cardsCounted.size() == 3:
		return 3 #3 of a kind

	return 1 #at least one joker, so one pair TODO check other cases


func is_first_hand_smaller_by_card(firstHand: String, secondHand: String) -> bool:
	for i in firstHand.length():
		if get_card_value(firstHand[i]) < get_card_value(secondHand[i]):
			return true
		elif get_card_value(firstHand[i]) > get_card_value(secondHand[i]):
			return false

	return false


func get_card_value(card: String) -> int:
	if card == "T":
		return 10
	elif card == "J":
		if isPart1:
			return 11
		else:
			return 1
	elif card == "Q":
		return 12
	elif card == "K":
		return 13
	elif card == "A":
		return 14
	else:
		return int(card)


