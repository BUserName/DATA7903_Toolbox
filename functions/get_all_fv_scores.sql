set search_path to mimic3;

-- delete from scores;
---------------------------------------------------------------
create or replace function get_all_fv_scores(tw integer, offset_pos integer, limit_num integer) returns void as $$
declare
	icustay_id bigint;
	tw_length int;
	cnt integer;
begin
	cnt:=0;
	tw_length=$1;
	for icustay_id in (select distinct icu.icustay_id from mimic3.mv_icustays_adult icu order by icu.icustay_id offset $2 limit $3 ) loop

		insert into mimic3.all_adult_fv_sofa_scores (icustay_id,tw_hour_idx,
        bpd, bpm, bps, albumin, alt, arterial_ph, phosphorous,	alkaline_phosphate, 
        bilirubin,	bun, calcium,	calcium_ionized , chloride,	creatinine, cvp,	
        fio2,	gcs, glucose,	hco3, hct,	hemoglobin, hr,	inr, magnesium,
        mean_airway_pressure,	o2_flow, paco2,	pao2, platelets,	potassium, pt,
        ptt,	rr, sao2,	sodium, spo2,	tco2, temperature,	urine, wbc,	weight, 
        cardiovascular_points, respiration_points, bilirubin_points, creatinine_points,
         urine_points, platelets_points, gcs_points, total_sofa_score)
		select icustay_id, tw_hour_idx, bpd, bpm, bps, albumin, alt, arterial_ph, 
        phosphorous,	alkaline_phosphate, bilirubin,	bun, calcium,	calcium_ionized, chloride,	creatinine, cvp, fio2,	gcs, glucose,	hco3, hct,	hemoglobin, 
        hr,	inr, magnesium, mean_airway_pressure,	o2_flow, paco2,	pao2, platelets,	potassium, pt, ptt,	rr, sao2,	sodium, spo2,	tco2, temperature,	urine, wbc,weight, cardiovascular_points, respiration_points, bilirubin_points, creatinine_points, urine_points, platelets_points, gcs_points, total_sofa_score 
        from mimic3.get_all_vars_sofa_scores(icustay_id,tw_length);
		cnt=cnt+1;
		raise notice '% ICUSTAYS has been done!', cnt;
	end loop;
end;
$$ language plpgsql;

