extends Node
#----------SKRYPT DO PRZECHOWYWANIA ZMIENNYCH (AUTOŁADOWANY)-----------
#Potrzebny np. w momencie, gdy chcemy przekazać zmienną z jednej sceny do drugiej, podczas gdy tamta jeszcze nie została załadowana

var ind; #zmienna służąca do przechowania wyboru poziomu trudności
var money=0; #Do przechowywania monet po ukończonym poziomie
var extra_life_price = 10;
var random_letter_price = 10;
var bad_letters = 0;
var extra_time_price = 10;


func _ready():
	SignalManager.difficulty_level.connect(_on_difficulty_level) #podłączmy sygnał wysyłany gdy gracz wybierze poziom trudności
	SignalManager.money_add.connect(_on_money_add)
	
func _on_difficulty_level(index) :
	ind = index; #do zmiennej ze skryptu przypisujemy poziom trudności - dzięki temu będziemy mogli się do tego odwołać w dowolnym miejscu w projekcie

#Funkcja służąca zwiększaniu ilości monet
func _on_money_add(howMany) :
	money += howMany
