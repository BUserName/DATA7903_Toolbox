SET SEARCH_PATH TO mimic3;

select pt_vars.tw_hour_idx, 
pt_vars.bpd,	
pt_vars.bpm,
pt_vars.bps,
pt_vars.albumin,
pt_vars.alt,	
pt_vars.arterial_ph,
pt_vars.phosphorous,	
pt_vars.alkaline_phosphate,
pt_vars.bilirubin,	
pt_vars.bun,
pt_vars.calcium,	
pt_vars.calcium_ionized ,
pt_vars.chloride,	
pt_vars.creatinine,
pt_vars.cvp,	
pt_vars.fio2,	
pt_vars.gcs,
pt_vars.glucose,	
pt_vars.hco3,
pt_vars.hct,	
pt_vars.hemoglobin,
pt_vars.hr,	
pt_vars.inr, 
pt_vars.magnesium,
pt_vars.mean_airway_pressure,	
pt_vars.o2_flow,
pt_vars.paco2,	
pt_vars.pao2,
pt_vars.platelets,	
pt_vars.potassium,
pt_vars.pt,	
pt_vars.ptt,	
pt_vars.rr,
pt_vars.sao2,	
pt_vars.sodium,
pt_vars.spo2,	
pt_vars.tco2,
pt_vars.temperature,	
pt_vars.urine,
pt_vars.wbc,	
pt_vars.weight,
pt_scores.total_apacheii_score
from get_locf_pvt_all_vars(274671,1) as pt_vars
left join (
select pt_scores.tw_hour_idx, pt_scores.total_apacheii_score
from get_score_locf_pvt_apacheii(274671,1) as pt_scores) as pt_scores
on pt_vars.tw_hour_idx=pt_scores.tw_hour_idx


