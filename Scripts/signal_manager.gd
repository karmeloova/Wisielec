extends Node
signal introduced_letter(l); #Sygnał mówiący, że została wpisana litera i przekazuje te litere
signal bad_letter(howMany) #Sygnał mówiący o tym, że została wpisana zła litera (jako parametr - ile tych liter)
signal difficulty_level(index) #Sygnał mówiący o tym, jaki poziom trudności został wybrany (index)
signal end(lose_or_win) #Sygnał mówiący o tym, że gra została zakończona i przekazuje jej rezultat (win_or_lose)
signal extra_heart() #Sygnał mówiący o tym, że złapano serce
signal money_add(howManyMoney) #Sygnał mówiący o tym, że stan konta został zmieniony
signal random_letter(); #Sygnał mówiacy o tym, że kupiiśmy losową literkę
signal drawn_letter(letter) #Sygnał używany do przesłania wylosowanej literki po zakupie w sklepie do tablicy użytych liter 
signal extra_time(); #Sygnał mówiący o tym, że kupiliy dodatkowy czas
