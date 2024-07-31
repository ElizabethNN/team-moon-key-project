extends Node2D

@onready
var current_form = $Human

@onready
var forms: Array = [$Human, $Cat, $Dog, $Bear]

func _process(delta):
	
	if current_form.get_node("Health").current_health <= 0:
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("dog"):
		# Disables all forms
		current_form.get_node("Health").current_health
		for i in forms:
			i.process_mode = Node.PROCESS_MODE_DISABLED
			i.set_visible(false)
			i.get_node("CollisionShape2D").disabled = true
		# Enables dog
		$Dog.set_visible(true)
		$Dog.process_mode = Node.PROCESS_MODE_INHERIT
		$Dog.position = current_form.position
		$Dog.get_node("CollisionShape2D").disabled = false
		$Dog.get_node("Health").current_health = current_form.get_node("Health").current_health
		$Dog.get_node("HealthBar").value = current_form.get_node("Health").current_health
		current_form = $Dog
		print(current_form.name + ": Health is " + str(current_form.get_node("Health").current_health))
	
	if Input.is_action_just_pressed("cat"):
		# Disables all forms
		current_form.get_node("Health").current_health
		for i in forms:
			i.process_mode = Node.PROCESS_MODE_DISABLED
			i.set_visible(false)
			i.get_node("CollisionShape2D").disabled = true
		$Cat.set_visible(true)
		# Enables cat
		$Cat.process_mode = Node.PROCESS_MODE_INHERIT
		$Cat.position = current_form.position
		$Cat.get_node("CollisionShape2D").disabled = false
		$Cat.get_node("Health").current_health = current_form.get_node("Health").current_health
		$Cat.get_node("HealthBar").value = current_form.get_node("Health").current_health
		current_form = $Cat
		print(current_form.name + ": Health is " + str(current_form.get_node("Health").current_health))
		
	if Input.is_action_just_pressed("human"):
		# Disables all forms
		current_form.get_node("Health").current_health
		for i in forms:
			i.process_mode = Node.PROCESS_MODE_DISABLED
			i.set_visible(false)
			i.get_node("CollisionShape2D").disabled = true
		# Enables cat
		$Human.set_visible(true)
		$Human.process_mode = Node.PROCESS_MODE_INHERIT
		$Human.position = current_form.position
		$Human.get_node("CollisionShape2D").disabled = false
		$Human.get_node("Health").current_health = current_form.get_node("Health").current_health
		$Human.get_node("HealthBar").value = current_form.get_node("Health").current_health
		current_form = $Human 
		print(current_form.name + ": Health is " + str(current_form.get_node("Health").current_health))
	if Input.is_action_just_pressed("bear"):
		# Disables all forms
		current_form.get_node("Health").current_health
		for i in forms:
			i.process_mode = Node.PROCESS_MODE_DISABLED
			i.set_visible(false)
			i.get_node("CollisionShape2D").disabled = true
		# Enables dog
		$Bear.set_visible(true)
		$Bear.process_mode = Node.PROCESS_MODE_INHERIT
		$Bear.position = current_form.position
		$Bear.get_node("CollisionShape2D").disabled = false
		$Bear.get_node("Health").current_health = current_form.get_node("Health").current_health
		current_form = $Bear
		print(current_form.name + ": Health is " + str(current_form.get_node("Health").current_health))
