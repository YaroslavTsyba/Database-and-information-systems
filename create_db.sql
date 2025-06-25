CREATE TABLE patient (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    birth_date DATE,
    address TEXT,
    phone VARCHAR(20)
);

CREATE TABLE doctor (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    specialization VARCHAR(100),
    experience INT
);

CREATE TABLE appointment (
    id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patient(id),
    doctor_id INT REFERENCES doctor(id),
    visit_date DATE,
    diagnosis TEXT
);