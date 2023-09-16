DROP TABLE IF EXISTS material; --each of these statements drops a table by the specified name if that table already exists 
DROP TABLE IF EXISTS step; --these drop statements are in an order where the tables with foreign keys are dropped before those foreign keys are primary keys in another table 
DROP TABLE IF EXISTS project_category; --the drop statements are before the create statements so that tables are never repeated 
DROP TABLE IF EXISTS category; 
DROP TABLE IF EXISTS project ; 

CREATE TABLE project (
	project_id INT AUTO_INCREMENT NOT NULL, --primary keys are auto incremented 
	project_name VARCHAR(128) NOT NULL,
	estimated_hours DECIMAL(7,2),
	actual_hours DECIMAL(7,2), 
	difficulty INT, 
	notes TEXT,
	PRIMARY KEY(project_id) --primary key is identified 
);

CREATE TABLE category (
	category_id INT AUTO_INCREMENT NOT NULL, --primary keys are auto incremented 
	category_name VARCHAR(128) NOT NULL, 
	PRIMARY KEY(category_id)--primary key is identified 
);

CREATE TABLE project_category ( --this table is necessary in order to join two tables with a many to many relationship 
	project_id INT NOT NULL, 
	category_id INT NOT NULL,
	FOREIGN KEY (project_id) REFERENCES project (project_id) ON DELETE CASCADE, --foreign keys are identified 
	FOREIGN KEY (category_id) REFERENCES category (category_id) ON DELETE CASCADE, --foreign keys are on delete cascade so they are deleted from the child tables when they are deleted from the parent table 
	UNIQUE KEY (project_id, category_id)
);

CREATE TABLE step (
	step_id INT AUTO_INCREMENT NOT NULL, --primary keys are auto incremented 
	project_id INT NOT NULL, 
	step_text TEXT NOT NULL, 
	step_order INT NOT NULL,
	PRIMARY KEY(step_id),--primary key is identified 
	FOREIGN KEY (project_id) REFERENCES project (project_id) ON DELETE CASCADE --foreign key is identified 
);

CREATE TABLE material (
	material_id INT AUTO_INCREMENT NOT NULL, --primary keys are auto incremented 
	project_id INT NOT NULL, 
	material_name VARCHAR(128) NOT NULL, 
	num_required INT, 
	cost DECIMAL(7,2), 
	PRIMARY KEY(material_id), --primary key is identified 
	FOREIGN KEY (project_id) REFERENCES project (project_id) ON DELETE CASCADE --foreign key is identified 
);--the tables are created in the opposite order of dropping them so that primary keys are established before they are used as foreign keys 



INSERT INTO project (project_name, estimated_hours, actual_hours, difficulty, notes) VALUES ('Bathroom Remodel', 12, 15, 4, 'Plumbing fixes, install new shower');
INSERT INTO material (project_id, material_name, num_required, cost) VALUES (1, 'PVC pipe', 4, 2.50); 
INSERT INTO material (project_id, material_name, num_required, cost) VALUES (1, 'Shower head', 1, 35.00);
INSERT INTO step (project_id, step_text, step_order) VALUES (1, 'Remove broken PVC pipe', 1);
INSERT INTO step (project_id, step_text, step_order) VALUES (1, 'Replace old shower head with new shower head', 2);
INSERT INTO category (category_name) VALUES ('Plumbing');
INSERT INTO category (category_name) VALUES ('Bathroom');
INSERT INTO category (category_name) VALUES ('Kitchen');
INSERT INTO project_category (project_id, category_id) VALUES (1, 1); 
INSERT INTO project_category (project_id, category_id) VALUES (1, 2); 

