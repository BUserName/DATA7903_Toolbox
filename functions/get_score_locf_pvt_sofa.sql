
set search_path to mimic3;

create or replace function get_score_locf_pvt_sofa(icustay_id bigint, time_window integer)
	returns table (
		tw_hour_idx double precision,
		cardiovascular_points integer,
		respiration_points integer,
		bilirubin_points integer,
		creatinine_points integer,
		urine_points integer,
		platelets_points integer,
		gcs_points integer,
		total_sofa_score integer
		)
as $$
begin
	return query 
		select 	scores_sheet.tw_hour_idx, scores_sheet.cardiovascular_points, 
				scores_sheet.respiration_points, scores_sheet.bilirubin_points, 
				scores_sheet.creatinine_points, scores_sheet.urine_points, 
				scores_sheet.platelets_points, scores_sheet.gcs_points,
				scores_sheet.cardiovascular_points + scores_sheet.respiration_points + scores_sheet.creatinine_points +
				scores_sheet.gcs_points + scores_sheet.bilirubin_points + scores_sheet.platelets_points + scores_sheet.urine_points
			as total_sofa_score from
		(
			select locf_pvt_sofa.tw_hour_idx,
				case -- Cardiovascular Points
					when (abp_mean>=70) and (dopamine is null) and (dobutamine is null) and (epinephrine is null) and (norepinephrine is null)  then 0
					when (abp_mean<70) and (dopamine is null) and (dobutamine is null) and (epinephrine is null) and (norepinephrine is null) then 1 
					when (dopamine<=5) or (dobutamine is not null) then 2
					when ((dopamine>5) and (dopamine<=15)) or ((epinephrine >0) and (epinephrine <=0.1)) or ((norepinephrine >0) and (norepinephrine<=0.1)) then 3
					when (dopamine>15) or (epinephrine>0.1) or (norepinephrine>0.1) then 4
					else 0
				end cardiovascular_points, 

				case -- Respiration Points
					when pao2/(fio2/100) <100 then 4
					when pao2/(fio2/100) <200 then 3
					when pao2/(fio2/100) <300 then 2
					when pao2/(fio2/100) <400 then 1
					when pao2/(fio2/100) >=400 then 0
				end respiration_points, 	

				case -- CREATININE Points
					when creatinine<1.2 then 0
					when creatinine<=1.9 then 1
					when creatinine<=3.4 then 2
					when creatinine<=4.9 then 3
					when creatinine>4.9 then 4 --(equation >=5)
				end creatinine_points,

				case -- GCS Points
					when round(gcs)<6 then 4
					when round(gcs)<=9 then 3
					when round(gcs)<=12 then 2
					when round(gcs)<=14 then 1
					when round(gcs)=15 then 0
				end gcs_points,

				case -- Bilirubin Points
					when bilirubin<=1.2 then 0
					when bilirubin<=1.9 then 1
					when bilirubin<=5.9 then 2
					when bilirubin<=11.9 then 3
					when bilirubin>11.9 then 4 --(equation >=12)
				end bilirubin_points,

				case -- Platelets Points
					when platelets<20 then 4
					when platelets<50 then 3
					when platelets<100 then 2
					when platelets<150 then 1
					when platelets>=150 then 0 
				end platelets_points,

				case -- Urine Points
					when urine<(($2*0.2)/24) then 4
					when urine<(($2*0.5)/24) then 3 
					else 0
				end urine_points	
			from (select * from mimic3.get_locf_pvt_sofa($1,$2)) locf_pvt_sofa
		) as scores_sheet;

end;
$$ language plpgsql;

-- select * from get_score_locf_pvt_sofa(200474,1)