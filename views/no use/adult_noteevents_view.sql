set search_path to mimic3;

DROP view IF EXISTS notevents_adults;
create or replace view mimic3.noteevents_adults as
	select *
	from noteevents n	
	where n.subject_id in (select distinct subject_id from patients_adults);

-- select count(*) from noteevents_adults;
-- 1,657,667 vs 2,083,180