extends Area2D
var speed = 200;
var i = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += speed*delta;

func _on_input_event(viewport, event, shape_idx):
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and i==0) :
		print(i)
		i+=1;
		SignalManager.catched_heart.emit()
		queue_free();


func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	queue_free();
