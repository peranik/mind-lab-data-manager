USE mind_lab_data_manager;

-- BTREE, brza tekstualna pretraga, neklasterovan, PK 'tip_id' je vec klasterovan, 
-- ubrzava filter po nazivu tipa ankete
CREATE INDEX IX_tip_ankete_naziv ON tip_ankete (naziv);

-- BTREE, efikasan JOIN i sortiranje, neklasterovan,
-- PK 'anketa_id' treba da ostane klasterovan, ubrzava pretragu anketa po tipu
CREATE INDEX IX_anketa_tip_naziv ON anketa (tip_id, naziv);

-- BTREE, tacan JOIN po ID, neklasterovan, 
-- PK '(istrazivac_id, anketa_id)' vec odredjuje raspored, ubrzava vezu anketa->dizajner
CREATE INDEX IX_dizajner_anketa_anketa_istrazivac ON dizajner_anketa (anketa_id, istrazivac_id);

-- BTREE, dobar za filter i opseg datuma, neklasterovan, 
-- PK 'izvodjenje_id' ostaje klasterovan, ubrzava pretragu izvodjenja po laboratoriji
CREATE INDEX IX_izvodjenje_lab_datum_izvodjenje ON izvodjenje (lab_id, datum, izvodjenje_id);

-- BTREE, brz JOIN i provera intervala,
-- neklasterovan, PK 'sesija_id' ostaje klasterovan, ubrzava proveru preklapanja termina
CREATE INDEX IX_sesija_izvodjenje_vreme ON sesija (izvodjenje_id, vreme_pocetka, vreme_zavrsetka);

-- BTREE, efikasan JOIN po FK, neklasterovan, 
-- PK 'alat_id' je vec klasterovan, ubrzava izbor alata po laboratoriji
CREATE INDEX IX_alat_lab_tip_alat ON alat (lab_id, tip_alata_id, alat_id);

-- BTREE, brz rad sa datumima, neklasterovan,
-- raspored po 'alat_id' ne treba menjati, ubrzava min/max nabavke po laboratoriji
CREATE INDEX IX_alat_lab_datum_nabavke ON alat (lab_id, datum_nabavke);

-- BTREE, tacna pretraga po sifri, neklasterovan, 
-- PK 'ucesnik_id' je stabilniji klasterovani kljuc, ubrzava sortiranje i proveru jedinstvenosti
CREATE UNIQUE INDEX IX_ucesnik_sifra ON ucesnik (sifra);

-- BTREE, brzo sortiranje po nazivu, neklasterovan,
--  PK 'istrazivac_id' vec nosi klasterovanje, ubrzava prikaz istrazivaca po imenu
CREATE INDEX IX_istrazivac_naziv ON istrazivac (naziv);

-- BTREE, efikasan JOIN iz obrnutog smera, neklasterovan, 
-- PK '(anketa_id, teorija_id)' vec definise raspored, ubrzava pretragu anketa po teoriji
CREATE INDEX IX_anketa_teorija_teorija_anketa ON anketa_teorija (teorija_id, anketa_id);
