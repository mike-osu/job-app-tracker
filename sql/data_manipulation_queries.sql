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

-- Add a new Contact
INSERT INTO contacts (first_name, last_name, email_address, contact_id)
VALUES (:first_name_input, :last_name_input, :email_address_input, :contact_id_input);


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

-- Add a new Job
INSERT INTO jobs (title, location, description, is_active, company_id, job_type_code)
VALUES (:title_input, :location_input, :description_input, 1, :company_id_input, :job_type_code_input);

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

-- Add a new Application
INSERT INTO applications (candidate_id, job_id, date_applied, is_archived)
VALUES (:candidate_id_input, :job_id_input, curdate(), 0);

-- Delete from Applications
DELETE FROM applications WHERE candidate_id = :candidate_id_selected AND job_id = :job_id_selected;

-- Update is_active attribute of Applications from NOT active to active
UPDATE applications SET is_archived = 1 WHERE candidate_id = :candidate_id_selected AND job_id = :job_id_selected;

-- Update is_active attribute of Applications from active to NOT active
UPDATE applications SET is_archived = 0 WHERE candidate_id = :candidate_id_selected AND job_id = :job_id_selected;
