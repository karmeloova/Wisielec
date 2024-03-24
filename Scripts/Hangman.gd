extends Node2D
#Wszystkie elementy wisielca do tabilcy - ułatwi to "rysowanie" go
@onready var part_tab = [0, get_node("LeftStand"), get_node("RightStand"), get_node("Column"), get_node("Top"), get_node("Curve"), get_node("Line"), get_node("Head"), get_node("Body"), get_node("LeftHand"), get_node("RightHand"), get_node("LeftLeg"), get_node("RightLeg")];
var bad_letters; #zmienna, która umożliwi zapisanie ilości złych liter i przeniesienie ich do funkcji _on_catched_heart w celu ustawienia ostatniej części wisielca na niewidoczny

func _ready():
	SignalManager.bad_letter.connect(_on_bad_letter) #podłączamy sygnał mówiący o tym, że gracz wpisał złą literkę
	SignalManager.catched_heart.connect(_on_catched_heart)

func _on_bad_letter(howMany) : #funkcja, która wykonuje się w momencie otrzymania sygnału o złej literce - otrzymujemy parametr howMany mówiący o tym, ile złych literek wprowadził gracz do tego momentu 
	if(howMany <= 12) : part_tab[howMany].visible = true; #w zależności od ilości ustawiamy odpowiednią część na widoczną - gdy gracz wpisze 1 to pokazuje się pierwsza część, potem gdy 2 to druga - nie ma nigdzie ustawianej niewidoczności, zatem możemy odkrywać po jednej części, a reszta zostaje widoczna
	if(howMany == 12) : SignalManager.end.emit(0); #Gdy ilość złych literek osiągnie 12 (tyle jest elementów) to emitujemy sygnał end z paremetrem 0, który informuje o porażce gracza
	bad_letters = howMany;

func _on_catched_heart() :
	if(bad_letters>0) : part_tab[bad_letters].visible = false;
