set search_path to mimic3;
create or replace view labevents_adults as
	select 	*
	from labevents la
	where la.subject_id in (select distinct subject_id from patients_adults)

--	27,234,907
--	27,854,055