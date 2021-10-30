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

@app.route('/companies')
def companies():
    return render_template('companies.html')

@app.route('/contacts')
def contacts():
    return render_template('contacts.html')

@app.route('/candidates')
def candidates():
    return render_template('candidates.html')  

@app.route('/jobs')
def jobs():
    return render_template('jobs.html')       

@app.route('/jobtypes')
def jobtypes():
    return render_template('jobtypes.html')      

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

    appsQuery = """SELECT j.job_id, j.title, j.location, 
                CASE
                    WHEN j.is_active = 1 THEN 'true'
                    ELSE 'false'
                END 'active job',
                j.job_type_code, c.name 'company', 
                c2.candidate_id, c2.first_name, c2.last_name, c2.email, date(a.date_applied) 'date applied', 
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
