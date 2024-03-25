extends Area2D
var speed = 200;
var i = 0;


func _process(delta):
	position.y += speed*delta; #ruch serca

func _on_input_event(viewport, event, shape_idx):
	#moment złapania serca (i jest flagą, ponieważ czasem czytało kilkukrotne kliknięcia)
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and i==0) :
		i+=1; 
		SignalManager.extra_heart.emit() #emitujemy sygnał mówiący o tym, że mamy dodatkowe serce
		queue_free(); #Po złapaniu zwalniamy pamięć


func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	queue_free(); #Po zderzeniu z podłogą (jedyne area2D, zatem brak konieczności sprawdzania czy to to) zwalniamy pamięć
