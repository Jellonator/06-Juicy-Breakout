extends Camera2D

export var decay_rate = 1.5
export var max_offset = 16
 
var _trauma
 
func _ready():
	_trauma = 0.0

func add_trauma(amount):
	_trauma = min(_trauma + amount, 1)
 
func _process(delta):   
	if _trauma > 0:
		_decay_trauma(delta)
		_apply_shake()
	   
func _decay_trauma(delta):
	var change = decay_rate * delta * (_trauma + 0.1)
	_trauma = max(_trauma - change, 0)
 
func _apply_shake():
	var shake = _trauma
	var o_x = max_offset * shake * _get_neg_or_pos_scalar()
	var o_y = max_offset * shake * _get_neg_or_pos_scalar()
	offset = Vector2(o_x, o_y)
 
func _get_neg_or_pos_scalar():
	return rand_range(-1.0, 1.0)
