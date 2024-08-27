class_name WeightedTable

var items: Array[Dictionary] = []
var weight_sum = 0


func add_item(item, weight: int):
	items.append({"item": item, "weight": weight})
	weight_sum += weight


func remove_item(item_to_remove):
	# update items list that are not 'item_to_remove' 
	items = items.filter(func (item): return item["item"] != item_to_remove)
	# update weignt_sum
	weight_sum = 0
	for item in items:
		weight_sum += item["weight"]


func pick_item(exclude_upgrades: Array = []):
	# logic below works for small arrays; not for large arrays of 200+ items
	var adjusted_items: Array[Dictionary] = items
	var adjusted_weight_sum = weight_sum
	if exclude_upgrades.size() > 0: 
		adjusted_items = []
		adjusted_weight_sum = 0
		# iterate over each item in the "items" array 
		for item in items:
			# check if stored key item is in the exclude_upgrade array list
			if item["item"] in exclude_upgrades:
				# if so, stop loop for 'this' item  and go to next item
				continue
			# if not, add the item to the adjusted_item 
			adjusted_items.append(item)
			# if not, also add item weight to adjusted_weight_sum
			adjusted_weight_sum += item["weight"]
	var chosen_weight = randi_range(1, adjusted_weight_sum)
	var iteration_sum = 0
	for item in adjusted_items:
		iteration_sum += item["weight"]
		if chosen_weight <= iteration_sum:
			return item["item"]

