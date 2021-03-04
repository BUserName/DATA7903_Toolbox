DROP VIEW IF EXISTS mimic3.chartevents_adults;
create or replace view mimic3.chartevents_adults as
	select c.row_id, c.subject_id, c.hadm_id, c.icustay_id,
	c.itemid, c.charttime, c.storetime, c.cgid, c.value, c.valuenum, c.valueuom, 
	c.warning, c.error, c.resultstatus, c.stopped
	from mimic3.chartevents c	
	where c.subject_id in (select distinct subject_id from mimic3.patients_adults);
	