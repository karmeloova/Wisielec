extends Node2D
var time = 11;
var end = false;
var bad_letter = false;
# Called when the node enters the scene tree for the first time.
func _ready():
	#Podłączenie potrzebnych sygnałów
	SignalManager.introduced_letter.connect(_on_introduced_letter)
	SignalManager.end.connect(_on_end)
	SignalManager.bad_letter.connect(_on_bad_letter)
	SignalManager.extra_time.connect(_on_extra_time);
	$TimerLabel.text = "Czas: " + str(time);
	$LetterTimer.start(time);
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Odliczanie czasu
	$TimerLabel.text = "Czas: " + str(int($LetterTimer.time_left));

func _on_introduced_letter(l) :
	#Gdy wprowadziliśmy poprawną literę timer się resetuje
	if(bad_letter == false) :
		$LetterTimer.start(time)
	bad_letter = false;
	
func _on_letter_timer_timeout():
	#W momencie upłynięcia czasu tracimy życie
	if(end==false) :
		VariableManager.bad_letters +=1;
		SignalManager.bad_letter.emit(VariableManager.bad_letters);
		$LetterTimer.start(time);

func _on_end(x) :
	end = true;
	$LetterTimer.stop();

#Sprawdzamy czy wprowadzona literka jest zła
func _on_bad_letter(l) :
	bad_letter = true;

#Gdy gracz kupi dodatkowy czas to dodajemy go do pozostałego
func _on_extra_time() :
	$LetterTimer.start($LetterTimer.time_left + 5);
