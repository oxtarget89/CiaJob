INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_cia', 'cia ', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_cia', 'cia ', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_cia', 'cia ', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('cia', 'cia '),
	('offcia', 'Off cia ')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('cia',0,'recruit','Recrue',20,'{}','{}'),
	('cia',1,'officer','Officier',40,'{}','{}'),
	('cia',2,'sergeant','Sergent',60,'{}','{}'),
	('cia',3,'lieutenant','Lieutenant',85,'{}','{}'),
	('cia',4,'boss','Commandant',100,'{}','{}'),
	('offcia',0,'recruit','Off Recrue',0,'{}','{}'),
	('offcia',1,'officer','Off Officier',0,'{}','{}'),
	('offcia',2,'sergeant','Off Sergent',0,'{}','{}'),
	('offcia',3,'lieutenant','Off Lieutenant',0,'{}','{}'),
	('offcia',4,'boss','Off Commandant',0,'{}','{}')
;
