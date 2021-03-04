set search_path to mimic3;

DROP TABLE IF EXISTS outputevents_adults;
create or replace view outputevents_adults as
	select *
	from outputevents o	
	where o.subject_id in (select distinct subject_id from patients_adults);

--select count(*) from outputevents_adults;
-- 4,219,596 vs 4,349,220