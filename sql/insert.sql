INSERT INTO companies (name, location, industry, size) VALUES
('Hooli', 'Silicon Valley', 'Internet', 10000),
('Acme Corporation', 'Los Angeles', 'Widgets', 5000),
('Los Pollos Hermanos', 'Albuquerque', 'Fast Food', 2500);

INSERT INTO contacts (first_name, last_name, email, company_id) VALUES
('Richard', 'Hendricks', 'rhendricks@hooli.com', 1),
('Marvin', 'Acme', 'marvin@acme.com', 2),
('Gus', 'Fring', 'gfring@lospolloshermanos.com', 3)

INSERT INTO candidates (first_name, last_name, email, phone_number) VALUES
('Joe', 'Blow', 'joe@blow.com', '1234567890'),
('Darth', 'Vader', 'darthvader@empire.com', '8883348719'),
('Vito', 'Corleone', 'godfather@mafia.com', '8007775555')

INSERT INTO job_types (job_type_code, description) VALUES
('EXEC', 'Executive'),
('TECH', 'Technical'),
('ADMIN', 'Administrative')

INSERT INTO jobs (title, location, description, is_active, company_id, job_type_code) VALUES
('Software Engineer', 'remote', 'Write Java code', 1, 1, 'TECH'),
('Administrative Assistant', 'Los Angeles', 'Assist the CEO', 1, 2, 'ADMIN'),
('Manager', 'New Mexico', 'Supervise fast food employees', 1, 3, NULL)

INSERT INTO applications (job_id, candidate_id, date_applied, is_archived) VALUES
(1, 1, CURDATE(), 0),
(1, 2, '2021-10-15', 0),
(2, 3, '2021-09-10', 0)