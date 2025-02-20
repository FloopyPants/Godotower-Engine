extends CharacterBody2D

enum states {
	normal,
	mach1,
	mach2,
	machturn,
	climbwall,
	animation,
	mach3,
	handstandjump,
}

var state = states.normal

var SPEED = 300.0
var ACCELERATION = 1000.0
var GRAVITY = 15.0 * 100.0
var JUMP_STRENGTH = 500.0  
var JUMPRELEASE = false
var MOVESPD = 0.0

func _process(delta: float) -> void:
	if state == states.normal:
		var moveR = Input.is_action_pressed("ui_right")
		var moveL = Input.is_action_pressed("ui_left")

		if moveR:
			if velocity.x < 0:
				velocity.x = 0
			velocity.x = move_toward(velocity.x, SPEED, ACCELERATION * delta)
			$NodeForStuff/spr.play("Move")
			$NodeForStuff/spr.scale.x = 1
		elif moveL:
			if velocity.x > 0:
				velocity.x = 0
			velocity.x = move_toward(velocity.x, -SPEED, ACCELERATION * delta)
			$NodeForStuff/spr.play("Move")
			$NodeForStuff/spr.scale.x = -1
		else:
			$NodeForStuff/spr.play("Idle")
			velocity.x = 0
			
		if is_on_floor() and Input.is_action_just_pressed("ui_jump"):
			velocity.y = -700.0
			JUMPRELEASE = true
		
		if Input.is_action_just_released("ui_jump") && JUMPRELEASE && velocity.y < -100.0:
			velocity.y = -100.0
			JUMPRELEASE = false
		
		if Input.is_action_pressed("ui_shift") && is_on_floor_only() && !is_on_wall():
			$NodeForStuff/spr.play("Mach_1")
			state = states.mach1
			MOVESPD = 0.0
		
		if Input.is_action_pressed("ui_slap"):
			MOVESPD = 900.0
			$NodeForStuff/spr.play("Grab")
			state = states.handstandjump
		
		velocity.y += GRAVITY * delta

		move_and_slide()
	if state == states.mach1:
		# ass!
		velocity.x = MOVESPD * $NodeForStuff/spr.scale.x
		MOVESPD = move_toward(MOVESPD, 400.0, 900.0 * delta)
		velocity.y += GRAVITY * delta
		
		move_and_slide()
		
	if state == states.mach2:
		var hor_move = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		velocity.x = MOVESPD * $NodeForStuff/spr.scale.x
		MOVESPD = move_toward(MOVESPD, 950.0, 250.0 * delta)
		
		velocity.y += GRAVITY * delta
		move_and_slide()
		
		if is_on_floor() and Input.is_action_just_pressed("ui_jump"):
			velocity.y = -600.0
			JUMPRELEASE = true
		
		if Input.is_action_just_released("ui_jump") && JUMPRELEASE && velocity.y < -100.0:
			velocity.y = -100.0
			JUMPRELEASE = false
		
		if not Input.is_action_pressed("ui_shift"):
			state = states.normal
		
		if is_on_floor():
			if hor_move == -1 && $NodeForStuff/spr.scale.x == 1:
				$NodeForStuff/spr.play("Mach_Turn")
				state = states.machturn
				
			if hor_move == 1 && $NodeForStuff/spr.scale.x == -1:
				$NodeForStuff/spr.play("Mach_Turn")
				state = states.machturn
			
			if is_on_wall():
				$NodeForStuff/spr.play("Wall_Splat")
				state = states.animation
			
		if is_on_wall() and not is_on_floor():
			velocity.y = -abs(MOVESPD)
			$NodeForStuff/spr.play("Climb_Wall")
			state = states.climbwall
			
		if abs(MOVESPD) >= 949.99:
			$NodeForStuff/spr.play("Mach_3")
			state = states.mach3
		
	if state == states.machturn:
		velocity.x = MOVESPD * $NodeForStuff/spr.scale.x
		MOVESPD = move_toward(MOVESPD, 0, 1000.0 * delta)
		velocity.y += GRAVITY * delta
		move_and_slide()
		
	if state == states.climbwall:
		velocity.y = move_toward(velocity.y, -1200.0, 75.0 * delta)
		if (!is_on_wall() && !is_on_ceiling()):
			state = states.mach2
			$NodeForStuff/spr.play("Mach_2")
			MOVESPD = -velocity.y
			velocity.y = 0
		if Input.is_action_just_released("ui_shift"):
			velocity.y = 0
			state = states.normal
		if Input.is_action_just_pressed("ui_jump"):
			JUMPRELEASE = true
			velocity.y = -600.0
			MOVESPD = 700.0
			$NodeForStuff/spr.play("Mach_2")
			$NodeForStuff/spr.scale.x = -$NodeForStuff/spr.scale.x
			state = states.mach2
		move_and_slide()
		
	if state == states.mach3:
		var hor_move = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
		velocity.x = MOVESPD * $NodeForStuff/spr.scale.x
		MOVESPD = move_toward(MOVESPD, 1000.0, 100.0 * delta)
		velocity.y += GRAVITY * delta
		move_and_slide()
		
		if is_on_floor() and Input.is_action_just_pressed("ui_jump"):
			velocity.y = -600.0
			JUMPRELEASE = true
		
		if Input.is_action_just_released("ui_jump") && JUMPRELEASE && velocity.y < -100.0:
			velocity.y = -100.0
			JUMPRELEASE = false
		
		if is_on_floor():
			if hor_move == -1 && $NodeForStuff/spr.scale.x == 1:
				$NodeForStuff/spr.play("Mach_Turn")
				state = states.machturn
				
			if hor_move == 1 && $NodeForStuff/spr.scale.x == -1:
				$NodeForStuff/spr.play("Mach_Turn")
				state = states.machturn
				
		if not Input.is_action_pressed("ui_shift"):
			state = states.normal
			
		if is_on_wall() and not is_on_floor():
			velocity.y = -abs(MOVESPD)
			$NodeForStuff/spr.play("Climb_Wall")
			state = states.climbwall
			
	if state == states.handstandjump:
		velocity.x = MOVESPD * $NodeForStuff/spr.scale.x
		MOVESPD = move_toward(MOVESPD, 0, 1200.0 * delta)
		velocity.y = 0
		
		move_and_slide()

func _on_spr_animation_looped() -> void:
	if state == states.mach1:
		MOVESPD = 500.0
		print("awesome")
		$NodeForStuff/spr.play("Mach_2")
		state = states.mach2
	if state == states.machturn:
		MOVESPD = 600.0
		print("awesome: Live & Reloaded")
		$NodeForStuff/spr.scale.x = -$NodeForStuff/spr.scale.x
		$NodeForStuff/spr.play("Mach_2")
		state = states.mach2
	if state == states.animation:
		state = states.normal
	if state == states.handstandjump:
		state = states.normal
