-- kreiranje baze bug_service_providers
CREATE DATABASE IF NOT EXISTS bug_service_providers;

-- stavljanje na korišćenje bazu

USE bug_service_providers;

-- kreiranje tabele project
CREATE TABLE IF NOT EXISTS project(
	project_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, -- INT je int xd
	project_name VARCHAR(40) NOT NULL -- VARCHAR je string
);

TRUNCATE TABLE project;
-- AUTO_INCREMENT oznacava da se primary key automatski povecava izmedju pojave entiteta
-- - znaci, 1, 2, 3, 4, ...
-- NOT NULL oznacava da polje ne sme biti prazno
-- PRIMARY KEY oznacava da je polje primarni kljuc
-- razlika između char i varchar je to sto char alocira tacan broj koliko je
-- potrebno, ali ako recimo ima 3 karaktera od 40, onda se ostalo popuni sa 0
-- varchar dinamicki povecava/smanjuje broj karaktera

-- dodavanje redova u tabelu project
-- u slucaju da imamo auto increment, onda ne smemo da prosledjujemo primary key
INSERT INTO project(project_name) VALUES('GeRuDok');
INSERT INTO project(project_name) VALUES('ThunderFury');
INSERT INTO project(project_name) VALUES('BeijingProject');
INSERT INTO project(project_name) VALUES('LabExperiment');
INSERT INTO project(project_name) VALUES('Chip8');

SELECT * FROM project;

CREATE TABLE IF NOT EXISTS service(
	service_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    date_start DATE NOT NULL,
    date_end DATE
);

INSERT INTO service(date_start, date_end) VALUES(STR_TO_DATE('2005-03-23', '%Y-%m-%d'), 
STR_TO_DATE('2022-05-28', '%Y-%m-%d'));

SELECT * FROM service;