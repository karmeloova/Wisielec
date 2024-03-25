extends Node2D

func _ready():
	#Ustawienie ceny produktów 
	$"ItemList/ExtraLife/Price".text = str(VariableManager.extra_life_price) 
	$"ItemList/RandomLetter/Price".text = str(VariableManager.random_letter_price)
	$"ItemList/ExtraTime/Price".text = str(VariableManager.extra_time_price)
	#Podłączenie sygnału mówiącego o tym, że dodajemy monety
	SignalManager.money_add.connect(_on_money_add) 
	#Sprawdzamy, czy stać nas na daną rzecz, jak nie to nie ma możliwości jej kupienia (przycisk nieaktywny)
	if(VariableManager.money < VariableManager.extra_life_price) : 
		$"ItemList/ExtraLife/ELBuyButton".disabled = true;
	if(VariableManager.money < VariableManager.random_letter_price) : 
		$"ItemList/RandomLetter/RLBuyButton".disabled = true;
	if(VariableManager.money < VariableManager.extra_time_price) :
		$"ItemList/ExtraTime/ETBuyButton".disabled = true;

func _on_shop_button_pressed():
	#"Otwarcie" sklepu
	$ItemList.visible = true;
	$BackButton.visible = true;

func _on_back_button_pressed():
	#"Zamknięcie" sklepu
	$ItemList.visible = false;
	$BackButton.visible = false;

func _on_money_add(a) :
	#Sprawdzamy czy po dodaniu monety jest nas na coś stać
	if(VariableManager.money >= VariableManager.extra_life_price) : $"ItemList/ExtraLife/ELBuyButton".disabled = false;
	else : $"ItemList/ExtraLife/ELBuyButton".disabled = true;
	if(VariableManager.money >= VariableManager.random_letter_price) : $"ItemList/RandomLetter/RLBuyButton".disabled = false;
	else : $"ItemList/RandomLetter/RLBuyButton".disabled = true;
	if(VariableManager.money >= VariableManager.extra_time_price) : $"ItemList/ExtraTime/ETBuyButton".disabled = false;
	else : $"ItemList/ExtraTime/ETBuyButton".disabled = true;

func _on_rl_buy_button_pressed():
	#Kupienie randomowej literki
	SignalManager.money_add.emit(-VariableManager.random_letter_price)
	VariableManager.random_letter_price *= 2; #zwiększamy cene dwukrotnie
	SignalManager.random_letter.emit();
	$"ItemList/RandomLetter/Price".text = str(VariableManager.random_letter_price)

func _on_el_buy_button_pressed():
	#Kupienie dodatkowego życia
	SignalManager.money_add.emit(-VariableManager.extra_life_price)
	VariableManager.extra_life_price *= 2; #zwiększamy cene dwukrotnie
	SignalManager.extra_heart.emit()
	$"ItemList/ExtraLife/Price".text = str(VariableManager.extra_life_price)

func _on_et_buy_button_pressed():
	#Kupienie dodatkowego czasu (5s)
	SignalManager.money_add.emit(-VariableManager.extra_time_price)
	VariableManager.extra_time_price *= 2; #zwiększamy cene dwukrotnie
	SignalManager.extra_time.emit();
	$"ItemList/ExtraTime/Price".text = str(VariableManager.extra_time_price)
	
