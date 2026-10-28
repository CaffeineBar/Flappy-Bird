extends CharacterBody2D

const GRAVITASI: int = 1000
const VELOSITI_MAKSIMAL: int = 600
const KECEPATAN_FLAP: int = -350
var terbang: bool = false
var jatuh: bool = false
const POS_MULAI = Vector2(100, 324)

func _ready() -> void:
	reset()

func reset() -> void:
	jatuh = false
	terbang = false
	position = POS_MULAI
	set_rotation(0)

func _physics_process(delta: float) -> void:
	if terbang or jatuh:
		velocity.y += GRAVITASI * delta
		if velocity.y > VELOSITI_MAKSIMAL:
			velocity.y = VELOSITI_MAKSIMAL
		if terbang:
			set_rotation(deg_to_rad(velocity.y * 0.05))
			$AnimatedSprite2D.play()
		elif jatuh:
			set_rotation(PI/2)
			$AnimatedSprite2D.stop()
		move_and_collide(velocity * delta)
	else:
		$AnimatedSprite2D.stop()

func flap() -> void:
	velocity.y = KECEPATAN_FLAP
