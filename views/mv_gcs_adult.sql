set search_path to mimic3;

create or replace view mv_gcs_adult as
	select subject_id, hadm_id, icustay_id, 'GCS' as itemcat, charttime, cvalue, valuenum, valueuom from
	(
	select distinct row_id, subject_id, hadm_id, icustay_id, 'GCS' as itemcat, charttime, value as cvalue, valuenum, valueuom
	from chartevents where itemid = 198
	and subject_id in (select distinct subject_id from mimic3.mv_patients_adult)
	order by subject_id, hadm_id, icustay_id, charttime
	) tmp -- 945,575

	union all
	
	select subject_id, hadm_id, icustay_id, 'GCS' as itemcat, charttime, to_char(sum(val), 'FM99') as cvalue, sum(val) as total_score, 'points' as valueuom from 
	(
	select distinct row_id, subject_id, hadm_id, icustay_id, charttime, valuenum as val from chartevents 
		where itemid in (220739,223900,223901)
		and subject_id in (select distinct subject_id from mimic3.mv_patients_adult)
		order by charttime) tmp
	group by charttime, subject_id, hadm_id, icustay_id
	order by subject_id, hadm_id, charttime --570,004 rows