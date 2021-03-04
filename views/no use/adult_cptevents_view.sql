DROP TABLE IF EXISTS mimic3.cptevents_adults;
create or replace view mimic3.cptevents_adults as
	select *
	from mimic3.cptevents cpt	
	where cpt.subject_id in (select distinct subject_id from patients_adults);	

-- test code
-- select count(*) from cptevents_adults;
-- 572842 vs 573146