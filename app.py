from flask import Flask, render_template, request, flash
from datetime import date
import database.db_connector as db
import logging
import os

# Configuration

app = Flask(__name__)
app.secret_key = b'_5#y2L"F4Q8z\n\xec]/'
logging.basicConfig(filename='record.log', level=logging.DEBUG, format=f'%(asctime)s %(levelname)s %(name)s %(threadName)s : %(message)s')

db_connection = db.connect_to_database()

# Routes 

@app.route('/')
def root():
    return render_template('index.html')

"""
Companies
"""
@app.route('/companies')
def companies():
    return render_template('companies.html')

"""
Contacts
"""
@app.route('/contacts', methods=['post', 'get'])
def contacts():
    if request.method == 'POST':
        firstName = request.form['first_name']
        lastName = request.form['last_name']
        email = request.form['email']
        companyId = request.form['company_id']

        if (firstName != '' and lastName != '' and email != '' and companyId != ''):
            insertContactQuery = '''INSERT INTO contacts (first_name, last_name, email, company_id)
                VALUES ('{}', '{}', '{}', {});'''.format(firstName, lastName, email, companyId)
            db.execute_query(db_connection=db_connection, query=insertContactQuery)

    contactsQuery = """SELECT c.contact_id, c.first_name 'First Name', c.last_name 'Last Name', c.email 'Email', co.name 'Company'
        FROM contacts c INNER JOIN companies co on c.company_id = co.company_id;"""
    cursor = db.execute_query(db_connection=db_connection, query=contactsQuery)
    contacts = cursor.fetchall() 

    # companies without a contact
    companiesQuery = """SELECT companies.company_id, companies.name
        FROM companies LEFT OUTER JOIN contacts ON companies.company_id = contacts.company_id
        WHERE contacts.company_id IS NULL;"""
    cursor = db.execute_query(db_connection=db_connection, query=companiesQuery)
    companies = cursor.fetchall() 

    return render_template('contacts.html', contacts=contacts, companies=companies)

"""
Candidates
"""
@app.route('/candidates')
def candidates():
    return render_template('candidates.html')  

"""
Jobs
"""
@app.route('/jobs', methods=['post', 'get'])
def jobs():
    jobsQuery = """SELECT j.job_id, j.title 'Title', j.location 'Location', j.description 'Description',
            IF(j.is_active = 1, 'Yes', 'No') 'Active Job',
            c.name 'Company', jt.description 'Job Type'
        FROM jobs j INNER JOIN companies c on j.company_id = c.company_id
        LEFT OUTER JOIN job_types jt on j.job_type_code = jt.job_type_code"""
    whereClause = ''
    args = None

    if request.method == 'POST':
        if request.form['statement'] == 'INSERT':
            title = request.form['title']
            location = request.form['location']
            description = request.form['description']
            companyId = request.form['company_id']
            jobTypeCode = request.form['job_type_code']

            if (title != '' and location != '' and description != ''):
                if (jobTypeCode != ''):
                    insertJobQuery = '''INSERT INTO jobs (title, location, description, is_active, company_id, job_type_code) 
                        VALUES ('{}', '{}', '{}', {}, {}, '{}');'''.format(title, location, description, 1, companyId, jobTypeCode)
                else:
                    insertJobQuery = '''INSERT INTO jobs (title, location, description, is_active, company_id) 
                        VALUES ('{}', '{}', '{}', {}, {});'''.format(title, location, description, 1, companyId)           

                db.execute_query(db_connection=db_connection, query=insertJobQuery)

        # if search, build WHERE clause and append to SELECT query
        if request.form['statement'] == 'SEARCH':
            searchBy = request.form['search_by']
            searchTerm = request.form['search_term']
            if searchBy != '' and searchTerm != '':
                if searchBy == 'company':
                    whereClause = " WHERE c.name LIKE %s"
                elif searchBy == 'job_type':
                    whereClause = " WHERE jt.description LIKE %s"
                elif searchBy == 'title':
                    whereClause = " WHERE j.title LIKE %s"
                elif searchBy == 'location':
                    whereClause = " WHERE j.location LIKE %s"

            jobsQuery = jobsQuery + whereClause

    jobsQuery = jobsQuery + ';'
    if (whereClause != ''):
        args=['%'+searchTerm+'%']
        cursor = db.execute_query(db_connection=db_connection, query=jobsQuery, query_params=args)
    else:
        cursor = db.execute_query(db_connection=db_connection, query=jobsQuery)

    jobs = cursor.fetchall()  

    companiesQuery = "SELECT company_id, name FROM companies;"
    cursor = db.execute_query(db_connection=db_connection, query=companiesQuery)
    companies = cursor.fetchall() 

    jobTypesQuery = "SELECT job_type_code, description FROM job_types;"
    cursor = db.execute_query(db_connection=db_connection, query=jobTypesQuery)
    jobTypes = cursor.fetchall()

    return render_template('jobs.html', jobs=jobs, companies=companies, jobTypes=jobTypes)       

"""
JobTypes
"""
@app.route('/jobtypes')
def jobtypes():
    return render_template('jobtypes.html')      

"""
Applications
"""
@app.route('/applications', methods=['post', 'get'])
def applications():
    if request.method == 'POST':
        jobId = request.form['job_id']
        candidateId = request.form['candidate_id']
        
        # insert
        if request.form['statement'] == 'INSERT':
            try:
                insertQuery = "INSERT INTO applications (candidate_id, job_id, date_applied, is_archived) VALUES ({}, {}, '{}', {});".format(candidateId, jobId, date.today(), 0)
                db.execute_query(db_connection=db_connection, query=insertQuery)
            except:
                flash('Selected candidate already applied to that job. Try again.')
            
        # delete
        if request.form['statement'] == 'DELETE':
            deleteQuery = "DELETE FROM applications WHERE candidate_id = {} AND job_id = {};".format(candidateId, jobId)
            db.execute_query(db_connection=db_connection, query=deleteQuery)

        # update
        if request.form['statement'] == 'UPDATE':
            isArchived = request.form['chkArchived']
            if isArchived == '1':
                updateQuery = "UPDATE applications SET is_archived = 0 WHERE candidate_id = {} AND job_id = {};".format(candidateId, jobId)
                db.execute_query(db_connection=db_connection, query=updateQuery)
            else:
                updateQuery = "UPDATE applications SET is_archived = 1 WHERE candidate_id = {} AND job_id = {};".format(candidateId, jobId)
                db.execute_query(db_connection=db_connection, query=updateQuery)

    appsQuery = """SELECT j.job_id, j.title 'Title', j.location 'Location', 
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
                INNER JOIN candidates c2 on a.candidate_id = c2.candidate_id;"""
    cursor = db.execute_query(db_connection=db_connection, query=appsQuery)
    results = cursor.fetchall() 

    jobsQuery = """SELECT job_id, title, name 'company' FROM jobs j INNER JOIN companies c on j.company_id = c.company_id
                WHERE j.is_active = 1;"""
    cursor = db.execute_query(db_connection=db_connection, query=jobsQuery)
    jobs = cursor.fetchall() 

    candidatesQuery = "SELECT candidate_id, first_name, last_name FROM candidates;"
    cursor = db.execute_query(db_connection=db_connection, query=candidatesQuery)
    candidates = cursor.fetchall() 

    return render_template('applications.html', applications=results, jobs=jobs, candidates=candidates)     

# Listener

if __name__ == "__main__":
    app.debug = True
    host = os.environ.get('IP', '0.0.0.0')
    port = int(os.environ.get('PORT', 5555)) 
    
    app.run(host=host, port=port) 
