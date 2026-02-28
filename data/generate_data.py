import pandas as pd
import numpy as np
from faker import Faker
from datetime import datetime, timedelta
import random

fake = Faker()
np.random.seed(42)
random.seed(42)

# Parameters
num_patients = 5000
num_staff = 200
num_shifts = 10000
start_date = datetime(2023, 1, 1)
end_date = datetime(2023, 12, 31)

# Departments
departments = ['Emergency', 'Cardiology', 'Surgery', 'Pediatrics', 'ICU']

print("Generating patient data...")
# Generate patients
patients = []
for i in range(num_patients):
    admission_date = fake.date_time_between(start_date=start_date, end_date=end_date)
    # Length of stay varies by acuity
    acuity = np.random.choice([1,2,3,4,5], p=[0.3,0.25,0.2,0.15,0.1])
    los_hours = np.random.poisson(lam=acuity*10)  # higher acuity -> longer stay
    discharge_date = admission_date + timedelta(hours=los_hours) if random.random()>0.1 else None  # 10% still admitted
    patients.append({
        'admission_id': i+1,
        'patient_id': fake.uuid4(),
        'admission_datetime': admission_date,
        'discharge_datetime': discharge_date,
        'department': np.random.choice(departments, p=[0.4,0.2,0.2,0.1,0.1]),
        'acuity_level': acuity,
        'age_group': np.random.choice(['child','adult','senior'], p=[0.2,0.5,0.3])
    })

df_patients = pd.DataFrame(patients)
df_patients.to_csv('data/patients.csv', index=False)
print(f"Created {len(df_patients)} patient records")

print("Generating staff schedule data...")
# Generate staff schedules
staff_ids = [fake.uuid4() for _ in range(num_staff)]
shifts = []
for i in range(num_shifts):
    staff_id = random.choice(staff_ids)
    role = np.random.choice(['nurse','doctor','technician'], p=[0.6,0.3,0.1])
    dept = np.random.choice(departments)
    shift_date = fake.date_time_between(start_date=start_date, end_date=end_date)
    shift_type = np.random.choice(['day','evening','night'], p=[0.5,0.3,0.2])
    # Shift lengths: 8h for day/evening, 10h for night
    shift_len = 8 if shift_type != 'night' else 10
    shift_start = shift_date.replace(hour=7 if shift_type=='day' else 15 if shift_type=='evening' else 23, minute=0)
    shift_end = shift_start + timedelta(hours=shift_len)
    shifts.append({
        'shift_id': i+1,
        'staff_id': staff_id,
        'role': role,
        'department': dept,
        'shift_start': shift_start,
        'shift_end': shift_end,
        'shift_type': shift_type
    })

df_shifts = pd.DataFrame(shifts)
df_shifts.to_csv('data/staff_schedule.csv', index=False)
print(f"Created {len(df_shifts)} shift records")
print("Done! Check the data folder for patients.csv and staff_schedule.csv")