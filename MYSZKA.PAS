Unit myszka;


interface {czesc opisowa}

  uses crt,dos,graph;   { deklaracja innych bibliotek przez nas uzywanych }
  var                   { deklaracja zmiennych i ich typu                 }
    rrr:registers;

{zapowiedz wszystkich funkcji i procedur wystapujacych w tej bibliotece}
  function jest :boolean;                 { sprawdzajaca obecnosc myszki        }
  function przycisk1 :boolean;            { czy nacisnieto lewy przycisk myszki }
  function przycisk2 :boolean;            { czy nacisnieto prawy przycisk myszki}
  procedure pokaz;                        { pokazujaca kursor myszki            }
  procedure ukryj;                        { ukrywajaca kursor myszki            }
  procedure ustaw(x,y: integer);          { ustawiajaca kursor w punkcie (x,y)  }
  procedure pozycja(var x,y:integer);     { odczytujaca pozycje kursora myszki  }



implementation {opis funkcji i procedur}

{--Sprawdzajaca-obecnosc-myszki---------------------------------------------}
Function jest :boolean;
  begin                            {wywolujemy przerwanie nr 33H z wartoscia}
    rrr.ax:=$00; intr($33,rrr);                           {00 w rejestrze ax}
    if rrr.ax=0 then jest:=false                    {badanie czy jest myszka}
      else jest:=true;
end;

{--Czy-nacisnieto-lewy-przycisk-myszki--------------------------------------}
Function przycisk1 :boolean;
  begin                            {wywolujemy przerwanie nr 33H z wartoscia}
    rrr.ax:=$03; intr($33,rrr);                           {03 w rejestrze ax}
    if rrr.bx=1 then przycisk1:=true                  {badanie czy wcisnieto}
      else przycisk1:=false;                            {lewy przycisk myszy}
  end;

{--Czy-nacisnieto-prawy-przycisk-myszki-------------------------------------}
Function przycisk2 :boolean;
  begin                            {wywolujemy przerwanie nr 33H z wartoscia}
    rrr.ax:=$03; intr($33,rrr);                           {03 w rejestrze ax}
    if rrr.bx=2 then przycisk2:=true                  {badanie czy wcisnieto}
      else przycisk2:=false;                           {prawy przycisk myszy}
end;

{--Jakie-pozycja-kursora-na-ekranie-----------------------------------------}
Procedure pozycja(var x,y:integer);
  begin
    rrr.ax:=$03; intr($33,rrr);    {wywolujemy przerwanie nr 33H z wartoscia}
    x:=rrr.cx;                                            {03 w rejestrze ax}
    y:=rrr.dx;                              {pozycja x - wartosc rejestru cx}
  end;                                      {pozycja y - wartosc rejestru yx}

{--Pokazanie-kursora-myszki-------------------------------------------------}
Procedure pokaz;
  begin                            {wywolujemy przerwanie nr 33H z wartoscia}
    rrr.ax:=$01; intr($33,rrr);                           {01 w rejestrze ax}
  end;

{--Ukrycie-kursora-myszki---------------------------------------------------}
Procedure ukryj;
  begin                            {wywolujemy przerwanie nr 33H z wartoscia}
    rrr.ax:=$02;intr($33,rrr);                            {02 w rejestrze ax}
  end;

{--Ustawienie-kursora-myszki-w-punkcie-(x,y)--------------------------------}
Procedure ustaw(x,y: integer);
  begin                            {wywolujemy przerwanie nr 33H z wartoscia}
    rrr.ax:=$04;                                          {04 w rejestrze ax}
    rrr.cx:=x;                          {wartosc rejestru cx - wspolrzedna x}
    rrr.dx:=y;                          {wartosc rejestru dx - wspolrzedna y}
    intr($33,rrr);
  end;
begin
end.