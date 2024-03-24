extends Node2D
var words = [] #pusta tablica, do której później przypiszemy słowa z wybranego poziomu trudności
var easy = ["Kotlet", "Zegar", "Jabłko", "Krzesło", "Kaczka"] #tablica ze słowami dla poziomu łatwego
var medium = ["Przestrzeń", "Truskawka", "Koncentracja", "Harmonijka", "Wytrwałość"]  #tablica ze słowami dla poziomu średniego
var hard = ["Kontrrewolucjonista", "Minimalistyczny", "Sentymentalny", "Idealistyczny", "Introwertyczny"]  #tablica ze słowami dla poziomu trudnego
var letter_field = preload("res://Scenes/letter_field.tscn"); #ładowanie sceny (pola liter), z której później będziemy robić instancje
var heart = preload("res://Scenes/extra_hearts.tscn"); #ładownie sceny (extra hearts), dzięki temu będą mogły spadać serca
@onready var node = get_node("/root/World/Word"); #Pobieramy węzeł, do którego będziemy podłączać instancje letter_field
var letter_field_position = 300; #miejsce pierwszego miejsca na literkę
var field_tab = []; #tablica do przechowywania instancji letter_field - pozwoli to na wpisywanie liter w odpowiednie miejsca
var letter_tab = []; #tablica liter - podzielone wylosowane słowo na literki
var founded = false; #zmienna do sprawdzenia czy gracz znalazł literkę
var bad_letters = 0; #ilość złych liter (do wisielca)
var good_letters = 0; #ilość dobrych liter (do sprawdzania czy zostało odgadnięte słowo
var bad_in_row = 0; #liczy ilość złych liter z rzędu. odpowiednia ilość daje 50% prawdopodobieństwo na spadnięcie extra heart
var how_many_need = 0; #ile złych liter z rzędu potrzeba - zależne od poziomu trudności
var uncovered_letters = [];
@onready var screenSize = get_viewport_rect();

func _ready():
	SignalManager.introduced_letter.connect(_on_introduced_letter) #podłączamy sygnał mówiący o tym, że została wpisana literka
	SignalManager.catched_heart.connect(_on_catched_heart) #podłączamy sygnał mówiący o tym, że gracz złapał dodatkowe życie
	SignalManager.random_letter.connect(_on_random_letter)
	#sprawdzamy, jaki poziom trudności wybrał gracz i w zależności od tego ustawiamy odpowiednio zmienne
	match VariableManager.ind: 
		1: 
			words = easy;
			how_many_need = 2;
		2: 
			words = medium;
			how_many_need = 3;
		3: 
			words = hard;
			how_many_need = 4;
	print(words)
	prepare_word(); #funkcja do przygotowania słowa - ustawienia kresek, podzielenia go na literki
	
func prepare_word() : #Funkcja, która "przygotowuje" wybrane słowo
	var random_word = randi_range(0,words.size()-1); #losowanie słowa
	for i in range(0, words[random_word].length()) : #tworzenie miejsc na litery
		var letter_field_instance = letter_field.instantiate(); #Tworzymy instancję letter_field
		field_tab.append(letter_field_instance) #Dodajemy do tablice instancję letter_field - potrzebne do sprawdzania liter
		letter_tab.append(words[random_word][i].to_upper()) #Towrzenie tablicy z literkami wylosowanego słowa - również potrzebne do sprawdzania liter, to_upper() w celu ujednolicenia wielkości wszystkich liter
		node.add_child(letter_field_instance); #dodawanie instancji obiektu do sceny głównej
		letter_field_instance.position = Vector2(letter_field_position, 75) #ustawianie pozycji instancji obiektu
		letter_field_position += 50; #dodawanie do poprzedniej pozycji 50 pikseli - w celu ładnego ustawienia obok siebie
		uncovered_letters.append(false);

func _on_introduced_letter(l) : #Odbieramy sygnał, który jest wysyłany po wpisaniu litery, która nie jest powtórką
	founded = false; #Zakładamy, że litera jest niepoprawna - jeśli tak nie jest to odpowiednio zostanie ustaiony warunek
	#Sprawdzanie czy litera znajduje się w słowie
	for i in range(0,letter_tab.size()) : 
		if(l.to_upper() == letter_tab[i]) : 
			field_tab[i].get_node("Letter").text = l.to_upper(); #Ustawiamy literkę w odpowiednim miejscu (odpowieniej instacji) słowa
			founded = true; #Warunek mówiący nam o tym, że znalezliśmy dobrą literę
			good_letters+=1; #Gdy litera jest poprawna, to dodajemy ją do licznika "Dobrych liter" 
			bad_in_row = 0;
			SignalManager.money_add.emit(1);
			uncovered_letters[i] = true;
			
	if(not(founded)) : #Jeżeli wpisaliśmy złą literkę 
		bad_letters += 1; #Zwiększamy licznik złych liter, używany jest do rysowania odpowiednich części wisielca
		SignalManager.bad_letter.emit(bad_letters) #wysyłamy sygnał mówiący o złej literze z ilością złych liter
		bad_in_row += 1;
	
	if(good_letters == letter_tab.size()) : #Sprawdzamy czy ilość dobrych liter jest równa liczbie liter w słowie - jak tak to gracz odgadł słowo
		SignalManager.end.emit(1) #jeżeli liczba liter jest równa liczbie liter w słowie to wysyłamy sygnał mówiący, że gracz wygrał

	if(bad_in_row == how_many_need and good_letters != letter_tab.size() and bad_letters != 12) :
		if(randf_range(0,1) > 0.5) :
			var heart_instance = heart.instantiate();
			node.add_child(heart_instance);
			heart_instance.position = Vector2(randi_range(0, screenSize.size.x-load("res://Images/Heart.png").get_size().x), 0);
		bad_in_row = 0;

func _on_catched_heart() :
	bad_letters -= 1; #jeżeli gracz złapał lecące życie to usuwamy jedną część z wisielca

func _on_random_letter() :
	print(uncovered_letters);

#TO-DO LISTA 
#-ekonomia - zdobywasz monety za co drugą (easy) co trzecią (medium) i co czwartą (hard) poprawną literę - za iles monet możesz kupić jedną losową literę ze słowa - podawajane za każdym razem, za więcej np słowo całe
#maybe timer 
