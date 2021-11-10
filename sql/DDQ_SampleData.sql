--
-- Table structure for table `Companies`
--

DROP TABLE IF EXISTS `companies`;
CREATE TABLE companies(
    company_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100) NOT NULL,
    industry VARCHAR(100) NOT NULL,
    size INT NOT NULL,
    PRIMARY KEY ( company_id )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Companies`
--

INSERT INTO companies (name, location, industry, size) VALUES
('Hooli', 'Silicon Valley', 'Internet', 10000),
('Acme Corporation', 'Los Angeles', 'Widgets', 5000),
('Los Pollos Hermanos', 'Albuquerque', 'Fast Food', 2500),
('Delos Incorporated', 'Westworld', 'Entertainment', 20000),
('Monsters, Inc.', 'Monstropolis', 'Energy', 15000);

-- --------------------------------------------------------

--
-- Table structure for table `Contacts`
--

DROP TABLE IF EXISTS `contacts`;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Contacts`
--

INSERT INTO contacts (first_name, last_name, email, company_id) VALUES
('Richard', 'Hendricks', 'rhendricks@hooli.com', 1),
('Marvin', 'Acme', 'marvin@acme.com', 2),
('Gus', 'Fring', 'gfring@lospolloshermanos.com', 3);


-- --------------------------------------------------------

--
-- Table structure for table `Candidates`
--

DROP TABLE IF EXISTS `candidates`;
CREATE TABLE candidates(
    candidate_id INT NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL,
    email VARCHAR(70) NOT NULL,
    phone_number VARCHAR(25),
    PRIMARY KEY ( candidate_id )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Candidates`
--

INSERT INTO candidates (first_name, last_name, email, phone_number) VALUES
('Joe', 'Blow', 'joe@blow.com', '123-456-7890'),
('Darth', 'Vader', 'darthvader@empire.com', '888-334-8719'),
('Vito', 'Corleone', 'godfather@mafia.com', '800-777-5555');

-- --------------------------------------------------------

--
-- Table structure for table `Job Types`
--

DROP TABLE IF EXISTS `job_types`;
CREATE TABLE job_types(
    job_type_code VARCHAR(10) NOT NULL UNIQUE,
    description VARCHAR(255) NOT NULL,
    PRIMARY KEY ( job_type_code )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Job Types`
--

INSERT INTO job_types (job_type_code, description) VALUES
('EXEC', 'Executive'),
('TECH', 'Technical'),
('ADMIN', 'Administrative');

-- --------------------------------------------------------

--
-- Table structure for table `Jobs`
--

DROP TABLE IF EXISTS `jobs`;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Jobs`
--

INSERT INTO jobs (title, location, description, is_active, company_id, job_type_code) VALUES
('Software Engineer', 'Remote', 'Write Java code', 1, 1, 'TECH'),
('Administrative Assistant', 'Los Angeles', 'Assist the CEO', 1, 2, 'ADMIN'),
('Manager', 'New Mexico', 'Supervise fast food employees', 1, 3, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `Applications`
--

DROP TABLE IF EXISTS `applications`;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Applications`
--

INSERT INTO applications (job_id, candidate_id, date_applied, is_archived) VALUES
(1, 1, CURDATE(), 0),
(1, 2, '2021-10-15', 0),
(2, 3, '2021-09-10', 0);

