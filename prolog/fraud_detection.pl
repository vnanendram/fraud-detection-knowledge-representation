% ============================================================
% Fraud-Detektion - Prolog-System (SWISH / SWI-Prolog)
% Finaldokumentation Gruppe 8, Aufgabe 4b
%
% Struktur: Eine Transaktion referenziert die KREDITKARTE,
% nicht direkt den Karteninhaber. Der Karteninhaber (und damit
% dessen Land/Region) wird ueber die Karte abgeleitet.
% ============================================================


% ============================================================
% 5.2 Faktenbasis
% ============================================================

% --- Karteninhaber ---
karteninhaber(sutter).
karteninhaber(mueller).

% --- Kreditkarten ---
kreditkarte(karte_sutter).
kreditkarte(karte_mueller).

% --- Karte gehoert zu Karteninhaber ---
gehoert_zu_karteninhaber(karte_sutter, sutter).
gehoert_zu_karteninhaber(karte_mueller, mueller).

% --- Karteninhaber ist ansaessig in Land ---
ansaessig_in(sutter, schweiz).
ansaessig_in(mueller, deutschland).

% --- Laender ---
land(schweiz).
land(deutschland).
land(suedafrika).
land(marokko).

% --- Regionen ---
region(schweiz_region).
region(europa).
region(afrika).

% --- Land gehoert zu Region ---
gehoert_zu_region(schweiz, schweiz_region).
gehoert_zu_region(deutschland, europa).
gehoert_zu_region(suedafrika, afrika).
gehoert_zu_region(marokko, afrika).

% --- Haendler ---
haendler(world_of_africa).
haendler(winds_of_deserts).
haendler(south_african_master_pieces).

% --- Haendler befindlich in Land ---
befindlich_in(world_of_africa, suedafrika).
befindlich_in(winds_of_deserts, marokko).
befindlich_in(south_african_master_pieces, suedafrika).

% --- Dienstleistungsart der Haendler ---
hat_dienstleistungsart(world_of_africa, physischer_shop).
hat_dienstleistungsart(winds_of_deserts, physischer_shop).
hat_dienstleistungsart(south_african_master_pieces, internet_shop).

% --- Transaktionen: transaktion(ID, Kreditkarte, Haendler, Betrag, Zeitstempel) ---
transaktion(t1, karte_sutter, world_of_africa, 11234, 1000000).
transaktion(t2, karte_mueller, winds_of_deserts, 12, 1000100).
transaktion(t3, karte_sutter, winds_of_deserts, 500, 1000180).
transaktion(t4, karte_mueller, south_african_master_pieces, 102, 1000300).

% --- Vorherige Transaktion (fuer die Zeitdifferenzregel) ---
vorherige_transaktion(t3, t1).


% ============================================================
% 5.3 Ableitung von Karteninhaberland und Haendlerland
% ============================================================

% Land des Karteninhabers einer Transaktion ableiten
karteninhaber_land(Transaktion, Land) :-
    transaktion(Transaktion, Kreditkarte, _, _, _),
    gehoert_zu_karteninhaber(Kreditkarte, Karteninhaber),
    ansaessig_in(Karteninhaber, Land).

% Haendlerland einer Transaktion ableiten
haendler_land(Transaktion, Land) :-
    transaktion(Transaktion, _, Haendler, _, _),
    befindlich_in(Haendler, Land).

% Dienstleistungsart einer Transaktion ableiten
dienstleistungsart_transaktion(Transaktion, Typ) :-
    transaktion(Transaktion, _, Haendler, _, _),
    hat_dienstleistungsart(Haendler, Typ).


% ============================================================
% 5.4 Teilrisiken
% ============================================================

% --- Risiko aufgrund der Region des Karteninhabers ---
karteninhaber_region_risiko(Transaktion, Risiko) :-
    karteninhaber_land(Transaktion, Land),
    gehoert_zu_region(Land, Region),
    risiko_karteninhaber_region(Region, Risiko).

risiko_karteninhaber_region(schweiz_region, 0).
risiko_karteninhaber_region(europa, 20).
risiko_karteninhaber_region(afrika, 10).

% --- Risiko aufgrund der Region des Haendlers ---
haendler_region_risiko(Transaktion, Risiko) :-
    haendler_land(Transaktion, Land),
    gehoert_zu_region(Land, Region),
    risiko_haendler_region(Region, Risiko).

risiko_haendler_region(schweiz_region, 10).
risiko_haendler_region(europa, 20).
risiko_haendler_region(afrika, 60).

% --- Risiko aufgrund des Betrags ---
betragsrisiko(Transaktion, 10) :-
    transaktion(Transaktion, _, _, Betrag, _),
    Betrag < 1000.

betragsrisiko(Transaktion, 60) :-
    transaktion(Transaktion, _, _, Betrag, _),
    Betrag >= 1000,
    Betrag < 10000.

betragsrisiko(Transaktion, 90) :-
    transaktion(Transaktion, _, _, Betrag, _),
    Betrag >= 10000.


% ============================================================
% 5.5 Zeitdifferenzregel
% Gleiche Kreditkarte, zwei verschiedene Laender,
% maximal 300 Sekunden Unterschied, physischer Shop.
% ============================================================
zeitdifferenz_risiko(Transaktion, 150) :-
    vorherige_transaktion(Transaktion, Vorherige),
    transaktion(Transaktion, Kreditkarte, _, _, Zeit),
    transaktion(Vorherige, Kreditkarte, _, _, ZeitVorher),
    haendler_land(Transaktion, LandAktuell),
    haendler_land(Vorherige, LandVorher),
    LandAktuell \= LandVorher,
    Diff is abs(Zeit - ZeitVorher),
    Diff =< 300,
    dienstleistungsart_transaktion(Transaktion, physischer_shop), !.

zeitdifferenz_risiko(_, 0).


% ============================================================
% 5.6 Haendler-Karteninhaber-Restriktion (neu in Aufgabe 4)
% Schweizer Karteninhaber verwendet die Kreditkarte bei einem
% Haendler in Suedafrika -> zusaetzliches Risiko von 30.
% ============================================================
haendler_karteninhaber_restriktion(Transaktion, 30) :-
    karteninhaber_land(Transaktion, schweiz),
    haendler_land(Transaktion, suedafrika), !.

haendler_karteninhaber_restriktion(_, 0).


% ============================================================
% 5.7 Gesamtrisiko und Entscheidung
% ============================================================
basisrisiko(Transaktion, Risiko) :-
    karteninhaber_region_risiko(Transaktion, R1),
    haendler_region_risiko(Transaktion, R2),
    betragsrisiko(Transaktion, R3),
    haendler_karteninhaber_restriktion(Transaktion, R4),
    Risiko is R1 + R2 + R3 + R4.

gesamtrisiko(Transaktion, Risiko) :-
    basisrisiko(Transaktion, Basis),
    zeitdifferenz_risiko(Transaktion, ZeitRisiko),
    Risiko is max(Basis, ZeitRisiko).

entscheidung(Transaktion, akzeptiert) :-
    gesamtrisiko(Transaktion, Risiko),
    Risiko < 100.

entscheidung(Transaktion, gestoppt) :-
    gesamtrisiko(Transaktion, Risiko),
    Risiko >= 100,
    Risiko < 150.

entscheidung(Transaktion, abgelehnt) :-
    gesamtrisiko(Transaktion, Risiko),
    Risiko >= 150.


% ============================================================
% 5.8 A- und B-Transaktion
% A-Transaktion: jede Transaktion in einem Internet-Shop.
% B-Transaktion wird NICHT als allgemeine Regel implementiert,
% weil nicht alle A-Regeln bekannt sind. Aus "nicht als A
% bekannt" darf nicht sicher auf B geschlossen werden.
% ============================================================
a_transaktion(Transaktion) :-
    dienstleistungsart_transaktion(Transaktion, internet_shop).


% ============================================================
% 5.9 Beispielqueries
% ?- gesamtrisiko(t1, R).   % R = 180
% ?- entscheidung(t1, E).   % E = abgelehnt
% ?- gesamtrisiko(t2, R).   % R = 90
% ?- entscheidung(t2, E).   % E = akzeptiert
% ?- gesamtrisiko(t3, R).   % R = 150
% ?- entscheidung(t3, E).   % E = abgelehnt
% ?- a_transaktion(t4).     % true
% ============================================================
