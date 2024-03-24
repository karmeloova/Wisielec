extends Node
signal introduced_letter(l); #Sygnał mówiący, że została wpisana litera i przekazuje te litere
signal bad_letter(howMany) #Sygnał mówiący o tym, że została wpisana zła litera (jako parametr - ile tych liter)
signal difficulty_level(index) #Sygnał mówiący o tym, jaki poziom trudności został wybrany (index)
signal end(lose_or_win) #Sygnał mówiący o tym, że gra została zakończona i przekazuje jej rezultat (win_or_lose)
signal catched_heart() #Sygnał mówiący o tym, że złapano serce
signal money_add(howManyMoney)
signal random_letter();
