-- Create tables for medical staff planning database
DROP TABLE IF EXISTS patients;
DROP TABLE IF EXISTS staff_schedule;

CREATE TABLE patients (
    admission_id INT PRIMARY KEY,
    patient_id UUID,
    admission_datetime TIMESTAMP,
    discharge_datetime TIMESTAMP,
    department VARCHAR(50),
    acuity_level INT,
    age_group VARCHAR(10)
);

CREATE TABLE staff_schedule (
    shift_id INT PRIMARY KEY,
    staff_id UUID,
    role VARCHAR(20),
    department VARCHAR(50),
    shift_start TIMESTAMP,
    shift_end TIMESTAMP,
    shift_type VARCHAR(10)
);

-- Create indexes for better query performance
CREATE INDEX idx_patients_admission_date ON patients(admission_datetime);
CREATE INDEX idx_patients_department ON patients(department);
CREATE INDEX idx_staff_shift_start ON staff_schedule(shift_start);
CREATE INDEX idx_staff_department ON staff_schedule(department);

-- Comments on tables
COMMENT ON TABLE patients IS 'Patient admission records';
COMMENT ON TABLE staff_schedule IS 'Staff shift schedules';