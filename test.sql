DROP DATABASE IF EXISTS mind_lab_data_manager;

CREATE DATABASE mind_lab_data_manager;

USE mind_lab_data_manager;

CREATE TABLE tip_ankete (
    tip_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL
);

CREATE TABLE anketa (
    anketa_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL,
    tip_id INT NOT NULL,
	FOREIGN KEY  (tip_id) REFERENCES tip_ankete(tip_id)
		ON UPDATE CASCADE
);


CREATE TABLE laboratorija (
    lab_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL
);

CREATE TABLE onlajn_centar (
    lab_id INT NOT NULL PRIMARY KEY,
    FOREIGN KEY (lab_id) REFERENCES laboratorija(lab_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
    onlajn_platforma VARCHAR(50) NOT NULL,
    link VARCHAR(255) NOT NULL
);

CREATE TABLE institut (
	lab_id INT NOT NULL PRIMARY KEY,
    FOREIGN KEY (lab_id) REFERENCES laboratorija(lab_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
    fizicka_adresa VARCHAR(100) NOT NULL
);

CREATE TABLE ucesnik (
    ucesnik_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    sifra VARCHAR(20) NOT NULL,
    pol CHAR(1),
    starost INT,
    obrazovanje VARCHAR(50),
    opis VARCHAR(1000) 
);

CREATE TABLE ucesce (
    lab_id INT NOT NULL,
    ucesnik_id INT NOT NULL,
    status VARCHAR(20),
    PRIMARY KEY (lab_id, ucesnik_id),
    FOREIGN KEY(lab_id) REFERENCES laboratorija(lab_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (ucesnik_id) REFERENCES ucesnik(ucesnik_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE tip_alata (
    tip_alata_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL,
    opis VARCHAR(1000)
);

CREATE TABLE alat (
    alat_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    datum_nabavke DATE NOT NULL,
    datum_proizvodnje DATE,
    lab_id INT,
    tip_alata_id INT NOT NULL,
	FOREIGN KEY (tip_alata_id) REFERENCES tip_alata(tip_alata_id)
		ON UPDATE CASCADE,
	FOREIGN KEY (lab_id) REFERENCES laboratorija(lab_id)
    ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE tip_teorije (
    tip_teorije_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL
);

CREATE TABLE teorija (

    teorija_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL,
    opis VARCHAR(1000),
	tip_teorije_id INT NOT NULL,
	FOREIGN KEY (tip_teorije_id) REFERENCES tip_teorije(tip_teorije_id)
		ON UPDATE CASCADE
);

CREATE TABLE izvodjenje (
    izvodjenje_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    lab_id INT NOT NULL,
    datum DATE NOT NULL,
    status VARCHAR(20),
    anketa_id INT NOT NULL,
    FOREIGN KEY (lab_id)
        REFERENCES laboratorija(lab_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (anketa_id)
        REFERENCES anketa(anketa_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE sesija (
    sesija_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    izvodjenje_id INT NOT NULL,
    vreme_pocetka TIME NOT NULL,
    vreme_zavrsetka TIME,

    FOREIGN KEY (izvodjenje_id)
        REFERENCES izvodjenje(izvodjenje_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE alat_sesija(
	sesija_id INT NOT NULL,
    alat_id INT NOT NULL,
    PRIMARY KEY (sesija_id,alat_id),
    FOREIGN KEY (sesija_id) REFERENCES sesija(sesija_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (alat_id) REFERENCES alat(alat_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE sesija_ucesnik(
	sesija_id INT NOT NULL,
    ucesnik_id INT NOT NULL,
    PRIMARY KEY (sesija_id,ucesnik_id),
    FOREIGN KEY (sesija_id) REFERENCES sesija(sesija_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (ucesnik_id) REFERENCES ucesnik(ucesnik_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE istrazivac (
    istrazivac_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL,
    kvalifikacije VARCHAR(100),
    specijalizacija VARCHAR(100)
);

CREATE TABLE dizajner (
    istrazivac_id INT NOT NULL PRIMARY KEY,
	FOREIGN KEY (istrazivac_id) REFERENCES istrazivac(istrazivac_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE izvodjac (
    istrazivac_id INT NOT NULL PRIMARY KEY,
    FOREIGN KEY (istrazivac_id) REFERENCES istrazivac(istrazivac_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE anketa_teorija (
    anketa_id INT NOT NULL,
    teorija_id INT NOT NULL,
    PRIMARY KEY (anketa_id, teorija_id),
    FOREIGN KEY (anketa_id) REFERENCES anketa(anketa_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (teorija_id) REFERENCES teorija(teorija_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE izvodjenje_izvodjac (
    izvodjenje_id INT NOT NULL,
    istrazivac_id INT NOT NULL,
    PRIMARY KEY (izvodjenje_id, istrazivac_id),

    FOREIGN KEY (izvodjenje_id)
		REFERENCES izvodjenje(izvodjenje_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (istrazivac_id)
        REFERENCES izvodjac(istrazivac_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE dizajner_anketa (
    istrazivac_id INT NOT NULL,
    anketa_id INT NOT NULL,
    PRIMARY KEY (istrazivac_id, anketa_id),
    FOREIGN KEY (istrazivac_id) REFERENCES dizajner(istrazivac_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (anketa_id) REFERENCES anketa(anketa_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);


-- View se dodaje da bi se mogao pogledati spisak imena dizajnera koji su dizajnirali upitnike
-- Veoma je bitno da mogu da se pogledaju dizajneri koji su dizajnirali upitnike

DROP VIEW IF EXISTS view_dizajneri_upitnika;
CREATE VIEW view_dizajneri_upitnika
AS SELECT DISTINCT istrazivac.naziv -- ,tip_ankete.naziv
AS stvaraoci_upitnika FROM tip_ankete
INNER JOIN anketa ON tip_ankete.tip_id=anketa.tip_id
INNER JOIN dizajner_anketa ON anketa.anketa_id=dizajner_anketa.anketa_id
INNER JOIN dizajner on dizajner_anketa.istrazivac_id=dizajner.istrazivac_id
INNER JOIN istrazivac on dizajner.istrazivac_id=istrazivac.istrazivac_id
WHERE tip_ankete.naziv LIKE "Upitnik"
GROUP BY tip_ankete.naziv,istrazivac.naziv ORDER BY istrazivac.naziv asc;

-- SELECT * FROM view_dizajneri_upitnika;

DROP VIEW IF EXISTS pregled_sesija_eksperimenata;

CREATE VIEW pregled_sesija_eksperimenata AS
SELECT
    sesija.sesija_id,
    izvodjenje.datum,
    sesija.vreme_pocetka,
    sesija.vreme_zavrsetka,
    izvodjenje.status AS status_izvodjenja,
    anketa.naziv AS naziv_ankete,
    laboratorija.naziv AS naziv_laboratorije,
    COUNT(DISTINCT alat_sesija.alat_id) AS broj_alata,
    COUNT(DISTINCT sesija_ucesnik.ucesnik_id) AS broj_ucesnika
FROM sesija
JOIN izvodjenje
    ON sesija.izvodjenje_id = izvodjenje.izvodjenje_id
JOIN anketa
    ON izvodjenje.anketa_id = anketa.anketa_id
JOIN laboratorija
    ON izvodjenje.lab_id = laboratorija.lab_id
LEFT JOIN alat_sesija
    ON sesija.sesija_id = alat_sesija.sesija_id
LEFT JOIN sesija_ucesnik
    ON sesija.sesija_id = sesija_ucesnik.sesija_id
GROUP BY
    sesija.sesija_id,
    izvodjenje.datum,
    sesija.vreme_pocetka,
    sesija.vreme_zavrsetka,
    izvodjenje.status,
    anketa.naziv,
    laboratorija.naziv
HAVING COUNT(DISTINCT sesija.sesija_id) > 0
ORDER BY
    izvodjenje.datum ASC,
    sesija.sesija_id ASC,
    sesija.vreme_pocetka ASC,
    sesija.vreme_zavrsetka DESC;
-- SELECT * FROM pregled_sesija_eksperimenata;

-- View se dodaje da bi se mogao pogledati spisak alata povezanih sa sesijom
-- Veoma je bitno da mogu da se prikazu alati za izbor pri uklanjanju iz sesije

DROP VIEW IF EXISTS pregled_alata_sesije;

CREATE VIEW pregled_alata_sesije AS
SELECT
    alat_sesija.sesija_id,
    alat.alat_id,
    tip_alata.naziv
FROM alat_sesija
JOIN alat
    ON alat_sesija.alat_id = alat.alat_id
JOIN tip_alata
    ON alat.tip_alata_id = tip_alata.tip_alata_id;
-- SELECT * FROM pregled_alata_sesije;

-- View se dodaje da bi se mogao pogledati spisak dostupnih alata za dodelu sesiji
-- Veoma je bitno da alat bude iz iste laboratorije i da vec nije dodat toj sesiji

DROP VIEW IF EXISTS pregled_dostupnih_alata_za_sesiju;

CREATE VIEW pregled_dostupnih_alata_za_sesiju AS
SELECT
    sesija.sesija_id,
    alat.alat_id,
    tip_alata.naziv
FROM sesija
JOIN izvodjenje
    ON sesija.izvodjenje_id = izvodjenje.izvodjenje_id
JOIN alat
    ON izvodjenje.lab_id = alat.lab_id
JOIN tip_alata
    ON alat.tip_alata_id = tip_alata.tip_alata_id
WHERE NOT EXISTS (
    SELECT 1
    FROM alat_sesija
    WHERE alat_sesija.sesija_id = sesija.sesija_id
    AND alat_sesija.alat_id = alat.alat_id
);
-- SELECT * FROM pregled_dostupnih_alata_za_sesiju;

-- View se dodaje da bi se mogao pogledati spisak ucesnika povezanih sa sesijom
-- Veoma je bitno da mogu da se prikazu ucesnici za izbor pri uklanjanju iz sesije

DROP VIEW IF EXISTS pregled_ucesnika_sesije;

CREATE VIEW pregled_ucesnika_sesije AS
SELECT
    sesija_ucesnik.sesija_id,
    ucesnik.ucesnik_id,
    ucesnik.sifra,
    ucesnik.pol,
    ucesnik.starost,
    ucesnik.obrazovanje,
    ucesnik.opis
FROM sesija_ucesnik
JOIN ucesnik
    ON sesija_ucesnik.ucesnik_id = ucesnik.ucesnik_id;
-- SELECT * FROM pregled_ucesnika_sesije;

-- View se dodaje da bi se mogao pogledati spisak dostupnih ucesnika za dodelu sesiji
-- Veoma je bitno da ucesnik bude iz iste laboratorije i da vec nije dodat toj sesiji

DROP VIEW IF EXISTS pregled_dostupnih_ucesnika_za_sesiju;

CREATE VIEW pregled_dostupnih_ucesnika_za_sesiju AS
SELECT
    sesija.sesija_id,
    ucesnik.ucesnik_id,
    ucesnik.sifra,
    ucesnik.pol,
    ucesnik.starost,
    ucesnik.obrazovanje,
    ucesnik.opis
FROM sesija
JOIN izvodjenje
    ON sesija.izvodjenje_id = izvodjenje.izvodjenje_id
JOIN ucesce
    ON izvodjenje.lab_id = ucesce.lab_id
JOIN ucesnik
    ON ucesce.ucesnik_id = ucesnik.ucesnik_id
WHERE NOT EXISTS (
    SELECT 1
    FROM sesija_ucesnik
    WHERE sesija_ucesnik.sesija_id = sesija.sesija_id
    AND sesija_ucesnik.ucesnik_id = ucesnik.ucesnik_id
);
-- SELECT * FROM pregled_dostupnih_ucesnika_za_sesiju;



-- FUNKCIJA KOJA PROVERAVA DA LI LABORATORIJA MOZE BITI OBRISANA
DELIMITER $$

CREATE FUNCTION can_delete_laboratorija(labBrisanje INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE cnt INT;

    SELECT COUNT(istrazivac_id) INTO cnt
    FROM laboratorija
    INNER JOIN izvodjenje on laboratorija.lab_id=izvodjenje.lab_id
    INNER JOIN izvodjenje_izvodjac ON izvodjenje.izvodjenje_id=izvodjenje_izvodjac.izvodjenje_id
    WHERE laboratorija.lab_id=labBrisanje;

    RETURN cnt = 0;
END $$
DELIMITER ;
-- PROCEDURA KOJA BRISE LABORATORIJU AKO JE TO DOZVOLJENO PRETHODNOM FUNKCIJOM
DROP PROCEDURE IF EXISTS delete_laboratory;
DELIMITER $$

CREATE PROCEDURE delete_laboratory(IN labBrisanje INT, OUT rezultat BOOL)
BEGIN
	DECLARE brisanje BOOLEAN;
    SET rezultat=FALSE;
    SET brisanje = can_delete_laboratorija(labBrisanje);
    IF brisanje THEN
        START TRANSACTION;
        DELETE FROM laboratorija
        WHERE lab_id = labBrisanje;
        SET rezultat = TRUE;
        COMMIT;
    END IF;
END $$

DELIMITER ;

-- Procedura kojom se menja vreme u sesiji

DROP PROCEDURE IF EXISTS izmeni_vreme_sesije;
DELIMITER $$
CREATE PROCEDURE izmeni_vreme_sesije(
IN idSesije INT,
IN novoVremePocetka VARCHAR(20),
IN novoVremeZavrsetka VARCHAR(20),
OUT poruka VARCHAR(100)
)
BEGIN
DECLARE pocetak TIME;
DECLARE kraj TIME;
DECLARE labSesije INT;

SET pocetak=STR_TO_DATE(novoVremePocetka, '%H:%i:%s');
SET kraj=STR_TO_DATE(novoVremeZavrsetka, '%H:%i:%s');
SELECT izvodjenje.lab_id
INTO labSesije
FROM sesija
JOIN izvodjenje ON sesija.izvodjenje_id = izvodjenje.izvodjenje_id
WHERE sesija.sesija_id = idSesije;

IF pocetak IS NULL OR kraj IS NULL THEN
	SET poruka='Neispravan format vremena';
ELSEIF pocetak >= kraj THEN
	SET poruka='Pocetak mora biti pre kraja';
ELSEIF EXISTS (
	SELECT 1
    FROM sesija
    JOIN izvodjenje ON sesija.izvodjenje_id = izvodjenje.izvodjenje_id
    WHERE sesija.sesija_id<>idSesije
    AND izvodjenje.lab_id = labSesije
    AND sesija.vreme_pocetka<kraj
    AND sesija.vreme_zavrsetka>pocetak
)THEN
	SET poruka='Termin je zauzet';
ELSE
    UPDATE SESIJA SET vreme_pocetka=pocetak,
    vreme_zavrsetka=kraj
    WHERE sesija_id=idSesije;

    SET poruka='Uspesno izmenjeno';
END IF;

END$$
DELIMITER ;

-- Procedura kojom se menja status izvodjenja vezanog za sesiju

DROP PROCEDURE IF EXISTS izmeni_status_izvodjenja;
DELIMITER $$
CREATE PROCEDURE izmeni_status_izvodjenja(
IN idSesije INT,
IN noviStatus VARCHAR(20),
OUT poruka VARCHAR(100)
)
BEGIN
IF noviStatus IS NULL OR TRIM(noviStatus) = '' THEN
    SET poruka='Status ne sme biti prazan';
ELSEIF NOT EXISTS (
    SELECT 1
    FROM sesija
    WHERE sesija.sesija_id = idSesije
) THEN
    SET poruka='Sesija ne postoji';
ELSE
    UPDATE izvodjenje
    JOIN sesija ON sesija.izvodjenje_id = izvodjenje.izvodjenje_id
    SET izvodjenje.status = TRIM(noviStatus)
    WHERE sesija.sesija_id = idSesije;

    SET poruka='Uspesno izmenjeno';
END IF;
END$$
DELIMITER ;

-- Procedura kojom se dodaje alat u sesiju

DROP PROCEDURE IF EXISTS dodaj_alat_u_sesiju;
DELIMITER $$
CREATE PROCEDURE dodaj_alat_u_sesiju(
IN idSesije INT,
IN idAlata INT,
OUT poruka VARCHAR(100)
)
BEGIN
DECLARE labSesije INT;
DECLARE labAlata INT;
DECLARE vecPostojiVeza INT DEFAULT 0;

DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    ROLLBACK;
    SET poruka = 'Greska pri dodavanju alata';
END;

SELECT izvodjenje.lab_id
INTO labSesije
FROM sesija
JOIN izvodjenje ON sesija.izvodjenje_id = izvodjenje.izvodjenje_id
WHERE sesija.sesija_id = idSesije;

SELECT alat.lab_id
INTO labAlata
FROM alat
WHERE alat.alat_id = idAlata;

SELECT COUNT(*)
INTO vecPostojiVeza
FROM alat_sesija
WHERE sesija_id = idSesije AND alat_id = idAlata;

IF labSesije IS NULL THEN
    SET poruka = 'Sesija ne postoji';
ELSEIF labAlata IS NULL THEN
    SET poruka = 'Alat ne postoji ili nije dodeljen laboratoriji';
ELSEIF labSesije <> labAlata THEN
    SET poruka = 'Alat nije iz iste laboratorije kao sesija';
ELSEIF vecPostojiVeza > 0 THEN
    SET poruka = 'Alat je vec dodat toj sesiji';
ELSE
    START TRANSACTION;

    INSERT INTO alat_sesija (sesija_id, alat_id)
    VALUES (idSesije, idAlata);

    UPDATE alat_sesija
    SET alat_id = idAlata
    WHERE sesija_id = idSesije AND alat_id = idAlata;

    COMMIT;
    SET poruka = 'Uspesno dodat alat';
END IF;
END$$
DELIMITER ;

-- Procedura kojom se uklanja alat iz sesije

DROP PROCEDURE IF EXISTS ukloni_alat_iz_sesije;
DELIMITER $$
CREATE PROCEDURE ukloni_alat_iz_sesije(
IN idSesije INT,
IN idAlata INT,
OUT poruka VARCHAR(100)
)
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM alat_sesija
    WHERE sesija_id = idSesije AND alat_id = idAlata
) THEN
    SET poruka = 'Veza sesije i alata ne postoji';
ELSE
    DELETE FROM alat_sesija
    WHERE sesija_id = idSesije AND alat_id = idAlata;

    SET poruka = 'Uspesno uklonjen alat';
END IF;
END$$
DELIMITER ;

-- Procedura kojom se dodaje ucesnik u sesiju

DROP PROCEDURE IF EXISTS dodaj_ucesnika_u_sesiju;
DELIMITER $$
CREATE PROCEDURE dodaj_ucesnika_u_sesiju(
IN idSesije INT,
IN idUcesnika INT,
OUT poruka VARCHAR(100)
)
BEGIN
DECLARE labSesije INT;

SELECT izvodjenje.lab_id
INTO labSesije
FROM sesija
JOIN izvodjenje ON sesija.izvodjenje_id = izvodjenje.izvodjenje_id
WHERE sesija.sesija_id = idSesije;

IF labSesije IS NULL THEN
    SET poruka = 'Sesija ne postoji';
ELSEIF NOT EXISTS (
    SELECT 1
    FROM ucesce
    WHERE ucesce.ucesnik_id = idUcesnika
    AND ucesce.lab_id = labSesije
) THEN
    SET poruka = 'Ucesnik nije iz iste laboratorije kao sesija';
ELSEIF EXISTS (
    SELECT 1
    FROM sesija_ucesnik
    WHERE sesija_id = idSesije AND ucesnik_id = idUcesnika
) THEN
    SET poruka = 'Ucesnik je vec dodat toj sesiji';
ELSE
    INSERT INTO sesija_ucesnik (sesija_id, ucesnik_id)
    VALUES (idSesije, idUcesnika);

    SET poruka = 'Uspesno dodat ucesnik';
END IF;
END$$
DELIMITER ;

-- Procedura kojom se uklanja ucesnik iz sesije

DROP PROCEDURE IF EXISTS ukloni_ucesnika_iz_sesije;
DELIMITER $$
CREATE PROCEDURE ukloni_ucesnika_iz_sesije(
IN idSesije INT,
IN idUcesnika INT,
OUT poruka VARCHAR(100)
)
BEGIN
IF NOT EXISTS (
    SELECT 1
    FROM sesija_ucesnik
    WHERE sesija_id = idSesije AND ucesnik_id = idUcesnika
) THEN
    SET poruka = 'Veza sesije i ucesnika ne postoji';
ELSE
    DELETE FROM sesija_ucesnik
    WHERE sesija_id = idSesije AND ucesnik_id = idUcesnika;

    SET poruka = 'Uspesno uklonjen ucesnik';
END IF;
END$$
DELIMITER ;

-- FUNKCIJA KOJA TESTIRA FUNKCIJU ZA BRISANJE LABORATORIJE
DELIMITER $$
CREATE FUNCTION fn_test_lab_can_delete()
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE ok BOOLEAN DEFAULT TRUE;

    -- test 1
    IF fn_lab_can_delete(1) NOT IN (0,1) THEN SET ok = FALSE; END IF;

    -- test 2
    IF fn_lab_can_delete(2) NOT IN (0,1) THEN SET ok = FALSE; END IF;

    -- test 3
    IF fn_lab_can_delete(3) NOT IN (0,1) THEN SET ok = FALSE; END IF;

    -- test 4
    IF fn_lab_can_delete(4) NOT IN (0,1) THEN SET ok = FALSE; END IF;

    -- test 5
    IF fn_lab_can_delete(5) NOT IN (0,1) THEN SET ok = FALSE; END IF;

    RETURN ok;
END $$

DELIMITER ;

DELIMITER //

CREATE PROCEDURE sp_update_session(
    IN p_id INT,
    IN p_datum VARCHAR(50),
    IN p_vreme VARCHAR(50)
)
BEGIN
    UPDATE sesija
    SET vreme_pocetka = STR_TO_DATE(p_vreme, '%H:%i:%s')
    WHERE sesija_id = p_id;
END//

DELIMITER ;
-- ============================================
-- INSERTS ZA MIND_LAB_DATA_MANAGER
-- 100+ redova po tabeli
-- ============================================

USE mind_lab_data_manager;

-- ============================================
-- TIP_ANKETE (100 redova)
-- ============================================
INSERT INTO tip_ankete (naziv) VALUES
('Eksperimentalna'),
('Upitnik'),
('Intervju'),
('Fokus grupa'),
('Case study'),
('Longitudinalna'),
('Cross-sectional'),
('Korelaciona'),
('Deskriptivna'),
('Eksplorativna'),
('Kvalitativna'),
('Kvantitativna'),
('Mešovita metoda'),
('Observaciona'),
('Participativna'),
('Etnografska'),
('Fenomenološka'),
('Grounded theory'),
('Akciona'),
('Evaluaciona'),
('Meta-analiza'),
('Sistematski pregled'),
('Pilot studija'),
('Randomizovana'),
('Kontrolisana'),
('Dvostruko slepa'),
('Placebo kontrolisana'),
('Prospektivna'),
('Retrospektivna'),
('Kohortna'),
('Nested case-control'),
('Panel studija'),
('Trend studija'),
('Time series'),
('Eksperiment u polju'),
('Laboratorijski eksperiment'),
('Kvazi-eksperiment'),
('Pre-post dizajn'),
('Solomon dizajn'),
('Factorial dizajn'),
('Split-plot dizajn'),
('Repeated measures'),
('Mixed design'),
('Between-subjects'),
('Within-subjects'),
('Crossover dizajn'),
('Adaptive dizajn'),
('Sequential dizajn'),
('Bayesian dizajn'),
('Pragmatski trial'),
('Superiority trial'),
('Non-inferiority trial'),
('Equivalence trial'),
('Dose-response'),
('Screening studija'),
('Dijagnostička studija'),
('Prognostička studija'),
('Etiološka studija'),
('Prevalence studija'),
('Incidence studija'),
('Risk assessment'),
('Cost-effectiveness'),
('Quality of life'),
('Patient satisfaction'),
('Clinical audit'),
('Service evaluation'),
('Needs assessment'),
('Benchmark studija'),
('Comparative studija'),
('Feasibility studija'),
('Acceptability studija'),
('Implementation studija'),
('Process evaluation'),
('Outcome evaluation'),
('Impact evaluation'),
('Formativna evaluacija'),
('Sumativna evaluacija'),
('Developmental evaluation'),
('Realist evaluation'),
('Theory-driven evaluation'),
('Utilization-focused'),
('Empowerment evaluation'),
('Participatory evaluation'),
('Responsive evaluation'),
('Goal-free evaluation'),
('Connoisseurship evaluation'),
('Adversary evaluation'),
('Transaction evaluation'),
('CIPP evaluation'),
('Logic model evaluation'),
('Experimental psychology'),
('Cognitive assessment'),
('Behavioral observation'),
('Neuropsychological'),
('Psychometric'),
('Sociometric'),
('Biometric'),
('Physiological monitoring'),
('Eye-tracking studija'),
('EEG studija'),
('fMRI studija');

-- ============================================
-- ANKETA (100 redova)
-- ============================================
INSERT INTO anketa (naziv, tip_id) VALUES
('Kognitivne funkcije - V1', 1),
('Memorijski test A', 2),
('Pažnja i koncentracija', 1),
('Emocionalna inteligencija', 2),
('Stres na radnom mestu', 3),
('Motivacija zaposlenih', 2),
('Leadership stil', 3),
('Organizaciona kultura', 4),
('Satisfakcija poslom', 2),
('Work-life balance', 2),
('Burnout sindrom', 2),
('Timski rad', 4),
('Komunikacijske veštine', 3),
('Konflikt menadžment', 4),
('Kreativnost i inovacije', 1),
('Problem solving', 1),
('Donošenje odluka', 1),
('Rizik percepcija', 2),
('Vremenska perspektiva', 2),
('Ciljevi i postignuća', 2),
('Self-efficacy skala', 2),
('Socijalna podrška', 2),
('Kvalitet života', 2),
('Subjektivna dobrobit', 2),
('Anksioznost - GAD7', 2),
('Depresija - PHQ9', 2),
('Psihološki kapital', 2),
('Reziliencija skala', 2),
('Optimizam test', 2),
('Lokus kontrole', 2),
('Perfekcionizam', 2),
('Prokrastinacija', 2),
('Asertivnost', 2),
('Empatija kvocijent', 2),
('Teorija uma test', 1),
('Moralno rezonovanje', 3),
('Vrednosni sistem', 2),
('Politička orijentacija', 2),
('Religioznost skala', 2),
('Kulturni identitet', 2),
('Akkulturacija', 2),
('Predrasude i stereotipi', 2),
('Implicitne asocijacije', 1),
('Socijalna distanca', 2),
('Kolektivizam vs individualizam', 2),
('Autoritarnost', 2),
('Socijalna dominacija', 2),
('Pravičnost percepcija', 2),
('Poverenje u institucije', 2),
('Građanska participacija', 2),
('Potrošačko ponašanje', 2),
('Brand lojalnost', 2),
('Advertising efektivnost', 1),
('Product placement efekat', 1),
('Cena percepcija', 2),
('Kupovna namera', 2),
('Customer satisfaction', 2),
('Service quality', 2),
('E-commerce preferencije', 2),
('Social media uticaj', 2),
('Influencer marketing', 2),
('Viral marketing', 1),
('Word-of-mouth', 2),
('Customer loyalty', 2),
('Sportska motivacija', 2),
('Exercise adherence', 2),
('Zdravstveno ponašanje', 2),
('Preventivne mere', 2),
('Adherencija terapiji', 2),
('Bolan prag', 1),
('Placebo efekat studija', 1),
('Nocebo efekat', 1),
('Patient empowerment', 2),
('Health literacy', 2),
('Medicinska adhezija', 2),
('Hronični bol', 2),
('Sleep quality', 2),
('Insomnia severity', 2),
('Chronotype upitnik', 2),
('Dietary habits', 2),
('Eating disorders', 2),
('Body image', 2),
('Physical activity', 2),
('Sedentary behavior', 2),
('Substance use', 2),
('Alcohol dependency', 2),
('Smoking cessation', 2),
('Gambling behavior', 2),
('Internet addiction', 2),
('Gaming disorder', 2),
('Social media addiction', 2),
('Smartphone dependency', 2),
('FOMO skala', 2),
('Digital wellbeing', 2),
('Cyberbullying', 2),
('Online dating behavior', 2),
('Privacy concerns', 2),
('Cyber security awareness', 2),
('AI attitudes', 2),
('Technology acceptance', 2),
('Innovation adoption', 2);

SELECT * FROM anketa WHERE anketa_id = 99;
-- ============================================
-- LABORATORIJA (100 redova)
-- ============================================
INSERT INTO laboratorija (naziv) VALUES
('Centralna laboratorija'),
('Kognitivni laboratorij'),
('Bihevioralni centar'),
('Neuropsihologijalab'),
('Razvojna psihologija'),
('Socijalna psihologija lab'),
('Organizaciona lab'),
('Klinička lab Beograd'),
('Edukaciona istraživanja'),
('Sport psihologija'),
('Lab za pažnju'),
('Memorijski centar'),
('Emocionalna inteligencija lab'),
('Kreativnost i inovacije'),
('Decision making lab'),
('Konflikt lab'),
('Motivaciona istraživanja'),
('Stres i health'),
('Sleep research'),
('Pain research center'),
('Addiction lab'),
('Eating behavior lab'),
('Child development'),
('Adolescent research'),
('Aging and cognition'),
('Dementia research'),
('Autism research center'),
('ADHD lab'),
('Anxiety disorders lab'),
('Depression research'),
('Trauma and PTSD'),
('Resilience lab'),
('Positive psychology'),
('Mindfulness center'),
('Psychotherapy research'),
('Counseling lab'),
('Career development'),
('Educational assessment'),
('Learning disabilities'),
('Gifted education'),
('Bilingualism lab'),
('Language development'),
('Reading research'),
('Math cognition'),
('STEM education'),
('Technology in education'),
('Online learning lab'),
('Gamification research'),
('Virtual reality lab'),
('Augmented reality'),
('Brain-computer interface'),
('Neurofeedback lab'),
('Biofeedback center'),
('Psychophysiology lab'),
('Eye-tracking lab'),
('EEG research'),
('fMRI center'),
('TMS lab'),
('Genetics and behavior'),
('Epigenetics lab'),
('Hormones and behavior'),
('Nutrition and cognition'),
('Exercise psychology'),
('Rehabilitation psychology'),
('Health promotion'),
('Behavioral medicine'),
('Chronic illness'),
('Palliative care research'),
('Quality of life lab'),
('Patient experience'),
('Medical decision making'),
('Risk communication'),
('Health communication'),
('Doctor-patient interaction'),
('Telemedicine research'),
('mHealth lab'),
('Digital health'),
('Wearables research'),
('Consumer psychology'),
('Marketing research lab'),
('Brand psychology'),
('Advertising effectiveness'),
('Social influence'),
('Persuasion lab'),
('Group dynamics'),
('Intergroup relations'),
('Prejudice and discrimination'),
('Social identity lab'),
('Cultural psychology'),
('Cross-cultural research'),
('Indigenous psychology'),
('Migration and acculturation'),
('Environmental psychology'),
('Sustainable behavior'),
('Climate change psychology'),
('Disaster psychology'),
('Terrorism research'),
('Political psychology'),
('Voting behavior'),
('Public opinion lab'),
('Media psychology'),
('Cyberpsychology'),
('Human-computer interaction'),
('User experience lab'),
('Delete behavior psychology'),
('Deletable memory studies'),
('Emotional deletion lab'),
('Cognitive delete patterns'),
('Psychology of forgetting'),
('Social deletion dynamics'),
('Digital identity deletion'),
('Selective memory deletion'),
('Delete anxiety research'),
('Behavioral deletion analysis'),
('Trauma and memory deletion'),
('Cyberpsychology of deletion'),
('Attachment and deletion lab'),
('Deletable habit formation'),
('Psychological reset studies');
-- Povezati ove obrisive laboratorije sa nekim alatima i tako time


-- ============================================
-- ONLAJN_CENTAR (50 redova - deo laboratorija)
-- ============================================
INSERT INTO onlajn_centar (lab_id, onlajn_platforma, link) VALUES
(1, 'Zoom', 'https://zoom.us/j/centralna-lab'),
(2, 'Microsoft Teams', 'https://teams.microsoft.com/kognitivni'),
(5, 'Google Meet', 'https://meet.google.com/razvojna-psi'),
(9, 'Zoom', 'https://zoom.us/j/edukacija-lab'),
(11, 'Webex', 'https://webex.com/paznja-lab'),
(15, 'Zoom', 'https://zoom.us/j/decision-making'),
(17, 'Teams', 'https://teams.microsoft.com/motivacija'),
(20, 'Zoom', 'https://zoom.us/j/pain-research'),
(23, 'Google Meet', 'https://meet.google.com/child-dev'),
(25, 'Zoom', 'https://zoom.us/j/aging-cognition'),
(30, 'Teams', 'https://teams.microsoft.com/depression'),
(32, 'Zoom', 'https://zoom.us/j/resilience'),
(33, 'Zoom', 'https://zoom.us/j/positive-psy'),
(35, 'Google Meet', 'https://meet.google.com/psychotherapy'),
(37, 'Zoom', 'https://zoom.us/j/career-dev'),
(40, 'Teams', 'https://teams.microsoft.com/gifted'),
(42, 'Zoom', 'https://zoom.us/j/language-dev'),
(46, 'Zoom', 'https://zoom.us/j/tech-education'),
(47, 'Google Meet', 'https://meet.google.com/online-learning'),
(48, 'Zoom', 'https://zoom.us/j/gamification'),
(60, 'Teams', 'https://teams.microsoft.com/hormones'),
(65, 'Zoom', 'https://zoom.us/j/health-promo'),
(68, 'Google Meet', 'https://meet.google.com/quality-life'),
(70, 'Zoom', 'https://zoom.us/j/medical-decision'),
(73, 'Teams', 'https://teams.microsoft.com/telemedicine'),
(74, 'Zoom', 'https://zoom.us/j/mhealth'),
(77, 'Zoom', 'https://zoom.us/j/consumer-psy'),
(80, 'Google Meet', 'https://meet.google.com/advertising'),
(82, 'Zoom', 'https://zoom.us/j/persuasion'),
(85, 'Teams', 'https://teams.microsoft.com/prejudice'),
(87, 'Zoom', 'https://zoom.us/j/cross-cultural'),
(90, 'Zoom', 'https://zoom.us/j/environmental'),
(91, 'Google Meet', 'https://meet.google.com/sustainable'),
(92, 'Zoom', 'https://zoom.us/j/climate-psy'),
(95, 'Teams', 'https://teams.microsoft.com/political'),
(96, 'Zoom', 'https://zoom.us/j/voting-behavior'),
(98, 'Google Meet', 'https://meet.google.com/media-psy'),
(99, 'Zoom', 'https://zoom.us/j/cyberpsychology'),
(100, 'Teams', 'https://teams.microsoft.com/ux-lab'),
(3, 'Zoom', 'https://zoom.us/j/behavioral-center'),
(6, 'Google Meet', 'https://meet.google.com/social-psy'),
(7, 'Teams', 'https://teams.microsoft.com/org-lab'),
(10, 'Zoom', 'https://zoom.us/j/sport-psy'),
(13, 'Webex', 'https://webex.com/emotional-intel'),
(18, 'Zoom', 'https://zoom.us/j/stress-health'),
(27, 'Google Meet', 'https://meet.google.com/autism-center'),
(34, 'Zoom', 'https://zoom.us/j/mindfulness'),
(41, 'Teams', 'https://teams.microsoft.com/bilingual'),
(50, 'Zoom', 'https://zoom.us/j/augmented-reality');

-- ============================================
-- INSTITUT (50 redova - deo laboratorija)
-- ============================================
INSERT INTO institut (lab_id, fizicka_adresa) VALUES
(4, 'Bulevar kralja Aleksandra 73, Beograd'),
(8, 'Nemanjina 22, Beograd'),
(12, 'Kneza Miloša 44, Beograd'),
(14, 'Terazije 25, Beograd'),
(16, 'Studentski trg 1, Beograd'),
(19, 'Kralja Petra 88, Beograd'),
(21, 'Đušina 7, Beograd'),
(22, 'Palmira Toljatija 3, Novi Beograd'),
(24, 'Vojvode Stepe 450, Beograd'),
(26, 'Pasterova 2, Beograd'),
(28, 'Resavska 33, Beograd'),
(29, 'Dr Subotića 8, Beograd'),
(31, 'Višegradska 26, Beograd'),
(36, 'Ćirila i Metodija 2, Niš'),
(38, 'Zorana Đinđića 1, Niš'),
(39, 'Jovana Cvijića bb, Kragujevac'),
(43, 'Svetozara Markovića 36, Kragujevac'),
(44, 'Trg Dositeja Obradovića 6, Novi Sad'),
(45, 'Dr Ilije Đuričića 1, Novi Sad'),
(49, 'Bulevar oslobođenja 81, Novi Sad'),
(51, 'Narodnih heroja 30, Subotica'),
(52, 'Milutina Milankovića 5, Beograd'),
(53, 'Vladimira Popovića 6, Beograd'),
(54, 'Save Kovačevića 14, Beograd'),
(55, 'Bulevar despota Stefana 68, Beograd'),
(56, 'Rajićeva 27, Beograd'),
(57, 'Makedonska 22, Beograd'),
(58, 'Čarlija Čaplina 2, Beograd'),
(59, 'Humska 1, Beograd'),
(61, 'Dr Dragoslava Popovića 24, Beograd'),
(62, 'Crnotravska 17, Niš'),
(63, 'Kneginje Ljubice 14, Kragujevac'),
(64, 'Stojana Novakovića 3, Novi Sad'),
(66, 'Železnička 17, Pančevo'),
(67, 'Dimitrija Tucovića 48, Leskovac'),
(69, 'Svetosavska 11, Valjevo'),
(71, 'Karađorđeva 65, Čačak'),
(72, 'Vuka Karadžića 8, Kruševac'),
(75, 'Trg oslobođenja 1, Zrenjanin'),
(76, 'Omladinska 4, Sombor'),
(78, 'Proleterska 23, Smederevo'),
(79, 'Dušanova 31, Šabac'),
(81, 'Miloša Obilića 42, Požarevac'),
(83, 'King Petra I Street 15, Užice'),
(84, 'Svetog Save 7, Jagodina'),
(86, 'Mihaila Pupina 12, Kikinda'),
(88, 'Zmaj Jovina 21, Sremska Mitrovica'),
(89, 'Jovana Šerbanovića 19, Vranje'),
(93, 'Njegoševa 44, Novi Pazar'),
(94, 'Stevana Mokranjca 9, Pirot'),
(97, 'Vojvođanska 33, Ruma');

-- ============================================
-- UCESNIK (100 redova)
-- ============================================
INSERT INTO ucesnik (sifra, pol, starost, obrazovanje, opis) VALUES
('UC001', 'M', 25, 'Srednja škola', 'Student psihologije, volonter u istraživanjima'),
('UC002', 'Ž', 32, 'Visoka - Bachelor', 'Zaposlena u IT sektoru, interesuje se za kognitivne nauke'),
('UC003', 'M', 28, 'Visoka - Master', 'Inženjer softver, hobista neuronauci'),
('UC004', 'Ž', 45, 'Visoka - PhD', 'Profesor univerziteta, kooperant u istraživanjima'),
('UC005', 'M', 19, 'Srednja škola', 'Student prve godine, prvi put u studiji'),
('UC006', 'Ž', 38, 'Visoka - Bachelor', 'Medicinska sestra, učesnik u health studijama'),
('UC007', 'M', 52, 'Visoka - Master', 'Menadžer u kompaniji, interesovanje za organizacionu psihologiju'),
('UC008', 'Ž', 27, 'Visoka - Bachelor', 'Dizajner, učestvuje u UX istraživanjima'),
('UC009', 'M', 34, 'Srednja škola', 'Sportski trener, deo sport psihologije studije'),
('UC010', 'Ž', 41, 'Visoka - Master', 'Psihoterapeut, kontinuirana edukacija'),
('UC011', 'M', 23, 'Visoka - Bachelor', 'Student poslednje godine ekonomije'),
('UC012', 'Ž', 29, 'Visoka - Master', 'HR menadžer, istraživanja motivacije'),
('UC013', 'M', 36, 'Visoka - Bachelor', 'Novinar, učestvuje u media studijama'),
('UC014', 'Ž', 50, 'Osnovna škola', 'Penzioner, volonter u aging studijama'),
('UC015', 'M', 22, 'Visoka - Bachelor', 'Student medicine, interes za neuropsihologiju'),
('UC016', 'Ž', 31, 'Visoka - PhD', 'Naučni saradnik, aktivna istraživačica'),
('UC017', 'M', 44, 'Srednja škola', 'Policajac, studija stresa na poslu'),
('UC018', 'Ž', 26, 'Visoka - Master', 'Psiholog u školi, profesionalni razvoj'),
('UC019', 'M', 39, 'Visoka - Bachelor', 'Farmaceut, health behavior research'),
('UC020', 'Ž', 33, 'Visoka - Master', 'Advokat, decision making studije'),
('UC021', 'M', 21, 'Srednja škola', 'Student filozofije, volonter'),
('UC022', 'Ž', 47, 'Visoka - Bachelor', 'Socijalni radnik, dugogodišnji učesnik'),
('UC023', 'M', 30, 'Visoka - Master', 'Arhitekta, environmental psychology'),
('UC024', 'Ž', 24, 'Visoka - Bachelor', 'Nutricionista, eating behavior studije'),
('UC025', 'M', 55, 'Srednja škola', 'Penzionisani nastavnik, kognitivne studije'),
('UC026', 'Ž', 28, 'Visoka - Master', 'Marketing stručnjak, consumer research'),
('UC027', 'M', 37, 'Visoka - PhD', 'Istraživač u biotehnologiji'),
('UC028', 'Ž', 42, 'Visoka - Bachelor', 'Fizioterapeut, rehabilitation psychology'),
('UC029', 'M', 20, 'Srednja škola', 'Student informatike, gaming studies'),
('UC030', 'Ž', 35, 'Visoka - Master', 'Ekonomista, organizational behavior'),
('UC031', 'M', 48, 'Visoka - Bachelor', 'Lekar opšte prakse, patient experience'),
('UC032', 'Ž', 25, 'Visoka - Bachelor', 'Grafički dizajner, creativity research'),
('UC033', 'M', 53, 'Srednja škola', 'Biznismen, leadership studije'),
('UC034', 'Ž', 30, 'Visoka - Master', 'Lingvista, bilingualism research'),
('UC035', 'M', 27, 'Visoka - Bachelor', 'Programer, HCI studije'),
('UC036', 'Ž', 40, 'Visoka - PhD', 'Profesor na fakultetu, mentorka'),
('UC037', 'M', 22, 'Visoka - Bachelor', 'Student biologije, interes za neuronauke'),
('UC038', 'Ž', 46, 'Srednja škola', 'Administrativni radnik, work stress study'),
('UC039', 'M', 32, 'Visoka - Master', 'Pisac, creativity and cognition'),
('UC040', 'Ž', 29, 'Visoka - Bachelor', 'Učiteljica, educational psychology'),
('UC041', 'M', 51, 'Visoka - Bachelor', 'Inženjer građevine, retired, hobista'),
('UC042', 'Ž', 24, 'Visoka - Bachelor', 'Student master studija psihologije'),
('UC043', 'M', 38, 'Visoka - Master', 'IT konsultant, technology adoption'),
('UC044', 'Ž', 43, 'Srednja škola', 'Radnica u fabrici, occupational health'),
('UC045', 'M', 26, 'Visoka - Bachelor', 'Muzičar, music and cognition'),
('UC046', 'Ž', 34, 'Visoka - Master', 'PR menadžer, persuasion research'),
('UC047', 'M', 49, 'Visoka - PhD', 'Naučnik, klimatolog, environmental attitudes'),
('UC048', 'Ž', 23, 'Visoka - Bachelor', 'Studentkinja master programa'),
('UC049', 'M', 31, 'Srednja škola', 'Vozač kamiona, sleep and fatigue'),
('UC050', 'Ž', 36, 'Visoka - Bachelor', 'Bibliotekarka, reading research'),
('UC051', 'M', 41, 'Visoka - Master', 'Psihijatar, clinical research'),
('UC052', 'Ž', 28, 'Visoka - Bachelor', 'Fitness instruktor, exercise psychology'),
('UC053', 'M', 54, 'Srednja škola', 'Penzioner, veteran, PTSD studies'),
('UC054', 'Ž', 25, 'Visoka - Master', 'Data scientist, AI and cognition'),
('UC055', 'M', 33, 'Visoka - Bachelor', 'Actor, emotion recognition'),
('UC056', 'Ž', 39, 'Visoka - PhD', 'Istraživačica u farmaciji'),
('UC057', 'M', 21, 'Visoka - Bachelor', 'Student politikologije'),
('UC058', 'Ž', 45, 'Srednja škola', 'Kuvarica, nutrition studies'),
('UC059', 'M', 29, 'Visoka - Master', 'UX researcher, profesionalno'),
('UC060', 'Ž', 37, 'Visoka - Bachelor', 'Event menadžer, stress management'),
('UC061', 'M', 52, 'Visoka - Bachelor', 'Poslovođa u trgovini, consumer behavior'),
('UC062', 'Ž', 26, 'Visoka - Bachelor', 'Studentkinja doktorskih studija'),
('UC063', 'M', 35, 'Visoka - Master', 'Biolog, genetics and behavior'),
('UC064', 'Ž', 42, 'Srednja škola', 'Čistačica, longitudinal health study'),
('UC065', 'M', 24, 'Visoka - Bachelor', 'Student prava, moral reasoning'),
('UC066', 'Ž', 48, 'Visoka - Master', 'Direktor škole, educational leadership'),
('UC067', 'M', 30, 'Visoka - Bachelor', 'Video game developer, gaming psychology'),
('UC068', 'Ž', 34, 'Visoka - PhD', 'Postdoc researcher, neuroscience'),
('UC069', 'M', 40, 'Srednja škola', 'Taksista, urban stress study'),
('UC070', 'Ž', 27, 'Visoka - Master', 'Social media manager, digital wellbeing'),
('UC071', 'M', 56, 'Visoka - Bachelor', 'Penzionisani oficir, aging research'),
('UC072', 'Ž', 23, 'Visoka - Bachelor', 'Studentkinja master, volonter'),
('UC073', 'M', 38, 'Visoka - Master', 'Financial analyst, risk perception'),
('UC074', 'Ž', 31, 'Visoka - Bachelor', 'Kozmetičarka, body image study'),
('UC075', 'M', 44, 'Srednja škola', 'Električar, occupational safety'),
('UC076', 'Ž', 29, 'Visoka - Master', 'Epidemiolog, public health'),
('UC077', 'M', 25, 'Visoka - Bachelor', 'Fotograf, visual perception'),
('UC078', 'Ž', 50, 'Visoka - PhD', 'Profesorka univerziteta, mentor'),
('UC079', 'M', 32, 'Visoka - Bachelor', 'Sales manager, persuasion tactics'),
('UC080', 'Ž', 39, 'Srednja škola', 'Frizerka, social interaction study'),
('UC081', 'M', 22, 'Visoka - Bachelor', 'Student teologije, religiosity'),
('UC082', 'Ž', 46, 'Visoka - Master', 'Psiholog u bolnici, patient care'),
('UC083', 'M', 34, 'Visoka - Bachelor', 'Dizajner enterijera, aesthetics'),
('UC084', 'Ž', 28, 'Visoka - Master', 'Specijalista ljudskih resursa'),
('UC085', 'M', 53, 'Srednja škola', 'Poljoprivrednik, rural psychology'),
('UC086', 'Ž', 26, 'Visoka - Bachelor', 'Farmaceutski tehničar'),
('UC087', 'M', 37, 'Visoka - PhD', 'Profesor matematike, math cognition'),
('UC088', 'Ž', 41, 'Visoka - Bachelor', 'Turistički vodič, cultural psychology'),
('UC089', 'M', 30, 'Visoka - Master', 'Brand manager, consumer research'),
('UC090', 'Ž', 35, 'Srednja škola', 'Konobarica, service quality study'),
('UC091', 'M', 47, 'Visoka - Bachelor', 'Pilot, attention and vigilance'),
('UC092', 'Ž', 24, 'Visoka - Bachelor', 'Studentkinja PhD programa'),
('UC093', 'M', 33, 'Visoka - Master', 'Cyber security analyst'),
('UC094', 'Ž', 49, 'Srednja škola', 'Radnica u call centru, burnout'),
('UC095', 'M', 27, 'Visoka - Bachelor', 'Sportski novinar, fandom psychology'),
('UC096', 'Ž', 36, 'Visoka - Master', 'Klinički psiholog, profesionalno'),
('UC097', 'M', 51, 'Visoka - PhD', 'Istraživač u neurologiji'),
('UC098', 'Ž', 25, 'Visoka - Bachelor', 'Apsolvent psihologije'),
('UC099', 'M', 42, 'Srednja škola', 'Majstor za grejanje, job satisfaction'),
('UC100', 'Ž', 31, 'Visoka - Master', 'Biostatističar, research methods');

-- ============================================
-- UCESCE (100+ redova)
-- ============================================
INSERT INTO ucesce (lab_id, ucesnik_id, status) VALUES
(1, 1, 'Aktivan'),
(1, 2, 'Aktivan'),
(1, 3, 'Završeno'),
(2, 4, 'Aktivan'),
(2, 5, 'Aktivan'),
(2, 6, 'Završeno'),
(3, 7, 'Aktivan'),
(3, 8, 'Aktivan'),
(4, 9, 'Završeno'),
(4, 10, 'Aktivan'),
(5, 11, 'Aktivan'),
(5, 12, 'Završeno'),
(6, 13, 'Aktivan'),
(6, 14, 'Aktivan'),
(7, 15, 'Završeno'),
(7, 16, 'Aktivan'),
(8, 17, 'Aktivan'),
(8, 18, 'Završeno'),
(9, 19, 'Aktivan'),
(9, 20, 'Aktivan'),
(10, 21, 'Završeno'),
(10, 22, 'Aktivan'),
(11, 23, 'Aktivan'),
(11, 24, 'Završeno'),
(12, 25, 'Aktivan'),
(12, 26, 'Aktivan'),
(13, 27, 'Završeno'),
(13, 28, 'Aktivan'),
(14, 29, 'Aktivan'),
(14, 30, 'Završeno'),
(15, 31, 'Aktivan'),
(15, 32, 'Aktivan'),
(16, 33, 'Završeno'),
(16, 34, 'Aktivan'),
(17, 35, 'Aktivan'),
(17, 36, 'Završeno'),
(18, 37, 'Aktivan'),
(18, 38, 'Aktivan'),
(19, 39, 'Završeno'),
(19, 40, 'Aktivan'),
(20, 41, 'Aktivan'),
(20, 42, 'Završeno'),
(21, 43, 'Aktivan'),
(21, 44, 'Aktivan'),
(22, 45, 'Završeno'),
(22, 46, 'Aktivan'),
(23, 47, 'Aktivan'),
(23, 48, 'Završeno'),
(24, 49, 'Aktivan'),
(24, 50, 'Aktivan'),
(25, 51, 'Završeno'),
(25, 52, 'Aktivan'),
(26, 53, 'Aktivan'),
(26, 54, 'Završeno'),
(27, 55, 'Aktivan'),
(27, 56, 'Aktivan'),
(28, 57, 'Završeno'),
(28, 58, 'Aktivan'),
(29, 59, 'Aktivan'),
(29, 60, 'Završeno'),
(30, 61, 'Aktivan'),
(30, 62, 'Aktivan'),
(31, 63, 'Završeno'),
(31, 64, 'Aktivan'),
(32, 65, 'Aktivan'),
(32, 66, 'Završeno'),
(33, 67, 'Aktivan'),
(33, 68, 'Aktivan'),
(34, 69, 'Završeno'),
(34, 70, 'Aktivan'),
(35, 71, 'Aktivan'),
(35, 72, 'Završeno'),
(36, 73, 'Aktivan'),
(36, 74, 'Aktivan'),
(37, 75, 'Završeno'),
(37, 76, 'Aktivan'),
(38, 77, 'Aktivan'),
(38, 78, 'Završeno'),
(39, 79, 'Aktivan'),
(39, 80, 'Aktivan'),
(40, 81, 'Završeno'),
(40, 82, 'Aktivan'),
(41, 83, 'Aktivan'),
(41, 84, 'Završeno'),
(42, 85, 'Aktivan'),
(42, 86, 'Aktivan'),
(43, 87, 'Završeno'),
(43, 88, 'Aktivan'),
(44, 89, 'Aktivan'),
(44, 90, 'Završeno'),
(45, 91, 'Aktivan'),
(45, 92, 'Aktivan'),
(46, 93, 'Završeno'),
(46, 94, 'Aktivan'),
(47, 95, 'Aktivan'),
(47, 96, 'Završeno'),
(48, 97, 'Aktivan'),
(48, 98, 'Aktivan'),
(49, 99, 'Završeno'),
(49, 100, 'Aktivan'),
(50, 1, 'Završeno'),
(50, 4, 'Aktivan'),
(1, 50, 'Aktivan'),
(2, 51, 'Završeno'),
(3, 52, 'Aktivan'),
(4, 53, 'Aktivan'),
(5, 54, 'Završeno'),
(6, 55, 'Aktivan'),
(7, 56, 'Aktivan'),
(8, 57, 'Završeno'),
(9, 58, 'Aktivan'),
(10, 59, 'Aktivan');

-- ============================================
-- TIP_ALATA (100 redova)
-- ============================================
INSERT INTO tip_alata (naziv, opis) VALUES
('EEG sistem', 'Elektroencefalografski uređaj za merenje moždane aktivnosti'),
('fMRI skener', 'Funkcionalna magnetna rezonanca za neuronsko oslikavanje'),
('Eye tracker', 'Uređaj za praćenje pokreta očiju'),
('TMS mašina', 'Transkranijalna magnetna stimulacija'),
('Biofeedback uređaj', 'Oprema za biološku povratnu spregu'),
('Neurofeedback sistem', 'Sistem za trening moždanih talasa'),
('GSR senzor', 'Galvanski odziv kože - stres merač'),
('Heart rate monitor', 'Monitor za otkucaje srca'),
('Respiratorni senzor', 'Merač disanja'),
('Termalni senzor', 'Merač telesne temperature'),
('EMG uređaj', 'Elektromiografija - merenje mišićne aktivnosti'),
('Poligraf', 'Detektor laži'),
('Audiometar', 'Uređaj za testiranje sluha'),
('Tachistoskop', 'Kratak vizuelni prikaz stimulusa'),
('Stereo audiofon', 'Visokokvalitetni audio sistem'),
('Reaction time device', 'Meri vreme reakcije'),
('Stroop test aparat', 'Meri kognitivnu interferenciju'),
('Memory drum', 'Rotacioni cilindar za testiranje memorije'),
('Perimetarski uređaj', 'Test vidnog polja'),
('Kolorimetar', 'Precizno merenje boja'),
('Lux metar', 'Merač osvetljenosti'),
('Sound level meter', 'Merač nivoa buke'),
('Vibration analyzer', 'Analizator vibracija'),
('Ergonomska stolica', 'Nameštaj za psihološke testove'),
('Ergonomski sto', 'Radni sto sa podešavanjima'),
('Senzorska izolaciona kabina', 'Kabina bez spoljnih draži'),
('VR headset', 'Naočare za virtuelnu realnost'),
('AR naočare', 'Proširena realnost sistem'),
('3D projektor', 'Stereo projekcija'),
('Haptički joystick', 'Kontroler sa taktilnim feedbackom'),
('Motion capture sistem', 'Praćenje pokreta tela'),
('Force platform', 'Platforma za merenje sile'),
('Gait analysis sistem', 'Analiza hoda'),
('Balance board', 'Tabla za ravnotežu sa senzorima'),
('Treadmill sa senzorima', 'Traka za trčanje sa merenjem'),
('Ergometar za bicikl', 'Sobni bicikl sa merenjem'),
('Grip strength dinamometar', 'Merač snage stiska'),
('Pinch gauge', 'Merač prstohvata'),
('Spirometar', 'Test kapaciteta pluća'),
('Puls oksimetar', 'Merač kiseonika u krvi'),
('Krvno-pritisak aparat', 'Digitalni tenziometar'),
('Glukometar', 'Merač šećera u krvi'),
('Body composition analyzer', 'Analiza telesnog sastava'),
('Kaliper za kožu', 'Merač potkožnog masnog tkiva'),
('Antropometrijski set', 'Set za merenje tela'),
('Stadiometar', 'Merač visine'),
('Medicinska vaga', 'Precizna vaga'),
('Infant scale', 'Vaga za bebe'),
('Infracrvena kamera', 'Termalna kamera'),
('Noćno-viđenje kamera', 'Kamera za snimanje u mraku'),
('High-speed kamera', 'Usporena snimka'),
('Mikrofon za kvalitativne intervjue', 'Studijski mikrofon'),
('Audio rekorder', 'Digitalni audio snimač'),
('Transkripcioni software licenca', 'Softver za transkripte'),
('Video kamera HD', 'Visoka rezolucija kamera'),
('PTZ kamera', 'Pan-tilt-zoom kamera'),
('Dvoručni ogledalo', 'Psihološki alat'),
('Inkblot kartice', 'Rorschach test'),
('TAT kartice', 'Tematska apercepcijska test'),
('IQ test materijali', 'Standardizovani testovi inteligencije'),
('Aptitude test baterija', 'Testovi sposobnosti'),
('Personality inventories', 'Upitnici ličnosti'),
('Projektivni crteži', 'Materijali za crtanje'),
('Play therapy set', 'Set za igroterapiju'),
('Sand tray therapy', 'Pesak terapija set'),
('Art therapy materijali', 'Boje, četke, papir'),
('Music therapy instrumenti', 'Mali instrumenti za terapiju'),
('Relaxation chair', 'Fotelja za relaksaciju'),
('Aromatherapy diffuser', 'Difuzor etarskih ulja'),
('White noise machine', 'Generator belog šuma'),
('Meditation timer', 'Tajmer za meditaciju'),
('Yoga mat', 'Prostirka za jogu'),
('Stress ball set', 'Lopte protiv stresa'),
('Fidget tools', 'Alati za smirenje'),
('Weighted blanket', 'Terapeutski ćebe'),
('Sensory brush', 'Senzorna četkica'),
('Textured balls', 'Lopte različitih tekstura'),
('Bubble tube', 'Svetleća vodena cev'),
('Fiber optic lights', 'Optička svetla'),
('Mirror ball', 'Disco kugla za senzornu terapiju'),
('UV blacklight', 'Ultrajubičasto svetlo'),
('Laser pointer set', 'Set laser pokazivača'),
('Prism glasses', 'Prizmatičke naočare'),
('Occluder set', 'Set za testiranje vida'),
('Olfactory test kit', 'Test mirisa'),
('Taste test kit', 'Test ukusa'),
('Texture discrimination set', 'Set za teksturnu diskriminaciju'),
('Stereognosis kit', 'Test prepoznavanja oblika'),
('Two-point discriminator', 'Merač taktilne osetljivosti'),
('Thermal grill illusion device', 'Uređaj za termalne iluzije'),
('Pain threshold algometer', 'Merač praga bola'),
('Pressure algometer', 'Merač praga pritiska'),
('Cold pressor test', 'Aparat za test hladne vode'),
('Heat pain device', 'Kontrolisana toplotna stimulacija'),
('Electrical stimulator', 'Električna stimulacija'),
('TENS jedinica', 'Transkutana električna stimulacija'),
('Vibrotactile stimulator', 'Vibracija stimulacija'),
('Acoustic startle system', 'Sistem za akustično trznuće'),
('Prepulse inhibition test', 'PPI test oprema'),
('Conditioned fear apparatus', 'Aparat za uslovni strah'),
('Operant conditioning chamber', 'Skinner box');

-- ============================================
-- ALAT (150 redova - više od 100)
-- ============================================
INSERT INTO alat (datum_nabavke, datum_proizvodnje, lab_id, tip_alata_id) VALUES
('2020-01-15', '2019-11-10', 1, 1),
('2020-02-20', '2019-12-05', 2, 1),
('2021-03-10', '2021-01-15', 3, 3),
('2019-05-12', '2019-03-20', 4, 4),
('2022-06-18', '2022-04-22', 5, 5),
('2020-07-25', '2020-05-30', 6, 6),
('2021-08-14', '2021-06-12', 7, 7),
('2019-09-21', '2019-07-15', 8, 8),
('2023-10-05', '2023-08-10', 9, 9),
('2020-11-30', '2020-09-25', 10, 10),
('2021-01-12', '2020-11-18', 11, 11),
('2022-02-28', '2021-12-20', 12, 12),
('2020-03-17', '2020-01-22', 13, 13),
('2021-04-09', '2021-02-14', 14, 14),
('2019-05-23', '2019-03-28', 15, 15),
('2022-06-11', '2022-04-16', 16, 16),
('2020-07-19', '2020-05-24', 17, 17),
('2021-08-27', '2021-06-30', 18, 18),
('2023-09-13', '2023-07-18', 19, 19),
('2020-10-22', '2020-08-27', 20, 20),
('2021-11-08', '2021-09-13', 21, 21),
('2022-12-15', '2022-10-20', 22, 22),
('2020-01-29', '2019-11-30', 23, 23),
('2021-02-14', '2020-12-19', 24, 24),
('2019-03-25', '2019-01-28', 25, 25),
('2022-04-07', '2022-02-10', 26, 26),
('2020-05-18', '2020-03-23', 27, 27),
('2021-06-30', '2021-04-30', 28, 28),
('2023-07-12', '2023-05-15', 29, 29),
('2020-08-24', '2020-06-28', 30, 30),
('2021-09-16', '2021-07-20', 31, 31),
('2022-10-28', '2022-08-31', 32, 32),
('2020-11-19', '2020-09-22', 33, 33),
('2021-12-05', '2021-10-08', 34, 34),
('2019-01-17', '2018-11-20', 35, 35),
('2022-02-21', '2021-12-24', 36, 36),
('2020-03-14', '2020-01-17', 37, 37),
('2021-04-26', '2021-02-27', 38, 38),
('2023-05-08', '2023-03-11', 39, 39),
('2020-06-20', '2020-04-23', 40, 40),
('2021-07-02', '2021-05-05', 41, 41),
('2022-08-14', '2022-06-17', 42, 42),
('2020-09-26', '2020-07-29', 43, 43),
('2021-10-08', '2021-08-11', 44, 44),
('2019-11-20', '2019-09-23', 45, 45),
('2022-12-02', '2022-10-05', 46, 46),
('2020-01-14', '2019-11-17', 47, 47),
('2021-02-26', '2020-12-29', 48, 48),
('2023-03-10', '2023-01-13', 49, 49),
('2020-04-22', '2020-02-25', 50, 50),
('2021-05-04', '2021-03-07', 1, 51),
('2022-06-16', '2022-04-19', 2, 52),
('2020-07-28', '2020-05-31', 3, 53),
('2021-08-09', '2021-06-12', 4, 54),
('2019-09-21', '2019-07-24', 5, 55),
('2022-10-03', '2022-08-06', 6, 56),
('2020-11-15', '2020-09-18', 7, 57),
('2021-12-27', '2021-10-30', 8, 58),
('2023-01-08', '2022-11-11', 9, 59),
('2020-02-20', '2019-12-23', 10, 60),
('2021-03-04', '2021-01-05', 11, 61),
('2022-04-16', '2022-02-17', 12, 62),
('2020-05-28', '2020-03-31', 13, 63),
('2021-06-09', '2021-04-12', 14, 64),
('2019-07-21', '2019-05-24', 15, 65),
('2022-08-02', '2022-06-05', 16, 66),
('2020-09-14', '2020-07-17', 17, 67),
('2021-10-26', '2021-08-29', 18, 68),
('2023-11-07', '2023-09-10', 19, 69),
('2020-12-19', '2020-10-22', 20, 70),
('2021-01-31', '2020-12-04', 21, 71),
('2022-03-14', '2022-01-15', 22, 72),
('2020-04-26', '2020-02-27', 23, 73),
('2021-05-08', '2021-03-11', 24, 74),
('2019-06-20', '2019-04-23', 25, 75),
('2022-07-02', '2022-05-05', 26, 76),
('2020-08-14', '2020-06-17', 27, 77),
('2021-09-26', '2021-07-29', 28, 78),
('2023-10-08', '2023-08-11', 29, 79),
('2020-11-20', '2020-09-23', 30, 80),
('2021-12-02', '2021-10-05', 31, 81),
('2022-01-14', '2021-11-17', 32, 82),
('2020-02-26', '2019-12-29', 33, 83),
('2021-03-10', '2021-01-13', 34, 84),
('2019-04-22', '2019-02-25', 35, 85),
('2022-05-04', '2022-03-07', 36, 86),
('2020-06-16', '2020-04-19', 37, 87),
('2021-07-28', '2021-05-31', 38, 88),
('2023-08-09', '2023-06-12', 39, 89),
('2020-09-21', '2020-07-24', 40, 90),
('2021-10-03', '2021-08-06', 41, 91),
('2022-11-15', '2022-09-18', 42, 92),
('2020-12-27', '2020-10-30', 43, 93),
('2021-01-08', '2020-11-11', 44, 94),
('2019-02-20', '2018-12-23', 45, 95),
('2022-03-04', '2022-01-05', 46, 96),
('2020-04-16', '2020-02-17', 47, 97),
('2021-05-28', '2021-03-31', 48, 98),
('2023-06-09', '2023-04-12', 49, 99),
('2020-07-21', '2020-05-24', 50, 100),
('2021-08-02', '2021-06-05', 1, 1),
('2022-09-14', '2022-07-17', 2, 2),
('2020-10-26', '2020-08-29', 3, 3),
('2021-11-07', '2021-09-10', 4, 4),
('2019-12-19', '2019-10-22', 5, 5),
('2022-01-31', '2021-12-04', 6, 6),
('2020-03-14', '2020-01-15', 7, 7),
('2021-04-26', '2021-02-27', 8, 8),
('2023-05-08', '2023-03-11', 9, 9),
('2020-06-20', '2020-04-23', 10, 10),
('2021-07-02', '2021-05-05', 11, 11),
('2022-08-14', '2022-06-17', 12, 12),
('2020-09-26', '2020-07-29', 13, 13),
('2021-10-08', '2021-08-11', 14, 14),
('2019-11-20', '2019-09-23', 15, 15),
('2022-12-02', '2022-10-05', 16, 16),
('2020-01-14', '2019-11-17', 17, 17),
('2021-02-26', '2020-12-29', 18, 18),
('2023-03-10', '2023-01-13', 19, 19),
('2020-04-22', '2020-02-25', 20, 20),
('2021-05-04', '2021-03-07', 21, 21),
('2022-06-16', '2022-04-19', 22, 22),
('2020-07-28', '2020-05-31', 23, 23),
('2021-08-09', '2021-06-12', 24, 24),
('2019-09-21', '2019-07-24', 25, 25),
('2022-10-03', '2022-08-06', 26, 26),
('2020-11-15', '2020-09-18', 27, 27),
('2021-12-27', '2021-10-30', 28, 28),
('2023-01-08', '2022-11-11', 29, 29),
('2020-02-20', '2019-12-23', 30, 30),
('2021-03-04', '2021-01-05', 31, 31),
('2022-04-16', '2022-02-17', 32, 32),
('2020-05-28', '2020-03-31', 33, 33),
('2021-06-09', '2021-04-12', 34, 34),
('2019-07-21', '2019-05-24', 35, 35),
('2022-08-02', '2022-06-05', 36, 36),
('2020-09-14', '2020-07-17', 37, 37),
('2021-10-26', '2021-08-29', 38, 38),
('2023-11-07', '2023-09-10', 39, 39),
('2020-12-19', '2020-10-22', 40, 40),
('2021-01-31', '2020-12-04', 41, 41),
('2022-03-14', '2022-01-15', 42, 42),
('2020-04-26', '2020-02-27', 43, 43),
('2021-05-08', '2021-03-11', 44, 44),
('2019-06-20', '2019-04-23', 45, 45),
('2022-07-02', '2022-05-05', 46, 46),
('2020-08-14', '2020-06-17', 47, 47),
('2021-09-26', '2021-07-29', 48, 48),
('2023-10-08', '2023-08-11', 49, 49),
('2020-11-20', '2020-09-23', 50, 50);

-- ============================================
-- TIP_TEORIJE (100 redova)
-- ============================================
INSERT INTO tip_teorije (naziv) VALUES
('Kognitivna teorija'),
('Bihevioralna teorija'),
('Psihoanalitička teorija'),
('Humanistička teorija'),
('Socijalna teorija'),
('Razvojna teorija'),
('Evolutivna teorija'),
('Biološka teorija'),
('Neuropsihološka teorija'),
('Gestalt teorija'),
('Konstruktivistička teorija'),
('Sistemska teorija'),
('Teorija učenja'),
('Motivaciona teorija'),
('Emocionalna teorija'),
('Teorija ličnosti'),
('Socio-kognitivna teorija'),
('Teorija atribucije'),
('Teorija samo-determinacije'),
('Teorija socijalnog poređenja'),
('Teorija kognitivne disonance'),
('Teorija planiranog ponašanja'),
('Teorija razmene'),
('Equity teorija'),
('Teorija simboličkog interakcionizma'),
('Teorija obeležavanja'),
('Teorija lomljenog prozora'),
('Teorija kontrole'),
('Teorija napetosti'),
('Teorija socijalnog učenja'),
('Teorija opservacionog učenja'),
('Klasično uslovljavanje'),
('Operantno uslovljavanje'),
('Kognitivno-bihevioralna teorija'),
('Teorija vezanosti'),
('Teorija odvojnosti'),
('Teorija objektnih relacija'),
('Ego psihologija'),
('Self psihologija'),
('Interpersonalna teorija'),
('Egzistencijalna teorija'),
('Logoterapija'),
('Teorija smisla'),
('Pozitivna psihologija teorija'),
('Flow teorija'),
('Teorija samoaktualizacije'),
('Teorija hijerarhije potreba'),
('Teorija fundamentalne atribucijske greške'),
('Teorija konformizma'),
('Teorija poslušnosti'),
('Teorija grupnog mišljenja'),
('Teorija polarizacije'),
('Difuzija odgovornosti teorija'),
('Teorija usamljenog posmatrača'),
('Teorija frustracije-agresije'),
('Teorija relativne deprivacije'),
('Teorija socijalnog identiteta'),
('Teorija samo-kategorizacije'),
('Teorija minimalnih grupa'),
('Kontakt teorija'),
('Teorija pretnji'),
('Teorija integrativne složenosti'),
('Teorija kognitivne elaboracije'),
('Dual process teorija'),
('Teorija heuristika'),
('Prospect teorija'),
('Teorija očekivane vrednosti'),
('Teorija igara'),
('Teorija racionalnog izbora'),
('Bounded rationality teorija'),
('Satisficing teorija'),
('Nudge teorija'),
('Priming teorija'),
('Spreading activation teorija'),
('Teorija radne memorije'),
('Teorija epizodičke memorije'),
('Teorija semantičke memorije'),
('Teorija proceduralnog znanja'),
('Encoding specificity teorija'),
('Teorija nivoa obrade'),
('Teorija transfera'),
('Interference teorija'),
('Decay teorija'),
('Consolidation teorija'),
('Reconsolidation teorija'),
('Schema teorija'),
('Script teorija'),
('Mental models teorija'),
('Teorija uma'),
('Teorija simulacije'),
('Teorija perspektive'),
('Embodied cognition teorija'),
('Distributed cognition teorija'),
('Situated cognition teorija'),
('Extended mind teorija'),
('Predictive processing teorija'),
('Bayesian brain teorija'),
('Free energy principle'),
('Global workspace teorija'),
('Integrated information teorija'),
('Higher order thought teorija');

-- ============================================
-- TEORIJA (100 redova)
-- ============================================
INSERT INTO teorija (naziv, opis, tip_teorije_id) VALUES
('Piaget razvojna teorija', 'Teorija kognitivnog razvoja kroz stadijume', 6),
('Erikson psihosocijalna teorija', 'Osam stadijuma psihosocijalnog razvoja', 3),
('Freud psihoanaliza', 'Klasična psihoanalitička teorija', 3),
('Skinner operantni', 'Operantno uslovljavanje', 2),
('Bandura socijalno učenje', 'Učenje kroz posmatranje', 5),
('Maslow hijerarhija', 'Hijerarhija ljudskih potreba', 4),
('Rogers klijent-centrisana', 'Humanistički pristup terapiji', 4),
('Beck kognitivna terapija', 'Kognitivni model depresije', 1),
('Ellis REBT', 'Racionalno-emotivna bihevioralna terapija', 1),
('Vygotsky sociokult. teorija', 'Zona proksimalnog razvoja', 6),
('Bowlby teorija vezanosti', 'Rana emocionalna vezanost', 35),
('Ainsworth stil vezanosti', 'Sigurna, anksiozna, izbegavajuća vezanost', 35),
('Festinger kognitivna disonanca', 'Neugodnost nekonzistentnih kognicija', 21),
('Heider atribuciona teorija', 'Uzročna atribucija ponašanja', 18),
('Weiner atribucije postignuća', 'Uspeh i neuspeh atribucije', 18),
('Ajzen planirana ponašanja', 'Namera, stav, norma, kontrola', 22),
('Fishbein razumna akcija', 'Prethodnica teorije planiranog ponašanja', 22),
('Deci i Ryan SDT', 'Teorija samo-determinacije', 19),
('Seligman naučena bespomoćnost', 'Model depresije i kontrole', 14),
('Dweck mindset teorija', 'Growth vs fixed mindset', 14),
('Kahneman i Tversky prospect', 'Donošenje odluka pod rizikom', 67),
('Simon bounded rationality', 'Ograničena racionalnost', 71),
('Thaler nudge teorija', 'Arhitektura izbora', 73),
('Asch konformizam', 'Grupni pritisak i konformizam', 49),
('Milgram poslušnost', 'Poslušnost autoritetu', 50),
('Zimbardo zatvorski eksperiment', 'Uloge i moć situacije', 5),
('Tajfel socijalni identitet', 'Grupni identitet i diskriminacija', 57),
('Turner samo-kategorizacija', 'Proces kategorizacije sebe u grupe', 58),
('Latané i Darley bystander', 'Difuzija odgovornosti', 53),
('Zajonc socijalna facilitacija', 'Prisustvo drugih na performans', 5),
('Sherif Robbers Cave', 'Intergroup konflikt i kooperacija', 5),
('Allport kontakt hipoteza', 'Redukcija predrasuda kroz kontakt', 61),
('Pettigrew kontakt teorija', 'Uslovi za efektivni kontakt', 61),
('Bem self-perception teorija', 'Zaključivanje stavova iz ponašanja', 17),
('Schachter-Singer emocionalna', 'Dvo-faktorska teorija emocija', 15),
('James-Lange emocionalna', 'Fiziološki odgovor = emocija', 15),
('Cannon-Bard emocionalna', 'Simultani odgovor mozga i tela', 15),
('Lazarus appraisal teorija', 'Kognitivna procena emocija', 15),
('LeDoux amigdala i strah', 'Neuronska osnova straha', 9),
('Damasio somatski marker', 'Emocije u donošenju odluka', 9),
('Ekman bazične emocije', 'Univerzalne facijalne ekspresije', 15),
('Plutchik točak emocija', 'Model emocionalnih kombinacija', 15),
('Barrett konstruktivne emocije', 'Emocije kao konstrukcije', 15),
('Csikszentmihalyi flow', 'Optimalno iskustvo', 45),
('Fredrickson broaden-and-build', 'Pozitivne emocije i resursi', 44),
('Diener subjektivna dobrobit', 'Sreća i satisfakcija životom', 44),
('Ryff psihološka dobrobit', 'Eudaimonska dobrobit', 44),
('Keyes mentalno cvjetanje', 'Flourishing model', 44),
('Peterson i Seligman karakter snage', 'VIA klasifikacija vrlina', 44),
('Frankl logoterapija', 'Potraga za smislom', 42),
('Yalom egzistencijalna', 'Smrt, sloboda, izolacija, besmisao', 41),
('May egzistencijalni pristup', 'Autentičnost i izbor', 41),
('Berne transakciona analiza', 'Ego stanja i transakcije', 40),
('Perls Gestalt terapija', 'Sadašnji trenutak i svesnost', 10),
('Kelly konstrukt teorija', 'Lični konstrukti', 11),
('Rotter lokus kontrole', 'Internalni vs externalni lokus', 17),
('Atkinson postignuće motiv', 'Nada za uspeh vs strah od neuspeha', 14),
('McClelland potreba za postignućem', 'nAch, nPow, nAff', 14),
('Herzberg dvo-faktorska', 'Motivatori vs higijenski faktori', 14),
('Vroom očekivanje', 'Očekivanje x instrumentalnost x valencija', 68),
('Locke goal-setting teorija', 'Specifični i izazovni ciljevi', 14),
('Hackman i Oldham JCM', 'Model karakteristika posla', 14),
('Adams equity teorija', 'Pravičnost razmene', 24),
('Walster equity teorija', 'Pravednost u relacijama', 24),
('Thibaut i Kelley interdependence', 'Međuzavisnost u relacijama', 23),
('Rusbult investment model', 'Commitment u vezama', 23),
('Sternberg trougao ljubavi', 'Intimnost, strast, odluka', 15),
('Hatfield passionate vs companionate', 'Strastvena i prijateljska ljubav', 15),
('Bartholomew attachment styles', 'Četiri stila vezanosti kod odraslih', 35),
('Hazan i Shaver romantic attachment', 'Vezanost u romantičnim vezama', 35),
('Kohlberg moralni razvoj', 'Stadijumi moralnog rezonovanja', 6),
('Gilligan etika brige', 'Feministička perspektiva moralnosti', 6),
('Haidt moralni intuicionizam', 'Pet moralnih osnova', 15),
('Turiel socijalna domena teorija', 'Moralno, socijalno, lično', 5),
('Bronfenbrenner ekološka teorija', 'Mikro, mezo, ekso, makro sistemi', 12),
('Lerner relational developmental', 'Razvojni kontekstualizam', 12),
('Elder life course teorija', 'Trajektorije životnog puta', 6),
('Baltes lifespan razvoj', 'SOC model - selekcija, optimizacija, kompenzacija', 6),
('Schaie kognitivni razvoj odraslih', 'Stadijumi odraslog mišljenja', 6),
('Horn i Cattell fluid-crystallized', 'Fluidna i kristalizovana inteligencija', 1),
('Spearman g factor', 'Generalna inteligencija', 16),
('Thurstone primarni mentalni', 'Sedam primarnih sposobnosti', 16),
('Gardner multiple intelligences', 'Osam tipova inteligencije', 16),
('Sternberg triarhijska inteligencija', 'Analitička, kreativna, praktična', 16),
('Goleman emocionalna inteligencija', 'Samosvest, regulacija, motivacija, empatija', 15),
('Mayer i Salovey EI model', 'Model sposobnosti EI', 15),
('Baddeley radna memorija', 'Fonološka petlja, vizuospacijalni notes, centralni izvršilac', 76),
('Atkinson i Shiffrin multistore', 'Senzorna, kratkoročna, dugoročna memorija', 1),
('Craik i Lockhart nivoi obrade', 'Dubina obrade utiče na memoriju', 80),
('Tulving episodička vs semantička', 'Tipovi deklarativne memorije', 77),
('Squire deklarativna vs proceduralna', 'Sistemi memorije', 78),
('Ebbinghaus kriva zaboravljanja', 'Eksponencijalni pad memorije', 13),
('Bartlett schema teorija', 'Rekonstruktivna priroda memorije', 87),
('Loftus eyewitness memory', 'Pogrešna sećanja očevidaca', 1),
('Roediger i McDermott false memory', 'DRM paradigma', 1),
('Schacter sedam grehova memorije', 'Tržnost, ometajnost, blokiranj...', 1),
('Broadbent filter teorija', 'Rana selekcija pažnje', 1),
('Treisman attenuation teorija', 'Oslabljivanje nepaženog', 1),
('Deutsch i Deutsch late selection', 'Kasna selekcija', 1),
('Broadbent filter teorija', 'Rana selekcija pažnje', 1);

-- ============================================
-- IZVODJENJE
-- ============================================
INSERT INTO izvodjenje (lab_id, datum, status, anketa_id)
VALUES
(1,  '2026-05-22', 'planirano', 1),
(2,  '2026-05-22', 'zavrseno', 2),
(3,  '2026-05-22', 'otkazano', 3),
(4,  '2026-05-23', 'planirano', 4),
(5,  '2026-05-23', 'zavrseno', 5),
(6,  '2026-05-23', 'planirano', 6),
(7,  '2026-05-24', 'zavrseno', 7),
(8,  '2026-05-24', 'otkazano', 8),
(9,  '2026-05-24', 'planirano', 9),
(10, '2026-05-25', 'zavrseno', 10),

(11, '2026-05-25', 'planirano', 11),
(12, '2026-05-25', 'zavrseno', 12),
(13, '2026-05-26', 'otkazano', 13),
(14, '2026-05-26', 'planirano', 14),
(15, '2026-05-26', 'zavrseno', 15),
(16, '2026-05-27', 'planirano', 16),
(17, '2026-05-27', 'zavrseno', 17),
(18, '2026-05-27', 'otkazano', 18),
(19, '2026-05-28', 'planirano', 19),
(20, '2026-05-28', 'zavrseno', 20),

(21, '2026-05-28', 'planirano', 21),
(22, '2026-05-29', 'zavrseno', 22),
(23, '2026-05-29', 'otkazano', 23),
(24, '2026-05-29', 'planirano', 24),
(25, '2026-05-30', 'zavrseno', 25),
(26, '2026-05-30', 'planirano', 26),
(27, '2026-05-30', 'zavrseno', 27),
(28, '2026-05-31', 'otkazano', 28),
(29, '2026-05-31', 'planirano', 29),
(30, '2026-05-31', 'zavrseno', 30),

(31, '2026-06-01', 'planirano', 31),
(32, '2026-06-01', 'zavrseno', 32),
(33, '2026-06-01', 'otkazano', 33),
(34, '2026-06-02', 'planirano', 34),
(35, '2026-06-02', 'zavrseno', 35),
(36, '2026-06-02', 'planirano', 36),
(37, '2026-06-03', 'zavrseno', 37),
(38, '2026-06-03', 'otkazano', 38),
(39, '2026-06-03', 'planirano', 39),
(40, '2026-06-04', 'zavrseno', 40),

(41, '2026-06-04', 'planirano', 41),
(42, '2026-06-04', 'zavrseno', 42),
(43, '2026-06-05', 'otkazano', 43),
(44, '2026-06-05', 'planirano', 44),
(45, '2026-06-05', 'zavrseno', 45),
(46, '2026-06-06', 'planirano', 46),
(47, '2026-06-06', 'zavrseno', 47),
(48, '2026-06-06', 'otkazano', 48),
(49, '2026-06-07', 'planirano', 49),
(50, '2026-06-07', 'zavrseno', 50),

(51, '2026-06-07', 'planirano', 51),
(52, '2026-06-08', 'zavrseno', 52),
(53, '2026-06-08', 'otkazano', 53),
(54, '2026-06-08', 'planirano', 54),
(55, '2026-06-09', 'zavrseno', 55),
(56, '2026-06-09', 'planirano', 56),
(57, '2026-06-09', 'zavrseno', 57),
(58, '2026-06-10', 'otkazano', 58),
(59, '2026-06-10', 'planirano', 59),
(60, '2026-06-10', 'zavrseno', 60),

(61, '2026-06-11', 'planirano', 61),
(62, '2026-06-11', 'zavrseno', 62),
(63, '2026-06-11', 'otkazano', 63),
(64, '2026-06-12', 'planirano', 64),
(65, '2026-06-12', 'zavrseno', 65),
(66, '2026-06-12', 'planirano', 66),
(67, '2026-06-13', 'zavrseno', 67),
(68, '2026-06-13', 'otkazano', 68),
(69, '2026-06-13', 'planirano', 69),
(70, '2026-06-14', 'zavrseno', 70),

(71, '2026-06-14', 'planirano', 71),
(72, '2026-06-14', 'zavrseno', 72),
(73, '2026-06-15', 'otkazano', 73),
(74, '2026-06-15', 'planirano', 74),
(75, '2026-06-15', 'zavrseno', 75),
(76, '2026-06-16', 'planirano', 76),
(77, '2026-06-16', 'zavrseno', 77),
(78, '2026-06-16', 'otkazano', 78),
(79, '2026-06-17', 'planirano', 79),
(80, '2026-06-17', 'zavrseno', 80),

(81, '2026-06-17', 'planirano', 81),
(82, '2026-06-18', 'zavrseno', 82),
(83, '2026-06-18', 'otkazano', 83),
(84, '2026-06-18', 'planirano', 84),
(85, '2026-06-19', 'zavrseno', 85),
(86, '2026-06-19', 'planirano', 86),
(87, '2026-06-19', 'zavrseno', 87),
(88, '2026-06-20', 'otkazano', 88),
(89, '2026-06-20', 'planirano', 89),
(90, '2026-06-20', 'zavrseno', 90),

(91, '2026-06-21', 'planirano', 91),
(92, '2026-06-21', 'zavrseno', 92),
(93, '2026-06-21', 'otkazano', 93),
(94, '2026-06-22', 'planirano', 94),
(95, '2026-06-22', 'zavrseno', 95),
(96, '2026-06-22', 'planirano', 96),
(97, '2026-06-23', 'zavrseno', 97),
(98, '2026-06-23', 'otkazano', 98),
(99, '2026-06-23', 'planirano', 99),
(100,'2026-06-24', 'zavrseno', 100),

(101,'2026-06-24', 'planirano', 101),
(102,'2026-06-24', 'zavrseno', 1),
(103,'2026-06-25', 'otkazano', 2),
(104,'2026-06-25', 'planirano', 3),

-- dodatnih ~46 redova da dođemo do 150
(1, '2026-05-27', 'zavrseno', 4),
(2, '2026-05-28', 'planirano', 5),
(3, '2026-05-29', 'zavrseno', 6),
(4, '2026-05-30', 'otkazano', 7),
(5, '2026-05-31', 'planirano', 8),
(6, '2026-06-01', 'zavrseno', 9),
(7, '2026-06-02', 'planirano', 10),
(8, '2026-06-03', 'otkazano', 11),
(9, '2026-06-04', 'zavrseno', 12),
(10,'2026-06-05', 'planirano', 13),

(11,'2026-06-06', 'zavrseno', 14),
(12,'2026-06-07', 'otkazano', 15),
(13,'2026-06-08', 'planirano', 16),
(14,'2026-06-09', 'zavrseno', 17),
(15,'2026-06-10', 'planirano', 18),
(16,'2026-06-11', 'otkazano', 19),
(17,'2026-06-12', 'zavrseno', 20),
(18,'2026-06-13', 'planirano', 21),
(19,'2026-06-14', 'zavrseno', 22),
(20,'2026-06-15', 'otkazano', 23),

(21,'2026-06-16', 'planirano', 24),
(22,'2026-06-17', 'zavrseno', 25),
(23,'2026-06-18', 'otkazano', 26),
(24,'2026-06-19', 'planirano', 27),
(25,'2026-06-20', 'zavrseno', 28),
(26,'2026-06-21', 'planirano', 29),
(27,'2026-06-22', 'zavrseno', 30),
(28,'2026-06-23', 'otkazano', 31),
(29,'2026-06-24', 'planirano', 32),
(30,'2026-06-25', 'zavrseno', 33);
-- ============================================
-- SESIJA
-- ============================================
INSERT INTO sesija (izvodjenje_id, vreme_pocetka, vreme_zavrsetka)
VALUES
(1, '09:00:00', '10:30:00'),
(2, '10:00:00', '11:15:00'),
(3, '09:30:00', '10:45:00'),
(4, '08:45:00', '10:00:00'),
(5, '09:15:00', '10:40:00'),

(6, '10:00:00', '11:30:00'),
(7, '09:00:00', '10:20:00'),
(8, '11:00:00', '12:15:00'),
(9, '08:30:00', '09:50:00'),
(10,'09:10:00', '10:35:00'),

(11,'10:00:00', '11:20:00'),
(12,'09:00:00', '10:30:00'),
(13,'08:45:00', '10:10:00'),
(14,'09:30:00', '11:00:00'),
(15,'10:15:00', '11:45:00'),

(16,'09:00:00', '10:25:00'),
(17,'08:40:00', '10:05:00'),
(18,'10:30:00', '12:00:00'),
(19,'09:10:00', '10:30:00'),
(20,'11:00:00', '12:20:00'),

(21,'09:00:00', '10:15:00'),
(22,'10:00:00', '11:30:00'),
(23,'08:50:00', '10:10:00'),
(24,'09:20:00', '10:50:00'),
(25,'11:10:00', '12:40:00'),

(26,'09:00:00', '10:30:00'),
(27,'10:00:00', '11:25:00'),
(28,'08:45:00', '10:00:00'),
(29,'09:30:00', '11:00:00'),
(30,'10:15:00', '11:40:00'),

(31,'09:00:00', '10:20:00'),
(32,'08:30:00', '09:50:00'),
(33,'10:00:00', '11:30:00'),
(34,'09:15:00', '10:45:00'),
(35,'11:00:00', '12:30:00'),

(36,'09:00:00', '10:30:00'),
(37,'10:10:00', '11:35:00'),
(38,'08:50:00', '10:10:00'),
(39,'09:25:00', '10:55:00'),
(40,'11:15:00', '12:45:00'),

(41,'09:00:00', '10:30:00'),
(42,'10:00:00', '11:20:00'),
(43,'08:45:00', '10:05:00'),
(44,'09:30:00', '11:00:00'),
(45,'10:15:00', '11:45:00'),
(46, '09:00:00', '10:30:00'),
(47, '10:00:00', '11:20:00'),
(48, '08:45:00', '10:05:00'),
(49, '09:30:00', '11:00:00'),
(50, '10:15:00', '11:45:00'),

(51, '09:00:00', '10:25:00'),
(52, '10:10:00', '11:35:00'),
(53, '08:50:00', '10:10:00'),
(54, '09:20:00', '10:50:00'),
(55, '11:00:00', '12:30:00'),

(56, '09:00:00', '10:30:00'),
(57, '10:00:00', '11:25:00'),
(58, '08:40:00', '10:00:00'),
(59, '09:15:00', '10:45:00'),
(60, '10:30:00', '12:00:00'),

(61, '09:00:00', '10:20:00'),
(62, '10:00:00', '11:30:00'),
(63, '08:45:00', '10:05:00'),
(64, '09:30:00', '11:00:00'),
(65, '10:15:00', '11:45:00'),

(66, '09:00:00', '10:30:00'),
(67, '10:10:00', '11:40:00'),
(68, '08:50:00', '10:10:00'),
(69, '09:25:00', '10:55:00'),
(70, '11:00:00', '12:20:00'),

(71, '09:00:00', '10:30:00'),
(72, '10:00:00', '11:20:00'),
(73, '08:45:00', '10:05:00'),
(74, '09:30:00', '11:00:00'),
(75, '10:15:00', '11:45:00'),

(76, '09:00:00', '10:25:00'),
(77, '10:10:00', '11:35:00'),
(78, '08:50:00', '10:10:00'),
(79, '09:20:00', '10:50:00'),
(80, '11:00:00', '12:30:00'),

(81, '09:00:00', '10:30:00'),
(82, '10:00:00', '11:25:00'),
(83, '08:45:00', '10:00:00'),
(84, '09:30:00', '11:00:00'),
(85, '10:15:00', '11:45:00'),

(86, '09:00:00', '10:20:00'),
(87, '10:10:00', '11:40:00'),
(88, '08:50:00', '10:10:00'),
(89, '09:25:00', '10:55:00'),
(90, '11:00:00', '12:30:00');
-- ============================================
-- ALAT_SESIJA (100+ redova)
-- ============================================
INSERT INTO alat_sesija (sesija_id, alat_id) VALUES
(1, 1), (1, 2), (2, 3), (2, 4), (3, 5),
(4, 6), (4, 7), (5, 8), (6, 9), (6, 10),
(7, 11), (7, 12), (8, 13), (9, 14), (9, 15),
(10, 16), (11, 17), (11, 18), (12, 19), (12, 20),
(13, 21), (14, 22), (14, 23), (15, 24), (16, 25),
(16, 26), (17, 27), (18, 28), (18, 29), (19, 30),
(20, 31), (20, 32), (21, 33), (22, 34), (22, 35),
(23, 36), (24, 37), (24, 38), (25, 39), (26, 40),
(26, 41), (27, 42), (28, 43), (28, 44), (29, 45),
(30, 46), (30, 47), (31, 48), (32, 49), (32, 50),
(33, 51), (34, 52), (34, 53), (35, 54), (36, 55),
(36, 56), (37, 57), (38, 58), (38, 59), (39, 60),
(40, 61), (40, 62), (41, 63), (42, 64), (42, 65),
(43, 66), (44, 67), (44, 68), (45, 69), (46, 70),
(46, 71), (47, 72), (48, 73), (48, 74), (49, 75),
(50, 76), (50, 77), (51, 78), (52, 79), (52, 80),
(53, 81), (54, 82), (54, 83), (55, 84), (56, 85),
(56, 86), (57, 87), (58, 88), (58, 89), (59, 90),
(60, 91), (60, 92), (61, 93), (62, 94), (62, 95),
(63, 96), (64, 97), (64, 98), (65, 99), (66, 100),
(67, 1), (67, 5), (68, 10), (69, 15), (69, 20),
(70, 25), (71, 30), (71, 35), (72, 40), (73, 45),
(73, 50), (74, 55), (75, 60), (75, 65), (76, 70),
(77, 75), (77, 80), (78, 85), (79, 90), (79, 95),
(80, 100), (81, 2), (81, 7), (82, 12), (83, 17),
(83, 22), (84, 27), (85, 32), (85, 37), (86, 42),
(87, 47), (87, 52), (88, 57), (89, 62), (89, 67);

-- ============================================
-- SESIJA_UCESNIK (100+ redova)
-- ============================================
INSERT INTO sesija_ucesnik (sesija_id, ucesnik_id) VALUES
(1, 1), (1, 2), (2, 3), (2, 4), (3, 5),
(4, 6), (4, 7), (5, 8), (6, 9), (6, 10),
(7, 11), (7, 12), (8, 13), (9, 14), (9, 15),
(10, 16), (11, 17), (11, 18), (12, 19), (12, 20),
(13, 21), (14, 22), (14, 23), (15, 24), (16, 25),
(16, 26), (17, 27), (18, 28), (18, 29), (19, 30),
(20, 31), (20, 32), (21, 33), (22, 34), (22, 35),
(23, 36), (24, 37), (24, 38), (25, 39), (26, 40),
(26, 41), (27, 42), (28, 43), (28, 44), (29, 45),
(30, 46), (30, 47), (31, 48), (32, 49), (32, 50),
(33, 51), (34, 52), (34, 53), (35, 54), (36, 55),
(36, 56), (37, 57), (38, 58), (38, 59), (39, 60),
(40, 61), (40, 62), (41, 63), (42, 64), (42, 65),
(43, 66), (44, 67), (44, 68), (45, 69), (46, 70),
(46, 71), (47, 72), (48, 73), (48, 74), (49, 75),
(50, 76), (50, 77), (51, 78), (52, 79), (52, 80),
(53, 81), (54, 82), (54, 83), (55, 84), (56, 85),
(56, 86), (57, 87), (58, 88), (58, 89), (59, 90),
(60, 91), (60, 92), (61, 93), (62, 94), (62, 95),
(63, 96), (64, 97), (64, 98), (65, 99), (66, 100),
(67, 1), (67, 5), (68, 10), (69, 15), (69, 20),
(70, 25), (71, 30), (71, 35), (72, 40), (73, 45),
(73, 50), (74, 55), (75, 60), (75, 65), (76, 70),
(77, 75), (77, 80), (78, 85), (79, 90), (79, 95),
(80, 100), (81, 2), (81, 7), (82, 12), (83, 17),
(83, 22), (84, 27), (85, 32), (85, 37), (86, 42),
(87, 47), (87, 52), (88, 57), (89, 62);

-- ============================================
-- ISTRAZIVAC (100 redova)
-- ============================================
INSERT INTO istrazivac (naziv, kvalifikacije, specijalizacija) VALUES
('Dr Marko Petrović', 'PhD Psychology', 'Kognitivna psihologija'),
('Dr Ana Jovanović', 'PhD Neuroscience', 'Neuropsihologija'),
('Dr Nikola Đorđević', 'PhD Clinical Psychology', 'Klinička psihologija'),
('Dr Jelena Stojanović', 'PhD Social Psychology', 'Socijalna psihologija'),
('Dr Stefan Nikolić', 'PhD Developmental', 'Razvojna psihologija'),
('Dr Milica Pavlović', 'PhD Cognitive Science', 'Kognitivne nauke'),
('Dr Ivan Ilić', 'PhD Organizational', 'Organizaciona psihologija'),
('Dr Jovana Dimitrijević', 'PhD Educational', 'Edukaciona psihologija'),
('Dr Aleksandar Marinković', 'PhD Experimental', 'Eksperimentalna psihologija'),
('Dr Teodora Stanković', 'PhD Health Psychology', 'Zdrav. psihologija'),
('Dr Milan Popović', 'MSc Psychology', 'Bihevioralna terapija'),
('Dr Katarina Milenković', 'PhD Counseling', 'Savetodavna psihologija'),
('Dr Dušan Mihajlović', 'PhD Statistics', 'Psihometrija'),
('Dr Isidora Tomić', 'PhD Psychophysiology', 'Psihofiziologija'),
('Dr Lazar Kostić', 'PhD Perception', 'Percepcija'),
('Dr Nataša Radovanović', 'PhD Memory Research', 'Memorija'),
('Dr Uroš Lazarević', 'PhD Attention', 'Pažnja'),
('Dr Olivera Ristić', 'PhD Emotion', 'Emocionalna regulacija'),
('Dr Vuk Stojković', 'PhD Decision Making', 'Donošenje odluka'),
('Dr Tijana Vasić', 'PhD Language', 'Psiholingvistika'),
('Dr Bogdan Živković', 'PhD Motor Control', 'Motorička kontrola'),
('Dr Maja Simić', 'PhD Personality', 'Psihologija ličnosti'),
('Dr Nemanja Đukić', 'PhD Forensic', 'Forenzička psihologija'),
('Dr Sofija Nikolić', 'PhD Sports', 'Sportska psihologija'),
('Dr Radomir Jović', 'PhD Consumer', 'Potrošačka psihologija'),
('Dr Ivana Cvetković', 'MSc Psychotherapy', 'Psihoterapija'),
('Dr Bojan Antić', 'PhD Creativity', 'Kreativnost'),
('Dr Dragana Matić', 'PhD Motivation', 'Motivacija'),
('Dr Zoran Stanišić', 'PhD Stress', 'Stres i coping'),
('Dr Suzana Todorović', 'PhD Sleep', 'Psihologija spavanja'),
('Dr Predrag Milosavljević', 'PhD Pain', 'Psihologija bola'),
('Dr Vesna Obradović', 'PhD Addiction', 'Adiktologija'),
('Dr Slobodan Radojčić', 'PhD Aging', 'Gerontopsihologija'),
('Dr Gordana Filipović', 'PhD Child', 'Dečja psihologija'),
('Dr Dejan Petrović', 'PhD Adolescent', 'Adolescentna psihologija'),
('Dr Snežana Maksimović', 'PhD Family', 'Porodična terapija'),
('Dr Goran Đorđević', 'PhD Couples', 'Parovna terapija'),
('Dr Ljiljana Stamenković', 'PhD Group', 'Grupna terapija'),
('Dr Bratislav Mitrović', 'PhD Industrial', 'Industrijska psihologija'),
('Dr Danijela Savić', 'PhD Human Factors', 'Ergonomija'),
('Dr Srđan Vujić', 'PhD Traffic', 'Saobraćajna psihologija'),
('Dr Mirjana Ranđelović', 'PhD Environmental', 'Ekološka psihologija'),
('Dr Dragan Nikolić', 'PhD Community', 'Psihologija zajednice'),
('Dr Biljana Đurić', 'PhD Political', 'Politička psihologija'),
('Dr Miloš Jocić', 'PhD Media', 'Medijska psihologija'),
('Dr Aleksandra Ilić', 'PhD Cyber', 'Sajber psihologija'),
('Dr Vladimir Kostić', 'PhD Music', 'Psihologija muzike'),
('Dr Jasmina Stanojević', 'PhD Art', 'Psihologija umetnosti'),
('Dr Srećko Marković', 'PhD Architecture', 'Arhitektonska psihologija'),
('Dr Zorica Stojanović', 'PhD Color', 'Psihologija boja'),
('Dr Radovan Živanović', 'PhD Aesthetics', 'Estetička psihologija'),
('Dr Milena Ćirić', 'PhD Reading', 'Psihologija čitanja'),
('Dr Nenad Petrović', 'PhD Math', 'Matematička kognicija'),
('Dr Tatjana Stefanović', 'PhD Bilingualism', 'Bilingvizam'),
('Dr Dragutin Ignjatović', 'PhD Cross-cultural', 'Interkulturalna psi.'),
('Dr Slavica Jovičić', 'PhD Gender', 'Rodna psihologija'),
('Dr Miladin Kostić', 'PhD LGBT', 'LGBTQ+ psihologija'),
('Dr Nevena Radović', 'PhD Disability', 'Psihologija invaliditeta'),
('Dr Miroslav Stanković', 'PhD Rehabilitation', 'Rehabilitaciona psi.'),
('Dr Danijela Đorđević', 'PhD Palliative', 'Palijativna psihologija'),
('Dr Miodrag Pavlović', 'PhD Thanatology', 'Tanatologija'),
('Dr Svetlana Milovanović', 'PhD Grief', 'Psihologija žalovanja'),
('Dr Branko Nikolić', 'PhD Trauma', 'Traumatska psihologija'),
('Dr Nada Stojanović', 'PhD PTSD', 'PTSP terapija'),
('Dr Petar Jovanović', 'PhD Resilience', 'Reziliencija'),
('Dr Radmila Dimitrijević', 'PhD Positive', 'Pozitivna psihologija'),
('Dr Miloje Petrović', 'PhD Mindfulness', 'Mindfulness'),
('Dr Tanja Ilić', 'PhD Compassion', 'Compassion terapija'),
('Dr Ognjen Stojanović', 'PhD ACT', 'ACT terapija'),
('Dr Marina Jović', 'PhD DBT', 'DBT terapija'),
('Dr Dušica Marković', 'PhD Schema', 'Schema terapija'),
('Dr Vladan Nikolić', 'PhD EMDR', 'EMDR terapija'),
('Dr Jelisaveta Petrović', 'PhD Hypnotherapy', 'Hipnoterapija'),
('Dr Branislav Stanković', 'PhD Psychodrama', 'Psihodrama'),
('Dr Gordana Ilić', 'PhD Gestalt', 'Gestalt terapija'),
('Dr Mihailo Đorđević', 'PhD Existential', 'Egzistencijalna terapija'),
('Dr Violeta Jovanović', 'PhD Logotherapy', 'Logoterapija'),
('Dr Ranko Kostić', 'PhD Psychoanalysis', 'Psihoanaliza'),
('Dr Milka Petrović', 'PhD Jungian', 'Jungijanska analiza'),
('Dr Stojan Nikolić', 'PhD Adlerian', 'Adlerijanska psihologija'),
('Dr Danica Stojković', 'PhD Systemic', 'Sistemska terapija'),
('Dr Momčilo Ilić', 'PhD Narrative', 'Narativna terapija'),
('Dr Slavoljub Đorđević', 'PhD Solution-focused', 'Solution-focused terapija'),
('Dr Natalija Petrović', 'PhD Brief therapy', 'Kratkotrajna terapija'),
('Dr Radiša Jovanović', 'PhD Play therapy', 'Igroterapija'),
('Dr Dragica Stanković', 'PhD Art therapy', 'Art terapija'),
('Dr Milojko Nikolić', 'PhD Music therapy', 'Muzikoterapija'),
('Dr Snežana Ilić', 'PhD Dance therapy', 'Dance/movement terapija'),
('Dr Radoje Petrović', 'PhD Drama therapy', 'Drama terapija'),
('Dr Miroslava Đorđević', 'PhD Animal therapy', 'Animal-assisted terapija'),
('Dr Živorad Jovanović', 'PhD Nature therapy', 'Eco-terapija'),
('Dr Biserka Kostić', 'PhD Adventure therapy', 'Adventure terapija'),
('Dr Nikodije Nikolić', 'PhD Virtual reality', 'VR terapija'),
('Dr Darinko Petrović', 'PhD Neurofeedback', 'Neurofeedback'),
('Dr Milana Ilić', 'PhD Biofeedback', 'Biofeedback'),
('Dr Radosav Stanković', 'PhD TMS', 'TMS terapija'),
('Dr Zlata Đorđević', 'PhD Pharmacotherapy', 'Psiho-farmakologija'),
('Dr Momčilo Jovanović', 'PhD Integrative', 'Integrativna psihologija'),
('Dr Petar Ković', 'PhD Psychology', 'Opšta psihologija'),
('Dr Jovana Marić', 'PhD Psychology', 'Mindfulness');

-- ============================================
-- DIZAJNER (50 redova)
-- ============================================
INSERT INTO dizajner (istrazivac_id) VALUES
(1), (2), (3), (5), (6), (8), (9), (10), (12), (13),
(15), (16), (18), (19), (20), (22), (24), (26), (27), (28),
(30), (32), (34), (36), (38), (40), (42), (44), (46), (48),
(50), (52), (54), (56), (58), (60), (62), (64), (66), (68),
(70), (72), (74), (76), (78), (80), (82), (84), (86), (88);

-- ============================================
-- IZVODJAC (50 redova)
-- ============================================
INSERT INTO izvodjac (istrazivac_id) VALUES
(4), (7), (11), (14), (17), (21), (23), (25), (29), (31),
(33), (35), (37), (39), (41), (43), (45), (47), (49), (51),
(53), (55), (57), (59), (61), (63), (65), (67), (69), (71),
(73), (75), (77), (79), (81), (83), (85), (87), (89), (90),
(91), (92), (93), (94), (95), (96), (97), (98), (99), (100);

-- ============================================
-- ANKETA_TEORIJA (100+ redova)
-- ============================================
INSERT INTO anketa_teorija (anketa_id, teorija_id) VALUES
(1, 1), (1, 6), (2, 76), (2, 77), (3, 90), (3, 91),
(4, 43), (4, 44), (5, 29), (5, 30), (6, 14), (6, 15),
(7, 47), (7, 48), (8, 39), (8, 40), (9, 64), (9, 65),
(10, 50), (10, 51), (11, 29), (11, 31), (12, 83), (12, 84),
(13, 20), (13, 21), (14, 22), (14, 23), (15, 27), (15, 45),
(16, 19), (16, 67), (17, 18), (17, 19), (18, 85), (18, 86),
(19, 37), (19, 38), (20, 14), (20, 18), (21, 19), (21, 53),
(22, 11), (22, 12), (23, 46), (23, 47), (24, 36), (24, 37),
(25, 8), (25, 9), (26, 8), (26, 31), (27, 44), (27, 46),
(28, 44), (28, 45), (29, 67), (29, 68), (30, 54), (30, 55),
(31, 32), (31, 33), (32, 28), (32, 29), (33, 24), (33, 25),
(34, 56), (34, 57), (35, 20), (35, 92), (36, 13), (36, 14),
(37, 61), (37, 62), (38, 54), (38, 55), (39, 39), (39, 40),
(40, 54), (40, 61), (41, 3), (41, 4), (42, 34), (42, 54),
(43, 43), (43, 44), (44, 52), (44, 82), (45, 27), (45, 28),
(46, 24), (46, 25), (47, 63), (47, 64), (48, 45), (48, 46),
(49, 82), (49, 83), (50, 64), (50, 65), (51, 66), (51, 67),
(52, 10), (52, 29), (53, 34), (53, 35), (54, 41), (54, 42),
(55, 31), (55, 32), (56, 50), (56, 51), (57, 14), (57, 53),
(58, 45), (58, 82), (59, 77), (59, 78), (60, 88), (60, 89),
(61, 90), (61, 91), (62, 92), (62, 93), (63, 3), (63, 77),
(64, 4), (64, 5), (65, 13), (65, 14), (66, 71), (66, 72),
(67, 73), (67, 74), (68, 75), (68, 76), (69, 79), (69, 80),
(70, 81), (70, 82), (71, 85), (71, 86), (72, 87), (72, 88),
(73, 12), (73, 13), (74, 26), (74, 27),
(75, 33), (75, 34), (76, 41), (76, 43), (77, 58), (77, 59),
(78, 60), (78, 61), (79, 62), (79, 63), (80, 70), (80, 71),
(81, 72), (81, 73), (82, 74), (82, 75), (83, 76), (83, 77),
(84, 78), (84, 79), (85, 80), (85, 81), (86, 82), (86, 83),
(87, 84), (87, 85), (88, 86), (88, 87), (89, 88), (89, 89),
(90, 90), (90, 91), (91, 92), (91, 93), (92, 94), (92, 95),
(93, 96), (93, 97), (94, 98), (94, 99), (95, 100), (95, 1),
(96, 2), (96, 3), (97, 4), (97, 5), (98, 6), (98, 7),
(99, 8), (99, 9), (100, 10), (100, 11);


INSERT INTO izvodjenje_izvodjac (izvodjenje_id, istrazivac_id)
VALUES
(1, 4),
(2, 7),
(3, 11),
(4, 14),
(5, 17),
(6, 21),
(7, 23),
(8, 25),
(9, 29),
(10, 31),

(11, 33),
(12, 35),
(13, 37),
(14, 39),
(15, 41),
(16, 43),
(17, 45),
(18, 47),
(19, 49),
(20, 51),

(21, 53),
(22, 55),
(23, 57),
(24, 59),
(25, 61),
(26, 63),
(27, 65),
(28, 67),
(29, 69),
(30, 71),

(31, 73),
(32, 75),
(33, 77),
(34, 79),
(35, 81),
(36, 83),
(37, 85),
(38, 87),
(39, 89),
(40, 90),

(41, 91),
(42, 92),
(43, 93),
(44, 94),
(45, 95),
(46, 96),
(47, 97),
(48, 98),
(49, 99),
(50, 100),

(51, 4),
(52, 7),
(53, 11),
(54, 14),
(55, 17),
(56, 21),
(57, 23),
(58, 25),
(59, 29),
(60, 31),

(61, 33),
(62, 35),
(63, 37),
(64, 39),
(65, 41),
(66, 43),
(67, 45),
(68, 47),
(69, 49),
(70, 51),

(71, 53),
(72, 55),
(73, 57),
(74, 59),
(75, 61),
(76, 63),
(77, 65),
(78, 67),
(79, 69),
(80, 71),

(81, 73),
(82, 75),
(83, 77),
(84, 79),
(85, 81),
(86, 83),
(87, 85),
(88, 87),
(89, 89),
(90, 90),

(91, 91),
(92, 92),
(93, 93),
(94, 94),
(95, 95),
(96, 96),
(97, 97),
(98, 98),
(99, 99),
(100, 100),

(101, 4),
(102, 7),
(103, 11),
(104, 14),
(105, 17),
(106, 21),
(107, 23),
(108, 25),
(109, 29),
(110, 31),

(111, 33),
(112, 35),
(113, 37),
(114, 39),
(115, 41),
(116, 43),
(117, 45),
(118, 47),
(119, 49),
(120, 51),

(121, 53),
(122, 55),
(123, 57),
(124, 59),
(125, 61),
(126, 63),
(127, 65),
(128, 67),
(129, 69),
(130, 71),

(131, 73),
(132, 75),
(133, 77),
(134, 79);

INSERT INTO dizajner_anketa (anketa_id, istrazivac_id) VALUES
(1, 1), (2, 2), (3, 3), (4, 5),
(5, 6), (6, 8), (7, 9), (8, 10),
(9, 12), (10, 13), (11, 15), (12, 16),
(13, 18), (14, 19), (15, 20), (16, 22),
(17, 24), (18, 26), (19, 27), (20, 28),
(21, 30), (22, 32), (23, 34), (24, 36),
(25, 38), (26, 40), (27, 42), (28, 44),
(29, 46), (30, 48), (31, 50), (32, 52),
(33, 54), (34, 56), (35, 58), (36, 60),
(37, 62), (38, 64), (39, 66), (40, 68),
(41, 70), (42, 72), (43, 74), (44, 76),
(45, 78), (46, 80), (47, 82), (48, 84),
(49, 86), (50, 88);
