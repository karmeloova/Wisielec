extends Node2D
var extra_life_price = 10;
var random_letter_price = 15;

func _ready():
	$"ItemList/ExtraLife/Price".text = str(extra_life_price)
	SignalManager.money_add.connect(_on_money_add)
	if(VariableManager.money < extra_life_price) : 
		$"ItemList/ExtraLife/ELBuyButton".disabled = true;
	if(VariableManager.money < random_letter_price) : 
		$"ItemList/RandomLetter/RLBuyButton".disabled = true;

func _on_shop_button_pressed():
	$ItemList.visible = true;
	$BackButton.visible = true;

func _on_back_button_pressed():
	$ItemList.visible = false;
	$BackButton.visible = false;

func _on_el_buy_button_pressed():
	SignalManager.money_add.emit(-10)
	SignalManager.catched_heart.emit()
	
func _on_money_add(a) :
	if(VariableManager.money >= extra_life_price) : $"ItemList/ExtraLife/ELBuyButton".disabled = false;
	else : $"ItemList/ExtraLife/ELBuyButton".disabled = true;
	if(VariableManager.money >= random_letter_price) : $"ItemList/RandomLetter/RLBuyButton".disabled = false;
	else : $"ItemList/RandomLetter/RLBuyButton".disabled = true;
	

func _on_rl_buy_button_pressed():
	SignalManager.money_add.emit(-15)
	SignalManager.random_letter.emit();
