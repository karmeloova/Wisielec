extends Node2D
var ind = 0; #Wybrana opcja - początkowo 0 ponieważ domyślnie jest ustawiony na "Wybierz"

func _ready():
	#Dodawanie opcji do "OptionButton"
	$DifficultyLevel.add_item("Wybierz...", 0)
	$DifficultyLevel.add_item("Łatwy", 1)
	$DifficultyLevel.add_item("Średni", 2)
	$DifficultyLevel.add_item("Trudny", 3)

func _on_start_button_pressed():
	if(ind > 0) : get_tree().change_scene_to_file("res://Scenes/world.tscn") #gdy gracz wybierze oraz to co wybrał nie jest zerem, wtedy można rozpocząć grę

func _on_difficulty_level_item_selected(index):
	ind = index; #przypisanie w celu użycia w funkcji wyżej
	SignalManager.difficulty_level.emit(index) #wysyłamy sygnał zawierający poziom trduności
