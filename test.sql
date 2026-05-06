DROP DATABASE mind_lab_data_manager;
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
    lab_id INT NOT NULL,
    tip_alata_id INT NOT NULL,
	FOREIGN KEY (tip_alata_id) REFERENCES tip_alata(tip_alata_id)
		ON UPDATE CASCADE,
	FOREIGN KEY (lab_id) REFERENCES laboratorija(lab_id)
    ON UPDATE CASCADE
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
    lab_id INT NOT NULL,
    datum DATE NOT NULL,
    vreme TIME NOT NULL,
    status VARCHAR(20),
    anketa_id INT NOT NULL,

    PRIMARY KEY (lab_id, datum, vreme),

    FOREIGN KEY (lab_id) REFERENCES laboratorija(lab_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (anketa_id) REFERENCES anketa(anketa_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE sesija (
    sesija_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    datum DATE NOT NULL,
    vreme_pocetka TIME NOT NULL,
    vreme_zavrsetka TIME,
    
    
    lab_id INT NOT NULL,
    datum_izvodjenja DATE NOT NULL,
    vreme TIME NOT NULL,
    FOREIGN KEY (lab_id, datum_izvodjenja,vreme) REFERENCES izvodjenje(lab_id, datum,vreme)
        ON UPDATE CASCADE ON DELETE CASCADE
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
    lab_id INT NOT NULL,
    datum DATE NOT NULL,
    vreme TIME NOT NULL,
    istrazivac_id INT NOT NULL,
    PRIMARY KEY (lab_id, datum, vreme, istrazivac_id),
    
    FOREIGN KEY (lab_id, datum, vreme)
        REFERENCES izvodjenje(lab_id, datum, vreme)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (istrazivac_id)
        REFERENCES izvodjac(istrazivac_id)
        ON UPDATE CASCADE ON DELETE CASCADE
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
