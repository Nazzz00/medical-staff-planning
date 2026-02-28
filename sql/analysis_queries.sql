-- Analysis Queries for Medical Staff Planning

-- 1. Daily patient admissions by department
SELECT 
    DATE(admission_datetime) as date,
    department,
    COUNT(*) as admissions,
    AVG(acuity_level) as avg_acuity
FROM patients
GROUP BY DATE(admission_datetime), department
ORDER BY date DESC, department;

-- 2. Average length of stay by acuity and department
SELECT 
    department,
    acuity_level,
    COUNT(*) as patient_count,
    AVG(EXTRACT(EPOCH FROM (discharge_datetime - admission_datetime))/3600) as avg_stay_hours,
    MIN(EXTRACT(EPOCH FROM (discharge_datetime - admission_datetime))/3600) as min_stay_hours,
    MAX(EXTRACT(EPOCH FROM (discharge_datetime - admission_datetime))/3600) as max_stay_hours
FROM patients
WHERE discharge_datetime IS NOT NULL
GROUP BY department, acuity_level
ORDER BY department, acuity_level;

-- 3. Hourly staff coverage by department
SELECT 
    EXTRACT(HOUR FROM shift_start) as hour_of_day,
    department,
    COUNT(DISTINCT staff_id) as total_staff,
    COUNT(DISTINCT CASE WHEN role = 'nurse' THEN staff_id END) as nurses,
    COUNT(DISTINCT CASE WHEN role = 'doctor' THEN staff_id END) as doctors,
    COUNT(DISTINCT CASE WHEN role = 'technician' THEN staff_id END) as technicians
FROM staff_schedule
GROUP BY EXTRACT(HOUR FROM shift_start), department
ORDER BY hour_of_day, department;

-- 4. Patient to staff ratio by hour (most critical analysis)
WITH hourly_patients AS (
    SELECT 
        DATE_TRUNC('hour', admission_datetime) as hour,
        department,
        COUNT(*) as patient_count
    FROM patients
    GROUP BY DATE_TRUNC('hour', admission_datetime), department
),
hourly_staff AS (
    SELECT 
        DATE_TRUNC('hour', shift_start) as hour,
        department,
        COUNT(DISTINCT staff_id) as staff_count
    FROM staff_schedule
    GROUP BY DATE_TRUNC('hour', shift_start), department
)
SELECT 
    COALESCE(hp.hour, hs.hour) as hour,
    COALESCE(hp.department, hs.department) as department,
    COALESCE(patient_count, 0) as patients,
    COALESCE(staff_count, 0) as staff,
    CASE 
        WHEN staff_count > 0 THEN ROUND(patient_count::DECIMAL / staff_count, 2)
        ELSE NULL 
    END as patient_to_staff_ratio
FROM hourly_patients hp
FULL OUTER JOIN hourly_staff hs ON hp.hour = hs.hour AND hp.department = hs.department
WHERE COALESCE(hp.hour, hs.hour) IS NOT NULL
ORDER BY hour, department;

-- 5. Peak admission times (hour of day)
SELECT 
    EXTRACT(HOUR FROM admission_datetime) as hour,
    COUNT(*) as total_admissions,
    AVG(acuity_level) as avg_acuity
FROM patients
GROUP BY EXTRACT(HOUR FROM admission_datetime)
ORDER BY hour;

-- 6. Monthly trends
SELECT 
    EXTRACT(MONTH FROM admission_datetime) as month,
    COUNT(*) as admissions,
    AVG(acuity_level) as avg_acuity
FROM patients
GROUP BY EXTRACT(MONTH FROM admission_datetime)
ORDER BY month;

-- 7. Currently admitted patients (if any)
SELECT *
FROM patients
WHERE discharge_datetime IS NULL
ORDER BY admission_datetime;