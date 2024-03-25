extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.money_add.connect(_on_money_add) #Podłączmy sygnał mówiący o tym, że mamy dodać monety
	$MoneyLabel.text = "Monety: " + str(VariableManager.money); #Zapisanie liczby moment na początku (0)

func _on_money_add(howmany) :
	$MoneyLabel.text = "Monety: " + str(VariableManager.money); #Za każdym razem gdy będzie sygnał zmieniamy liczbę monet

