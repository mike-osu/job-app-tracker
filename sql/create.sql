CREATE TABLE companies(
    company_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    industry VARCHAR(100) NOT NULL,
    size INT NOT NULL,
    PRIMARY KEY ( company_id )
);

CREATE TABLE contacts(
    contact_id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    email VARCHAR(70) NOT NULL,
    company_id INT NOT NULL UNIQUE,
    PRIMARY KEY ( contact_id ),
    FOREIGN KEY ( company_id )
        REFERENCES companies(company_id)
        ON DELETE CASCADE   # if parent company record is deleted, also delete contact row
);

CREATE TABLE candidates(
    candidate_id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    email VARCHAR(70) NOT NULL,
    phone_number VARCHAR(25),
    PRIMARY KEY ( candidate_id )
);

CREATE TABLE job_types(
    job_type_code VARCHAR(10) NOT NULL UNIQUE,
    description VARCHAR(255) NOT NULL,
    PRIMARY KEY ( job_type_code )
);

CREATE TABLE jobs(
    job_id INT NOT NULL AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    description VARCHAR(255) NOT NULL,
    is_active BOOLEAN,
    company_id INT NOT NULL,
    job_type_code VARCHAR(10),
    PRIMARY KEY ( job_id ),
    FOREIGN KEY ( company_id )
        REFERENCES companies(company_id)
        ON DELETE RESTRICT,  # prevent parent company row from being deleted
    FOREIGN KEY ( job_type_code )
        REFERENCES job_types(job_type_code)
        ON DELETE SET NULL  # if parent job_type is deleted, set job_type_code to NULL
);

CREATE TABLE applications(
    candidate_id INT NOT NULL,
    job_id INT NOT NULL,
    date_applied DATETIME NOT NULL,
    is_archived BOOLEAN,
    PRIMARY KEY ( candidate_id, job_id ),
    FOREIGN KEY ( candidate_id )
        REFERENCES candidates(candidate_id)
        ON DELETE RESTRICT,  # prevent parent candidate row from being deleted
    FOREIGN KEY ( job_id )
        REFERENCES jobs(job_id)
        ON DELETE RESTRICT   # prevent parent job row from being deleted
);

