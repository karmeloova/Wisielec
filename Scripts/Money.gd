extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.money_add.connect(_on_money_add)
	$MoneyLabel.text = "Monety: " + str(VariableManager.money);

func _on_money_add(howmany) :
	$MoneyLabel.text = "Monety: " + str(VariableManager.money);

