extends Node2D
var words = [] #pusta tablica, do której później przypiszemy słowa z wybranego poziomu trudności
var easy = ["Octi", "Kaure", "DAXPL", "ZWOLF", "Unity", "Godot", "Milka", "Danny"] #tablica ze słowami dla poziomu łatwego
var medium = ["Allium", "Chrupeck", "Cosinus", "Misuzu", "Shadow", "Raport", "Blender"]  #tablica ze słowami dla poziomu średniego
var hard = ["Dom Lesterów", "Flappy Octi", "Kharakternik", "Magical Fighter", "Morphology", "Szkoła Octiego", "Myszojeleń"]  #tablica ze słowami dla poziomu trudnego
var letter_field = preload("res://Scenes/letter_field.tscn"); #ładowanie sceny (pola liter), z której później będziemy robić instancje
var heart = preload("res://Scenes/extra_hearts.tscn"); #ładownie sceny (extra hearts), dzięki temu będą mogły spadać serca
@onready var node = get_node("/root/World/Word"); #Pobieramy węzeł, do którego będziemy podłączać instancje letter_field
var letter_field_position = 300; #miejsce pierwszego miejsca na literkę
var field_tab = []; #tablica do przechowywania instancji letter_field - pozwoli to na wpisywanie liter w odpowiednie miejsca
var letter_tab = []; #tablica liter - podzielone wylosowane słowo na literki
var founded = false; #zmienna do sprawdzenia czy gracz znalazł literkę
var good_letters = 0; #ilość dobrych liter (do sprawdzania czy zostało odgadnięte słowo
var bad_in_row = 0; #liczy ilość złych liter z rzędu. odpowiednia ilość daje 50% prawdopodobieństwo na spadnięcie extra heart
var how_many_need = 0; #ile złych liter z rzędu potrzeba - zależne od poziomu trudności
var uncovered_letters = []; #tablica mówiąca o tym, czy dana litera została odkryta - potrzebne do random_letters
var random_letter; #wylosowana litera do ujawnienia po zakupie
@onready var screenSize = get_viewport_rect(); #Pobieramy wymiary ekrany

func _ready():
	SignalManager.introduced_letter.connect(_on_introduced_letter) #podłączamy sygnał mówiący o tym, że została wpisana literka
	SignalManager.extra_heart.connect(_on_extra_heart) #podłączamy sygnał mówiący o tym, że gracz złapał dodatkowe życie
	SignalManager.random_letter.connect(_on_random_letter) #podłączamy sygnał mówiący o tym, że gracz kupił literę
	SignalManager.end.connect(_on_end) #Podłączamy sygnał mówiący o tym, że jest koniec
	VariableManager.bad_letters = 0; #na początku 0 złych liter 
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
		#IF służący do ustwienia spacji pomiędzy słowami
		if(words[random_word][i] == " ") :
			letter_field_instance.get_node("Line").visible = false;
			good_letters += 1;
		uncovered_letters.append(false); #Dołączamy do tablicy wartość false mówiącą o tym, że dana litera nie jest odkryta

func _on_introduced_letter(l) : #Odbieramy sygnał, który jest wysyłany po wpisaniu litery, która nie jest powtórką
	founded = false; #Zakładamy, że litera jest niepoprawna - jeśli tak nie jest to odpowiednio zostanie ustaiony warunek
	#Sprawdzanie czy litera znajduje się w słowie
	for i in range(0,letter_tab.size()) : 
		if(l.to_upper() == letter_tab[i] && uncovered_letters[i] == false) : 
			field_tab[i].get_node("Letter").text = l.to_upper(); #Ustawiamy literkę w odpowiednim miejscu (odpowieniej instacji) słowa
			founded = true; #Warunek mówiący nam o tym, że znalezliśmy dobrą literę
			good_letters+=1; #Gdy litera jest poprawna, to dodajemy ją do licznika "Dobrych liter" 
			bad_in_row = 0; #Ilość złych liter z rzędu zerujemy, ponieważ gracz znalazł dobrą
			SignalManager.money_add.emit(1); #Dodawanie monet po każdej dobrej literce
			uncovered_letters[i] = true; #Gdy gracz zgadnie literkę to ustawiamy true 
			
	if(not(founded)) : #Jeżeli wpisaliśmy złą literkę 
		VariableManager.bad_letters += 1; #Zwiększamy licznik złych liter, używany jest do rysowania odpowiednich części wisielca
		SignalManager.bad_letter.emit(VariableManager.bad_letters) #wysyłamy sygnał mówiący o złej literze z ilością złych liter
		bad_in_row += 1; #inkrementacja ilości złych liter z rzędu
	
	if(good_letters >= letter_tab.size()) : #Sprawdzamy czy ilość dobrych liter jest równa liczbie liter w słowie - jak tak to gracz odgadł słowo
		SignalManager.end.emit(1) #jeżeli liczba liter jest równa liczbie liter w słowie to wysyłamy sygnał mówiący, że gracz wygrał

	#Sprawdzenie czy liczba złych liter z rzędu jest wystarczająca oraz czy nie zostały spełnione warunki zakończenia
	if(bad_in_row == how_many_need and good_letters != letter_tab.size() and VariableManager.bad_letters != 12) :
		#Z prawdopodobieństwem 1/2 zresp spadające dodatkowe życie w losowej pozycji
		if(randf_range(0,1) > 0.5) :
			var heart_instance = heart.instantiate();
			node.add_child(heart_instance);
			heart_instance.position = Vector2(randi_range(0, screenSize.size.x-load("res://Images/Heart.png").get_size().x), 0);
		bad_in_row = 0; 

func _on_extra_heart() :
	VariableManager.bad_letters -= 1; #jeżeli gracz złapał lecące życie to usuwamy jedną część z wisielca

func _on_random_letter() :
	var letter; #zmienna do przechowania wylosowanej literki
	random_letter = randi_range(0, letter_tab.size()-1) #losujemy miejsce losowej literki
	#Ma losować dopóki nie znajdziemy nie odkrytej litery
	while(uncovered_letters[random_letter] == true) :
		random_letter = randi_range(0, letter_tab.size()-1)
	letter = letter_tab[random_letter]; #przypsianie pod litere wylosowanej litery
	#ustawienie wylosowanej litery w odpowiednim miejscu (miejsach)
	for i in range(0,letter_tab.size()) :
		if(letter == letter_tab[i]) :
			field_tab[i].get_node("Letter").text = letter.to_upper();
			good_letters += 1; #zwiększanie liczby dobrych liter - skoro ujawnione to gracz nie musi jej zgadywać
			uncovered_letters[i] = true #przypisujemy true, ponieważ dana litera została odkryta
		
	SignalManager.drawn_letter.emit(letter); #Emitujemy sygnał z wylosowaną literą, ponieważ chcemy dodać ją do listy wykorzystanych liter
	
	if(good_letters == letter_tab.size()) : #Sprawdzamy czy ilość dobrych liter jest równa liczbie liter w słowie - jak tak to gracz odgadł słowo
		SignalManager.end.emit(1) 
	
#Funkcja służąca uzupełnieniu słowa w momencie, gdy gracz przegrał - chcemy pokazać co to było za słowo 
func _on_end(win_or_lose) :
	if(win_or_lose == 0) :
		for i in range(0,letter_tab.size()) :
			if(uncovered_letters[i] == false) :
				field_tab[i].get_node("Letter").text = letter_tab[i];
