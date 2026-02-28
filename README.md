# medical-staff-planning
Hospital staff planning analysis using Python, SQL, and machine learning

# Medical Staff Planning Analysis

## Project Overview
This project analyzes hospital patient admissions and staff schedules to optimize shift planning and ensure adequate patient coverage. Using synthetic data generated with Python Faker, I performed exploratory data analysis and built a predictive model to forecast daily patient admissions and recommend optimal staffing levels.

## Business Problem
Hospitals struggle with staffing efficiency - too few staff leads to burnout and safety issues, too many leads to waste. This project provides data-driven insights to help hospitals:
- Predict daily patient admissions with 85% accuracy
- Identify understaffed periods (especially night shifts)
- Optimize staff allocation across 5 departments
- Maintain safe patient-to-staff ratios

## Datasets Generated

### Patient Admissions (5,000+ records)
- **Admission/Discharge timestamps**: Track patient flow
- **Department**: Emergency, Cardiology, Surgery, Pediatrics, ICU
- **Acuity Level**: 1 (low) to 5 (critical)
- **Age Group**: Child, Adult, Senior

### Staff Schedule (10,000+ shifts)
- **Staff ID**: 200+ unique staff members
- **Role**: Nurses (60%), Doctors (30%), Technicians (10%)
- **Shift Type**: Day (7am-3pm), Evening (3pm-11pm), Night (11pm-7am)
- **Department assignments**: Matches patient departments

## Key Findings from Analysis

### Patient Admission Patterns
- **Peak hours**: 10 AM - 2 PM (busiest time of day)
- **Busiest day**: Monday (highest admission volume)
- **Busiest department**: Emergency (40% of all admissions)
- **Most common acuity**: Level 1 (30% of patients)

### Staff Utilization
- **Coverage gaps**: Night shifts have 40% fewer staff than day shifts
- **Emergency Department**: Highest patient-to-staff ratio (7:1 during peak)
- **ICU**: Best staff coverage (3:1 patient-to-staff ratio)

### Length of Stay Analysis
- **Critical patients** (Level 5): Stay 3x longer than Level 1
- **Average stay**: 24-48 hours for most patients
- **ICU patients**: Average stay of 72+ hours

## Predictive Model Performance

I built a **Random Forest Regressor** to forecast daily patient admissions:

- **Features used**: Day of week, month, holiday indicators, lag features (1, 2, 3, 7 days)
- **Mean Absolute Error**: ±4.2 patients per day
- **R² Score**: 0.85 (explains 85% of variance)
- **Most important feature**: Same day last week's admissions

## Staffing Recommendations

Based on the analysis, I recommend:

| Department | Peak Hours | Current Staff | Recommended Staff | Change |
|------------|------------|---------------|-------------------|--------|
| Emergency | 10am-2pm | 8 nurses | 11 nurses | +3 |
| ICU | All hours | 5 nurses | 6 nurses | +1 |
| Night Shift | 11pm-7am | 4 nurses | 7 nurses | +3 |

## Technologies Used

- **Python**: Pandas, NumPy, Scikit-learn, Matplotlib, Seaborn
- **Jupyter Notebooks**: Interactive development and visualization
- **SQL**: PostgreSQL queries for data analysis
- **Git/GitHub**: Version control and project hosting

## Project Structure
