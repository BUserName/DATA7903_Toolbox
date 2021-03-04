### create dictionary tables (2 SQL files)
1. create **d_sofa_vars** that has information of sofa variables in MIMIC3.
   [[code -> ./dicts/d_sofa_vars.sql]]
2. create **d_all_variables** that has information of all variables (46 features) in MIMIC3
   [[code -> ./dicts/d_all_vars.sql]]
### create materialized views (9 SQL files)
1. create **mv_patients_adult**, a materialised view that filters non-adult patients. Age >= 16.
   [[code -> ./view/mv_patients_adult.sql]]
   Note: this view has four columns: *subject_id, hadm_id, icustay_id, pt_age*
2. create **mv_labevents_icuid_adult** based on labevents, adding in **icustay_id**
   [[code -> ./view/mv_labevents_icuid_adult.sql]]
3. create **mv_gcs_adult** to include all adult patents' GCS and icustay_id.
   [[code -> ./view/mv_gcs_adult.sql]]
4. create **mv_icustays_adult** that has all icustay information for adult patients.
   [[code -> ./view/mv_icustays_adult.sql]]
5. create **mv_adult_sofa_vars**, where only **SOFA variables** are kept. 
   [[code -> ./view/mv_adult_sofa_vars.sql]]
   only **12 features** that are related to SOFA calculations are kept.
   all records are from adult patients.
6. create **mv_adult_sofa_vars_tw** that has extra columns for time window information，based on **mv_adult_sofa_vars** in Step 4 and **icustays_adult** in Step 5, 
   [[code -> ./view/mv_adult_sofa_vars_tw.sql]]
7. create **mv_adult_daily_urine_outputs** that has urine output information of adult patients.
   [[code -> ./view/mv_adult_daily_urine_outputs.sql]]
8. create **mv_adult_all_vars** that has 41 features (excluding age and sex) of adult patients.
   [[code -> ./view/mv_adult_all_vars.sql]]
9. create **mv_adult_all_vars_tw** that has extra columns for time windown information.
    [[code -> ./view/mv_adult_all_vars_tw.sql]]
10. create table **all_adult_fv_sofa_scores** that will storage all features and sofa scores together.
    [[code -> ./view/all_adult_fv_sofa_scores.sql]]
### create functions (8 SQL files)
1. run "CREATE EXTENSION tablefunc;" to enable crosstab function.
2. create **get_pvt_sofa(icustay_id bigint, time_window integer)**, given a *icustay_id* and *a time window*, the function will return a pivot table of an icustay record. The columns are features, while each row is the feature values in one time window. Ex. "select * from get_pvt_sofa(274671,1)"
   [[code -> ./functions/get_pvt_sofa.sql]]
3. create **locf()** function to conduct Last Observation Carried Forward imputation.
   [[code -> ./functions/func_locf.sql]]
4. create **get_locf_pvt_sofa(icustay_id bigint, time_window integer)** to generate imputed data.
   [[code -> ./functions/get_locf_pvt_sofa.sql]]
5. create **get_score_locf_pvt_sofa(icustay_id bigint, time_window integer)** to generate sofa scores, including sub-scores, given an icustay and time window length.
   [[code -> ./functions/get_score_locf_pvt_sofa.sql]]
6. create **get_pvt_all_vars(icustay_id bigint, time_window integer)** to generate pivot table containing all variables.
   [[code -> ./functions/get_pvt_all_vars.sql]]
7. [ [[OPTIONAL]] ]. create **get_mask_pvt_all_vars(icustay_id bigint, time_window integer)** to generate mask matrix that has either 0 or 1 to represent missing values (0 is missing otherwise 1)
   [[code -> ./functions/get_mask_pvt_all_vars.sql]]
8. create **get_locf_pvt_all_vars(icustay_id bigint, time_window integer)** to generate imputed pivot table containing all variables.
   [[code -> ./functions/get_locf_pvt_all_vars.sql]] 
9. create **get_all_vars_sofa_scores(icustay_id bigint, time_window integer)** to generate all features, sub-points, and total scores.
   [[code -> ./functions/get_all_vars_sofa_scores.sql]] 
10. create **get_all_fv_scores(tw integer, offset_pos integer, limit_num integer)** to generate all features and sofa scores.
   [[code -> ./functions/get_all_fv_scores.sql]]
   run "*select * from mimic3.get_all_fv_scores(1,0,100000);*"