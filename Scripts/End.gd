extends Node2D

func _ready():
	SignalManager.end.connect(_on_end) #podłączamy sygnał "end" mówiący o zakończniu rozgrywki
	visible = false; #skrypt ładuje się na początku, gdzie nie jest nam potrzebny panel zakończenia rozgrywki

func _on_end(win_or_lose) : #funkcja, która zostaje wykonana, gdy zostanie emitowany sygnał "end" z paremetrem informującym o rezultacie 
	#Sprawdzanie, czy gracz przegrał (0) czy wygrał (1) i ustawienie odpowiedniego napisu na EndLabel
	match win_or_lose :
		0: $EndLabel.text = "Przegrales"
		1: $EndLabel.text = "Wygrales";
	visible = true; #po otrzymaniu sygnału i ustawieniu odpowiedniego tekstu możemy pokazać nasz panel

func _on_restart_button_pressed(): #W momencie gdy gracz wciśnie przycisk
	get_tree().change_scene_to_file("res://Scenes/start_screen.tscn") #zmień scene na ekran początkowy
