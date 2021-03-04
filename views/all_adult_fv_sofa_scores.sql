set search_path to mimic3;
drop table if exists all_adult_fv_sofa_scores;
create table all_adult_fv_sofa_scores
(
icustay_id bigint,
tw_hour_idx double precision,
bpd double precision,
bpm double precision,
bps double precision,
albumin double precision,
alt double precision,	
arterial_ph double precision,
phosphorous double precision,	
alkaline_phosphate double precision,
bilirubin double precision,	
bun double precision,
calcium double precision,	
calcium_ionized  double precision,
chloride double precision,	
creatinine double precision,
cvp double precision,	
fio2 double precision,	
gcs double precision,
glucose double precision,	
hco3 double precision,
hct double precision,	
hemoglobin double precision,
hr double precision,	
inr double precision, 
magnesium double precision,
mean_airway_pressure double precision,	
o2_flow double precision,
paco2 double precision,	
pao2 double precision,
platelets double precision,	
potassium double precision,
pt double precision,	
ptt double precision,	
rr double precision,
sao2 double precision,	
sodium double precision,
spo2 double precision,	
tco2 double precision,
temperature double precision,	
urine double precision,
wbc double precision,	
weight double precision, 
cardiovascular_points double precision, 
respiration_points double precision,
bilirubin_points double precision, 
creatinine_points double precision,
urine_points double precision, 
platelets_points double precision,
gcs_points double precision, 
total_sofa_score double precision
);