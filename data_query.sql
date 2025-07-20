--Create Tables
-- 1. Patients table
CREATE TABLE Patients (
    patient_id INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    date_of_birth DATE,
    gender TEXT,
    enrollment_date DATE
);

-- 2. Visits table
CREATE TABLE Visits (
    visit_id INTEGER PRIMARY KEY,
    patient_id INTEGER,
    visit_date DATE,
    visit_type TEXT,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- 3. Lab Results table
CREATE TABLE Lab_Results (
    result_id INTEGER PRIMARY KEY,
    patient_id INTEGER,
    visit_id INTEGER,
    test_name TEXT,
    result_value REAL,
    result_unit TEXT,
    test_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (visit_id) REFERENCES Visits(visit_id)
);

-- 4. Adverse Events table
CREATE TABLE Adverse_Events (
    event_id INTEGER PRIMARY KEY,
    patient_id INTEGER,
    event_description TEXT,
    severity TEXT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- 5. Medications table
CREATE TABLE Medications (
    med_id INTEGER PRIMARY KEY,
    patient_id INTEGER,
    drug_name TEXT,
    dosage TEXT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id)
);

-- Insert sample datasets for each table
INSERT INTO Patients (patient_id, first_name, last_name, date_of_birth, gender, enrollment_date) VALUES
(1, 'Alice', 'Wong', '1985-06-10', 'Female', '2023-01-15'),
(2, 'Brian', 'Smith', '1978-09-22', 'Male', '2023-01-18'),
(3, 'Clara', 'Nguyen', '1990-02-14', 'Female', '2023-01-20'),
(4, 'David', 'Lee', '1982-11-03', 'Male', '2023-01-25'),
(5, 'Emily', 'Brown', '1995-03-30', 'Female', '2023-02-01');

INSERT INTO Visits (visit_id, patient_id, visit_date, visit_type) VALUES
(1, 1, '2023-01-15', 'Screening'),
(2, 1, '2023-01-20', 'Baseline'),
(3, 2, '2023-01-18', 'Screening'),
(4, 2, '2023-01-25', 'Baseline'),
(5, 3, '2023-01-20', 'Screening'),
(6, 3, '2023-01-27', 'Baseline'),
(7, 4, '2023-01-25', 'Screening'),
(8, 4, '2023-01-30', 'Baseline'),
(9, 5, '2023-02-01', 'Screening'),
(10, 5, '2023-02-06', 'Baseline');

INSERT INTO Lab_Results (result_id, patient_id, visit_id, test_name, result_value, result_unit, test_date) VALUES
(1, 1, 2, 'Hemoglobin', 13.5, 'g/dL', '2023-01-20'),
(2, 1, 2, 'ALT', 42, 'U/L', '2023-01-20'),
(3, 2, 4, 'Hemoglobin', 14.2, 'g/dL', '2023-01-25'),
(4, 2, 4, 'WBC', 6.1, 'x10^9/L', '2023-01-25'),
(5, 3, 6, 'ALT', 75, 'U/L', '2023-01-27'),
(6, 4, 8, 'Hemoglobin', 12.8, 'g/dL', '2023-01-30'),
(7, 5, 10, 'WBC', 7.0, 'x10^9/L', '2023-02-06');

INSERT INTO Adverse_Events (event_id, patient_id, event_description, severity, start_date, end_date) VALUES
(1, 1, 'Headache', 'Mild', '2023-01-21', '2023-01-22'),
(2, 2, 'Nausea', 'Moderate', '2023-01-26', '2023-01-27'),
(3, 3, 'Fatigue', 'Mild', '2023-01-28', '2023-01-30'),
(4, 4, 'Rash', 'Severe', '2023-01-31', '2023-02-05');

INSERT INTO Medications (med_id, patient_id, drug_name, dosage, start_date, end_date) VALUES
(1, 1, 'Drug A', '100mg once daily', '2023-01-20', '2023-02-20'),
(2, 2, 'Drug B', '200mg once daily', '2023-01-25', '2023-02-25'),
(3, 3, 'Drug A', '100mg once daily', '2023-01-27', '2023-02-27'),
(4, 4, 'Drug B', '200mg once daily', '2023-01-30', '2023-02-28'),
(5, 5, 'Drug A', '100mg once daily', '2023-02-06', '2023-03-06');

--Query to select the patients that experienced adverse effects
SELECT 
    Patients.patient_id,
    first_name,
    last_name,
    event_description,
    severity,
    start_date,
    end_date
FROM 
    Patients
JOIN 
    Adverse_Events ON Patients.patient_id = Adverse_Events.patient_id;

--query to find the patients with abnormal ALT results (>50)
SELECT 
    Patients.patient_id,
    first_name,
    last_name,
    Lab_Results.test_name,
    Lab_Results.result_value,
    Lab_Results.result_unit,
    Lab_Results.test_date
FROM 
    Lab_Results
JOIN 
    Patients ON Lab_Results.patient_id = Patients.patient_id
WHERE 
    test_name = 'ALT' AND result_value > 50;

--query to showcase the adverse effects from drug A
SELECT 
    Patients.patient_id,
    first_name,
    last_name,
    Medications.drug_name,
    Adverse_Events.event_description,
    Adverse_Events.severity,
    Adverse_Events.start_date,
    Adverse_Events.end_date
FROM 
    Patients
JOIN 
    Medications ON Patients.patient_id = Medications.patient_id
JOIN 
    Adverse_Events ON Patients.patient_id = Adverse_Events.patient_id
WHERE 
    Adverse_Events.start_date BETWEEN Medications.start_date AND Medications.end_date
    AND Medications.drug_name = 'Drug A'

--Identify missing lab results
SELECT 
    Patients.patient_id,
    first_name,
    last_name,
    Visits.visit_id,
    Visits.visit_date
FROM 
    Patients
JOIN 
    Visits ON Patients.patient_id = Visits.patient_id
LEFT JOIN 
    Lab_Results ON Visits.visit_id = Lab_Results.visit_id
WHERE 
    Lab_Results.result_id IS NULL;

--Find adverse effects that took place before enrollment
SELECT 
    Patients.patient_id,
    first_name,
    last_name,
    enrollment_date,
    Adverse_Events.event_description,
    Adverse_Events.start_date
FROM 
    Patients
JOIN 
    Adverse_Events ON Patients.patient_id = Adverse_Events.patient_id
WHERE 
    Adverse_Events.start_date < Patients.enrollment_date;

--Check for duplicate visits
SELECT 
    patient_id,
    visit_date,
    visit_type,
    COUNT(*) AS visit_count
FROM 
    Visits
GROUP BY 
    patient_id, visit_date, visit_type
HAVING 
    COUNT(*) > 1;

--Check for patients aged 30 - 50
SELECT
    patient_id,
    first_name,
    last_name,
    date_of_birth,
    enrollment_date,
    CAST((julianday(enrollment_date) - julianday(date_of_birth)) / 365.25 AS INTEGER) AS age_at_enrollment
FROM
    Patients
WHERE
    age_at_enrollment BETWEEN 30 AND 50;

--Check for patients with hemoglobin ≥ 13.0 g/dL
SELECT 
    Patients.patient_id,
    first_name,
    last_name,
    Lab_Results.test_name,
    Lab_Results.result_value,
    Lab_Results.test_date
FROM 
    Patients
JOIN 
    Lab_Results ON Patients.patient_id = Lab_Results.patient_id
WHERE 
    Lab_Results.test_name = 'Hemoglobin'
    AND Lab_Results.result_value >= 13.0;

--Identify patient with severe adverse effects
SELECT 
    DISTINCT Patients.patient_id,
    first_name,
    last_name,
    event_description,
    severity
FROM 
    Patients
JOIN 
    Adverse_Events ON Patients.patient_id = Adverse_Events.patient_id
WHERE 
    severity = 'Severe';

--Combined query
SELECT 
    p.patient_id,
    p.first_name,
    p.last_name
FROM 
    Patients p
JOIN 
    Lab_Results l ON p.patient_id = l.patient_id
WHERE 
    CAST((julianday(p.enrollment_date) - julianday(p.date_of_birth)) / 365.25 AS INTEGER) BETWEEN 30 AND 50
    AND l.test_name = 'Hemoglobin'
    AND l.result_value >= 13.0
    AND p.patient_id NOT IN (
        SELECT patient_id
        FROM Adverse_Events
        WHERE severity = 'Severe'
    );

