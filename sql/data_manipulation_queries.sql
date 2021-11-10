-----------------------
-- Companies
-----------------------

-- Show all Companies in the table
SELECT * from companies;

-- Add a new Company
INSERT INTO companies (name, location, industry, size)
VALUES (:name_input, :location_input, :industry_input, :size_input);


-----------------------
-- Contacts
-----------------------

-- Show all Contacts in the table
SELECT * from contacts;
SELECT contacts.*, companies.name
FROM contacts INNER JOIN companies on contacts.company_id = companies.company_id;

-- Get companies without a contact to populate a dropdown for adding a new contact to a company
SELECT companies.company_id, companies.name
FROM companies LEFT OUTER JOIN contacts ON companies.company_id = contacts.company_id
WHERE contacts.company_id IS NULL;

-- Add a new Contact
INSERT INTO contacts (first_name, last_name, email_address, company_id)
VALUES (:first_name_input, :last_name_input, :email_address_input, :company_id_from_dropdown_input);


-----------------------
-- Candidates
-----------------------

-- Show all Candidates in the table
SELECT * from candidates;

-- Add a new Candidate
INSERT INTO candidates (first_name, last_name, email_address, phone_number)
VALUES (:first_name_input, :last_name_input, :email_address_input, :phone_number_input);


-----------------------
-- Jobs
-----------------------

-- Show all Jobs in the table
SELECT * from jobs;
SELECT jobs.*, company.name
FROM jobs INNER JOIN companies ON jobs.company_id = companies.company_id;

-- Add a new Job
INSERT INTO jobs (title, location, description, is_active, company_id, job_type_code)
VALUES (:title_input, :location_input, :description_input, 1, :company_id_from_dropdown_input, :job_type_code_from_dropdown_input);

-- Get jobs in table to populate a dropdown for updating/editing
SELECT jobs.title, companies.name
FROM jobs LEFT OUTER JOIN companies ON jobs.company_id = companies.company_id;

-- Get all company ID and name values to populate the Company dropdown
SELECT company_id, name FROM companies;

-- Get all job_type_code and description values to populate the Job Type dropdown
SELECT job_type_code, description FROM jobtypes;

-- Edit/Update a selected Job 
UPDATE jobs SET title = :title_input, location = :location_input, description = :description_input, is_active = :is_active_input, job_type_code = :job_type_code_input)
WHERE job_id = :job_id_selected AND company_id = :company_id_selected;

-- Search for a Job by Company
SELECT * FROM jobs WHERE CONTAINS (company_id, :search_input);

-- Search for a Job by Job Type
SELECT * FROM jobs WHERE CONTAINS (job_type_code, :search_input);

-- Search for a Job by Title
SELECT * FROM jobs WHERE CONTAINS (title, :search_input);

-- Search for a Job by Location
SELECT * FROM jobs WHERE CONTAINS (location, :search_input);


-----------------------
-- Job Types
-----------------------

-- Show all Job Types in the table
SELECT * from job_types;

-- Add a new Job Type
INSERT INTO job_types (job_type_code, description)
VALUES (:job_type_code_input, :description_input);


-----------------------
-- Applications
-----------------------

-- Show all Applications in the table
SELECT * from applications;
SELECT j.job_id, j.title 'Title', j.location 'Location', 
                CASE
                    WHEN j.is_active = 1 THEN 'true'
                    ELSE 'false'
                END 'Active Job',
                j.job_type_code, c.name 'Company', 
                c2.candidate_id, c2.first_name 'First Name', c2.last_name 'Last Name', c2.email 'Email', date(a.date_applied) 'Date Applied', 
                CASE
                    WHEN  a.is_archived = 1 THEN 'true'
                    ELSE 'false'
                END 'is_archived'
                FROM jobs j INNER JOIN companies c ON j.company_id = c.company_id
                INNER JOIN applications a on j.job_id = a.job_id
                INNER JOIN candidates c2 on a.candidate_id = c2.candidate_id;

-- Get all job_id, title and company name values for active jobs to populate the Job dropdown
SELECT job_id, title, name 'company' FROM jobs j INNER JOIN companies c on j.company_id = c.company_id
WHERE j.is_active = 1;

-- Get all candidate_id, first_name, and last_name values to populate the Candidate dropdown
SELECT candidate_id, first_name, last_name FROM candidates;

-- Add a new Application
INSERT INTO applications (candidate_id, job_id, date_applied, is_archived)
VALUES (:candidate_id_from_dropdown_input, :job_id_from_dropdown_input, curdate(), 0);

-- Delete from Applications
DELETE FROM applications WHERE candidate_id = :candidate_id_selected AND job_id = :job_id_selected;

-- Update is_active attribute of Applications from NOT active to active
UPDATE applications SET is_archived = 1 WHERE candidate_id = :candidate_id_selected AND job_id = :job_id_selected;

-- Update is_active attribute of Applications from active to NOT active
UPDATE applications SET is_archived = 0 WHERE candidate_id = :candidate_id_selected AND job_id = :job_id_selected;
