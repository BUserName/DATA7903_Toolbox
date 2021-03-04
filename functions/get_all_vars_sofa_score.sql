set search_path to mimic3;


create or replace function get_all_vars_sofa(icustay_id bigint, time_window integer)
	returns table (
		tw_hour_idx double precision, 
	bpd double precision,	bpm double precision,
	bps double precision,	albumin double precision,
	alt double precision,	arterial_ph double precision,
	phosphorous double precision,	alkaline_phosphate double precision,
	bilirubin double precision,	bun double precision,
	calcium double precision,	calcium_ionized  double precision,
	chloride double precision,	creatinine double precision,
	cvp double precision,	fio2 double precision,	gcs double precision,
	glucose double precision,	hco3 double precision,
	hct double precision,	hemoglobin double precision,
	hr double precision,	inr double precision, magnesium double precision,
	mean_airway_pressure double precision,	o2_flow double precision,
	paco2 double precision,	pao2 double precision,
	platelets double precision,	potassium double precision,
	pt double precision,	ptt double precision,	rr double precision,
	sao2 double precision,	sodium double precision,
	spo2 double precision,	tco2 double precision,
	temperature double precision,	urine double precision,
	wbc double precision,	weight double precision, total_sofa_score double precision
	) 
as $$
begin
	return query
	
	select  pt_vars_scores.tw_hour_idx,
			pt_vars_scores.bpd,	
			pt_vars_scores.bpm,
			pt_vars_scores.bps,
			pt_vars_scores.albumin,
			pt_vars_scores.alt,	
			pt_vars_scores.arterial_ph,
			pt_vars_scores.phosphorous,	
			pt_vars_scores.alkaline_phosphate,
			pt_vars_scores.bilirubin,	
			pt_vars_scores.bun,
			pt_vars_scores.calcium,	
			pt_vars_scores.calcium_ionized ,
			pt_vars_scores.chloride,	
			pt_vars_scores.creatinine,
			pt_vars_scores.cvp,	
			pt_vars_scores.fio2,	
			pt_vars_scores.gcs,
			pt_vars_scores.glucose,	
			pt_vars_scores.hco3,
			pt_vars_scores.hct,	
			pt_vars_scores.hemoglobin,
			pt_vars_scores.hr,	
			pt_vars_scores.inr, 
			pt_vars_scores.magnesium,
			pt_vars_scores.mean_airway_pressure,	
			pt_vars_scores.o2_flow,
			pt_vars_scores.paco2,	
			pt_vars_scores.pao2,
			pt_vars_scores.platelets,	
			pt_vars_scores.potassium,
			pt_vars_scores.pt,	
			pt_vars_scores.ptt,	
			pt_vars_scores.rr,
			pt_vars_scores.sao2,	
			pt_vars_scores.sodium,
			pt_vars_scores.spo2,	
			pt_vars_scores.tco2,
			pt_vars_scores.temperature,	
			pt_vars_scores.urine,
			pt_vars_scores.wbc,	
			pt_vars_scores.weight,
				case 
					when locf(pt_vars_scores.total_sofa_score) over (order by pt_vars_scores.tw_hour_idx) is null
						then 1
					else locf(pt_vars_scores.total_sofa_score) over (order by pt_vars_scores.tw_hour_idx)
				end total_sofa_score
		from (
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
		    pt_scores.total_sofa_score
		    from get_locf_pvt_all_vars($1,$2) as pt_vars
		    left join (
		    select pt_scores.tw_hour_idx, pt_scores.total_sofa_score
		    from get_score_locf_pvt_sofa($1,$2) as pt_scores) as pt_scores
		    on pt_vars.tw_hour_idx=pt_scores.tw_hour_idx ) pt_vars_scores;
end;
$$ language plpgsql;
	