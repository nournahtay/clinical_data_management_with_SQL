## Clinical Data Management with SQL

### Simulating the query of clinical trial data
This mini project simulates the process of storing, querying, cleaning datasets from duplicates & missing values and managing clinical trial datasets with SQL. The data includes:
1. patients data
2. visits data
3. lab results
4. adverse events
5. medications given during the trial

This was done via the SQLite3 tool in Ubuntu

```
#Install SQLite3

sudo apt update
sudo apt install sqlite3

#Create a directory
mkdir clinical_sql_project
cd clinical_sql_project

#Create database
sqlite3 clinical_trial.db

```
###Simulating patient eligibility
This part queries data to ensure that patients are eligibile to participate in clinical trials. the criteria include:
1. Age: 18-65
