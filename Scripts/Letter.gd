extends Node2D
var used_letter_tab = []; #tablica wpisanych liter
var used_letter = false; #zmienna służąca do oznaczania czy dana literka została już użyta 

func _ready():
	SignalManager.end.connect(_on_end) #podłączamy sygnał mówiący o tym, że gra się zakończyła
	$LetterBox.begin_complex_operation();

func _on_text_edit_text_changed():
	if($LetterBox.text.length() == 1) : $LetterBox.editable = false; #w momencie wpisania jednej literki zostaje zablokowana możliwość wpisania większej ilości - w wisielcu podaje się po jednej literce

func _input(event):
	if(Input.is_key_pressed(KEY_BACKSPACE)) : #jeżeli został naciśnięty przycisk backspace
		$LetterBox.begin_complex_operation(); 
		$LetterBox.editable = true; #gdy osoba naciśnie backspace dostaje możliwość poprawienia swojego wyboru - zarazem literka jest usuwana i ma możliwość ponownego wpisania
	
	
	if($LetterButton.is_pressed() and $LetterBox.text.length() == 1)  :
		used_letter = false; #Zakładamy, że dana literka nie została użyta
		#Pętla do przeszukiwania użytych liter
		for i in range(0, used_letter_tab.size()) :
			#Jeżeli znajdziemy wpisaną literkę w tablicy użytych liter, to zmienną ustawiamy na true
			if($LetterBox.text.to_upper() == used_letter_tab[i]) : used_letter = true;
		#Jeżeli nie znaleźliśmy literki w tablicy użytych liter
		if(not(used_letter)) : 
			SignalManager.introduced_letter.emit($LetterBox.text.to_upper()); #wysyłamy sygnał informujący, że została wprowadzona litera, jednocześnie przekazując te literkę
			used_letter_tab.append($LetterBox.text.to_upper()); #dołączamy te literkę do tablicy użytych liter
			$UsedLettersLabel.text += $LetterBox.text.to_upper() + ", " #Zapisujemy literkę na scenie w polu, by gracz mógł kontrolować jakie literki użył
			
		$LetterBox.clear(); #czyścimy textbox robiąc miejsce na kolejną literkę
		$LetterBox.editable = true; #ponownie dajemy możliość wpisywania liter
		$LetterBox.begin_complex_operation();

func _on_end(win_or_lose) :
	$LetterButton.disabled = true; #w momencie gdy gra się zakończyła, ustawiamy przycisk na nieaktywny - dzieki temu nie można wpisywać kolejnych liter
