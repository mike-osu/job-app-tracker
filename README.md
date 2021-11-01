# job-app-tracker

## Set up

1. Clone this repo and navigate to root directory
```
$ git clone ...
$ cd job-app-tracker
```

2. Start MySQL (locally or remote)
- (Optional) Can run on [Docker](https://www.docker.com/) using the included `docker-compose.yml` file

3. On MySQL, run these scripts to create and populate database tables

`sql/create.sql`

`sql/insert.sql`

4. Create and activate a Python 3 [virtual environment](https://realpython.com/python-virtual-environments-a-primer/) 
```
$ python3 -m venv env
$ . env/bin/activate
```

5. Install dependencies
```
$ pip install -r requirements.txt
```

6. Create a `.env` file, update with your specific DB configuration info
```
340DBHOST=127.0.0.1
340DBUSER=root
340DBPW=mypassword
340DB=my_database_name
340PORT=3306    # 3307 if using Docker
```

7. Run the application
```
$ python app.py
```

8. Go to http://0.0.0.0:5555/