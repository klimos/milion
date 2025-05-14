{                            MILIONERZY                         }
{               Program zaliczeniowy z Turbo Pascala            }
{                  wykonany przez Michala Klimka                }
{               na podstawie teleturnieju Milionerzy            }


Program Milionerzy;

  uses
    Crt,Graph,Myszka;

  type
    zagadka=record
              tresc:string;
              odp_a:string;
              odp_b:string;
              odp_c:string;
              odp_d:string;
              odpowiedz:char;
              wartosc:1..15;
            end;

  const
    delanim=50;            {'Delay' dla animacji}
    delgra=3000;           {'Delay' dla ekranow w grze}

  var
    pytanie :zagadka;
    zestaw :file of zagadka;
    karta,tryb :integer;
    x,y:integer;           {pozycja myszki}

{menu poczatkowe}
    podswietl :0..3;
{wpisywanie pytan}
    poz:byte;                {pozycja belki - stopien trudnosci pytania}
    odpow:char;              {prawidlowa odpowiedz - zamiana malych liter na duze}
{gra}
    mozliwe_telefon:boolean;       {czy uzyto tego kola ratunkowego}
    mozliwe_publicznosc:boolean;   {czy uzyto tego kola ratunkowego}
    mozliwe_pol_na_pol:boolean;    {czy uzyto tego kola ratunkowego}
    mozliwe_a:boolean;             {czy mozna zaznaczyc odpowiedz a}
    mozliwe_b:boolean;             {czy mozna zaznaczyc odpowiedz b}
    mozliwe_c:boolean;             {czy mozna zaznaczyc odpowiedz c}
    mozliwe_d:boolean;             {czy mozna zaznaczyc odpowiedz d}
    odp:char;              {wybrana odpowiedz}
    wart:0..15;            {licznik - o jaka sume toczy sie gra}
    wwygranej:string;      {wartosc wygranej - przy rezygnacji}
{animacje}
    wx,                    {wartosc wspolrzednej poziomej ludzika}
    wy,                    {wartosc wspolrzednej pionowej ludzika}
    wxs:integer;           {wartosc wspolrzednej poziomej samolotu}



{--Definicje procedur-------------------------------------------------------}
{---------------------------------------------------------------------------}
{---------------------------------------------------------------------------}


{--Procedury-animacji-poczatkowej-------------------------------------------}
{--Samolot-z-transparentem--------------------------------------------------}
Procedure samolot_prawy(x:integer);

  begin
{samolot}
     SetColor(7);                              {jasnoszary kolor linii}
     SetLineStyle(0,0,0);                      {cienka linia}
    Ellipse(x,25,180,286,50,25);              {dol}
    Arc(x-45,25,20,180,5);                    {ogon}
    Ellipse(x-32,15,215,270,10,15);           {gora - tyl}
    Ellipse(x-32,35,30,90,10,5);              {gora - srodek}
    Ellipse(x-18,30,210,330,6,4);             {wglebienie}
    Ellipse(x-19,32,180,360,8,5);             {linia wglebienia}
    Line(x-12,31,x+12,33);                    {gora - przod2}
    Ellipse(x+13,41,0,360,1,7);               {przod}
    Line(x-47,33,x-52,35);                    {linia gorna silnika}
    Line(x-43,38,x-52,35);                    {linia dolna silnika}
    Arc(x-6,51,140,20,3);                     {przednie kolo samolotu}
    Ellipse(x-38,42,90,340,2,1);              {tylnie kolo samolotu}

     SetFillStyle(1,12);                       {jasnoczerwony kolor wypelnienia}
    FloodFill(x+11,40,7);                     {wypelnienie kadluba - jasnoczerwone - (przod)}
    FloodFill(x-49,25,7);                     {wypelnienie kadluba - jasnoczerwone - (tyl)}
     SetFillStyle(1,4);                        {czerwony kolor wypelnienia}
    FloodFill(x-12,32,7);                     {wypelnienie wglebienia - czerwone - (przod)}
    FloodFill(x-26,32,7);                     {wypelnienie wglebienia - czerwone - (tyl)}
     SetFillStyle(1,7);                        {jasnoszary kolor wypelnienia}
    FloodFill(x-38,42,7);                     {wypelnienie tylniego kola samolotu - jasnoszare - (tyl)}
    FloodFill(x-4,51,7);                      {wypelnienie przedniego kola samolotu - jasnoszare - (przod)}
    FloodFill(x-8,51,7);                      {wypelnienie przedniego kola samolotu - jasnoszare - (przod)}
     SetFillStyle(1,15);                       {bialy kolor wypelnienia}
    FloodFill(x+13,41,7);                     {wypelnienie dziobu - biale}

    Line(x+15,37,x+15,45);                    {linia na dziobie}
    Line(x+15,39,x+17,41);                    {dziobek od smigielka - gora}
    Line(x+15,43,x+17,41);                    {dziobek od smigielka - dol}
    Circle(x-45,25,3);                        {kolko na ogonie}
     SetColor(15);
    FillEllipse(x-41,35,2,2);                 {silnik tylni}
    Line(x-41,33,x-50,35);                    {silnik tylni - gora}
    Line(x-41,37,x-50,35);                    {silnik tylni - dol}
    FillEllipse(x+5,31,3,3);                  {silnik gorny}
    Line(x+5,28,x-8,31);                      {silnik gorny - gora}
    Line(x+5,34,x-8,31);                      {silnik gorny - dol}
    FillEllipse(x+5,44,3,3);                  {silnik dolny}
    Line(x+5,41,x-8,44);                      {silnik dolny - gora}
    Line(x+5,47,x-8,44);                      {silnik dolny - dol}
     SetColor(7);
    Ellipse(x+19,41,0,360,1,10);              {slad smigla - kolo male}
    Line(x+19,31,x+19,28);                    {slad smigla malego - linia gorna}
    Line(x+19,51,x+19,54);                    {slad smigla malego - linia dolna}

    FloodFill(x-43,25,7);                     {wypelnienie kolka na ogonie - biale - (przod)}
    FloodFill(x-47,25,7);                     {wypelnienie kolka na ogonie - biale - (tyl)}
    FloodFill(x-44,35,15);                    {wypelnienie tylniego silnika - biale - (przod)}
    FloodFill(x-47,35,15);                    {wypelnienie tylniego silnika - biale - (tyl)}
    FloodFill(x+1,31,15);                     {wypelnienie gornego silnika - biale - (przod)}
    FloodFill(x-5,31,15);                     {wypelnienie gornego silnika - biale - (tyl)}
    FloodFill(x+1,44,15);                     {wypelnienie dolnego silnika - biale - (przod)}
    FloodFill(x-5,44,15);                     {wypelnienie dolnego silnika - biale - (tyl)}
     SetFillStyle(1,7);                        {jasnoszary kolor wypelnienia}
    FloodFill(x+16,41,7);                     {wypelnienie dziobka od smigielka - jasnoszare}

    Line(x-5,33,x+3,40);                      {skos \ pomiedzy silnikami}
    Line(x+3,35,x-5,42);                      {skos / pomiedzy silnikami}
    Ellipse(x+19,41,0,360,3,20);              {slad smigla - duze kolo}
    Line(x-6,53,x-50,53);                     {smuga 1}
    Line(x-40,42,x-65,42);                    {smuga 2}
    Line(x-53,22,x-72,22);                    {smuga 3}
    Line(x-49,21,x-69,21);                    {smuga 4}

     SetColor(15);                             {bialy kolor linii}
    Line(x-6,31,x-6,44);                      {polaczenie silnikow - tylnie}
    Line(x+4,34,x+4,41);                      {polaczenie silnikow - przednie}

{napis}
     SetColor(14);                            {zolty kolor linii transparentu}
     SetFillStyle(1,14);                      {zolty kolor wypelnienia transparentu}
    Line(x-52,35,x-100,35);                   {sznurek}
    Line(x-100,35,x-130,2);                   {linka gorna}
    Line(x-100,35,x-130,70);                  {linka dolna}
    Bar(x-625,2,x-130,70);                    {transparent}
     SetTextStyle(4,0,5);                      {gotyk - 5}
     SetTextJustify(1,1);                      {wysrodkowanie tekstu}
     SetColor(1);                              {niebieski kolor napisu}
    OutTextXY(x-375,25,'M I L I O N E R Z Y');
  end;


{--Glowa-i-tulow-ludzika-wyskakujacego-z-samolotu---------------------------}
Procedure ludzik_maly(x,y:integer);

  begin
     SetColor(15);                             {bialy kolor linii}
     SetFillStyle(1,15);                       {bialy kolor wypelnienia}
    FillEllipse(x-19,y+18,3,4);               {glowa}
    FillEllipse(x-19,y+30,4,7);               {tulow}
    Line(x-16,y+18,x-14,y+20);                {nos}
     SetFillStyle(1,15);                       {bialy kolor wypelnienia}
  end;


{--Lewa-reka-opuszczona-----------------------------------------------------}
Procedure reka_lewa_dol(x,y:integer);

  begin
     SetColor(15);                             {bialy kolor linii}
     SetLineStyle(0,0,3);                      {linia pogrubiona}
    Line(x-20,y+23,x-27,y+31);                {lewe ramie}
     SetLineStyle(0,0,0);                      {linia cianka}
    Line(x-28,y+30,x-25,y+37);                {lewy dol reki - zewnatrz}
    Line(x-27,y+30,x-25,y+37);                {lewy dol reki - wewnatrz}
    Line(x-25,y+37,x-27,y+40);                {lewy nadgarstek - zewnatrz}
    Line(x-25,y+37,x-26,y+40);                {lewy nadgarstek - wewnatrz}
  end;


{--Lewa-reka-podniesiona----------------------------------------------------}
Procedure reka_lewa_gora(x,y:integer);

  begin
     SetColor(15);                             {bialy kolor linii}
     SetLineStyle(0,0,3);                      {linia pogrubiona}
    Line(x-22,y+27,x-28,y+18);                {lewe ramie}
     SetLineStyle(0,0,0);                      {linia cienka}
    Line(x-28,y+18,x-25,y+8);                 {lewy dol reki - zewnatrz}
    Line(x-27,y+18,x-25,y+8);                 {lewy dol reki - wewnatrz}
    Line(x-25,y+8,x-27,y+5);                  {lewy nadgarstek - zewnatrz}
    Line(x-25,y+8,x-26,y+5);                  {lewy nadgarstek - wewnatrz}
  end;


{--Prawa-reka-opuszczona----------------------------------------------------}
Procedure reka_prawa_dol(x,y:integer);

  begin
     SetColor(15);                             {bialy kolor linii}
     SetLineStyle(0,0,3);                      {linia pogrubiona}
    Line(x-18,y+24,x-11,y+31);                {prawe ramie}
     SetLineStyle(0,0,0);                      {linia cienka}
    Line(x-11,y+31,x-13,y+38);                {prawy dol reki - zewnatrz}
    Line(x-12,y+31,x-13,y+38);                {prawy dol reki - wewnatrz}
    Line(x-13,y+38,x-11,y+41);                {prawy nadgarstek - zewnatrz}
    Line(x-13,y+38,x-12,y+41);                {prawy nadgarstek - wewnatrz}
  end;


{--Prawa-reka-podniesiona---------------------------------------------------}
Procedure reka_prawa_gora(x,y:integer);
  begin
     SetColor(15);                             {bialy kolor linii}
     SetLineStyle(0,0,3);                      {linia pogrubiona}
    Line(x-17,y+27,x-10,y+18);                {prawe ramie}
     SetLineStyle(0,0,0);                      {linia cienka}
    Line(x-10,y+18,x-13,y+8);                 {prawy dol reki - zewnatrz}
    Line(x-11,y+18,x-13,y+8);                 {prawy dol reki - wewnatrz}
    Line(x-13,y+8,x-11,y+5);                  {prawy nadgarstek - zewnatrz}
    Line(x-13,y+8,x-12,y+5);                  {prawy nadgarstek - wewnatrz}
  end;


{--Noga-lewa-podkurczona----------------------------------------------------}
Procedure noga_lewa_siedzi(x,y:integer);

  begin
     SetColor(15);                             {bialy kolor linii}
     SetLineStyle(0,0,3);                      {linia pogrubiona}
    Line(x-21,y+34,x-23,y+40);                {lewe udo}
     SetLineStyle(0,0,0);                      {linia cienka}
    Line(x-23,y+40,x-21,y+50);                {lewy dol nogi - zewnatrz}
    Line(x-22,y+40,x-21,y+50);                {lewy dol nogi - wewnatrz}
    Line(x-21,y+50,x-25,y+50);                {lewa stopa - zewnatrz}
    Line(x-21,y+50,x-24,y+51);                {lewa stopa - wewnatrz}
  end;


{--Noga-lewa-wyprostowana---------------------------------------------------}
Procedure noga_lewa_stoi(x,y:integer);

  begin
     SetColor(15);                             {bialy kolor linii}
     SetLineStyle(0,0,3);                      {linia pogrubiona}
    Line(x-21,y+34,x-23,y+45);                {lewe udo}
     SetLineStyle(0,0,0);                      {linia cienka}
    Line(x-23,y+45,x-21,y+55);                {lewy dol nogi - zewnatrz}
    Line(x-22,y+45,x-21,y+55);                {lewy dol nogi - wewnatrz}
    Line(x-21,y+55,x-25,y+55);                {lewa stopa - zewnatrz}
    Line(x-21,y+55,x-24,y+56);                {lewa stopa - wewnatrz}
  end;

{--Noga-prawa-podkurczona---------------------------------------------------}
Procedure noga_prawa_siedzi(x,y:integer);

  begin
     SetColor(15);                             {bialy kolor linii}
     SetLineStyle(0,0,3);                      {linia pogrubiona}
    Line(x-17,y+34,x-16,y+39);                {prawe udo}
     SetLineStyle(0,0,0);                      {linia cienka}
    Line(x-15,y+39,x-17,y+49);                {prawy dol nogi - zewnatrz}
    Line(x-16,y+39,x-17,y+49);                {prawy dol nogi - wewnatrz}
    Line(x-17,y+49,x-13,y+50);                {prawa stopa - zewnatrz}
    Line(x-17,y+49,x-14,y+51);                {prawa stopa - zewnatrz}
  end;


{--Noga-prawa-wyprostowana--------------------------------------------------}
Procedure noga_prawa_stoi(x,y:integer);

  begin
     SetColor(15);                             {bialy kolor linii}
     SetLineStyle(0,0,3);                      {linia pogrubiona}
    Line(x-17,y+34,x-16,y+44);                {prawe udo}
     SetLineStyle(0,0,0);                      {linia cienka}
    Line(x-15,y+44,x-17,y+54);                {prawy dol nogi - zewnatrz}
    Line(x-16,y+44,x-17,y+54);                {prawy dol nogi - wewnatrz}
    Line(x-17,y+54,x-13,y+55);                {prawa stopa - zewnatrz}
    Line(x-17,y+54,x-14,y+56);                {prawa stopa - zewnatrz}
  end;


{--Balonik------------------------------------------------------------------}
Procedure balonik(x,y:integer);

  begin
     SetColor(12);                             {jasnoczerwony kolor linii}
     SetFillStyle(1,12);                       {jasnoczerwony kolor wypelnienia}
    Line(x-13,y+9,x-13,y-5);                  {sznureczek}
    FillEllipse(x-13,y-20,9,10);              {balonik}
    Line(x-13,y-10,x-15,y-7);                 {ogonek - lewa}
    Line(x-13,y-10,x-11,y-7);                 {ogonek - prawa}
    Line(x-15,y-7,x-11,y-7);                  {ogonek - dol}
    FloodFill(x-13,y-8,12);                    {wypelnienie ogonka - jasnoczerwone}
  end;


{--Ludzik-przedstawiajacy-dane-o-autorach-----------------------------------}
Procedure ludzik_mowi;

  begin
     SetColor(15);                             {bialy kolor linii}
     SetFillStyle(1,15);                       {bialy kolor wypelnienia}
    FillEllipse(200,330,12,20);               {glowa}
    FillEllipse(200,382,15,30);               {tulow}

    Line(200,354,230,379);                    {ramie lewe - gora}
    Line(200,362,230,383);                    {ramie lewe - dol}
    Line(230,379,245,381);                    {przedramie lewe - gora}
    Line(230,383,245,384);                    {przedramie lewe - dol}
    FillEllipse(250,382,5,3);                 {lewa dlon}
    FloodFill(230,381,15);                    {wypelnienie reki lewej}

    Line(190,359,168,379);                    {ramie lewe - zewnatrz}
    Line(190,367,174,379);                    {ramie lewe - wewnatrz}
    Line(168,379,186,399);                    {przedramie lewe - zewnatrz}
    Line(174,379,189,398);                    {przedramie lewe - wewnatrz}
    Line(186,399,181,406);                    {dlon lewa - zewnatrz}
    Line(189,398,184,410);                    {dlon lewa - wewnatrz}
    Line(181,406,184,410);                    {dlon lewa - czubek}
    FloodFill(183,407,15);                    {wypelnienie dloni lewej}
    FloodFill(170,379,15);                    {wypelnienie reki lewej}

    Line(195,382,184,442);                    {udo lewe - zewnatrz}
    Line(202,382,188,442);                    {udo lewe - wawnatrz}
    Line(184,442,190,472);                    {lydka lewa - zewnatrz}
    Line(187,442,192,472);                    {lydka lewa - wawnatrz}
    Line(190,472,180,477);                    {stopa lewa - gora}
    Line(180,477,183,479);                    {stopa lewa - czubek}
    Line(183,479,192,472);                    {stopa lewa - dol}
    FloodFill(183,478,15);                    {wypelnienie stopy lewej}
    FloodFill(186,442,15);                    {wypelnienie nogi lewej}

    Line(198,372,212,440);                    {udo prawe - wewnatrz}
    Line(206,372,217,440);                    {udo prawe - zewnatrz}
    Line(212,440,208,470);                    {lydka prawa - wewnatrz}
    Line(217,440,210,470);                    {lydka prawa - zewnatrz}
    Line(208,470,217,477);                    {stopa prawa - dol}
    Line(217,477,220,475);                    {stopa prawa - czubek}
    Line(220,475,210,470);                    {stopa prawa - gora}
    FloodFill(217,476,15);                    {wypelnienie stopy prawej}
    FloodFill(215,440,15);                    {wypelnienie nogi prawej}
     SetLineStyle(0,0,3);                      {linia pogrubiona}
    Line(200,330,225,342);                    {nos}
  end;


{--Chmurka,-w-ktorej-pojawiaja-sie-dane-o-autorach--------------------------}
Procedure chmurka;

  begin
    Ellipse(400,300,0,360,120,80);            {"chmurka"}
    Line(230,350,286,330);                    {linia gorna}
    Line(230,350,300,345);                    {linia dolna}
     SetTextJustify(1,1);                      {wysrodkowanie tekstu w chmurce}
     SetTextStyle(0,0,0);                      {normalny rozmiar czcionki}
    OutTextXY(400,260,'Program');
    OutTextXY(400,275,'napisany przez:');
     SetTextStyle(0,0,1);                      {czcionka nieco wieksza}
    OutTextXY(400,300,' Michala Klimka');
     SetTextStyle(0,0,0);                      {normalny rozmiar czcionki}
    OutTextXY(400,325,'wedlug teleturnieju');
    OutTextXY(400,340,'MILIONERZY');
  end;


{==Cala-animacja-poczatkowa=================================================}
Procedure animacja_poczatkowa;

  begin
     SetFillStyle(1,0);
    ClearDevice;
     SetTextJustify(1,1);
    wxs:=-50;wy:=0;

{samolot leci a ludzik spada}
    repeat{samolocik leci z ludzikiem w srodku}
       SetFillStyle(1,0);
      Bar(0,0,639,479);
      samolot_prawy(wxs);
      ludzik_maly(wxs,wy);
      reka_prawa_dol(wxs,wy);
      reka_lewa_dol(wxs,wy);
      delay(delanim);
      wxs:=wxs+2;
    until (wxs=150) or keypressed;

    repeat{ludzik wystawia lewa noge}
       SetFillStyle(1,0);
      Bar(0,0,639,479);
      samolot_prawy(wxs);
      ludzik_maly(wxs,wy);
      reka_prawa_dol(wxs,wy);
      reka_lewa_dol(wxs,wy);
      noga_lewa_siedzi(wxs,wy);
      delay(delanim);
      wxs:=wxs+2;
    until (wxs=170) or keypressed;

    repeat{ludzik wystawia prawa noge}
       SetFillStyle(1,0);
      Bar(0,0,639,479);
      samolot_prawy(wxs);
      ludzik_maly(wxs,wy);
      reka_prawa_dol(wxs,wy);
      reka_lewa_dol(wxs,wy);
      noga_lewa_siedzi(wxs,wy);
      noga_prawa_siedzi(wxs,wy);
      delay(delanim);
      wxs:=wxs+2;
    until (wxs=190) or keypressed;

    wy:=wy+25;
    repeat{ludzik zwisa}
       SetFillStyle(1,0);
      Bar(0,0,639,479);
      samolot_prawy(wxs);
      ludzik_maly(wxs,wy);
      reka_prawa_gora(wxs,wy);
      reka_lewa_gora(wxs,wy);
      noga_lewa_siedzi(wxs,wy);
      noga_prawa_siedzi(wxs,wy);
      delay(delanim);
      wxs:=wxs+2;
    until (wxs=210) or keypressed;

    wx:=wxs;
    repeat{ludzik spada}
       SetFillStyle(1,0);
      Bar(0,0,639,479);
      samolot_prawy(wxs);
      ludzik_maly(wx,wy);
      reka_prawa_gora(wx,wy);
      reka_lewa_gora(wx,wy);
      noga_lewa_stoi(wx,wy);
      noga_prawa_stoi(wx,wy);
      delay(delanim);
      wxs:=wxs+2;
      wy:=wy+5;
    until (wy=175) or keypressed;

    repeat{pojawia sie balonik}
       SetFillStyle(1,0);
      Bar(0,0,639,479);
      samolot_prawy(wxs);
      ludzik_maly(wx,wy);
      reka_prawa_gora(wx,wy);
      reka_lewa_gora(wx,wy);
      noga_lewa_stoi(wx,wy);
      noga_prawa_stoi(wx,wy);
      balonik(wx,wy);
      delay(delanim);
      wxs:=wxs+2;
      wy:=wy+2;
    until (wy=185) or keypressed;

    repeat{leci z balonikiem}
       SetFillStyle(1,0);
      Bar(0,0,639,479);
      samolot_prawy(wxs);
      ludzik_maly(wx,wy);
      reka_prawa_gora(wx,wy);
      reka_lewa_dol(wx,wy);
      noga_lewa_stoi(wx,wy);
      noga_prawa_stoi(wx,wy);
      balonik(wx,wy);
      delay(delanim);
      wxs:=wxs+2;
      wy:=wy+2;
    until (wy=423) or keypressed;

    repeat{ludzik stoi, balonik znika, samolot leci}
       SetFillStyle(1,0);
      Bar(0,0,639,479);
      samolot_prawy(wxs);
      ludzik_maly(wx,wy);
      reka_prawa_dol(wx,wy);
      reka_lewa_dol(wx,wy);
      noga_lewa_stoi(wx,wy);
      noga_prawa_stoi(wx,wy);
      delay(delanim);
      wxs:=wxs+2;
    until (wxs=694) or keypressed;

{ludzik mowi}
     SetFillStyle(1,0);                        {czarny kolor wypelnienia}
    Bar(0,0,639,479);                         {zamazanie ekranu}
     SetColor(10);                             {zielony kolor linii}
     SetFillStyle(1,10);                       {zielony kolor wypelnienia}
    Bar(694-625,2,694-130,70);                {transparent}
     SetTextStyle(4,0,5);                      {gotyk - 5}
     SetTextJustify(1,1);                      {wyrownanie tekstu}
     SetColor(1);                              {niebieski kolor tekstu}
    OutTextXY(694-375,25,'M I L I O N E R Z Y');    {napis - MILIONERZY}
    delay(delanim*10);
    ludzik_mowi;
    delay(delanim*20);
    chmurka;
    delay(delgra);
  end;


{--Procedury-menu-poczatkowego----------------------------------------------}
{==Menu-poczatkowe==========================================================}
Procedure menu;

  begin
    ustaw(320,100);
    pokaz;

     SetColor(10);                             {zielony kolor linii}
     SetTextJustify(1,1);
     SetTextStyle(4,0,6);
    OutTextXY(320,50,'M I L I O N E R Z Y');

     SetColor(14);                             {zolty kolor napisow}
     SetTextStyle(1,0,2);
    OutTextXY(320,200,'ZACZNIJ GRE');
    OutTextXY(320,300,'WPISYWANIE PYTAN');
    OutTextXY(320,400,'WYJSCIE');

    podswietl:=0;
    repeat
      pozycja(x,y);
      if (x>255) and (x<380) and (y>194) and (y<212) then podswietl:=1 else
      if (x>219) and (x<419) and (y>294) and (y<312) then podswietl:=2 else
      if (x>279) and (x<360) and (y>394) and (y<412) then podswietl:=3 else
      podswietl:=0;

       SetTextStyle(1,0,2);
      if podswietl=1 then SetColor(9) else SetColor(14);
      OutTextXY(320,200,'ZACZNIJ GRE');
      if podswietl=2 then SetColor(9) else SetColor(14);
      OutTextXY(320,300,'WPISYWANIE PYTAN');
      if podswietl=3 then SetColor(9) else SetColor(14);
      OutTextXY(320,400,'WYJSCIE');

    until (podswietl<>0) and przycisk1;
  end;


{--Procedury-gry------------------------------------------------------------}
{--Otwarcie-pliku-z-danymi--------------------------------------------------}
Procedure otworz;

  begin
    Assign(zestaw,'wpis.dat');
    {$I-}
    Reset(zestaw);
    {$I+}
    if IOResult<>0 then
    ReWrite(zestaw);
  end;

{--Szablon:-kola-ratunkowe,-miejsce-na-pytania,-odpowiedzi-itd.-------------}
Procedure szablon(suma:string);

  begin
    ClearDevice;

{glowny napis - Milionerzy}
     SetColor(12);                             {zielony kolor napisow}
     SetTextJustify(1,1);                      {wysrodkowanie tekstu}
     SetTextStyle(4,0,6);                      {gotyk 6}
     SetLineStyle(0,0,0);                      {cienka normalna linia}
    OutTextXY(320,50,'M I L I O N E R Z Y');

{informacja o stawce gry}
     SetColor(9);                              {niebieski kolor napisow}
     SetTextStyle(0,0,2);                      {normalna czcionka 2}
    OutTextXY(320,110,suma);

    SetColor(14);                              {zolty kolor linii}
{tresc pytania}
    Rectangle(70,250,570,290);

{odpowiedz A}
    Rectangle(70,310,310,340);
     Circle(85,325,15);
     OutTextXY(86,326,'A');
{odpowiedz B}
    Rectangle(330,310,570,340);
     Circle(345,325,15);
     OutTextXY(346,326,'B');
{odpowiedz C}
    Rectangle(70,350,310,380);
     Circle(85,365,15);
     OutTextXY(86,366,'C');
{odpowiedz D}
    Rectangle(330,350,570,380);
     Circle(345,365,15);
     OutTextXY(346,366,'D');

{kolo ratunkowe - 50:50}
     SetColor(10);                              {jasnoszary kolor linii}
     SetLineStyle(0,0,0);
    Rectangle(70,400,150,460);
     SetTextStyle(0,0,1);
    OutTextXY(110,430,'50:50');
    if mozliwe_pol_na_pol=false then
    begin
       SetColor(12);                              {jasnoczerwony kolor przekreslenia}
       SetLineStyle(0,0,3);
      Line(70,400,150,460);                   {przekreslenie kola \ }
      Line(150,400,70,460);                   {przekreslenie kola / }
       SetLineStyle(0,0,0);
    end;

{kolo ratunkowe - telefon do przyjaciela}
     SetColor(10);                              {jasnoszary kolor linii}
     SetLineStyle(0,0,0);
    Rectangle(170,400,250,460);
    Line(190,450,230,450);                    {dol}
    Line(190,435,190,450);                    {bok lewy}
    Line(230,435,230,450);                    {bok prawy}
    Line(190,435,200,425);                    {skos lewy}
    Line(230,435,220,425);                    {skos prawy}
    Line(200,425,220,425);                    {gora}
    Line(195,420,225,420);                    {sluchawka - dol}
    Line(195,420,197,424);                    {sluchawka - polaczenie lewe}
    Line(225,420,223,424);                    {sluchawaka - polaczenie prawe}
    Line(181,428,197,424);                    {sluchawka - linia lewa}
    Line(239,428,223,424);                    {sluchawka - linia prawa}
    Ellipse(210,425,350,190,30,15);           {sluchawka - gora}
    Circle(210,438,7);                        {tarcza}
    if mozliwe_telefon=false then
    begin
       SetColor(12);                              {jasnoczerwony kolor przekreslenia}
       SetLineStyle(0,0,3);
      Line(170,400,250,460);                   {przekraslenie kola \ }
      Line(250,400,170,460);                   {przekraslenie kola / }
       SetLineStyle(0,0,0);
    end;

{kolo ratunkowe - pytanie do publicznosci}
     SetColor(10);                              {jasnoszary kolor linii}
     SetLineStyle(0,0,0);
    Rectangle(270,400,350,460);
    Circle(310,420,6);                        {ludzik srodkowy - glowa}
    Ellipse(310,453,0,180,10,27);             {ludzik srodkowy - tulow}
    Circle(292,415,5);                        {ludzik lewy - glowa}
    Ellipse(292,442,10,180,9,22);             {ludzik lewy - tulow}
    Circle(328,417,5);                        {ludzik prawy - glowa}
    Ellipse(328,444,0,170,9,22);              {ludzik prawy - tulow}
    if mozliwe_publicznosc=false then
    begin
       SetColor(12);                              {jasnoczerwony kolor przekreslenia}
       SetLineStyle(0,0,3);
      Line(270,400,350,460);                   {przekraslenie kola \ }
      Line(350,400,270,460);                   {przekraslenie kola / }
       SetLineStyle(0,0,0);
    end;

{wycofanie sie z gry}
     SetColor(7);                              {jasnoszary kolor linii}
     SetLineStyle(0,0,0);
    Rectangle(480,400,570,460);
    OutTextXY(525,423,'REZYGNACJA');
    OutTextXY(525,437,'Z GRY');
  end;

{--kolo-ratunkowe-pol-na-pol------------------------------------------------}
Procedure pol_na_pol;

  var wylosowana_cyfra:byte;
      litera_1,litera_2:char;

  begin
    repeat
      randomize;
      wylosowana_cyfra:=random(4);
      Case wylosowana_cyfra of
        0: litera_1:='A';
        1: litera_1:='B';
        2: litera_1:='C';
        3: litera_1:='D';
      end;
    until litera_1<>pytanie.odpowiedz;
    repeat
      randomize;
      wylosowana_cyfra:=random(4);
      Case wylosowana_cyfra of
        0: litera_2:='A';
        1: litera_2:='B';
        2: litera_2:='C';
        3: litera_2:='D';
      end;
    until (litera_2<>litera_1) and (litera_2<>pytanie.odpowiedz);
{jezeli wylosowano A...}
    if (litera_1='A') or (litera_2='A') then
      begin
         SetFillStyle(1,0);                   {czarny kolor wypelnienia}
        Bar(101,311,309,339);                 {wymazanie zlej odpowiedzi}
        mozliwe_a:=false;
      end;
{jezeli wylosowano B...}
    if (litera_1='B') or (litera_2='B') then
      begin
         SetFillStyle(1,0);                   {czarny kolor wypelnienia}
        Bar(361,311,569,339);                 {wymazanie zlej odpowiedzi}
        mozliwe_b:=false;
      end;
{jezeli wylosowano C...}
    if (litera_1='C') or (litera_2='C') then
      begin
         SetFillStyle(1,0);                   {czarny kolor wypelnienia}
        Bar(101,351,309,379);                 {wymazanie zlej odpowiedzi}
        mozliwe_c:=false;
      end;
{jezeli wylosowano D...}
    if (litera_1='D') or (litera_2='D') then
      begin
         SetFillStyle(1,0);                   {czarny kolor wypelnienia}
        Bar(361,351,569,379);                 {wymazanie zlej odpowiedzi}
        mozliwe_d:=false;
      end;

    mozliwe_pol_na_pol:=false;
     SetLineStyle(0,0,3);
     SetColor(12);                          {jasnoczerwony kolor linii}
    ukryj;
    Line(70,400,150,460);                   {przekraslenie kola \ }
    Line(150,400,70,460);                   {przekraslenie kola / }
    pokaz;
     SetLineStyle(0,0,0);
  end;

{--kolo-ratunkowe-telefon-do-przyjaciela------------------------------------}
Procedure telefon;

  var szansa_przyjaciela:byte;
      wylosowana_cyfra:byte;
      litera:char;

  begin
    repeat
      randomize;
      wylosowana_cyfra:=random(4);
      Case wylosowana_cyfra of
        0: if mozliwe_a then litera:='A'
           else
             if mozliwe_b then litera:='B'
             else litera:='C';
        1:if mozliwe_b then litera:='B'
          else
            if mozliwe_c then litera:='C'
            else litera:='D';
        2:if mozliwe_c then litera:='C'
          else
            if mozliwe_d then litera:='D'
            else litera:='A';
        3:if mozliwe_d then litera:='D'
          else
            if mozliwe_a then litera:='A'
            else litera:='B';
      end;
    until litera<>pytanie.odpowiedz;
    Randomize;
    szansa_przyjaciela:=random(5);
     SetTextJustify(2,2);                      {wyrownanie tekstu - gora,prawa}
     SetTextStyle(0,0,0);
     SetColor(12);                             {jasnoczerwony kolor napisow}
    Case szansa_przyjaciela of
      0: begin
           OutTextXY(555,180,'Przyjaciel jest pewien odpowiedzi');
           OutTextXY(570,180,pytanie.odpowiedz);
         end;
      1: begin
           OutTextXY(555,180,'Przyjaciel jest prawie pewien odpowiedzi');
           OutTextXY(570,180,pytanie.odpowiedz);
           OutTextXY(555,195,'Zastanawia sie tez nad odpowiedzia');
           OutTextXY(570,195,litera);
         end;
      2: begin
           OutTextXY(555,180,'Przyjaciel sugeruje odpowiedz');
           OutTextXY(570,180,pytanie.odpowiedz);
           OutTextXY(555,195,'Powaznie zastanawia sie nad odpowiedzia');
           OutTextXY(570,195,litera);
         end;
      3: begin
           OutTextXY(525,180,'Przyjaciel tylko rozwaza dwie odpowiedzi:');
           OutTextXY(540,180,pytanie.odpowiedz);
           OutTextXY(555,180,'i');
           OutTextXY(570,180,litera);
         end;
      4: begin
           OutTextXY(555,180,'Przyjaciel sugeruje odpowiedz');
           OutTextXY(570,180,litera);
           OutTextXY(555,195,'Zastanawia sie tez nad odpowiedzia');
           OutTextXY(570,195,pytanie.odpowiedz);
         end;
    end;
    mozliwe_telefon:=false;
     SetLineStyle(0,0,3);
     SetColor(12);                             {jasnoczerwony kolor linii}
    ukryj;
    Line(170,400,250,460);
    Line(250,400,170,460);
    pokaz;
     SetLineStyle(0,0,0);
  end;

{--kolo-ratunkowe-pytanie-do-publicznosci-----------------------------------}
Procedure publicznosc;

  var szansa_a:byte;
      szansa_b:byte;
      szansa_c:byte;
      szansa_d:byte;
      liczba:byte;
      procent_a:string;
      procent_b:string;
      procent_c:string;
      procent_d:string;

  begin
    randomize;
    liczba:=random(70);
    Case pytanie.odpowiedz of
      'A': if (mozliwe_a) and (mozliwe_b) and (mozliwe_c) and (mozliwe_d) then
             begin
               szansa_a:=liczba+30;
               szansa_b:=random(100-szansa_a);
               szansa_c:=random(100-szansa_a-szansa_b);
               szansa_d:=100-szansa_a-szansa_b-szansa_c;
             end
           else
             begin
               szansa_a:=liczba+30;
               if mozliwe_b then
                 begin
                   szansa_b:=100-szansa_a;
                   szansa_c:=0;
                   szansa_d:=0;
                 end
               else
                 if mozliwe_c then
                   begin
                     szansa_c:=100-szansa_a;
                     szansa_b:=0;
                     szansa_d:=0;
                   end
                 else
                   begin
                     szansa_d:=100-szansa_a;
                     szansa_b:=0;
                     szansa_c:=0;
                   end;
             end;

      'B': if (mozliwe_a) and (mozliwe_b) and (mozliwe_c) and (mozliwe_d) then
             begin
               szansa_b:=liczba+30;
               szansa_c:=random(100-szansa_b);
               szansa_d:=random(100-szansa_b-szansa_c);
               szansa_a:=100-szansa_b-szansa_c-szansa_d;
             end
           else
             begin
               szansa_b:=liczba+30;
               if mozliwe_c then
                 begin
                   szansa_c:=100-szansa_b;
                   szansa_a:=0;
                   szansa_d:=0;
                 end
               else
                 if mozliwe_d then
                   begin
                     szansa_d:=100-szansa_b;
                     szansa_a:=0;
                     szansa_c:=0;
                   end
                 else
                   begin
                     szansa_a:=100-szansa_b;
                     szansa_c:=0;
                     szansa_d:=0;
                   end;
             end;

      'C': if (mozliwe_a) and (mozliwe_b) and (mozliwe_c) and (mozliwe_d) then
             begin
               szansa_c:=liczba+30;
               szansa_d:=random(100-szansa_c);
               szansa_a:=random(100-szansa_c-szansa_d);
               szansa_b:=100-szansa_c-szansa_d-szansa_a;
             end
           else
             begin
               szansa_c:=liczba+30;
               if mozliwe_d then
                 begin
                   szansa_d:=100-szansa_c;
                   szansa_a:=0;
                   szansa_b:=0;
                 end
               else
                 if mozliwe_a then
                   begin
                     szansa_a:=100-szansa_c;
                     szansa_b:=0;
                     szansa_d:=0;
                   end
                 else
                   begin
                     szansa_b:=100-szansa_c;
                     szansa_a:=0;
                     szansa_d:=0;
                   end;
             end;

      'D': if (mozliwe_a) and (mozliwe_b) and (mozliwe_c) and (mozliwe_d) then
             begin
               szansa_d:=liczba+30;
               szansa_a:=random(100-szansa_d);
               szansa_b:=random(100-szansa_d-szansa_a);
               szansa_c:=100-szansa_d-szansa_a-szansa_b;
             end
           else
             begin
               szansa_d:=liczba+30;
               if mozliwe_a then
                 begin
                   szansa_a:=100-szansa_d;
                   szansa_b:=0;
                   szansa_c:=0;
                 end
               else
                 if mozliwe_b then
                   begin
                     szansa_b:=100-szansa_d;
                     szansa_a:=0;
                     szansa_c:=0;
                   end
                 else
                   begin
                     szansa_c:=100-szansa_d;
                     szansa_a:=0;
                     szansa_b:=0;
                   end;
             end;

    end;
    str(szansa_a,procent_a);
    str(szansa_b,procent_b);
    str(szansa_c,procent_c);
    str(szansa_d,procent_d);
     SetColor(12);                             {jasnoczerwony kolor linii}
     SetTextStyle(0,0,0);
     SetTextJustify(1,1);
    OutTextXY(35,218,'A');
    OutTextXY(60,218,'B');
    OutTextXY(85,218,'C');
    OutTextXY(110,218,'D');
     SetFillStyle(1,14);                       {zolty kolor wypelnienia}
    Bar(25,210-szansa_a,45,210);
    Bar(50,210-szansa_b,70,210);
    Bar(75,210-szansa_c,95,210);
    Bar(100,210-szansa_d,120,210);
    OutTextXY(30,205-szansa_a,procent_a);
    OutTextXY(43,205-szansa_a,'%');
    OutTextXY(55,205-szansa_b,procent_b);
    OutTextXY(68,205-szansa_b,'%');
    OutTextXY(80,205-szansa_c,procent_c);
    OutTextXY(93,205-szansa_c,'%');
    OutTextXY(105,205-szansa_d,procent_d);
    OutTextXY(118,205-szansa_d,'%');
    mozliwe_publicznosc:=false;
     SetLineStyle(0,0,3);
    ukryj;
    Line(270,400,350,460);
    Line(350,400,270,460);
    pokaz;
     SetLineStyle(0,0,0);
  end;


{--Postepowanie-w-przypadku-dobrej-odpowiedzi-------------------------------}
Procedure dobrze(wygrana:string);

  var i:byte;
      gwarant:string;

  begin
    if wygrana='1 MILION' then odp:='K' else
    begin
      ClearDevice;
      if (wygrana='1.000') or (wygrana='32.000')
      then gwarant:='(wygrana gwarantowana)'
      else gwarant:=' ';

       SetTextJustify(1,1);                    {wysrodkowanie tekstu}
       SetColor(14);                           {zolty kolor linii}
      Rectangle(160,0,480,479);               {prostokat duzy}

{prostokat kol ratunkowych}
       SetColor(14);                           {zolty kolor linii}
      Rectangle(160,380,480,479);
{kolo ratunkowe - 50:50}
       SetColor(7);                           {jasnoszary kolor linii}
      SetLineStyle(0,0,0);
      Rectangle(187,400,247,460);
      SetTextStyle(0,0,1);
      OutTextXY(217,430,'50:50');
      if mozliwe_pol_na_pol=false then
      begin
         SetColor(12);                           {jasnoczerwony kolor linii}
         SetLineStyle(0,0,3);
        Line(187,400,247,460);                   {przekraslenie kola \ }
        Line(247,400,187,460);                   {przekraslenie kola / }
         SetLineStyle(0,0,0);
      end;

{kolo ratunkowe - telefon do przyjaciela}
       SetColor(7);                           {jasnoszary kolor linii}
       SetLineStyle(0,0,0);
      Rectangle(287,400,347,460);
      Line(297,450,337,450);                  {dol}
      Line(297,435,297,450);                  {bok lewy}
      Line(337,435,337,450);                  {bok prawy}
      Line(297,435,307,425);                  {skos lewy}
      Line(337,435,327,425);                  {skos prawy}
      Line(307,425,327,425);                  {gora}
      Line(302,420,332,420);                  {sluchawka - dol}
      Line(302,420,304,424);                  {sluchawka - polaczenie lewe}
      Line(332,420,330,424);                  {sluchawaka - polaczenie prawe}
      Line(288,428,304,424);                  {sluchawka - linia lewa}
      Line(346,428,330,424);                  {sluchawka - linia prawa}
      Ellipse(317,425,350,190,30,15);         {sluchawka - gora}
      Circle(317,438,7);                      {tarcza}
      if mozliwe_telefon=false then
        begin
           SetColor(12);                           {jasnoczerwony kolor linii}
           SetLineStyle(0,0,3);
          Line(287,400,347,460);                   {przekraslenie kola \ }
          Line(347,400,287,460);                   {przekraslenie kola / }
           SetLineStyle(0,0,0);
        end;

{kolo ratunkowe - pytanie do publicznosci}
       SetColor(7);                           {jasnoszary kolor linii}
       SetLineStyle(0,0,0);
      Rectangle(387,400,447,460);
      Circle(417,420,6);                      {ludzik srodkowy - glowa}
      Ellipse(417,453,0,180,10,27);           {ludzik srodkowy - tulowie}
      Circle(399,415,5);                      {ludzik lewy - glowa}
      Ellipse(399,442,10,180,9,22);           {ludzik lewy - tulowie}
      Circle(435,417,5);                      {ludzik prawy - glowa}
      Ellipse(435,444,0,170,9,22);            {ludzik prawy - tulowie}
      if mozliwe_publicznosc=false then
        begin
          SetColor(12);                           {jasnoczerwony kolor linii}
          SetLineStyle(0,0,3);
          Line(387,400,447,460);                   {przekraslenie kola \ }
          Line(447,400,387,460);                   {przekraslenie kola / }
          SetLineStyle(0,0,0);
        end;

{prostokat wygranej}
       SetColor(14);                           {zolty kolor linii}
      Rectangle(160,0,480,60);
       SetColor(15);                           {bialy kolor napisow}
      OutTextXY(320,17,'Masz juz na swoim koncie');
      OutTextXY(320,32,wygrana);
      OutTextXY(320,47,gwarant);

{srodek - belka z wartoscia wygranej}
      i:=0;
       SetTextJustify(0,1);                    {do lewej, centrycznie}
      repeat
        wart:=wart+i;
        if wart=15 then
          begin
             SetFillStyle(1,6);
            bar(161,70,479,90);
             SetFillStyle(1,0);
            bar(161,90,479,110);
          end;
        OutTextXY(260,80,'15. 1 MILION');
        OutTextXY(260,100,'14. 500.000');
        if wart=14 then
          begin
             SetFillStyle(1,6);
            bar(161,90,479,110);
             SetFillStyle(1,0);
            bar(161,110,479,130);
          end;
        OutTextXY(260,100,'14. 500.000');
        OutTextXY(260,120,'13. 250.000');
        if wart=13 then
          begin
             SetFillStyle(1,6);
            bar(161,110,479,130);
             SetFillStyle(1,0);
            bar(161,130,479,150);
          end;
        OutTextXY(260,120,'13. 250.000');
        OutTextXY(260,140,'12. 125.000');
        if wart=12 then
          begin
             SetFillStyle(1,6);
            bar(161,130,479,150);
             SetFillStyle(1,0);
            bar(161,150,479,170);
          end;
        OutTextXY(260,140,'12. 125.000');
        OutTextXY(260,160,'11. 64.000');
        if wart=11 then
          begin
             SetFillStyle(1,6);
            bar(161,150,479,170);
             SetFillStyle(1,0);
            bar(161,170,479,190);
          end;
        OutTextXY(260,160,'11. 64.000');
        OutTextXY(260,180,'10. 32.000');
        if wart=10 then
          begin
             SetFillStyle(1,6);
            bar(161,170,479,190);
             SetFillStyle(1,0);
            bar(161,190,479,210);
          end;
        OutTextXY(260,180,'10. 32.000');
        OutTextXY(260,200,' 9. 16.000');
        if wart=9 then
          begin
             SetFillStyle(1,6);
            bar(161,190,479,210);
             SetFillStyle(1,0);
            bar(161,210,479,230);
          end;
        OutTextXY(260,200,' 9. 16.000');
        OutTextXY(260,220,' 8. 8.000');
        if wart=8 then
          begin
             SetFillStyle(1,6);
            bar(161,210,479,230);
             SetFillStyle(1,0);
            bar(161,230,479,250);
          end;
        OutTextXY(260,220,' 8. 8.000');
        OutTextXY(260,240,' 7. 4.000');
        if wart=7 then
          begin
             SetFillStyle(1,6);
            bar(161,230,479,250);
             SetFillStyle(1,0);
            bar(161,250,479,270);
          end;
        OutTextXY(260,240,' 7. 4.000');
        OutTextXY(260,260,' 6. 2.000');
        if wart=6 then
          begin
             SetFillStyle(1,6);
            bar(161,250,479,270);
             SetFillStyle(1,0);
            bar(161,270,479,290);
          end;
        OutTextXY(260,260,' 6. 2.000');
        OutTextXY(260,280,' 5. 1.000');
        if wart=5 then
          begin
             SetFillStyle(1,6);
            bar(161,270,479,290);
             SetFillStyle(1,0);
            bar(161,290,479,310);
          end;
        OutTextXY(260,280,' 5. 1.000');
        OutTextXY(260,300,' 4. 500');
        if wart=4 then
          begin
             SetFillStyle(1,6);
            bar(161,290,479,310);
             SetFillStyle(1,0);
            bar(161,310,479,330);
          end;
        OutTextXY(260,300,' 4. 500');
        OutTextXY(260,320,' 3. 300');
        if wart=3 then
          begin
             SetFillStyle(1,6);
            bar(161,310,479,330);
             SetFillStyle(1,0);
            bar(161,330,479,350);
          end;
        OutTextXY(260,320,' 3. 300');
        OutTextXY(260,340,' 2. 200');
        if wart=2 then
          begin
             SetFillStyle(1,6);
            bar(161,330,479,350);
             SetFillStyle(1,0);
            bar(161,350,479,370);
          end;
        OutTextXY(260,340,' 2. 200');
        OutTextXY(260,360,' 1. 100');
        if wart=1 then
          begin
            SetFillStyle(1,6);
            bar(161,350,479,370);
          end;
        OutTextXY(260,360,' 1. 100');
        delay(delgra);
        i:=i+1;
      until i=2;
      delay(delgra);
    end;
  end;


{--Postepowanie-w-przypadku-zlej-odpowiedzi---------------------------------}
Procedure zle;

  begin
    ClearDevice;

{ludzik}
    SetFillStyle(1,15);                        {bialy kolor wypelnienia}
    FillEllipse(210,200,23,12);               {glowa}
    FillEllipse(160,200,25,12);               {bark}
    Bar(135,200,165,260);                     {tulow}
    FillEllipse(150,260,15,15);               {zadek}
    Line(169,190,172,280);                    {reka wewnetrzna - od ludzika}
    Line(175,190,174,280);                    {reka wewnetrzna - od napisu}
    Line(172,280,169,291);                    {dlon wewnetrzna - od ludzika}
    Line(174,280,172,294);                    {dlon wewnetrzna - od napisu}
    Line(172,294,169,291);                    {dlon wewnetrzna - dol}
    FloodFill(171,292,15);                    {wypelnienie reki wewnetrznej}
    Line(177,200,178,290);                    {reka zewnetrzna - od ludzika}
    Line(185,200,180,290);                    {reka zewnetrzna - od napisu}
    Line(178,290,175,301);                    {dlon zewnetrzna - od ludzika}
    Line(180,290,178,304);                    {dlon zewnetrzna - od napisu}
    Line(178,304,175,301);                    {dlon zewnetrzna - dol}
    FloodFill(177,302,15);                    {wypelnienie reki zewnetrznej}
    Line(135,260,145,300);                    {noga z lewej - gora - zewnatrz}
    Line(145,260,150,300);                    {noga z lewej - gora - wewnatrz}
    Line(145,300,140,343);                    {noga z lewej - dol - zewnatrz}
    Line(150,300,143,340);                    {noga z lewej - dol - wewnetrz}
    Line(140,343,154,340);                    {noga z lewej - dol}
    Line(154,340,150,336);                    {noga z lewej - czubek}
    Line(150,336,142,340);                    {noga z lewj - gora}
    FloodFill(148,300,15);                    {wypelnienie nogi lewej}
    Line(152,260,161,300);                    {noga z prawej - gora - wewnatrz}
    Line(162,260,166,300);                    {noga z prawej - gora - zewnatrz}
    Line(161,300,153,347);                    {noga z prawej - dol - wewnatrz}
    Line(166,300,157,344);                    {noga z prawej - dol - zewnatrz}
    Line(153,347,172,345);                    {stopa prawa - dol}
    Line(172,345,166,341);                    {stopa prawa - czubek}
    Line(166,341,156,343);                    {stopa prawa - gora}
    FloodFill(163,300,15);                    {wypelnienie nogi prawej}
     SetLineStyle(0,0,3);                      {linia pogrubiona}
    Line(215,200,210,222);                    {nos}

{napisy}
     SetTextJustify(1,1);                      {wysrodkowanie tekstu}
     SetTextStyle(0,0,1);                      {czcionka normalna 1}
     SetColor(9);                              {jasnoniebieski kolor napisu}
    OutTextXY(420,190,'Niestety');
    OutTextXY(420,210,'twoja odpowiedz jest zla');
    OutTextXY(420,300,'Tym razem nie wygrales MILIONA');
     SetTextStyle(0,0,2);                      {czcionka normalna 2}
     SetColor(10);                             {zielony kolor napisu}
    OutTextXY(420,340,'SPROBOJ JESZCZE RAZ !!!');
    delay(delgra);

{uwzglednienie gwarantowanej wygranej}
    if wart<6 then wwygranej:='nic';
    if (wart>5) and (wart<11) then wwygranej:='1.000';
    if wart>10 then wwygranej:='32.000';
    odp:='K';
  end;


{--Informacja-o-wygranej----------------------------------------------------}
Procedure wygrana(wygrana:string);

  begin
{ludzik}
     SetColor(15);                             {bialy kolor linii}
     SetLineStyle(0,0,0);
     SetFillStyle(1,15);                       {bialy kolor wypelnienia}
    FillEllipse(200,188,12,20);               {glowa}
    FillEllipse(200,240,15,30);               {tulow}

    Line(197,216,230,212);                    {ramie prawe - gora}
    Line(200,223,230,214);                    {ramie prawe - dol}
    Line(230,212,250,213);                    {przedramie prawe - gora}
    Line(230,214,250,215);                    {przedramie prawe - dol}
    Line(250,213,250,215);                    {reka prawa - zakonczenie}
    FloodFill(249,214,15);                    {wypelnienie przedramienia prawego}
    FloodFill(230,213,15);                    {wypelnienie reki prawej}

    Line(200,212,170,237);                    {ramie lewe - gora}
    Line(200,220,170,241);                    {ramie lewe - dol}
    Line(170,237,155,239);                    {przedramie lewe - gora}
    Line(170,241,155,242);                    {przedramie lewe - dol}
    FillEllipse(150,240,5,3);                 {lewa dlon}
    FloodFill(170,239,15);                    {wypelnienie reki lewej}

    Line(195,240,184,300);                    {udo lewe - zewnatrz}
    Line(202,240,188,300);                    {udo lewe - wawnatrz}
    Line(184,300,190,330);                    {lydka lewa - zewnatrz}
    Line(187,300,192,330);                    {lydka lewa - wawnatrz}
    Line(190,330,180,335);                    {stopa lewa - gora}
    Line(180,335,183,337);                    {stopa lewa - czubek}
    Line(183,337,192,330);                    {stopa lewa - dol}
    FloodFill(183,336,15);                    {wypelnienie stopy lewej}
    FloodFill(186,300,15);                    {wypelnienie nogi lewej}

    Line(198,240,212,298);                    {udo prawe - wewnatrz}
    Line(206,240,217,298);                    {udo prawe - zewnatrz}
    Line(212,298,208,328);                    {lydka prawa - wewnatrz}
    Line(217,298,210,328);                    {lydka prawa - zewnatrz}
    Line(208,328,217,335);                    {stopa prawa - dol}
    Line(217,335,220,333);                    {stopa prawa - czubek}
    Line(220,333,210,328);                    {stopa prawa - gora}
    FloodFill(217,334,15);                    {wypelnienie stopy prawej}
    FloodFill(215,298,15);                    {wypelnienie nogi prawej}
     SetLineStyle(0,0,3);                      {linia pogrubiona}
    Line(200,188,175,200);                    {nos}
{worek na pieniadze}
     SetFillStyle(1,6);                        {brazowy kolor wypelnienia}
     SetColor(6);                              {brazowy kolor linii}
    FillEllipse(305,260,75,70);               {worek}
    Line(301,200,286,177);                    {uchwyt - lewa}
    Line(310,200,320,177);                    {uchwyt - prawa}
    Line(286,177,320,177);                    {uchwyt - gora}
    FloodFill(300,180,6);                     {wypelnienie uchwytu}
     SetLineStyle(0,0,3);                      {linia pogrubiona}
     SetColor(7);                              {jasnoszary kolor linii}
    Ellipse(305,190,180,360,10,4);            {sznurek}
    Line(298,192,290,210);                    {fredzel sznurka - lewy}
    Line(298,192,303,230);                    {fredzel sznurka - prawy}
     SetTextJustify(1,1);                      {wysrodkowanie}
     SetTextStyle(0,0,2);                      {wieksza czcionka}
     SetColor(14);                             {zolty kolor napisu}
    OutTextXY(305,270,wygrana);
  end;

{--Informacja-o-przergranej-------------------------------------------------}
Procedure przegrana;

  begin
     SetColor(15);                             {bialy kolor linii}
     SetFillStyle(1,15);                       {bialy kolor wypelnienia}
     SetLineStyle(0,0,0);                      {normalna linia}

{tulow}
    FillEllipse(200,240,15,30);
{lewa reka}
    Line(190,217,168,237);                    {ramie lewe - zewnatrz}
    Line(190,225,174,237);                    {ramie lewe - wewnatrz}
    Line(168,237,186,257);                    {przedramie lewe - zewnatrz}
    Line(174,237,189,256);                    {przedramie lewe - wewnatrz}
    Line(186,257,181,264);                    {dlon lewa - zewnatrz}
    Line(189,256,184,268);                    {dlon lewa - wewnatrz}
    Line(181,264,184,268);                    {dlon lewa - czubek}
    FloodFill(183,265,15);                    {wypelnienie dloni lewej}
    FloodFill(170,237,15);                    {wypelnienie reki lewej}
{prawa reka}
    Line(210,217,232,237);                    {ramie prawe  - zewnetrzne}
    Line(210,225,226,237);                    {ramie prawe - wewnetrzne}
    Line(232,237,214,257);                    {przedramie prawe - zewnetrzne}
    Line(226,237,211,256);                    {przedramie prawe - wewnetrzne}
    Line(214,257,219,264);                    {dlon prawa - zewnatrz}
    Line(211,256,216,268);                    {dlon prawa - wewnatrz}
    Line(219,264,216,268);                    {dlon prawa - czubek}
    FloodFill(217,265,15);                    {wypelnienie dloni prawej}
    FloodFill(230,237,15);                    {wypelnienie reki prawej}
{lewa noga}
    Line(195,240,184,300);                    {udo lewe - zewnatrz}
    Line(202,240,188,300);                    {udo lewe - wawnatrz}
    Line(184,300,190,330);                    {lydka lewa - zewnatrz}
    Line(187,300,192,330);                    {lydka lewa - wawnatrz}
    Line(190,330,180,335);                    {stopa lewa - gora}
    Line(180,335,183,337);                    {stopa lewa - czubek}
    Line(183,337,192,330);                    {stopa lewa - dol}
    FloodFill(183,336,15);                    {wypelnienie stopy lewej}
    FloodFill(186,300,15);                    {wypelnienie nogi lewej}
{prawa noga}
    Line(198,240,212,298);                    {udo prawe - wewnatrz}
    Line(206,240,217,298);                    {udo prawe - zewnatrz}
    Line(212,298,208,328);                    {lydka prawa - wewnatrz}
    Line(217,298,210,328);                    {lydka prawa - zewnatrz}
    Line(208,328,217,335);                    {stopa prawa - dol}
    Line(217,335,220,333);                    {stopa prawa - czubek}
    Line(220,333,210,328);                    {stopa prawa - gora}
    FloodFill(217,334,15);                    {wypelnienie stopy prawej}
    FloodFill(215,298,15);                    {wypelnienie nogi prawej}
{glowa}
     SetLineStyle(0,0,3);                      {pogrubienie linii}
    FillEllipse(250,318,12,20);               {twarz}
    Line(250,318,275,330);                    {nos}

{napisy}
     SetTextStyle(0,0,2);                      {normalna czcionka 2}
     SetTextJustify(1,1);                      {wysrodkowanie tekstu}
     SetColor(10);                             {zielony kolor napisu}
    OutTextXY(400,200,'Nie trac glowy!!!');
     SetTextStyle(0,0,1);                      {normalna czcionka 1}
     SetColor(9);                              {jasnoniebieski kolor napisu}
    OutTextXY(400,250,'Nastepnym razem mozesz wygarac');
    OutTextXY(400,270,'NAWET   M I L I O N');
    delay(delgra);
  end;

{==Glowna-gra===============================================================}
Procedure gra;

  var numer_pytania:byte;         {numer wylosowanego pytania}
      wsumy:string;               {wyswietlenie napisu o ile gramy}

  begin
     mozliwe_pol_na_pol:=true;
     mozliwe_telefon:=true;
     mozliwe_publicznosc:=true;
     SetTextJustify(1,1);                      {wysrodkowanie tekstu}
     SetTextStyle(2,0,0);                      {czcionka nr 2}
    wart:=1;                                  {rozpoczecie gry - o 100 zl}
    otworz;

    repeat
      mozliwe_a:=true;
      mozliwe_b:=true;
      mozliwe_c:=true;
      mozliwe_d:=true;
{Uzaleznienie informacji o jaka sume toczy sie gra od zmiennej wart}
      case wart of
        1: wsumy:='Gra o 100 zlotych';
        2: wsumy:='Gra o 200 zlotych';
        3: wsumy:='Gra o 300 zlotych';
        4: wsumy:='Gra o 500 zlotych';
        5: wsumy:='Gra o 1.000 zlotych';
        6: wsumy:='Gra o 2.000 zlotych';
        7: wsumy:='Gra o 4.000 zlotych';
        8: wsumy:='Gra o 8.000 zlotych';
        9: wsumy:='Gra o 16.000 zlotych';
       10: wsumy:='Gra o 32.000 zlotych';
       11: wsumy:='Gra o 64.000 zlotych';
       12: wsumy:='Gra o 125.000 zlotych';
       13: wsumy:='Gra o 250.000 zlotych';
       14: wsumy:='Gra o 500.000 zlotych';
       15: wsumy:='Gra o 1 MILION zlotych';
      end;
      szablon(wsumy);
{losowanie pytania}
      Randomize;
      numer_pytania:=random(filesize(zestaw)-1);
        repeat
          Seek(zestaw,numer_pytania);
          Read(zestaw,pytanie);
          numer_pytania:=numer_pytania+1;
          if numer_pytania=filesize(zestaw) then numer_pytania:=0;
        until pytanie.wartosc=wart;
{wyswietlenie tresci pytania i odpowiedzi}
       SetTextStyle(2,0,0);                    {czcionka nr 2}
       SetColor(15);                           {bialy kolor napisow}
      OutTextXY(320,270,pytanie.tresc);
      OutTextXY(205,325,pytanie.odp_a);
      OutTextXY(455,325,pytanie.odp_b);
      OutTextXY(205,365,pytanie.odp_c);
      OutTextXY(455,365,pytanie.odp_d);
{pokazanie kursora myszki}
      ustaw(320,240);
      pokaz;

{postepowanie przy wyborze odpowiedzi}
       SetFillStyle(1,4);                      {czerwony kolor wypelnienia}
       SetColor(15);                            {bialy kolor tekstu}
       SetTextStyle(0,0,2);                    {normalna czcionka 2}
      odp:='E';

{gdy kliknieto przycisk myszy...}
      repeat
        if przycisk1 then
          begin
            pozycja(x,y);
{gdy kliknieto na kolo ratunkowe - pol na pol...}
            if (x>70) and (x<150) and (y>400) and (y<460) and mozliwe_pol_na_pol
            then pol_na_pol;
{gdy kliknieto na kolo ratunkowe - telefon...}
            if (x>170) and (x<250) and (y>400) and (y<460) and mozliwe_telefon
            then telefon;
{gdy kliknieto na kolo ratunkowe - publicznosc...}
            if (x>270) and (x<350) and (y>400) and (y<460) and mozliwe_publicznosc
            then publicznosc;
             SetTextJustify(1,1);
             SetLineStyle(0,0,0);
             SetFillStyle(1,6);
  {gdy kliknieto na A...}
            if (x>70) and (x<310) and (y>310) and (y<340) and mozliwe_a
            then
              begin
                ukryj;
                odp:='A';
                Bar(70,310,310,340);
                 SetColor(14);                 {kolor linii zielony}
                Rectangle(70,310,310,340);
                Circle(85,325,15);
                 SetTextStyle(0,0,2);
                OutTextXY(86,326,'A');
                 SetTextStyle(2,0,0);
                 SetColor(15);                 {bialy kolor tekstu}
                OutTextXY(205,325,pytanie.odp_a);
              end
  {gdy kliknieto na B...}
            else if (x>330) and (x<570) and (y>310) and (y<340) and mozliwe_b then
              begin
                ukryj;
                odp:='B';
                Bar(330,310,570,340);
                 SetColor(14);
                Rectangle(330,310,570,340);
                Circle(345,325,15);
                 SetTextStyle(0,0,2);
                OutTextXY(346,326,'B');
                 SetTextStyle(2,0,0);
                 SetColor(15);
                OutTextXY(455,325,pytanie.odp_b);
              end

  {gdy kliknieto na C...}
            else if (x>70) and (x<310) and (y>350) and (y<380) and mozliwe_c then
              begin
                ukryj;
                odp:='C';
                Bar(70,350,310,380);
                 SetColor(14);
                Rectangle(70,350,310,380);
                Circle(85,365,15);
                 SetTextStyle(0,0,2);
                OutTextXY(86,366,'C');
                 SetTextStyle(2,0,0);
                 SetColor(15);
                OutTextXY(205,365,pytanie.odp_c);
              end
  {gdy kliknieto na D...}
            else if (x>330) and (x<570) and (y>350) and (y<380) and mozliwe_d then
              begin
                ukryj;
                odp:='D';
                Bar(330,350,570,380);
                 SetColor(14);
                Rectangle(330,350,570,380);
                Circle(345,365,15);
                 SetTextStyle(0,0,2);
                OutTextXY(346,366,'D');
                 SetTextStyle(2,0,0);
                 SetColor(15);
                OutTextXY(455,365,pytanie.odp_d);
              end
            else if (x>490) and (x<570) and (y>400) and (y<460) then odp:='K';
          end;
      until odp<>'E';
      delay(delgra);

{sprawdzanie poprawnej odpowiedzi}
       SetFillStyle(1,green);                      {zielony kolor wypelnienia}
  {poprawna odpowiedz to A...}
      if pytanie.odpowiedz='A' then
        begin
          Bar(70,310,310,340);
           SetColor(14);
          Rectangle(70,310,310,340);
          Circle(85,325,15);
           SetTextStyle(0,0,2);
          OutTextXY(86,326,'A');
           SetTextStyle(2,0,0);
           SetColor(15);                       {bialy kolor linii}
          OutTextXY(205,325,pytanie.odp_a);
        end
  {poprawna odpowiedz to B...}
      else if pytanie.odpowiedz='B' then
        begin
          Bar(330,310,570,340);
           SetColor(14);
          Rectangle(330,310,570,340);
          Circle(345,325,15);
           SetTextStyle(0,0,2);
          OutTextXY(346,326,'B');
           SetTextStyle(2,0,0);
           SetColor(15);
          OutTextXY(455,325,pytanie.odp_b);
         end
  {poprawna odpowiedz to C...}
      else if pytanie.odpowiedz='C' then
        begin
          Bar(70,350,310,380);
           SetColor(14);
          Rectangle(70,350,310,380);
          Circle(85,365,15);
           SetTextStyle(0,0,2);
          OutTextXY(86,366,'C');
           SetTextStyle(2,0,0);
           SetColor(15);
          OutTextXY(205,365,pytanie.odp_c);
        end
  {poprawna odpowiedz to D...}
      else if pytanie.odpowiedz='D' then
        begin
          Bar(330,350,570,380);
           SetColor(14);
          Rectangle(330,350,570,380);
          Circle(345,365,15);
           SetTextStyle(0,0,2);
          OutTextXY(346,366,'D');
           SetTextStyle(2,0,0);
           SetColor(15);
          OutTextXY(455,365,pytanie.odp_d);
        end;
      delay(delgra);

{jezeli odpowiedz jest bledna...}
      if (odp<>'K') and (odp<>pytanie.odpowiedz) then zle

{jezeli rezygnujemy z gry...}
      else
        begin
          if odp='K' then wart:=wart-1;
          case wart of
            0: wwygranej:='wycofanie';
            1: wwygranej:='100';
            2: wwygranej:='200';
            3: wwygranej:='300';
            4: wwygranej:='500';
            5: wwygranej:='1.000';
            6: wwygranej:='2.000';
            7: wwygranej:='4.000';
            8: wwygranej:='8.000';
            9: wwygranej:='16.000';
           10: wwygranej:='32.000';
           11: wwygranej:='64.000';
           12: wwygranej:='125.000';
           13: wwygranej:='250.000';
           14: wwygranej:='500.000';
           15: wwygranej:='1 MILION';
          end;

{jezeli odpowiedz jest prawidlowa...}
          if odp=pytanie.odpowiedz then dobrze(wwygranej);
         end;
     until odp='K';

     ukryj;
{wyswietlenie informacji o wygranej lub przegranej}
     cleardevice;
     if wwygranej='nic' then przegrana
     else if wwygranej<>'wycofanie' then wygrana(wwygranej);

{zamkniecie pliku i wyjscie z procedury}
    Close(zestaw);
    ClearDevice;
  end;


{--Procedury-wpisywania-pytan-----------------------------------------------}
{--Normalne-ustawienia-ekranu:-czarne-tlo,-jasnoszary-tekst-----------------}
Procedure normalnie;

  begin
    TextColor(7);
    TextBackGround(0);
  end;


{--Odwrotne-ustawienia-ekranu:-jasnoszare-tlo,-czarny-tekst-----------------}
Procedure odwrotnie;

  begin
    TextColor(0);
    TextBackGround(7);
  end;


{--Czynnosc-wpisywania-pytania-(sam-zapis-do-pliku)-------------------------}
Procedure wpisuj;

  var
    poprawnosc:char;

  begin
{otwarcie pliku z danymi}
    Assign(zestaw,'wpis.dat');
    {$I-}
    Reset(zestaw);
    {$I+}
    if IOResult<>0 then
    ReWrite(zestaw);
    normalnie;
{wpisywanie pytania}
      ClrScr;
      Seek(zestaw,FileSize(zestaw));
      pytanie.wartosc:=poz;
      WriteLn('Wpisz pytanie (maksymalna dlugosc do konca linijki):');
      ReadLn(pytanie.tresc);
      Write('Wpisz odpowiedz A: ');
      ReadLn(pytanie.odp_a);
      Write('Wpisz odpowiedz B: ');
      ReadLn(pytanie.odp_b);
      Write('Wpisz odpowiedz C: ');
      ReadLn(pytanie.odp_c);
      Write('Wpisz odpowiedz D: ');
      ReadLn(pytanie.odp_d);
{uwzglednienie wielkosci liter}
      repeat
        Write('Ktora odpowiedz jest prawidlowa? ');
        Readln(odpow);
        if (odpow='a') or (odpow='A') then pytanie.odpowiedz:='A' else
        if (odpow='b') or (odpow='B') then pytanie.odpowiedz:='B' else
        if (odpow='c') or (odpow='C') then pytanie.odpowiedz:='C' else
        if (odpow='d') or (odpow='D') then pytanie.odpowiedz:='D' else
        pytanie.odpowiedz:='e';
      until (pytanie.odpowiedz='A')
         or (pytanie.odpowiedz='B')
         or (pytanie.odpowiedz='C')
         or (pytanie.odpowiedz='D');
      WriteLn('Czy wprowadzone dane sa poprawne? (T/N)');
      ReadLn(poprawnosc);
    if (poprawnosc='t') or (poprawnosc='T') then Write(zestaw,pytanie);
    Close(zestaw);
  end;


{==Podprogram-sluzacy-do-wpisywania-pytan-(razem-z-belka)===================}
Procedure wpis;

  var znak:char;             {ruch belki}
      wyjscie:boolean;       {wyjscie z procedury wpisywania pytan}

  begin
    poz:=1;
    wyjscie:=false;
    repeat
      normalnie;
      ClrScr;
{wpisanie tekstu, po ktorym porusza sie belka przy wyborze stopnia trudnosci pytania}
      GotoXY(23,3);
      WriteLn('Wybierz poziom trudnosci pytania:');
      if poz=1 then odwrotnie else normalnie;
      GotoXY(28,5);
      WriteLn('  1. Za 100 zl.     ');
      if poz=2 then odwrotnie else normalnie;
      GotoXY(28,6);
      WriteLn('  2. Za 200 zl.     ');
      if poz=3 then odwrotnie else normalnie;
      GotoXY(28,7);
      WriteLn('  3. Za 300 zl.     ');
      if poz=4 then odwrotnie else normalnie;
      GotoXY(28,8);
      WriteLn('  4. Za 500 zl.     ');
      if poz=5 then odwrotnie else normalnie;
      GotoXY(28,9);
      WriteLn('  5. Za 1 tys. zl.  ');
      if poz=6 then odwrotnie else normalnie;
      GotoXY(28,10);
      WriteLn('  6. Za 2 tys. zl.  ');
      if poz=7 then odwrotnie else normalnie;
      GotoXY(28,11);
      WriteLn('  7. Za 4 tys. zl.  ');
      if poz=8 then odwrotnie else normalnie;
      GotoXY(28,12);
      WriteLn('  8. Za 8 tys. zl.  ');
      if poz=9 then odwrotnie else normalnie;
      GotoXY(28,13);
      WriteLn('  9. Za 16 tys. zl. ');
      if poz=10 then odwrotnie else normalnie;
      GotoXY(28,14);
      WriteLn(' 10. Za 32 tys. zl. ');
      if poz=11 then odwrotnie else normalnie;
      GotoXY(28,15);
      WriteLn(' 11. Za 64 tys. zl. ');
      if poz=12 then odwrotnie else normalnie;
      GotoXY(28,16);
      WriteLn(' 12. Za 125 tys. zl.');
      if poz=13 then odwrotnie else normalnie;
      GotoXY(28,17);
      WriteLn(' 13. Za 250 tys. zl.');
      if poz=14 then odwrotnie else normalnie;
      GotoXY(28,18);
      WriteLn(' 14. Za 500 tys. zl.');
      if poz=15 then odwrotnie else normalnie;
      GotoXY(28,19);
      WriteLn(' 15. Za milion zl.  ');
      if poz=16 then odwrotnie else normalnie;
      GotoXY(28,21);
      WriteLn(' 16. Powrot do menu.');
{opis ruchu belki przy wyborze stopnia trudnosci pytania}
      znak:=readkey;
      if znak=#0 then
        begin
          znak:=readkey;
          case znak of
            #72: if poz>1 then poz:=poz-1 else poz:=16;
            #80: if poz<16 then poz:=poz+1 else poz:=1;
          end;
        end
      else if znak=#13 then
          if poz<>16 then wpisuj else wyjscie:=true;
    until (znak=#27) or (wyjscie);
  end;


{--Procedury-animacji-koncowej----------------------------------------------}
{--Samolot-z-transparentem--------------------------------------------------}
Procedure samolot_lewy(x:integer);

  begin

{samolot}
     SetColor(7);                              {jasnoszary kolor linii}
     SetLineStyle(0,0,0);                      {cienka linia}
    Ellipse(x,25,254,360,50,25);              {dol}
    Arc(x+45,25,0,160,5);                     {ogon}
    Ellipse(x+32,15,270,320,10,15);           {gora - tyl}
    Ellipse(x+32,35,90,150,10,5);              {gora - srodek}
    Ellipse(x+18,30,210,330,6,4);             {wglebienie}
    Ellipse(x+19,32,180,360,8,5);             {linia wglebienia}
    Line(x+12,31,x-12,33);                    {gora - przod2}
    Ellipse(x-13,41,0,360,1,7);               {przod}
    Line(x+47,33,x+52,35);                    {linia gorna silnika}
    Line(x+43,38,x+52,35);                    {linia dolna silnika}
    Arc(x+6,51,160,40,3);                     {przednie kolo samolotu}
    Ellipse(x+38,42,200,90,2,1);              {tylnie kolo samolotu}

     SetFillStyle(1,12);                       {jasnoczerwony kolor wypelnienia}
    FloodFill(x-11,40,7);                     {wypelnienie kadluba - jasnoczerwone - (przod)}
    FloodFill(x+49,25,7);                     {wypelnienie kadluba - jasnoczerwone - (tyl)}
     SetFillStyle(1,4);                        {czerwony kolor wypelnienia}
    FloodFill(x+26,32,7);                     {wypelnienie wglebienia - czerwone - (tyl)}
     SetFillStyle(1,7);                        {jasnoszary kolor wypelnienia}
    FloodFill(x+38,42,7);                     {wypelnienie tylniego kola samolotu - jasnoszare - (tyl)}
    FloodFill(x+4,51,7);                      {wypelnienie przedniego kola samolotu - jasnoszare - (przod)}
    FloodFill(x+8,51,7);                      {wypelnienie przedniego kola samolotu - jasnoszare - (przod)}
     SetFillStyle(1,15);                       {bialy kolor wypelnienia}
    FloodFill(x-13,41,7);                     {wypelnienie dziobu - biale}

    Line(x-15,37,x-15,45);                    {linia na dziobie}
    Line(x-15,39,x-17,41);                    {dziobek od smigielka - gora}
    Line(x-15,43,x-17,41);                    {dziobek od smigielka - dol}
     SetColor(15);
    FillEllipse(x+45,25,3,3);                 {kolko na ogonie}
    FillEllipse(x+41,35,2,2);                 {silnik tylni}
    Line(x+41,33,x+50,35);                    {silnik tylni - gora}
    Line(x+41,37,x+50,35);                    {silnik tylni - dol}
    FillEllipse(x-5,31,3,3);                  {silnik gorny}
    Line(x-5,28,x+8,31);                      {silnik gorny - gora}
    Line(x-5,34,x+8,31);                      {silnik gorny - dol}
    FillEllipse(x-5,44,3,3);                  {silnik dolny}
    Line(x-5,41,x+8,44);                      {silnik dolny - gora}
    Line(x-5,47,x+8,44);                      {silnik dolny - dol}
     SetColor(7);
    Ellipse(x-19,41,0,360,1,10);              {slad smigla - kolo male}
    Line(x-19,31,x-19,28);                    {slad smigla malego - linia gorna}
    Line(x-19,51,x-19,54);                    {slad smigla malego - linia dolna}

    FloodFill(x+44,35,15);                     {wypelnienie tylniego silnika - biale - (przod)}
    FloodFill(x+47,35,15);                     {wypelnienie tylniego silnika - biale - (tyl)}
{    FloodFill(x-1,31,15);                      {wypelnienie gornego silnika - biale - (przod)}
    FloodFill(x+5,31,15);                      {wypelnienie gornego silnika - biale - (tyl)}
{    FloodFill(x-1,44,15);                      {wypelnienie dolnego silnika - biale - (przod)}
    FloodFill(x+5,44,15);                      {wypelnienie dolnego silnika - biale - (tyl)}
     SetFillStyle(1,7);                        {jasnoszary kolor wypelnienia}
    FloodFill(x-16,41,7);                     {wypelnienie dziobka od smigielka - jasnoszare}

    Line(x+5,33,x-3,40);                      {skos \ pomiedzy silnikami}
    Line(x-3,35,x+5,42);                      {skos / pomiedzy silnikami}
    Ellipse(x-19,41,0,360,3,20);              {slad smigla - duze kolo}
    Line(x+6,53,x+50,53);                     {smuga 1}
    Line(x+40,42,x+65,42);                    {smuga 2}
    Line(x+53,22,x+72,22);                    {smuga 3}
    Line(x+49,21,x+69,21);                    {smuga 4}

     SetColor(15);                             {bialy kolor linii}
    Line(x+6,31,x+6,44);                      {polaczenie silnikow - tylnie}
    Line(x-4,34,x-4,41);                      {polaczenie silnikow - przednie}

{napis}
     SetColor(14);                             {zolty kolor linii}
     SetFillStyle(1,14);                       {zolty kolor transparentu}
    Line(x+52,35,x+100,35);                   {sznurek}
    Line(x+100,35,x+130,2);                   {linka gorna}
    Line(x+100,35,x+130,70);                  {linka dolna}
    Bar(x+625,2,x+130,70);                    {transparent}
     SetTextStyle(4,0,5);                      {gotyk - 5}
     SetTextJustify(1,1);                      {wyrownanie tekstu}
     SetColor(1);                              {niebieski kolor tekstu}
    OutTextXY(x+375,25,'M I L I O N E R Z Y');
  end;


{--Lewa-reka-na-sznurku-----------------------------------------------------}
Procedure reka_lewa_sznurek(x,y:integer);

  begin
     SetColor(15);                             {bialy kolor linii}
    Line(x-19,y+30,x-25,y+17);                {ramie - wewnetrzna}
    Line(x-19,y+32,x-26,y+17);                {ramie - zewnetrzna}
    Line(x-25,y+17,x-19,y+3);                 {przedramie - wewnwtrzna}
    Line(x-26,y+17,x-19,y+3);                 {przedramie - zewnetrzna}
    Line(x-19,y+3,x-18,y+2);                  {dlon - wewnatrz}
    Line(x-19,y+3,x-17,y+2);                  {dlon - zewnatrz}
  end;


{--Prawa-reka-na-sznurku----------------------------------------------------}
Procedure reka_prawa_sznurek(x,y:integer);

  begin
     SetColor(15);                             {bialy kolor linii}
    Line(x-19,y+30,x-12,y+17);                {ramie - wewnetrzna}
    Line(x-19,y+32,x-11,y+17);                {ramie - zewnetrzna}
    Line(x-12,y+17,x-19,y+6);                 {przedramie - wewnwtrzna}
    Line(x-11,y+17,x-19,y+6);                 {przedramie - zewnetrzna}
    Line(x-19,y+6,x-20,y+5);                  {dlon - wewnatrz}
    Line(x-19,y+6,x-21,y+5);                  {dlon - zewnatrz}
  end;

{==Cala-animacja-koncowa====================================================}
Procedure animacja_koncowa;

  begin
    cleardevice;
     SetFillStyle(1,0);
     SetTextJustify(1,1);
    wxs:=690;wy:=420;

    repeat {samolot leci, ludzik stoi}
       SetFillStyle(1,0);
      Bar(0,0,639,479);
      samolot_lewy(wxs);
       SetColor(15);
      Line(wxs+19,37,wxs+19,wy+30);
      ludzik_maly(500+38,wy);
      noga_lewa_stoi(500+38,wy);
      noga_prawa_stoi(500+38,wy);
      reka_lewa_dol(500+38,wy);
      reka_prawa_dol(500+38,wy);
      delay(delanim);
      wxs:=wxs-2;
    until (wxs=500) or keypressed;

    repeat {wciaganie ludzika}
       SetFillStyle(1,0);
      Bar(0,0,639,479);
      samolot_lewy(wxs);
       SetColor(15);
      Line(wxs+19,37,wxs+19,wy+30);
      ludzik_maly(wxs+38,wy);
      noga_lewa_stoi(wxs+38,wy);
      noga_prawa_stoi(wxs+38,wy);
      reka_lewa_sznurek(wxs+38,wy);
      reka_prawa_sznurek(wxs+38,wy);
      delay(delanim);
      wxs:=wxs-2;
      wy:=wy-2;
    until (wy=26) or keypressed;

    wy:=0;
    repeat{samolocik leci z ludzikiem w srodku}
       SetFillStyle(1,0);
      Bar(0,0,639,479);
      samolot_lewy(wxs);
      ludzik_maly(wxs+38,wy);
      reka_prawa_dol(wxs+38,wy);
      reka_lewa_dol(wxs+38,wy);
      delay(delanim);
      wxs:=wxs-2;
    until (wxs=-50) or keypressed;

    ClearDevice;
     SetFillStyle(1,10);
    Bar(694-625,2,694-130,70);                       {transparent}
     SetTextStyle(4,0,5);                         {gotyk - 5}
     SetTextJustify(1,1);
     SetColor(1);
    OutTextXY(694-375,25,'M I L I O N E R Z Y');    {napis - MILIONERZY}
    delay(delanim*20);
     SetTextStyle(0,0,3);
     SetColor(14);
    OutTextXY(320,250,'DO ZOBACZENIA !!!');
     delay(delgra);
  end;




{--Cialo-programu-----------------------------------------------------------}
{---------------------------------------------------------------------------}
{---------------------------------------------------------------------------}


BEGIN
    karta:=detect;
    InitGraph(karta,tryb,'c:\tp\bgi');
    animacja_poczatkowa;
    ClearDevice;
    repeat
      menu;
      if przycisk1 then
        if podswietl=1 then
          begin
            ukryj;
            ClearDevice;
            gra;
            ClearDevice;
            pokaz;
          end
          else if podswietl=2 then
            begin
              CloseGraph;
              wpis;
              InitGraph(karta,tryb,'c:\tp\bgi');
              ClearDevice;
            end;
    until (podswietl=3) and przycisk1;
    ukryj;
    animacja_koncowa;
  CloseGraph;
END.